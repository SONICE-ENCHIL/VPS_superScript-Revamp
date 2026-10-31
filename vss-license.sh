#!/bin/bash
# ==========================================================
#  VPS_superScript — license verification library
#
#  Sourced by both install-with-key.sh and menu.sh.
#  Ships in the public repo. Contains the PUBLIC key only.
#  Never put privatekey.pem in here.
#
#  Token format:
#    VSS1-<payload_b64url>.<signature_b64url>
#
#  payload (plain text, ':' separated):
#    v1:<key_id>:<owner>:<machine_id>:<issued>:<expires>:<max>
#
#    machine_id  "*" = not bound to a machine, or 16 hex chars
#                from sha256(/etc/machine-id)
#    issued       YYYY-MM-DD   (UTC)
#    expires      YYYY-MM-DD   (UTC)  — enforced
#    max          reserved, not enforced yet
# ==========================================================

VSS_PUBKEY='-----BEGIN PUBLIC KEY-----
REPLACE_ME_WITH_generate-keys.sh_OUTPUT
-----END PUBLIC KEY-----'

# Where the issued key lives after a successful install.
VSS_LICENSE_FILE="${VSS_LICENSE_FILE:-/etc/VPS_superScript/license.key}"

# Optional revocation list, fetched best-effort at install time.
# Point this at the raw URL of revoked-ids.txt in YOUR repo.
VSS_REVOKED_URL="${VSS_REVOKED_URL:-}"

# ---------- helpers ----------

vss_machine_id() {
    # Stable per-installation identifier. /etc/machine-id is present on
    # systemd distros; fall back to the ssh host key fingerprint, then to
    # the first hardware MAC address on non-systemd or container images.
    local src=""
    if [[ -r /etc/machine-id ]]; then
        src="$(tr -d '\n\r ' < /etc/machine-id)"
    elif [[ -r /var/lib/dbus/machine-id ]]; then
        src="$(tr -d '\n\r ' < /var/lib/dbus/machine-id)"
    elif [[ -r /etc/ssh/ssh_host_ed25519_key.pub ]]; then
        src="$(awk '{print $2}' /etc/ssh/ssh_host_ed25519_key.pub)"
    elif [[ -d /sys/class/net ]]; then
        # sort -u keeps it deterministic regardless of interface order.
        src="$(cat /sys/class/net/*/address 2>/dev/null \
               | grep -v '^00:00:00:00:00:00$' \
               | sort -u | head -n1)"
    fi

    if [[ -z "$src" ]]; then
        echo ""
        return 1
    fi

    printf '%s' "$src" | sha256sum | cut -c1-16
}

# Strip '=' padding and -/_ so the result is a plain shell-safe token.
vss_b64url_decode() {
    local s="$1"
    s="${s//-/+}"
    s="${s//_//}"
    while (( ${#s} % 4 )); do
        s="${s}="
    done
    printf '%s' "$s" | base64 -d
}

# The key arrives via argument, env var, or prompt — in that order.
vss_read_key() {
    local k="${1:-${VSS_LICENSE_KEY:-}}"
    k="$(printf '%s' "$k" | tr -d '[:space:]')"
    if [[ -z "$k" ]] && [[ -t 0 ]]; then
        printf 'License key: ' >&2
        read -r k
        k="$(printf '%s' "$k" | tr -d '[:space:]')"
    fi
    printf '%s' "$k"
}

# ---------- main verification ----------

# Returns 0 on valid, prints the reason to stderr otherwise.
license_verify() {
    local key reason="" tmp payload sig pub
    key="$(vss_read_key "${1:-}")"

    if [[ -z "$key" ]]; then
        echo "LICENSE: no key supplied." >&2
        return 1
    fi

    if [[ "${key#VSS1-}" == "$key" ]]; then
        echo "LICENSE: not a vss key (expected VSS1-...)." >&2
        return 1
    fi

    local body="${key#VSS1-}"
    local b64_payload="${body%%.*}"
    local b64_sig="${body#*.}"

    if [[ -z "$b64_payload" || -z "$b64_sig" || "$b64_payload" == "$body" ]]; then
        echo "LICENSE: malformed token." >&2
        return 1
    fi

    tmp="$(mktemp -d)"
    # shellcheck disable=SC2064
    trap "rm -rf '$tmp'" RETURN

    payload="$tmp/payload"
    sig="$tmp/sig"
    pub="$tmp/pub.pem"

    if ! vss_b64url_decode "$b64_payload" > "$payload" 2>/dev/null; then
        echo "LICENSE: payload is not valid base64." >&2
        return 1
    fi
    if ! vss_b64url_decode "$b64_sig" > "$sig" 2>/dev/null; then
        echo "LICENSE: signature is not valid base64." >&2
        return 1
    fi

    printf '%s\n' "$VSS_PUBKEY" > "$pub"

    # 1. Cryptographic check — this is the one an attacker cannot fake.
    if ! openssl pkeyutl -verify -pubin -inkey "$pub" \
            -rawin -in "$payload" -sigfile "$sig" >/dev/null 2>&1; then
        echo "LICENSE: signature is invalid (key was not issued by this project)." >&2
        return 1
    fi

    # 2. Parse the signed claims. Everything below is trustworthy now.
    local ver="" kid="" owner="" mid="" issued="" expires="" max=""
    IFS=':' read -r ver kid owner mid issued expires max < "$payload"

    if [[ "$ver" != "v1" ]]; then
        echo "LICENSE: unsupported key version '$ver'." >&2
        return 1
    fi

    # 3. Machine binding.
    if [[ "$mid" != "*" ]]; then
        local mine
        mine="$(vss_machine_id)" || mine=""
        if [[ -z "$mine" ]]; then
            echo "LICENSE: cannot read this machine's id; key is bound to another host." >&2
            return 1
        fi
        if [[ "$mid" != "$mine" ]]; then
            echo "LICENSE: key is bound to machine $mid, this host is $mine." >&2
            return 1
        fi
    fi

    # 4. Expiry. Bad or blank dates fail closed.
    local today exp_ts today_ts
    today="$(date -u +%F)"
    if [[ ! "$expires" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "LICENSE: expiry missing or malformed." >&2
        return 1
    fi
    today_ts="$(date -u -d "$today" +%s 2>/dev/null)" || today_ts=""
    exp_ts="$(date -u -d "$expires" +%s 2>/dev/null)" || exp_ts=""
    if [[ -z "$today_ts" || -z "$exp_ts" ]]; then
        echo "LICENSE: could not evaluate expiry." >&2
        return 1
    fi
    if (( exp_ts < today_ts )); then
        echo "LICENSE: key expired on $expires." >&2
        return 1
    fi

    # 5. Revocation. Best effort: a network failure must not lock out a
    #    paying customer, so we warn instead of failing. Remove the
    #    '|| true' if you'd rather have it fail closed.
    if [[ -n "$VSS_REVOKED_URL" ]]; then
        local revoked
        revoked="$(curl -fsSL --max-time 3 "$VSS_REVOKED_URL" 2>/dev/null || true)"
        if [[ -n "$revoked" ]] && grep -qxF "$kid" <<< "$revoked"; then
            echo "LICENSE: key $kid has been revoked." >&2
            return 1
        fi
    fi

    VSS_LICENSE_OWNER="$owner"
    VSS_LICENSE_KID="$kid"
    VSS_LICENSE_EXPIRES="$expires"
    return 0
}

# Persist the key after a successful install (0600).
license_save() {
    local key="$1"
    local dir
    dir="$(dirname "$VSS_LICENSE_FILE")"
    mkdir -p "$dir"
    printf '%s\n' "$key" > "$VSS_LICENSE_FILE"
    chmod 600 "$VSS_LICENSE_FILE"
}

# Re-check the stored key; used at menu startup.
license_check_stored() {
    if [[ ! -s "$VSS_LICENSE_FILE" ]]; then
        echo "LICENSE: no license installed." >&2
        return 1
    fi
    license_verify "$(tr -d '[:space:]' < "$VSS_LICENSE_FILE")"
}

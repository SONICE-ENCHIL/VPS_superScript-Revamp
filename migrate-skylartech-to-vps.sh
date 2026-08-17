#!/bin/bash
#
# migrate-skylartech-to-vps.sh
# ---------------------------------------------------------------------------
# One-shot migration: brings existing skylartech-manager users (and their
# bandwidth counters, HWID locks, ZiVPN locks, trials, certs, DNSTT keys and
# banners) into a VPS_superScript install on the SAME server.
#
# Safe to run on a LIVE box:
#   * backs up whatever VPS_superScript already has before touching anything
#   * never deletes /etc/skylartech (your old data stays as a fallback)
#   * validates sshd config before reloading — never breaks SSH
#
# RUN AS ROOT, AFTER you have installed VPS_superScript
# (i.e. after `bash <(curl -Ls .../install.sh)` has finished).
# ---------------------------------------------------------------------------
set -euo pipefail

OLD="/etc/skylartech"
NEW="/etc/VPS_superScript"

# ---- 0. sanity checks -----------------------------------------------------
[[ $EUID -eq 0 ]] || { echo "❌ Run this as root."; exit 1; }
[[ -d "$OLD" ]]   || { echo "❌ $OLD not found — nothing to migrate."; exit 1; }
command -v menu >/dev/null 2>&1 || echo "⚠️  'menu' not on PATH — did you install VPS_superScript first?"

echo "🔁 Migrating skylartech-manager → VPS_superScript"
echo

# ---- 1. back up the new install's current state (reversible) --------------
TS="$(date +%F-%H%M%S)"
if [[ -d "$NEW" ]]; then
    cp -a "$NEW" "${NEW}.pre-migrate.$TS"
    echo "📦 Backed up existing $NEW → ${NEW}.pre-migrate.$TS"
fi
mkdir -p "$NEW"

# ---- 2. copy the user data across -----------------------------------------
# Destination basenames were verified identical to the source, and the row
# format of users.db is byte-for-byte the same in both managers.
# We rm the destination item first so directories copy cleanly (no nesting).
echo "📂 Copying user data:"
for item in users.db hwid_allowed.db bandwidth trials zivpn_locked \
            banners banners_enabled ssl dnstt; do
    if [[ -e "$OLD/$item" ]]; then
        rm -rf "${NEW:?}/$item"
        cp -a "$OLD/$item" "$NEW/$item"
        echo "   ✓ $item"
    fi
done
_rows="$(grep -c . "$NEW/users.db" 2>/dev/null || echo 0)"
echo "✅ Data copied — $_rows row(s) in users.db"
echo

# ---- 3. stop & disable the stale skylartech background services -----------
# These are named differently from VPS_superScript's own units, so after the
# install they would keep running against the OLD /etc/skylartech/users.db
# (and could lock users on stale quota/HWID state). Disable — don't delete.
echo "🛑 Disabling stale skylartech services:"
for svc in skylartech-limiter skylartech-bandwidth skylartech-hwid-enforcer; do
    if [[ -f "/etc/systemd/system/${svc}.service" ]]; then
        systemctl disable --now "$svc" 2>/dev/null || true
        echo "   ⛔ ${svc}.service"
    fi
done
echo "   (protocol daemons — zivpn, dnstt, udp-custom, badvpn, etc. — share the"
echo "    same unit names in both and are left running.)"
echo

# ---- 4. re-apply the dynamic per-user SSH banner (only if it was enabled) --
# The old drop-in points at /etc/skylartech/banners; rebuild it against the
# new /etc/VPS_superScript/banners. Mirrors update_ssh_banners_config().
OLD_DROPIN="/etc/ssh/sshd_config.d/skylartech.conf"
NEW_DROPIN="/etc/ssh/sshd_config.d/VPS_superScript.conf"
RELOAD_NEEDED=0

if [[ -f "$OLD_DROPIN" ]]; then
    rm -f "$OLD_DROPIN"
    RELOAD_NEEDED=1
    echo "🎨 Removed stale banner drop-in ($OLD_DROPIN)"
fi

if [[ -f "$NEW/banners_enabled" && -f "$NEW/users.db" ]]; then
    tmp="$(mktemp)"
    echo "# VPS_superScript - Dynamic per-user SSH banners" > "$tmp"
    while IFS=: read -r u _rest; do
        [[ -z "$u" || "$u" == \#* ]] && continue
        echo "Match User $u"                                    >> "$tmp"
        echo "    Banner /etc/VPS_superScript/banners/${u}.txt"  >> "$tmp"
    done < "$NEW/users.db"
    mv "$tmp" "$NEW_DROPIN"
    grep -q "^Include /etc/ssh/sshd_config.d/" /etc/ssh/sshd_config \
        || echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config
    RELOAD_NEEDED=1
    echo "🎨 Rebuilt per-user banner routing against new paths"
fi

# ---- 5. validate & reload sshd (never break SSH on a live box) ------------
if [[ "$RELOAD_NEEDED" -eq 1 ]]; then
    if sshd -t 2>/dev/null; then
        systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || true
        echo "   ✓ sshd config valid — reloaded"
    else
        rm -f "$NEW_DROPIN"
        echo "   ⚠️  sshd -t FAILED — reverted the banner drop-in, sshd left untouched."
        echo "      Your SSH is unaffected; enable banners later from the menu."
    fi
fi
echo

echo "🎉 Done. Launch  menu  → [7] List Users to confirm your accounts are there."
echo "   Your old data is untouched at $OLD, and a backup is at ${NEW}.pre-migrate.$TS"

#!/bin/bash
# ==========================================================
#  VPS_superScript — installer with license gate
#
#  Drop-in replacement for install.sh. Same flow, but it
#  refuses to touch the box without a signed key.
#
#  Usage on a client VPS:
#
#    # 1. show this box's machine id (step the bot asks for)
#    tr -d '\n\r ' < /etc/machine-id | sha256sum | cut -c1-16
#
#    # 2. send it to the bot:  /newkey <id> 30
#    # 3. install with the key it replies with
#
#    bash <(curl -fsSL $RAW_BASE/install-with-key.sh) 'VSS1-eyJ...xxxx'
#
#  Or non-interactively:
#    VSS_LICENSE_KEY='VSS1-...' bash install-with-key.sh
# ==========================================================
set -euo pipefail

# ---- repo location (same overrides as the original install.sh) ----
FF_REPO_HOST="${FF_REPO_HOST:-github}"
FF_REPO_OWNER="${FF_REPO_OWNER:-SONICE-ENCHIL}"
FF_REPO_NAME="${FF_REPO_NAME:-VPS_superScript-Revamp}"
FF_REPO_BRANCH="${FF_REPO_BRANCH:-main}"

if [[ "$FF_REPO_HOST" == "github" ]]; then
    RAW_BASE="https://raw.githubusercontent.com/$FF_REPO_OWNER/$FF_REPO_NAME/$FF_REPO_BRANCH"
else
    RAW_BASE="https://codeberg.org/$FF_REPO_OWNER/$FF_REPO_NAME/raw/branch/$FF_REPO_BRANCH"
fi

MENU_URL="$RAW_BASE/menu.sh"
SSHD_URL="$RAW_BASE/ssh"
LICENSE_LIB_URL="$RAW_BASE/vss-license.sh"
API_CLIENT_URL="$RAW_BASE/vss-api-client.sh"

# Set this to your entitlement API before you publish the repo. menu.sh only
# uses the entitlement layer when the client library below installed OK.
VSS_API_URL="${VSS_API_URL:-https://api.yourdomain.com}"

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

# ==========================================================
#  STEP 1 — LICENSE, before anything is downloaded
# ==========================================================

echo "VPS_superScript Manager — license check"

tmp_lib="$(mktemp)"
trap 'rm -f "$tmp_lib"' EXIT

if ! curl -fsSL --retry 3 --connect-timeout 30 -o "$tmp_lib" "$LICENSE_LIB_URL"; then
    echo "Error: could not fetch the license library." >&2
    exit 1
fi
# shellcheck source=/dev/null
source "$tmp_lib"

if ! license_verify "${1:-}"; then
    echo
    echo "This copy of VPS_superScript requires a license key."
    if [[ -t 0 ]]; then
        echo "Nothing on this machine has been changed."
        echo
        echo "To buy a key, message the bot and send:"
        echo "    /buy"
    fi
    exit 2
fi

echo "License OK — owner: $VSS_LICENSE_OWNER, expires: $VSS_LICENSE_EXPIRES"

# ==========================================================
#  STEP 2 — original install flow
# ==========================================================

echo "Installing VPS_superScript Manager..."

download_file() {
    local dest=$1
    local url=$2
    local tmp
    tmp="$(mktemp)"
    if command -v curl &> /dev/null; then
        if ! curl -fsSL --retry 3 --connect-timeout 30 -o "$tmp" "$url"; then
            rm -f "$tmp"
            echo "Error: failed to download $url" >&2
            echo "       Make sure the repo/branch is public and the file exists." >&2
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if ! wget -q --tries=3 --timeout=30 -O "$tmp" "$url"; then
            rm -f "$tmp"
            echo "Error: failed to download $url" >&2
            echo "       Make sure the repo/branch is public and the file exists." >&2
            exit 1
        fi
    else
        rm -f "$tmp"
        echo "Error: Neither curl nor wget is installed." >&2
        exit 1
    fi
    if [[ ! -s "$tmp" ]]; then
        rm -f "$tmp"
        echo "Error: downloaded file from $url is empty." >&2
        exit 1
    fi
    mv -f "$tmp" "$dest"
}

# Install menu
download_file /usr/local/bin/menu "$MENU_URL"
sed -i 's/\r$//' /usr/local/bin/menu 2>/dev/null || true
chmod +x /usr/local/bin/menu

# Install the license library next to the app, so menu.sh can source it
# even when the repo goes private later.
mkdir -p /usr/lib/VPS_superScript
cp -f "$tmp_lib" /usr/lib/VPS_superScript/vss-license.sh
chmod 644 /usr/lib/VPS_superScript/vss-license.sh

# Entitlement client. Optional: until the API exists this 404s, and menu.sh
# treats a missing library as "license-only" rather than bricking the box.
if curl -fsSL --retry 2 --connect-timeout 15 \
        -o /usr/lib/VPS_superScript/vss-api-client.sh "$API_CLIENT_URL" 2>/dev/null; then
    chmod 644 /usr/lib/VPS_superScript/vss-api-client.sh
    mkdir -p /etc/VPS_superScript
    printf 'VSS_API_URL=%s\n' "$VSS_API_URL" > /etc/VPS_superScript/api.conf
    chmod 600 /etc/VPS_superScript/api.conf
    echo "Entitlement client installed ($VSS_API_URL)."
else
    rm -f /usr/lib/VPS_superScript/vss-api-client.sh
    echo "Note: entitlement client not published yet — license-only mode."
fi

echo "Applying VPS_superScript SSH configuration..."

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="/etc/ssh/sshd_config.backup.$(date +%F-%H%M%S)"

cp "$SSHD_CONFIG" "$BACKUP"
download_file "$SSHD_CONFIG" "$SSHD_URL"
chmod 600 "$SSHD_CONFIG"

if ! sshd -t 2>/dev/null; then
    echo "ERROR: SSH configuration is invalid!" >&2
    echo "Restoring previous configuration..." >&2
    cp "$BACKUP" "$SSHD_CONFIG"
    exit 1
fi

echo "SSH configuration validated."

restart_ssh() {
    if command -v systemctl >/dev/null 2>&1; then
        systemctl restart sshd 2>/dev/null \
        || systemctl restart ssh 2>/dev/null \
        || return 1
    elif command -v service >/dev/null 2>&1; then
        service sshd restart 2>/dev/null \
        || service ssh restart 2>/dev/null \
        || return 1
    elif command -v rc-service >/dev/null 2>&1; then
        rc-service sshd restart 2>/dev/null \
        || rc-service ssh restart 2>/dev/null \
        || return 1
    elif [ -x /etc/init.d/sshd ]; then
        /etc/init.d/sshd restart >/dev/null 2>&1
    elif [ -x /etc/init.d/ssh ]; then
        /etc/init.d/ssh restart >/dev/null 2>&1
    else
        return 1
    fi
}

if restart_ssh; then
    echo "SSH service restarted."
else
    echo "WARNING: SSH restart not supported on this system."
    echo "SSH config applied but service was not restarted automatically."
fi

# Only now, after every download and config write succeeded, do we
# persist the key. A failed install leaves no usable license behind.
license_save "${1:-${VSS_LICENSE_KEY:-}}"

bash /usr/local/bin/menu --install-setup

echo "Installation complete!"
echo "Type 'menu' to start."

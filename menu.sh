#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

C_RESET=$'\033[0m'
C_BOLD=$'\033[1m'
C_DIM=$'\033[2m'
C_UL=$'\033[4m'

# Premium Color Palette
C_RED=$'\033[38;5;196m'      # Bright Red
C_GREEN=$'\033[38;5;46m'     # Neon Green
C_YELLOW=$'\033[38;5;226m'   # Bright Yellow
C_BLUE=$'\033[38;5;39m'      # Deep Sky Blue
C_PURPLE=$'\033[38;5;135m'   # Light Purple
C_CYAN=$'\033[38;5;51m'      # Cyan
C_WHITE=$'\033[38;5;255m'    # Bright White
C_GRAY=$'\033[38;5;245m'     # Gray
C_ORANGE=$'\033[38;5;208m'   # Orange

# Semantic Aliases
C_TITLE=$C_PURPLE
C_CHOICE=$C_CYAN
C_PROMPT=$C_BLUE
C_WARN=$C_YELLOW
C_DANGER=$C_RED
C_STATUS_A=$C_GREEN
C_STATUS_I=$C_GRAY
C_ACCENT=$C_ORANGE

DB_DIR="/etc/VPS_superScript"
DB_FILE="$DB_DIR/users.db"
OWNER_FILE="$DB_DIR/user_owners.db"
INSTALL_FLAG_FILE="$DB_DIR/.install"
BADVPN_SERVICE_FILE="/etc/systemd/system/badvpn.service"
BADVPN_BUILD_DIR="/root/badvpn-build"

NGINX_CONFIG_FILE="/etc/nginx/sites-available/default"
SSL_CERT_DIR="/etc/VPS_superScript/ssl"
SSL_CERT_FILE="$SSL_CERT_DIR/VPS_superScript.pem"
SSL_CERT_CHAIN_FILE="$SSL_CERT_DIR/VPS_superScript.crt"
SSL_CERT_KEY_FILE="$SSL_CERT_DIR/VPS_superScript.key"
EDGE_CERT_INFO_FILE="$DB_DIR/edge_cert.conf"
NGINX_PORTS_FILE="$DB_DIR/nginx_ports.conf"
EDGE_PUBLIC_HTTP_PORT="80"
EDGE_PUBLIC_TLS_PORT="443"
NGINX_INTERNAL_HTTP_PORT="8880"
NGINX_INTERNAL_TLS_PORT="8443"

DNSTT_SERVICE_FILE="/etc/systemd/system/dnstt.service"
DNSTT_BINARY="/usr/local/bin/dnstt-server"
DNSTT_KEYS_DIR="/etc/VPS_superScript/dnstt"
DNSTT_CONFIG_FILE="$DB_DIR/dnstt_info.conf"
UDP_CUSTOM_DIR="/root/udp"
UDP_CUSTOM_SERVICE_FILE="/etc/systemd/system/udp-custom.service"
UDPGW_BINARY="/usr/local/bin/udpgw"
# Separate copy for badvpn. Same program as udpgw, but kept at its own path so
# uninstalling udp-custom cannot delete the binary badvpn's service runs.
BADVPN_BINARY="/usr/local/bin/badvpn-udpgw"
UDPGW_SERVICE_FILE="/etc/systemd/system/udpgw.service"
SSH_BANNER_FILE="/etc/bannerssh"
FALCONPROXY_SERVICE_FILE="/etc/systemd/system/falconproxy.service"
FALCONPROXY_BINARY="/usr/local/bin/falconproxy"
FALCONPROXY_CONFIG_FILE="$DB_DIR/falconproxy_config.conf"
LIMITER_SCRIPT="/usr/local/bin/VPS_superScript-limiter.sh"
LIMITER_SERVICE="/etc/systemd/system/VPS_superScript-limiter.service"
BANDWIDTH_DIR="$DB_DIR/bandwidth"
BACKUP_DIR="/root/VPS_superScript_backups"
TRIAL_EXPIRY_DIR="$DB_DIR/trials"
CREATED_DIR="$DB_DIR/created"
BANDWIDTH_SCRIPT="/usr/local/bin/VPS_superScript-bandwidth.sh"
BANDWIDTH_SERVICE="/etc/systemd/system/VPS_superScript-bandwidth.service"
LEGACY_BANDWIDTH_DIR="/usr/local/bin/VPS_superScript-bandwidth"
TRIAL_CLEANUP_SCRIPT="/usr/local/bin/VPS_superScript-trial-cleanup.sh"
LOGIN_INFO_SCRIPT="/usr/local/bin/VPS_superScript-login-info.sh"
SSHD_FF_CONFIG="/etc/ssh/sshd_config.d/VPS_superScript.conf"

# --- ZiVPN Variables ---
ZIVPN_DIR="/etc/zivpn"
ZIVPN_BIN="/usr/local/bin/zivpn"
ZIVPN_SERVICE_FILE="/etc/systemd/system/zivpn.service"
ZIVPN_CONFIG_FILE="$ZIVPN_DIR/config.json"
ZIVPN_CERT_FILE="$ZIVPN_DIR/zivpn.crt"
ZIVPN_KEY_FILE="$ZIVPN_DIR/zivpn.key"
ZIVPN_LISTEN_PORT="5667"
UDP_CUSTOM_LISTEN_PORT="36712"
BADVPN_LISTEN_PORT="7300"
# Tracks users whose password we pulled from the ZiVPN auth list while locked,
# so unlock can restore exactly what was removed (one file per user, holds pass).
ZIVPN_LOCK_DIR="$DB_DIR/zivpn_locked"

# --- HWID Lock Variables ---
# hwid_allowed.db is the runtime mirror the enforcer daemon reads, so it never
# has to parse the password-bearing main users.db while tailing journals.
HWID_ALLOWED_DB="$DB_DIR/hwid_allowed.db"            # username|password|hwid|strict
EXPORTS_DIR="/etc/VPS_superScript/exports"
HWID_ENFORCER_SCRIPT="/usr/local/bin/VPS_superScript-hwid-enforcer.sh"
HWID_ENFORCER_SERVICE="/etc/systemd/system/VPS_superScript-hwid-enforcer.service"
HWID_STATE_FILE="$DB_DIR/hwid_enforce.state"         # "on" / "off" global flag
HWID_POLICY_FILE="$DB_DIR/hwid_policy"               # "block" (secure default) / "allow"
HWID_KICK_LOG="/var/log/VPS_superScript_hwid.log"

# --- UDP Sharing Control (udp-custom) ---------------------------------------
# Per-user concurrent source-IP limiter for udp-custom. Because UDP has no
# per-process session to count (the relay runs as root), this daemon derives
# identity from udp-custom's own auth log and drops the *excess* source IPs for
# a user who exceeds their per-account connection limit. It FAILS VISIBLE: if it
# cannot parse an identity out of the log it says so rather than pretending.
UDP_SHARE_ENFORCER_SCRIPT="/usr/local/bin/VPS_superScript-udp-share.sh"
UDP_SHARE_ENFORCER_SERVICE="/etc/systemd/system/VPS_superScript-udp-share.service"
UDP_SHARE_STATE_FILE="$DB_DIR/udp_share.state"       # "on" / "off" global flag
UDP_SHARE_HEALTH_FILE="$DB_DIR/udp_share.health"     # runtime parser health for the menu
UDP_SHARE_ACTION_FILE="$DB_DIR/udp_share.action"     # warn | lock | drop (re-read live by daemon)
UDP_SHARE_LOG="/var/log/VPS_superScript_udp_share.log"

DESEC_TOKEN="V55cFY8zTictLCPfviiuX5DHjs15"
DESEC_DOMAIN="manager.VPS_superScript.qzz.io"

DOMAIN_OVERRIDE_FILE="$DB_DIR/domain_override"

# ── Support / Contact (shown in the banner subtitle) ──
SUPPORT_EMAIL="skylartecho@gmail.com"
SUPPORT_TG="@coded_skylartech"

# ── DuckDNS ──
DUCKDNS_CONFIG_FILE="$DB_DIR/duckdns.conf"
DUCKDNS_CRON_SCHED="*/5 * * * *"

# ── New Protocol Ports ──
DROPBEAR_PORTS="109,143"
OPENVPN_TCP_PORT="1194"
OPENVPN_UDP_PORT="2200"
OPENVPN_SDNS_PORT="25000"
WIREGUARD_PORT="51820"
HYSTERIA1_PORT="20000"
HYSTERIA2_PORT="20001"
SHADOWSOCKS_PORT="2443"
SOCKS5_PORT="1080"
STUNNEL_PORT="777"

# ── WS-SSH (WebSocket -> SSH bridge) ──
# These were referenced by install_ws_ssh, uninstall_ws_ssh, the port manager
# and the status grid, but never defined: the heredocs below wrote to an empty
# path, no unit was created, and every call still announced "installed".
WS_SSH_INTERNAL_PORT="2080"
WS_SSH_SCRIPT="/usr/local/bin/VPS_superScript-ws-ssh.py"
WS_SSH_SERVICE="/etc/systemd/system/ws-ssh.service"
WS_SSH_CONFIG_FILE="$DB_DIR/ws_ssh_config.conf"

# ── Service Info Database (for Service Info menu) ──
SERVICE_INFO_DB=(
  "SSH:OpenSSH server for secure shell access. Default: 22. Conflicts: none."
  "ZiVPN:Custom UDP VPN protocol for tunnel connections. Default: 5667. Conflicts: none."
  "UDP-Custom:Custom UDP tunneling protocol, popular for VPN. Default: 36712. Conflicts: none."
  "BadVPN:UDP gateway for forwarding UDP traffic. Default: 7300. Conflicts: none."
  "DNSTT:DNS-over-HTTPS tunnel (SlowDNS). Default: 53. Conflicts: none."
  "Nginx:Internal reverse proxy for WebSocket/gRPC. Default: 8880, 8443. Conflicts: none."
  "Dropbear:Lightweight SSH server alternative, more connections. Default: 109, 143. Conflicts: none."
  "OpenVPN:Full VPN tunnel with TCP/UDP/SlowDNS modes. Default: 1194, 2200, 25000. Conflicts: none."
  "WireGuard:Fast kernel-level VPN with modern crypto. Default: 51820. Conflicts: none."
  "Hysteria:HTTP/3 (QUIC) proxy to bypass DPI/censorship. Default: random high UDP. Conflicts: none (avoid 443/8443)."
  "ShadowSocks:Lightweight secure proxy protocol. Default: 2443, 3443. Conflicts: none."
  "Socks5:Simple SOCKS5 proxy for tunnel routing. Default: 1080. Conflicts: none."
  "Stunnel:SSL/TLS wrapper for non-encrypted connections. Default: 777. Conflicts: none."
  "WS-SSH:WebSocket SSH proxy — bridges WebSocket to SSH without FalconProxy. Accessible via 80/443 through Nginx. Conflicts: none."
)

# --- Repository / binary source -------------------------------------------
# Where release assets (Falcon Proxy) and raw files (udp-custom) are pulled
# from. Defaults preserve the original Codeberg source, so behaviour is
# unchanged. If you host a fork, override these via the environment, e.g.:
#   FF_REPO_HOST=github FF_REPO_OWNER=youruser FF_REPO_NAME=YourRepo menu
# (Codeberg uses the Gitea API; GitHub uses the GitHub API. Both expose
#  .tag_name, so version selection works on either host.)
FF_REPO_HOST="${FF_REPO_HOST:-github}"
FF_REPO_OWNER="${FF_REPO_OWNER:-SONICE-ENCHIL}"
FF_REPO_NAME="${FF_REPO_NAME:-VPS_superScript-Revamp}"
FF_REPO_BRANCH="${FF_REPO_BRANCH:-main}"

if [[ "$FF_REPO_HOST" == "github" ]]; then
    FF_RAW_BASE="https://raw.githubusercontent.com/$FF_REPO_OWNER/$FF_REPO_NAME/$FF_REPO_BRANCH"
    FF_RELEASES_API="https://api.github.com/repos/$FF_REPO_OWNER/$FF_REPO_NAME/releases"
    FF_RELEASE_DL_BASE="https://github.com/$FF_REPO_OWNER/$FF_REPO_NAME/releases/download"
else
    FF_RAW_BASE="https://codeberg.org/$FF_REPO_OWNER/$FF_REPO_NAME/raw/branch/$FF_REPO_BRANCH"
    FF_RELEASES_API="https://codeberg.org/api/v1/repos/$FF_REPO_OWNER/$FF_REPO_NAME/releases"
    FF_RELEASE_DL_BASE="https://codeberg.org/$FF_REPO_OWNER/$FF_REPO_NAME/releases/download"
fi

SELECTED_USER=""
UNINSTALL_MODE="interactive"
BANNER_CACHE_TTL=15
BANNER_CACHE_TS=0
BANNER_CACHE_OS_NAME=""
BANNER_CACHE_UP_TIME=""
BANNER_CACHE_RAM_USAGE=""
BANNER_CACHE_CPU_LOAD=""
BANNER_CACHE_ONLINE_USERS=0
BANNER_CACHE_TOTAL_USERS=0
BANNER_CACHE_EXPIRED_USERS=0
BANNER_CACHE_MEM_TOTAL=""
BANNER_CACHE_MEM_USED=""
BANNER_CACHE_MEM_FREE=""
BANNER_CACHE_MEM_BUFF=""
SSH_SESSION_CACHE_TTL=10
SSH_SESSION_CACHE_TS=0
SSH_SESSION_CACHE_DB_MTIME=0
SSH_SESSION_TOTAL=0
APT_CACHE_READY=0
FF_USERS_GROUP="ffusers"
declare -A SSH_SESSION_COUNTS=()
declare -A SSH_SESSION_PIDS=()
declare -A FF_TRIAL_USERS=()

# --- Package Manager Abstraction ---
FF_PKG_MGR=""
_detect_pkg_manager() {
    if command -v apt-get &>/dev/null; then
        FF_PKG_MGR="apt"
    elif command -v dnf &>/dev/null; then
        FF_PKG_MGR="dnf"
    elif command -v yum &>/dev/null; then
        FF_PKG_MGR="yum"
    elif command -v zypper &>/dev/null; then
        FF_PKG_MGR="zypper"
    elif command -v pacman &>/dev/null; then
        FF_PKG_MGR="pacman"
    else
        echo -e "${C_RED}❌ No supported package manager found (apt/dnf/yum/zypper/pacman).${C_RESET}"
        exit 1
    fi
}
_detect_pkg_manager

_map_pkg_names() {
    local -a result=()
    local pkg
    for pkg in "$@"; do
        case "$FF_PKG_MGR" in
            dnf|yum)
                case "$pkg" in
                    build-essential) result+=(gcc gcc-c++ make) ;;
                    libssl-dev) result+=(openssl-devel) ;;
                    libnspr4-dev) result+=(nspr-devel) ;;
                    libnss3-dev) result+=(nss-devel) ;;
                    nginx-common) result+=(nginx) ;;
                    pkg-config) result+=(pkgconf) ;;
                    *) result+=("$pkg") ;;
                esac ;;
            zypper)
                case "$pkg" in
                    build-essential) result+=(gcc gcc-c++ make) ;;
                    libssl-dev) result+=(libopenssl-devel) ;;
                    libnspr4-dev) result+=(mozilla-nspr-devel) ;;
                    libnss3-dev) result+=(mozilla-nss-devel) ;;
                    nginx-common) result+=(nginx) ;;
                    *) result+=("$pkg") ;;
                esac ;;
            pacman)
                case "$pkg" in
                    build-essential) result+=(base-devel) ;;
                    libssl-dev) result+=(openssl) ;;
                    libnspr4-dev) result+=(nspr) ;;
                    libnss3-dev) result+=(nss) ;;
                    nginx-common) result+=(nginx) ;;
                    bc) result+=(bc) ;;
                    *) result+=("$pkg") ;;
                esac ;;
            *) result+=("$pkg") ;;
        esac
    done
    printf '%s\n' "${result[@]}"
}

if [[ $EUID -ne 0 ]]; then
   echo -e "${C_RED}❌ Error: This script requires root privileges to run.${C_RESET}"
   exit 1
fi

get_ubuntu_codename() {
    local codename=""

    if [[ -r /etc/os-release ]]; then
        codename=$(awk -F= '/^(VERSION_CODENAME|UBUNTU_CODENAME)=/{gsub(/"/, "", $2); if ($2 != "") { print $2; exit }}' /etc/os-release 2>/dev/null)
    fi

    if [[ -z "$codename" ]] && command -v lsb_release &>/dev/null; then
        codename=$(lsb_release -sc 2>/dev/null)
    fi

    echo "$codename"
}

is_known_eol_ubuntu_codename() {
    case "$1" in
        yakkety|zesty|artful|cosmic|disco|eoan|groovy|hirsute|impish|kinetic|lunar|mantic|oracular|plucky)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

rewrite_ubuntu_apt_sources() {
    local mode="$1"
    local os_id=""
    local changed=false
    local file backup_file
    local from_archive to_archive from_security to_security from_ports to_ports
    local -a source_files=("/etc/apt/sources.list" /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources)

    if [[ -r /etc/os-release ]]; then
        os_id=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2; exit}' /etc/os-release 2>/dev/null)
    fi
    [[ "$os_id" == "ubuntu" ]] || return 1

    case "$mode" in
        primary)
            from_archive='https?://([A-Za-z0-9-]+\.)?archive\.ubuntu\.com/ubuntu'
            to_archive='http://archive.ubuntu.com/ubuntu'
            from_security='https?://security\.ubuntu\.com/ubuntu'
            to_security='http://security.ubuntu.com/ubuntu'
            from_ports='https?://ports\.ubuntu\.com/ubuntu-ports'
            to_ports='http://ports.ubuntu.com/ubuntu-ports'
            ;;
        old-releases)
            from_archive='https?://([A-Za-z0-9-]+\.)?archive\.ubuntu\.com/ubuntu'
            to_archive='http://old-releases.ubuntu.com/ubuntu'
            from_security='https?://security\.ubuntu\.com/ubuntu'
            to_security='http://old-releases.ubuntu.com/ubuntu'
            from_ports='https?://ports\.ubuntu\.com/ubuntu-ports'
            to_ports='http://old-releases.ubuntu.com/ubuntu'
            ;;
        *)
            return 1
            ;;
    esac

    for file in "${source_files[@]}"; do
        [[ -f "$file" ]] || continue
        if grep -Eq "$from_archive|$from_security|$from_ports" "$file" 2>/dev/null; then
            backup_file="${file}.bak.VPS_superScript"
            [[ -f "$backup_file" ]] || cp "$file" "$backup_file" 2>/dev/null || true
            sed -i -E \
                -e "s|$from_archive|$to_archive|g" \
                -e "s|$from_security|$to_security|g" \
                -e "s|$from_ports|$to_ports|g" \
                "$file" 2>/dev/null
            changed=true
        fi
    done

    [[ "$changed" == true ]]
}

repair_ubuntu_apt_mirrors() {
    rewrite_ubuntu_apt_sources "primary"
}

switch_ubuntu_to_old_releases() {
    local codename
    codename=$(get_ubuntu_codename)
    [[ -n "$codename" ]] || return 1
    is_known_eol_ubuntu_codename "$codename" || return 1
    rewrite_ubuntu_apt_sources "old-releases"
}

ff_apt_update() {
    local -a apt_opts=(
        -o Acquire::Retries=3
        -o Acquire::ForceIPv4=true
        -o Acquire::http::Timeout=20
        -o Acquire::https::Timeout=20
        -o Acquire::http::Pipeline-Depth=0
    )

    if (( APT_CACHE_READY == 1 )); then
        return 0
    fi

    if DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update; then
        APT_CACHE_READY=1
        return 0
    fi

    if repair_ubuntu_apt_mirrors; then
        echo -e "${C_YELLOW}⚠️ APT mirror timed out. Switching Ubuntu sources to archive.ubuntu.com and retrying...${C_RESET}"
        apt-get clean >/dev/null 2>&1 || true
        if DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update; then
            APT_CACHE_READY=1
            return 0
        fi
    fi

    if switch_ubuntu_to_old_releases; then
        echo -e "${C_YELLOW}⚠️ Detected an end-of-life Ubuntu release. Switching APT sources to old-releases.ubuntu.com and retrying...${C_RESET}"
        apt-get clean >/dev/null 2>&1 || true
        if DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update; then
            APT_CACHE_READY=1
            return 0
        fi
    fi

    echo -e "${C_RED}❌ Failed to refresh package lists. Please check VPS network, DNS, or blocked Ubuntu mirrors.${C_RESET}"
    return 1
}

ff_apt_install() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0

    ff_apt_update || return 1
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Use-Pty=0 install "${packages[@]}"
}

ff_apt_purge() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Use-Pty=0 purge "${packages[@]}"
}

ff_pkg_install() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0
    local -a mapped=()
    mapfile -t mapped < <(_map_pkg_names "${packages[@]}")
    case "$FF_PKG_MGR" in
        apt) ff_apt_install "${mapped[@]}" ;;
        dnf) dnf install -y -q "${mapped[@]}" ;;
        yum) yum install -y -q "${mapped[@]}" ;;
        zypper) zypper install -y -q "${mapped[@]}" ;;
        pacman) pacman -S --noconfirm --needed "${mapped[@]}" ;;
        *) echo -e "${C_RED}❌ Unsupported package manager.${C_RESET}"; return 1 ;;
    esac
}

ff_pkg_purge() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0
    local -a mapped=()
    mapfile -t mapped < <(_map_pkg_names "${packages[@]}")
    case "$FF_PKG_MGR" in
        apt) ff_apt_purge "${mapped[@]}" ;;
        dnf) dnf remove -y -q "${mapped[@]}" ;;
        yum) yum remove -y -q "${mapped[@]}" ;;
        zypper) zypper remove -y "${mapped[@]}" ;;
        pacman) pacman -Rns --noconfirm "${mapped[@]}" 2>/dev/null ;;
        *) echo -e "${C_RED}❌ Unsupported package manager.${C_RESET}"; return 1 ;;
    esac
}

ff_pkg_autoremove() {
    case "$FF_PKG_MGR" in
        apt) apt-get autoremove -y >/dev/null 2>&1 ;;
        dnf) dnf autoremove -y -q >/dev/null 2>&1 ;;
        yum) yum autoremove -y -q >/dev/null 2>&1 ;;
        zypper) zypper packages --unneeded 2>/dev/null | awk -F'|' 'NR>3{print $3}' | xargs -r zypper remove -y >/dev/null 2>&1 ;;
        pacman) pacman -Qdtq 2>/dev/null | xargs -r pacman -Rns --noconfirm >/dev/null 2>&1 ;;
    esac
    return 0
}

ff_pkg_is_installed() {
    local pkg="$1"
    case "$FF_PKG_MGR" in
        apt) dpkg -s "$pkg" &>/dev/null ;;
        dnf|yum) rpm -q "$pkg" &>/dev/null ;;
        zypper) rpm -q "$pkg" &>/dev/null ;;
        pacman) pacman -Q "$pkg" &>/dev/null ;;
    esac
}

# Enable a unit, (re)start it, and verify it actually came up. Every protocol
# installer used to print "✅ installed" and leave the truth to the status grid,
# which showed a red dot next to a protocol the user had just been told was
# fine. This makes the installer the single place that decides success.
# Usage: ff_service_up <unit> <label> [verify-seconds]
# Returns 0 only when `systemctl is-active` says the unit is running.
ff_service_up() {
    local unit="$1" label="${2:-$1}" wait_s="${3:-2}"
    systemctl daemon-reload >/dev/null 2>&1
    # Clear a latched "failed" state; without this a unit that failed once keeps
    # reporting failed even after the cause is fixed.
    systemctl reset-failed "$unit" >/dev/null 2>&1
    systemctl enable "$unit" >/dev/null 2>&1
    systemctl restart "$unit" >/dev/null 2>&1
    sleep "$wait_s"
    if systemctl is-active --quiet "$unit" 2>/dev/null; then
        return 0
    fi
    echo -e "\n${C_RED}❌ ${label} failed to start.${C_RESET}"
    echo -e "${C_YELLOW}ℹ️ Last 15 log lines for ${unit}:${C_RESET}"
    journalctl -u "$unit" -n 15 --no-pager 2>/dev/null
    return 1
}

# The units are already on disk, so the installer can only report "already
# installed". It used to just `return`, which left a stopped (or crash-looping)
# service exactly as it was — the user reinstalled and still saw a red dot.
# This restarts and reports the real state instead.
# Usage: ff_service_kick <unit> <label>
ff_service_kick() {
    local unit="$1" label="${2:-$1}"
    echo -e "\n${C_BLUE}▶️ Bringing ${label} up...${C_RESET}"
    if ff_service_up "$unit" "$label" 2; then
        echo -e "${C_GREEN}✅ ${label} is active.${C_RESET}"
    fi
}

# Download a binary and verify it actually is an executable, not an HTML/JSON
# error page (e.g. a 404 from a fork that is missing the release asset). This
# prevents installing a broken "binary" and chmod +x-ing an error page.
# Usage: ff_fetch_binary <dest> <url>
ff_fetch_binary() {
    local dest="$1" url="$2"
    rm -f "$dest" 2>/dev/null
    if ! wget -q --show-progress -O "$dest" "$url"; then
        rm -f "$dest" 2>/dev/null
        return 1
    fi
    # Must be non-empty and a real binary (ELF) or at least not an HTML/JSON page.
    if [[ ! -s "$dest" ]]; then
        rm -f "$dest" 2>/dev/null
        return 1
    fi
    if command -v file &>/dev/null; then
        if ! file -b "$dest" | grep -qiE 'ELF|executable'; then
            rm -f "$dest" 2>/dev/null
            return 1
        fi
    else
        # Fallback: reject obvious HTML/JSON error bodies by their first bytes.
        local head_bytes
        head_bytes=$(head -c 16 "$dest" 2>/dev/null)
        case "$head_bytes" in
            "<"*|"{"*|"["*)
                rm -f "$dest" 2>/dev/null
                return 1 ;;
        esac
    fi
    return 0
}

# Fetch a remote shell installer to a temp file, sanity-check it, then run it.
# `bash <(curl ...)` discards curl's exit status: a DNS failure, a 404 HTML
# page, or a rate-limit JSON body all get piped straight into bash and
# "succeed". This downloads first, rejects empty/HTML/JSON bodies, and only
# then executes — so a bad URL or a mistyped version tag reports an error
# instead of silently doing nothing.
# Usage: ff_run_remote_installer <url> [args-passed-to-script...]
ff_run_remote_installer() {
    local url="$1"; shift
    local tmp rc
    tmp=$(mktemp /tmp/ff-installer.XXXXXX 2>/dev/null) || {
        echo -e "${C_RED}❌ Could not create a temporary file.${C_RESET}"
        return 1
    }
    if ! curl -fsSL --max-time 60 -o "$tmp" "$url"; then
        echo -e "${C_RED}❌ Download failed:${C_RESET} ${C_YELLOW}$url${C_RESET}"
        echo -e "${C_DIM}   Check your network, or that the version tag exists.${C_RESET}"
        rm -f "$tmp"; return 1
    fi
    if [[ ! -s "$tmp" ]]; then
        echo -e "${C_RED}❌ Downloaded installer is empty.${C_RESET}"
        rm -f "$tmp"; return 1
    fi
    # Reject HTML/JSON error bodies that still returned HTTP 200.
    local first
    first=$(head -c 1 "$tmp" 2>/dev/null)
    case "$first" in
        "<"|"{"|"[")
            echo -e "${C_RED}❌ Server returned a web page, not an install script.${C_RESET}"
            echo -e "${C_DIM}   That usually means the version does not exist.${C_RESET}"
            rm -f "$tmp"; return 1 ;;
    esac
    bash "$tmp" "$@"
    rc=$?
    rm -f "$tmp"
    return $rc
}

# Mandatory Dependency Check (Added jq and curl)
check_environment() {
    local missing_packages=()
    local cmd

    for cmd in bc jq curl wget; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_packages+=("$cmd")
        fi
    done

    if (( ${#missing_packages[@]} > 0 )); then
        echo -e "${C_YELLOW}⚠️ Installing missing dependencies: ${missing_packages[*]}${C_RESET}"
        ff_pkg_install "${missing_packages[@]}" >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Error: Failed to install required dependencies: ${missing_packages[*]}.${C_RESET}"
            exit 1
        }
    fi
}

migrate_from_firewallfalcon() {
    [[ -d /etc/firewallfalcon ]] || return 0
    echo -e "${C_YELLOW}⚠️ Detected old FirewallFalcon installation. Migrating to VPS_superScript...${C_RESET}"

    # Stop old services
    for svc in firewallfalcon-limiter firewallfalcon-bandwidth firewallfalcon-hwid-enforcer; do
        systemctl stop "$svc" 2>/dev/null || true
        systemctl disable "$svc" 2>/dev/null || true
    done

    # Move data directory
    [[ -d /etc/firewallfalcon ]] && mv /etc/firewallfalcon /etc/VPS_superScript

    # Move backup directory
    [[ -d /root/firewallfalcon_backups ]] && mv /root/firewallfalcon_backups /root/VPS_superScript_backups

    # Rename scripts
    for old in /usr/local/bin/firewallfalcon-*.sh; do
        [[ -f "$old" ]] || continue
        local new="${old//firewallfalcon-/VPS_superScript-}"
        mv "$old" "$new"
    done

    # Rename systemd service files
    for old in /etc/systemd/system/firewallfalcon-*.service; do
        [[ -f "$old" ]] || continue
        local new="${old//firewallfalcon-/VPS_superScript-}"
        mv "$old" "$new"
        # Update service file internals referencing old paths
        sed -i 's|/etc/firewallfalcon|/etc/VPS_superScript|g; s|firewallfalcon-|VPS_superScript-|g; s|FirewallFalcon|VPS_superScript|g' "$new"
    done

    # Rename log files
    for old in /var/log/firewallfalcon_*.log; do
        [[ -f "$old" ]] || continue
        local new="${old//firewallfalcon_/VPS_superScript_}"
        mv "$old" "$new"
    done

    # Rename sshd config drop-in
    [[ -f /etc/ssh/sshd_config.d/firewallfalcon.conf ]] && mv /etc/ssh/sshd_config.d/firewallfalcon.conf /etc/ssh/sshd_config.d/VPS_superScript.conf

    # Rename backup marker files
    local bak_files
    while IFS= read -r -d '' bak_files; do
        local dir="${bak_files%/*}"
        local base="${bak_files##*/}"
        local new_base="${base//firewallfalcon/VPS_superScript}"
        [[ "$base" != "$new_base" ]] && mv "$bak_files" "$dir/$new_base"
    done < <(find /etc /root /usr/local -name '*.bak.firewallfalcon' -print0 2>/dev/null)
    # Reload systemd and re-enable services
    systemctl daemon-reload 2>/dev/null || true
    for svc in VPS_superScript-limiter VPS_superScript-bandwidth VPS_superScript-hwid-enforcer VPS_superScript-udp-share; do
        if [[ -f "/etc/systemd/system/${svc}.service" ]]; then
            systemctl enable "$svc" 2>/dev/null || true
            systemctl start "$svc" 2>/dev/null || true
        fi
    done

    # Migrate iptables rules file if it exists
    [[ -f /etc/iptables/rules.v4 ]] && sed -i 's|/etc/firewallfalcon|/etc/VPS_superScript|g' /etc/iptables/rules.v4 2>/dev/null || true

    # Update any stale banner references in sshd_config
    sed -i 's|/etc/firewallfalcon|/etc/VPS_superScript|g' /etc/ssh/sshd_config 2>/dev/null || true

    # Remove old empty directory if it still exists
    rmdir /etc/firewallfalcon 2>/dev/null || true

    echo -e "${C_GREEN}✅ Migration complete.${C_RESET}"
}

migrate_from_skylartech() {
    # One-time import of an existing skylartech-manager install on the SAME box.
    # skylartech and VPS_superScript both descend from FirewallFalcon and share an
    # identical users.db row format (user:pass:expiry:limit:bw::hwid:strict:app) and
    # data-store layout, so accounts, passwords, bandwidth counters, HWID/ZiVPN
    # locks, trials, certs, DNSTT keys, banners and on/off state flags all carry
    # over 1:1. Unlike migrate_from_firewallfalcon() we COPY (never move), leaving
    # /etc/skylartech fully intact as a fallback.
    local OLD="/etc/skylartech"
    [[ -d "$OLD" ]] || return 0

    # Never clobber existing VPS_superScript data. Skip if this box has already
    # completed a VPS_superScript setup, or already has users in its db (e.g. a
    # FirewallFalcon migration ran moments ago — that data wins, since a box can't
    # meaningfully have carried both lineages into the same slot).
    [[ -f "$INSTALL_FLAG_FILE" ]] && return 0
    local dest_rows=0
    [[ -f "$DB_FILE" ]] && dest_rows="$(grep -c . "$DB_FILE" 2>/dev/null || echo 0)"
    [[ "$dest_rows" -gt 0 ]] && return 0

    echo -e "${C_YELLOW}⚠️ Detected existing skylartech-manager installation. Importing its accounts into VPS_superScript...${C_RESET}"

    mkdir -p "$DB_DIR"

    # Reversible: snapshot whatever VPS_superScript already has (normally nothing).
    if [[ -n "$(ls -A "$DB_DIR" 2>/dev/null)" ]]; then
        local ts; ts="$(date +%F-%H%M%S)"
        if cp -a "$DB_DIR" "${DB_DIR}.pre-skylartech.${ts}" 2>/dev/null; then
            echo -e "${C_BLUE}📦 Backed up current $DB_DIR → ${DB_DIR}.pre-skylartech.${ts}${C_RESET}"
        fi
    fi

    # Copy EVERYTHING from skylartech so nothing is missed — users.db, all locks,
    # counters, certs, keys, banners and every state flag. Data-dir contents are
    # path-agnostic (the only dir-name references live in systemd units and sshd
    # drop-ins, both OUTSIDE this directory and rebuilt fresh below), so a verbatim
    # copy is safe. The directory is empty here (gated above), so it's a clean copy.
    cp -a "$OLD/." "$DB_DIR/" 2>/dev/null || true
    # Let initial_setup own the install-flag; don't inherit skylartech's marker.
    rm -f "$DB_DIR/.install" 2>/dev/null || true

    # Stop & disable the stale skylartech background services so they stop acting
    # on the old /etc/skylartech state. Their unit names differ from
    # VPS_superScript's, so the fresh install won't otherwise touch them. The
    # shared protocol daemons (zivpn, dnstt, udp-custom, badvpn, ...) keep the same
    # names in both and are left running. Disable — never delete.
    local svc
    for svc in skylartech-limiter skylartech-bandwidth skylartech-hwid-enforcer; do
        if [[ -f "/etc/systemd/system/${svc}.service" ]]; then
            systemctl disable --now "$svc" 2>/dev/null || true
        fi
    done

    # Drop the stale skylartech sshd banner drop-in (it points at old paths). The
    # correct new drop-in is rebuilt later in initial_setup from the imported data.
    rm -f /etc/ssh/sshd_config.d/skylartech.conf 2>/dev/null || true

    local rows; rows="$(grep -c . "$DB_FILE" 2>/dev/null || echo 0)"
    echo -e "${C_GREEN}✅ Imported ${rows} account(s) from skylartech. Old data left intact at $OLD as a fallback.${C_RESET}"

    # Tell initial_setup to re-apply the imported per-user banners after its own
    # banner-cleanup step (which would otherwise wipe them mid-setup).
    _SKYLAR_IMPORTED=1
}

ensure_VPS_superScript_dirs() {
    mkdir -p "$DB_DIR" "$SSL_CERT_DIR" "$BANDWIDTH_DIR" "$TRIAL_EXPIRY_DIR" "$CREATED_DIR" /etc/ssh/sshd_config.d
    touch "$DB_FILE"
    touch "$OWNER_FILE"
    chmod 600 "$OWNER_FILE" 2>/dev/null
}

ensure_VPS_superScript_system_group() {
    getent group "$FF_USERS_GROUP" >/dev/null 2>&1 || groupadd "$FF_USERS_GROUP" >/dev/null 2>&1 || true
}

db_has_user() {
    [[ -f "$DB_FILE" ]] || return 1
    awk -F: -v target="$1" '$1 == target { found=1; exit } END { exit(found ? 0 : 1) }' "$DB_FILE"
}

# Safely rewrite a user's record, preserving all fields.
# Usage: db_set_user <user> <pass> <expiry> <limit> <bandwidth> <marker> [hwid] [strict]
# Uses awk+ENVIRON (not sed) so values containing / & \ or other
# metacharacters cannot corrupt the database line.
# Fields 7 (hwid) and 8 (strict) are optional; when omitted they default to
# empty / 0, and a legacy 6-field row is transparently upgraded to 8 fields.
db_set_user() {
    [[ -f "$DB_FILE" ]] || return 1
    local tmp
    tmp=$(mktemp) || return 1
    _FF_DB_USER="$1" _FF_DB_PASS="$2" _FF_DB_EXPIRY="$3" \
    _FF_DB_LIMIT="$4" _FF_DB_BW="$5" _FF_DB_MARKER="$6" \
    _FF_DB_HWID="${7:-}" _FF_DB_STRICT="${8:-0}" _FF_DB_APP="${9:-http}" \
    awk -F: 'BEGIN { OFS=":" }
        $1 == ENVIRON["_FF_DB_USER"] {
            print ENVIRON["_FF_DB_USER"], ENVIRON["_FF_DB_PASS"], ENVIRON["_FF_DB_EXPIRY"], \
                  ENVIRON["_FF_DB_LIMIT"], ENVIRON["_FF_DB_BW"], ENVIRON["_FF_DB_MARKER"], \
                  ENVIRON["_FF_DB_HWID"], ENVIRON["_FF_DB_STRICT"], ENVIRON["_FF_DB_APP"]
            next
        }
        { print }
    ' "$DB_FILE" > "$tmp" && mv "$tmp" "$DB_FILE"
    local rc=$?
    rm -f "$tmp" 2>/dev/null
    return $rc
}

# Read a single colon field (1-based) for a user from users.db. Blank if absent.
# Usage: db_get_field <user> <field_number>
db_get_field() {
    [[ -f "$DB_FILE" ]] || { echo ""; return 1; }
    awk -F: -v u="$1" -v n="$2" '$1 == u { print $n; exit }' "$DB_FILE"
}

# Populate FF_TRIAL_USERS from users.db. Field 6 is the account marker; only
# auto-expiring trial accounts carry "trial". The user pickers use this to
# colour trials purple and keep them at the bottom of every list.
_ff_load_trial_users() {
    FF_TRIAL_USERS=()
    [[ -s "$DB_FILE" ]] || return 0
    local _u _m
    while IFS=: read -r _u _ _ _ _ _m _; do
        [[ -n "$_u" && "$_m" == "trial" ]] || continue
        _own_visible "$_u" && FF_TRIAL_USERS["$_u"]=1
    done < "$DB_FILE"
}

# Usernames in stable display order: normal accounts first, trials last, each
# group sorted by name. Mirrors the ordering used by list_users().
# When VSS_ACTOR is set (delegated admin console) only that owner's users are
# returned, so admin-created accounts never appear in delegated pickers.
_ff_sorted_user_names() {
    [[ -s "$DB_FILE" ]] || return 0
    local _n
    while IFS= read -r _n; do
        [[ -n "$_n" ]] || continue
        _own_visible "$_n" && printf '%s\n' "$_n"
    done < <(LC_ALL=C sort -t: -k6,6 -k1,1 "$DB_FILE" | cut -d: -f1)
}

# ── Delegated-admin ownership ─────────────────────────────
# user_owners.db maps <username>:<owner>. A missing row means the server owner
# ("admin") created the account. The owner sees everything; a delegated console
# runs with VSS_ACTOR=<actor> and only ever sees/touches rows owned by it.
_own_get() {
    local _o=""
    [[ -f "$OWNER_FILE" ]] && _o=$(awk -F: -v u="$1" '$1==u{print $2; exit}' "$OWNER_FILE" 2>/dev/null)
    printf '%s' "${_o:-admin}"
}
_own_set() { # <user> <owner>
    local _u="$1" _o="$2" _tmp
    mkdir -p "$DB_DIR"; touch "$OWNER_FILE"; chmod 600 "$OWNER_FILE" 2>/dev/null
    _tmp=$(mktemp) || return 1
    _OWN_U="$_u" _OWN_O="$_o" awk -F: 'BEGIN { OFS=":" }
        $1 == ENVIRON["_OWN_U"] { $2 = ENVIRON["_OWN_O"]; found=1; print; next }
        { print }
        END { if (!found) print ENVIRON["_OWN_U"] ":" ENVIRON["_OWN_O"] }
    ' "$OWNER_FILE" > "$_tmp" && mv "$_tmp" "$OWNER_FILE"
    local rc=$?
    rm -f "$_tmp" 2>/dev/null
    chmod 600 "$OWNER_FILE" 2>/dev/null
    return $rc
}
_own_remove() {
    local _u="$1" _tmp
    [[ -f "$OWNER_FILE" ]] || return 0
    _tmp=$(mktemp) || return 1
    awk -F: -v u="$_u" '$1!=u' "$OWNER_FILE" > "$_tmp" && mv "$_tmp" "$OWNER_FILE"
    rm -f "$_tmp" 2>/dev/null
    chmod 600 "$OWNER_FILE" 2>/dev/null
}
_own_visible() {
    [[ -z "${VSS_ACTOR:-}" ]] && return 0
    [[ "$(_own_get "$1")" == "$VSS_ACTOR" ]]
}
_own_guard() {
    _own_visible "$1" && return 0
    echo -e "\n${C_RED}❌ Access denied: '${1}' is not managed by you.${C_RESET}"
    return 1
}
_ff_valid_managed_username() {
    [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

# Regenerate the enforcer's runtime mirror from users.db, keeping only rows that
# actually carry an HWID. Called after every create / edit / renew / delete so the
# daemon always sees current state.
# Format: username|hwid|strict|password  — password is placed LAST so a literal '|'
# inside a password can't shift the hwid/strict columns the daemon relies on.
hwid_sync_allowed_db() {
    [[ -n "$DB_DIR" ]] || return 1
    mkdir -p "$DB_DIR" 2>/dev/null
    local tmp
    tmp=$(mktemp) || return 1
    if [[ -f "$DB_FILE" ]]; then
        awk -F: 'BEGIN { OFS="|" }
            { user=$1; pass=$2; hwid=$7; strict=$8 }
            user != "" && user !~ /^#/ {
                # Field 7 may list several devices; entries marked "!" are disabled.
                # The runtime mirror carries only the ENABLED ids (markers stripped),
                # so disabled devices are absent from the allow-list the enforcer reads.
                n = split(hwid, parts, ",")
                enabled = ""
                for (i = 1; i <= n; i++) {
                    t = parts[i]
                    gsub(/^[ \t]+|[ \t]+$/, "", t)
                    if (t == "" || substr(t, 1, 1) == "!") continue
                    enabled = (enabled == "") ? t : enabled "," t
                }
                if (enabled != "") {
                    if (strict == "") strict = "0"
                    print user, enabled, strict, pass
                }
            }
        ' "$DB_FILE" > "$tmp"
    fi
    mv "$tmp" "$HWID_ALLOWED_DB" 2>/dev/null || { rm -f "$tmp"; return 1; }
    chmod 600 "$HWID_ALLOWED_DB" 2>/dev/null
    return 0
}

# --- Per-device HWID parsing -------------------------------------------------
# Field 7 holds a comma-separated device list where each entry is either an
# enabled HWID ("hwidA") or a disabled one marked with a leading '!' ("!hwidA").
# A leading '!' is used (not a ':state' suffix) because device IDs can themselves
# contain ':' (MAC-style ids); a real HWID never starts with '!'. A bare entry
# (no marker) is treated as enabled, so legacy single/multi-HWID rows parse as-is.

# Parse a field-7 string into the globals FF_HWID_IDS[] and FF_HWID_STATES[]
# (parallel arrays; state is "on" or "off"). Whitespace trimmed, marker stripped.
_ff_hwid_parse() {
    FF_HWID_IDS=(); FF_HWID_STATES=()
    local raw="$1" part id state
    local IFS=','
    for part in $raw; do
        part="${part#"${part%%[![:space:]]*}"}"
        part="${part%"${part##*[![:space:]]}"}"
        [[ -z "$part" ]] && continue
        if [[ "${part:0:1}" == "!" ]]; then state="off"; id="${part:1}"; else state="on"; id="$part"; fi
        [[ -z "$id" ]] && continue
        FF_HWID_IDS+=("$id"); FF_HWID_STATES+=("$state")
    done
}

# Rebuild a field-7 string from FF_HWID_IDS[]/FF_HWID_STATES[] (re-emitting the
# '!' marker for disabled devices). Echoes the joined list.
_ff_hwid_join() {
    local out="" i
    for i in "${!FF_HWID_IDS[@]}"; do
        [[ -n "$out" ]] && out+=","
        [[ "${FF_HWID_STATES[$i]}" == "off" ]] && out+="!"
        out+="${FF_HWID_IDS[$i]}"
    done
    printf '%s' "$out"
}

# Normalize a raw comma-separated HWID string: split on ',', trim whitespace, drop
# empties, de-duplicate by device id (last occurrence wins, so re-adding a disabled
# device re-enables it), preserving order and each entry's enabled/disabled marker.
_ff_normalize_hwids() {
    local raw="$1" part id state i
    local -a ids=() states=()
    local IFS=','
    for part in $raw; do
        part="${part#"${part%%[![:space:]]*}"}"
        part="${part%"${part##*[![:space:]]}"}"
        [[ -z "$part" ]] && continue
        if [[ "${part:0:1}" == "!" ]]; then state="off"; id="${part:1}"; else state="on"; id="$part"; fi
        [[ -z "$id" ]] && continue
        # Last-wins: if this id was seen, update its state and keep its position.
        local found=""
        for i in "${!ids[@]}"; do
            if [[ "${ids[$i]}" == "$id" ]]; then states[$i]="$state"; found=1; break; fi
        done
        [[ -n "$found" ]] && continue
        ids+=("$id"); states+=("$state")
    done
    local out=""
    for i in "${!ids[@]}"; do
        [[ -n "$out" ]] && out+=","
        [[ "${states[$i]}" == "off" ]] && out+="!"
        out+="${ids[$i]}"
    done
    printf '%s' "$out"
}

# Human-readable HWID label for summaries/headers. Disabled devices render as
# "id (off)"; the trailer shows device + enabled counts when there's more than one
# device or any disabled one, else the compact "id (word: ON/OFF)".
# Arg1 = field-7 list, Arg2 = strict flag ("1"/"0"), Arg3 = word ("strict"/"enforce").
_ff_hwid_label() {
    local list="$1" strict="$2" word="${3:-strict}" st_msg disp="" i total enabled=0
    [[ -z "$list" ]] && { printf 'none'; return; }
    _ff_hwid_parse "$list"
    total=${#FF_HWID_IDS[@]}
    [[ "$total" -eq 0 ]] && { printf 'none'; return; }
    for i in "${!FF_HWID_IDS[@]}"; do
        [[ -n "$disp" ]] && disp+=", "
        if [[ "${FF_HWID_STATES[$i]}" == "off" ]]; then
            disp+="${FF_HWID_IDS[$i]} (off)"
        else
            disp+="${FF_HWID_IDS[$i]}"; enabled=$((enabled+1))
        fi
    done
    st_msg="off"; [[ "$strict" == "1" ]] && st_msg="ON"
    if (( total > 1 || enabled < total )); then
        printf '%s (%d devices, %d enabled, %s: %s)' "$disp" "$total" "$enabled" "$word" "$st_msg"
    else
        printf '%s (%s: %s)' "$disp" "$word" "$st_msg"
    fi
}

# ── Duration & quota parsing (OnePesewa-compatible UX) ──────────────────────
# Parse a duration like "30m", "2h", "1d", "2d4h30m" (or a bare number = days)
# into a whole number of seconds. Echoes 0 when the value is empty/invalid.
_ff_dur_to_seconds() {
    local s; s=$(printf '%s' "$1" | tr 'A-Z' 'a-z' | tr -d ' ,')
    [[ -z "$s" ]] && { echo 0; return; }
    if [[ "$s" =~ ^[0-9]+$ ]]; then echo $(( s * 86400 )); return; fi
    local total=0 matched=0
    [[ "$s" =~ ([0-9]+)d ]] && { total=$(( total + BASH_REMATCH[1]*86400 )); matched=1; }
    [[ "$s" =~ ([0-9]+)h ]] && { total=$(( total + BASH_REMATCH[1]*3600 ));  matched=1; }
    [[ "$s" =~ ([0-9]+)m ]] && { total=$(( total + BASH_REMATCH[1]*60 ));    matched=1; }
    [[ "$s" =~ ([0-9]+)s ]] && { total=$(( total + BASH_REMATCH[1] ));       matched=1; }
    [[ "$matched" -eq 1 ]] && echo "$total" || echo 0
}

# Convert seconds to trial duration format (20d5h30m) — matches the
# OFFICIAL OnePesewa panel style. Emits a bare duration (no "left" suffix)
# so callers can wrap it however they like.
expiry_human() {
    local s="$1" out="" dd hh mm
    [[ -z "$s" || ! "$s" =~ ^[0-9]+$ || "$s" -le 0 ]] && { echo "0d"; return; }
    ((dd = s / 86400)); ((s %= 86400))
    ((hh = s / 3600));  ((s %= 3600))
    ((mm = s / 60));    ((s %= 60))
    [ "$dd" -gt 0 ] && out="${dd}d"
    [ "$hh" -gt 0 ] && out="${out}${hh}h"
    [ "$mm" -gt 0 ] && out="${out}${mm}m"
    [ -z "$out" ] && out="<1m"
    printf '%s' "$out"
}

# Human "+durations" (e.g. 2d4h30m) rendered with a trailing "left" label for
# creation/renewal confirmations:  "20d5h30m left".
expiry_human_left() {
    local s="$1" h; h=$(expiry_human "$s")
    [[ "$h" == "<1m" ]] && { echo "<1m left"; return; }
    printf '%s left' "$h"
}

# True (rc 0) when a quota entry is well-formed: 100MB / 2GB / 1.5GB / a bare
# number (=GB, legacy) / 0 or blank (= unlimited). rc 1 otherwise.
_ff_quota_valid() {
    local up; up=$(printf '%s' "$1" | tr -d ' ' | tr 'a-z' 'A-Z')
    [[ -z "$up" || "$up" == "0" ]] && return 0
    [[ "$up" =~ ^[0-9]+(\.[0-9]+)?(GB|MB|KB)?$ ]] && return 0
    return 1
}

# Normalise a quota entry to a tidy canonical string ("2GB", "500MB", "0").
# Accepts 100MB / 2GB / 1.5GB / a bare number (=GB, legacy) / 0 (unlimited).
_ff_quota_canonical() {
    local up v; up=$(printf '%s' "$1" | tr -d ' ' | tr 'a-z' 'A-Z')
    [[ -z "$up" ]] && { echo "0"; return; }
    case "$up" in
        *GB) v="${up%GB}" ;;
        *MB) v="${up%MB}" ;;
        *KB) v="${up%KB}" ;;
        *)   v="$up" ;;
    esac
    [[ "$v" =~ ^[0-9]+(\.[0-9]+)?$ ]] || { echo "0"; return; }
    awk "BEGIN{exit !($v>0)}" || { echo "0"; return; }
    case "$up" in
        *GB) echo "${v}GB" ;;
        *MB) echo "${v}MB" ;;
        *KB) echo "${v}KB" ;;
        *)   echo "${v}GB" ;;
    esac
}

# Convert a stored quota field (canonical "2GB"/"500MB", legacy bare number =GB,
# or "0"/empty = unlimited) into a whole number of bytes. Echoes 0 for unlimited.
_ff_quota_to_bytes() {
    local up val mult
    up=$(printf '%s' "$1" | tr -d ' ' | tr 'a-z' 'A-Z')
    [[ -z "$up" || "$up" == "0" ]] && { echo 0; return; }
    case "$up" in
        *GB) mult=1073741824 ;;
        *MB) mult=1048576 ;;
        *KB) mult=1024 ;;
        *)   mult=1073741824 ;;
    esac
    val="${up%GB}"; val="${val%MB}"; val="${val%KB}"
    if ! [[ "$val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then echo 0; return; fi
    awk "BEGIN { printf \"%.0f\", $val * $mult }"
}

# Human label for a stored quota field ("Unlimited" when 0/empty).
_ff_quota_label() {
    local c; c=$(_ff_quota_canonical "$1")
    [[ "$c" == "0" ]] && printf 'Unlimited' || printf '%s' "$c"
}

is_VPS_superScript_orphan_user() {
    local username="$1"
    local passwd_line system_user _ uid _ home shell

    passwd_line=$(getent passwd "$username" 2>/dev/null) || return 1
    IFS=: read -r system_user _ uid _ _ home shell <<< "$passwd_line"
    [[ "$uid" =~ ^[0-9]+$ ]] || return 1
    db_has_user "$username" && return 1

    if id -nG "$username" 2>/dev/null | tr ' ' '\n' | grep -Fxq "$FF_USERS_GROUP"; then
        return 0
    fi

    (( uid >= 1000 )) || return 1
    [[ "$home" == "/home/$username" || "$home" == /home/* ]] || return 1

    case "$shell" in
        /usr/sbin/nologin|/usr/bin/false|/bin/false) return 0 ;;
    esac

    return 1
}

get_VPS_superScript_orphan_users() {
    local username
    while IFS=: read -r username _rest; do
        [[ -n "$username" ]] || continue
        if is_VPS_superScript_orphan_user "$username"; then
            echo "$username"
        fi
    done < /etc/passwd
}

get_VPS_superScript_known_users() {
    local username
    local -A seen_users=()

    if [[ -f "$DB_FILE" ]]; then
        while IFS=: read -r username _rest; do
            [[ -n "$username" && "$username" != \#* ]] || continue
            seen_users["$username"]=1
        done < "$DB_FILE"
    fi

    while IFS= read -r username; do
        [[ -n "$username" ]] && seen_users["$username"]=1
    done < <(get_VPS_superScript_orphan_users)

    (( ${#seen_users[@]} > 0 )) || return 0
    printf "%s\n" "${!seen_users[@]}" | sort
}

delete_VPS_superScript_user_accounts() {
    local -a users_to_delete=("$@")
    local username

    [[ ${#users_to_delete[@]} -gt 0 ]] || return 0

    # Delegated console: silently drop anything not owned by the actor so a
    # crafted argument list can never delete an admin-created account.
    if [[ -n "${VSS_ACTOR:-}" ]]; then
        local -a _allowed=()
        for username in "${users_to_delete[@]}"; do
            _own_visible "$username" && _allowed+=("$username")
        done
        users_to_delete=("${_allowed[@]}")
        [[ ${#users_to_delete[@]} -gt 0 ]] || return 0
    fi

    for username in "${users_to_delete[@]}"; do
        [[ -n "$username" ]] || continue
        local _del_app
        _del_app=$(db_get_field "$username" 9)
        # If this was a ZiVPN account, remove its password from config.json
        local _zivpn_pass
        _zivpn_pass=$(db_get_field "$username" 2)
        if [[ "$_del_app" == "zivpn" && -n "$_zivpn_pass" && -f "$ZIVPN_CONFIG_FILE" ]] && command -v jq &>/dev/null; then
            if jq -e --arg p "$_zivpn_pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null; then
                local _tmp; _tmp=$(mktemp) || true
                if [[ -n "$_tmp" ]] && jq --arg p "$_zivpn_pass" '.auth.config |= map(select(. != $p))' "$ZIVPN_CONFIG_FILE" > "$_tmp" 2>/dev/null; then
                    mv "$_tmp" "$ZIVPN_CONFIG_FILE"
                    echo -e " 🔑 ZiVPN password for '${C_YELLOW}$username${C_RESET}' removed from config."
                fi
                rm -f "$_tmp" 2>/dev/null
            fi
        fi
        # Clean up exported config files
        rm -f "$EXPORTS_DIR/${username}.ovpn" "$EXPORTS_DIR/${username}.conf" "$EXPORTS_DIR/${username}-hysteria.json" 2>/dev/null
        # OpenVPN: revoke client cert
        if [[ "$_del_app" == "openvpn" && -f /etc/openvpn/easy-rsa/pki/index.txt ]]; then
            ( cd /etc/openvpn/easy-rsa 2>/dev/null && EASYRSA_BATCH=1 ./easyrsa revoke "$username" 2>/dev/null && EASYRSA_BATCH=1 ./easyrsa gen-crl 2>/dev/null )
        fi
        # WireGuard: remove peer
        if [[ "$_del_app" == "wireguard" && -f /etc/wireguard/wg0.conf ]]; then
            local _wg_del_pub
            _wg_del_pub=$(grep -A1 "^# BEGIN ${username}$" /etc/wireguard/wg0.conf 2>/dev/null | grep PublicKey | awk '{print $3}')
            if [[ -n "$_wg_del_pub" ]]; then
                wg set wg0 peer "$_wg_del_pub" remove 2>/dev/null
                sed -i "/^# BEGIN ${username}$/,/^# END ${username}$/d" /etc/wireguard/wg0.conf 2>/dev/null
                wg-quick down wg0 2>/dev/null; wg-quick up wg0 2>/dev/null
            fi
        fi
        # Hysteria2: remove user from config
        if [[ "$_del_app" == "hysteria2" && -f /etc/hysteria/config.json ]] && command -v jq &>/dev/null; then
            local _tmp2; _tmp2=$(mktemp) || true
            if [[ -n "$_tmp2" ]]; then
                jq --arg u "$username" '.auth.config |= map(select(.user != $u))' /etc/hysteria/config.json > "$_tmp2" 2>/dev/null && mv "$_tmp2" /etc/hysteria/config.json
                rm -f "$_tmp2" 2>/dev/null
                systemctl try-restart hysteria-server 2>/dev/null
            fi
        fi
        # Clear any per-user traffic block before the UID is freed/recycled.
        _ff_unblock_user_traffic "$username"
        killall -u "$username" -9 &>/dev/null
        if id "$username" &>/dev/null; then
            if userdel -r "$username" &>/dev/null; then
                echo -e " ✅ System user '${C_YELLOW}$username${C_RESET}' deleted."
            else
                echo -e " ❌ Failed to delete system user '${C_YELLOW}$username${C_RESET}'."
            fi
        else
            echo -e " ℹ️ System user '${C_YELLOW}$username${C_RESET}' was already missing. Removing manager data only."
        fi
        rm -f "$BANDWIDTH_DIR/${username}.usage"
        rm -rf "$BANDWIDTH_DIR/pidtrack/${username}"
        rm -f "$TRIAL_EXPIRY_DIR/${username}.ts"
        rm -f "$CREATED_DIR/${username}"
        rm -f "$ZIVPN_LOCK_DIR/${username}"
        _own_remove "$username"
    done

    # Reload ZiVPN so any removed passwords take effect immediately.
    systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null

    if [[ -f "$DB_FILE" ]]; then
        local db_tmp
        db_tmp=$(mktemp)
        awk -F: 'NR==FNR { drop[$1]=1; next } !($1 in drop)' <(printf "%s\n" "${users_to_delete[@]}") "$DB_FILE" > "$db_tmp" && mv "$db_tmp" "$DB_FILE"
        rm -f "$db_tmp" 2>/dev/null
    fi

    # Keep the HWID enforcer's view current after removals.
    hwid_sync_allowed_db

    local _del_users="${users_to_delete[*]}"
    _send_telegram "🔔 <b>User(s) Deleted</b>%0A👤 $_del_users"

    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

require_interactive_terminal() {
    if [[ ! -t 0 || ! -t 1 ]]; then
        echo -e "${C_RED}❌ Error: The VPS_superScript menu must be run from an interactive terminal.${C_RESET}"
        exit 1
    fi
}

# Re-check the stored license key on every launch. install-with-key.sh drops
# the verifier at /usr/lib/VPS_superScript/vss-license.sh and the key at
# /etc/VPS_superScript/license.key; a missing library means the install was
# done with the un-gated install.sh, so we fall through rather than brick.
vss_license_gate() {
    local lib="/usr/lib/VPS_superScript/vss-license.sh"

    if [[ ! -r "$lib" ]]; then
        return 0
    fi

    # shellcheck source=/dev/null
    source "$lib"

    license_check_stored && { _vss_entitlement_gate_and_return; return 0; }

    clear
    echo -e "${C_RED}╔══════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_RED}║             LICENSE EXPIRED / INVALID            ║${C_RESET}"
    echo -e "${C_RED}╚══════════════════════════════════════════════════╝${C_RESET}"
    echo
    echo "This installation needs a valid key to run."
    echo "Send /renew to the seller's bot and paste the new key here."
    echo

    local newkey
    printf 'Paste new key (blank to quit): ' >&2
    read -r newkey
    newkey="$(printf '%s' "$newkey" | tr -d '[:space:]')"
    if [[ -n "$newkey" ]] && license_verify "$newkey"; then
        license_save "$newkey"
        echo -e "${C_GREEN}Key accepted — expires $VSS_LICENSE_EXPIRES.${C_RESET}"
        sleep 1
        _vss_entitlement_gate_and_return
        return 0
    fi

    exit 1
}

# Entitlement layer (server-side plan/quota check). Optional: the client
# library is only present on installs that shipped it, so its absence falls
# through instead of bricking older boxes.
_vss_entitlement_gate() {
    local lib="/usr/lib/VPS_superScript/vss-api-client.sh"

    if [[ ! -r "$lib" ]]; then
        return 0
    fi

    # shellcheck source=/dev/null
    source "$lib"

    if vss_api_sync; then
        return 0
    fi

    clear
    echo -e "${C_RED}╔══════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_RED}║        ENTITLEMENT EXPIRED / UNREACHABLE         ║${C_RESET}"
    echo -e "${C_RED}╚══════════════════════════════════════════════════╝${C_RESET}"
    echo
    echo "The server has not confirmed this installation's plan."
    echo "Check the network, then press Enter to retry."
    echo

    if [[ -t 0 ]]; then
        read -r _ans
    fi
    if vss_api_sync; then
        return 0
    fi
    exit 1
}

_vss_entitlement_gate_and_return() {
    _vss_entitlement_gate
    return 0
}

initial_setup() {
    migrate_from_firewallfalcon
    migrate_from_skylartech
    echo -e "${C_BLUE}⚙️ Initializing VPS_superScript Manager setup...${C_RESET}"
    check_environment
    
    ensure_VPS_superScript_dirs
    ensure_VPS_superScript_system_group
    
    echo -e "${C_BLUE}🔹 Configuring user limiter service...${C_RESET}"
    setup_limiter_service
    
    echo -e "${C_BLUE}🔹 Configuring bandwidth monitoring service...${C_RESET}"
    setup_bandwidth_service
    
    echo -e "${C_BLUE}🔹 Installing trial account cleanup script...${C_RESET}"
    setup_trial_cleanup_script

    echo -e "${C_BLUE}🔹 Preparing HWID lock store...${C_RESET}"
    touch "$HWID_ALLOWED_DB" 2>/dev/null
    chmod 600 "$HWID_ALLOWED_DB" 2>/dev/null
    hwid_sync_allowed_db
    # If HWID enforcement was previously enabled, re-arm it after a re-setup.
    if [[ "$(cat "$HWID_STATE_FILE" 2>/dev/null)" == "on" ]]; then
        enable_hwid_lock >/dev/null 2>&1
    fi
    # Same for UDP anti-sharing enforcement.
    if [[ "$(cat "$UDP_SHARE_STATE_FILE" 2>/dev/null)" == "on" ]]; then
        enable_udp_share >/dev/null 2>&1
    fi
    
    echo -e "${C_BLUE}🔹 Cleaning legacy dynamic SSH banner hooks...${C_RESET}"
    disable_dynamic_ssh_banner_system
    systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || true

    # If we just imported a skylartech install that had per-user SSH banners on,
    # re-apply them now (the cleanup above wipes banners mid-setup). /etc/skylartech
    # is our untouched source. Guarded by sshd -t so a bad config can never break SSH.
    if [[ "${_SKYLAR_IMPORTED:-0}" == "1" && -f /etc/skylartech/banners_enabled && -d /etc/skylartech/banners ]]; then
        echo -e "${C_BLUE}🔹 Re-applying per-user SSH banners imported from skylartech...${C_RESET}"
        mkdir -p "$DB_DIR/banners"
        cp -a /etc/skylartech/banners/. "$DB_DIR/banners/" 2>/dev/null || true
        touch "$DB_DIR/banners_enabled"
        update_ssh_banners_config
        if ! sshd -t 2>/dev/null; then
            rm -f "$SSHD_FF_CONFIG" "$DB_DIR/banners_enabled" 2>/dev/null
            systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || true
            echo -e "${C_YELLOW}⚠️ Imported banner config failed validation — reverted it (SSH unaffected).${C_RESET}"
        fi
    fi
    
    echo -e "${C_BLUE}🔹 Installing iptables-persistent for reboot survival...${C_RESET}"
    ff_pkg_install iptables-persistent >/dev/null 2>&1 || true
    systemctl enable netfilter-persistent 2>/dev/null || true
    
    echo -e "${C_BLUE}🔹 Applying NAT port forwarding defaults...${C_RESET}"
    apply_default_nat_rules
    
    if [ ! -f "$INSTALL_FLAG_FILE" ]; then
        touch "$INSTALL_FLAG_FILE"
    fi
    echo -e "${C_GREEN}✅ Setup finished.${C_RESET}"
}

_is_valid_ipv4() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

check_and_open_firewall_port() {
    local port="$1"
    local protocol="${2:-tcp}"
    local firewall_detected=false

    if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
        firewall_detected=true
        if ! ufw status | grep -qw "$port/$protocol"; then
            echo -e "${C_YELLOW}🔥 UFW firewall is active and port ${port}/${protocol} is closed.${C_RESET}"
            read -p "👉 Do you want to open this port now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                ufw allow "$port/$protocol"
                echo -e "${C_GREEN}✅ Port ${port}/${protocol} has been opened in UFW.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Port ${port}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
             echo -e "${C_GREEN}✅ Port ${port}/${protocol} is already open in UFW.${C_RESET}"
        fi
    fi

    if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
        firewall_detected=true
        if ! firewall-cmd --list-ports --permanent | grep -qw "$port/$protocol"; then
            echo -e "${C_YELLOW}🔥 firewalld is active and port ${port}/${protocol} is not open.${C_RESET}"
            read -p "👉 Do you want to open this port now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                firewall-cmd --add-port="$port/$protocol" --permanent
                firewall-cmd --reload
                echo -e "${C_GREEN}✅ Port ${port}/${protocol} has been opened in firewalld.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Port ${port}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Port ${port}/${protocol} is already open in firewalld.${C_RESET}"
        fi
    fi

    if ! $firewall_detected; then
        echo -e "${C_BLUE}ℹ️ No active firewall (UFW or firewalld) detected. Assuming ports are open.${C_RESET}"
    fi
    return 0
}

check_and_open_firewall_port_range() {
    local port_range="$1"
    local protocol="${2:-tcp}"
    local firewall_detected=false

    if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
        firewall_detected=true
        if ! ufw status | grep -Fq "$port_range/$protocol"; then
            echo -e "${C_YELLOW}🔥 UFW firewall is active and range ${port_range}/${protocol} is closed.${C_RESET}"
            read -p "👉 Do you want to open this port range now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                ufw allow "$port_range/$protocol"
                echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} has been opened in UFW.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Range ${port_range}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} is already open in UFW.${C_RESET}"
        fi
    fi

    if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
        firewall_detected=true
        if ! firewall-cmd --quiet --query-port="$port_range/$protocol"; then
            echo -e "${C_YELLOW}🔥 firewalld is active and range ${port_range}/${protocol} is not open.${C_RESET}"
            read -p "👉 Do you want to open this port range now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                firewall-cmd --add-port="$port_range/$protocol" --permanent
                firewall-cmd --reload
                echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} has been opened in firewalld.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Range ${port_range}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} is already open in firewalld.${C_RESET}"
        fi
    fi

    if ! $firewall_detected; then
        echo -e "${C_BLUE}ℹ️ No active firewall (UFW or firewalld) detected. Assuming range ${port_range}/${protocol} is open.${C_RESET}"
    fi
    return 0
}

check_and_free_ports() {
    local ports_to_check=("$@")
    for port in "${ports_to_check[@]}"; do
        echo -e "\n${C_BLUE}🔎 Checking if port $port is available...${C_RESET}"
        local conflicting_process_info
        conflicting_process_info=$(
            ss -H -lntp "( sport = :$port )" 2>/dev/null
            ss -H -lunp "( sport = :$port )" 2>/dev/null
        )
        
        if [[ -n "$conflicting_process_info" ]]; then
            local conflicting_pid
            conflicting_pid=$(echo "$conflicting_process_info" | grep -oP 'pid=\K[0-9]+' | head -n 1)
            local conflicting_name
            conflicting_name=$(echo "$conflicting_process_info" | grep -oP 'users:\(\("(\K[^"]+)' | head -n 1)
            
            echo -e "${C_YELLOW}⚠️ Warning: Port $port is in use by process '${conflicting_name:-unknown}' (PID: ${conflicting_pid:-N/A}).${C_RESET}"
            read -p "👉 Do you want to attempt to stop this process? (y/n): " kill_confirm
            if [[ "$kill_confirm" == "y" || "$kill_confirm" == "Y" ]]; then
                if [[ -z "$conflicting_pid" ]]; then
                    echo -e "${C_RED}❌ Could not determine which PID owns port $port. Please free it manually.${C_RESET}"
                    return 1
                fi
                echo -e "${C_GREEN}🛑 Stopping process PID $conflicting_pid...${C_RESET}"
                systemctl stop "$(ps -p "$conflicting_pid" -o comm=)" &>/dev/null || kill -9 "$conflicting_pid"
                sleep 2
                
                if ss -H -lntp "( sport = :$port )" 2>/dev/null | grep -q . || ss -H -lunp "( sport = :$port )" 2>/dev/null | grep -q .; then
                     echo -e "${C_RED}❌ Failed to free port $port. Please handle it manually. Aborting.${C_RESET}"
                     return 1
                else
                     echo -e "${C_GREEN}✅ Port $port has been successfully freed.${C_RESET}"
                fi
            else
                echo -e "${C_RED}❌ Cannot proceed without freeing port $port. Aborting.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Port $port is free to use.${C_RESET}"
        fi
    done
    return 0
}

setup_limiter_service() {
    # Combined limiter + bandwidth monitoring
    cat > "$LIMITER_SCRIPT" << 'EOF'
#!/bin/bash
# VPS_superScript limiter version 2026-10-11.5
DB_FILE="/etc/VPS_superScript/users.db"
BW_DIR="/etc/VPS_superScript/bandwidth"
PID_DIR="$BW_DIR/pidtrack"
BANNER_DIR="/etc/VPS_superScript/banners"
TRIAL_DIR="/etc/VPS_superScript/trials"
SCAN_INTERVAL=10
# UDP relay coordinates so auto-locks can cut ZiVPN / udp-custom like the menu does.
ZIVPN_CONFIG_FILE="/etc/zivpn/config.json"
ZIVPN_LOCK_DIR="/etc/VPS_superScript/zivpn_locked"
ZIVPN_LISTEN_PORT="5667"
UDP_CUSTOM_LISTEN_PORT="36712"
BADVPN_LISTEN_PORT="7300"

mkdir -p "$BW_DIR" "$PID_DIR"
shopt -s nullglob

# Convert a stored quota field into bytes. Handles the canonical forms the menu
# now writes ("2GB", "500MB"), legacy bare numbers (=GB) and "0"/empty
# (=unlimited). Kept inline because this daemon runs with no menu functions.
ff_quota_to_bytes() {
    local up val mult
    up=$(printf '%s' "$1" | tr -d ' ' | tr 'a-z' 'A-Z')
    [[ -z "$up" || "$up" == "0" ]] && { echo 0; return; }
    case "$up" in
        *GB) mult=1073741824 ;;
        *MB) mult=1048576 ;;
        *KB) mult=1024 ;;
        *)   mult=1073741824 ;;
    esac
    val="${up%GB}"; val="${val%MB}"; val="${val%KB}"
    if ! [[ "$val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then echo 0; return; fi
    awk "BEGIN { printf \"%.0f\", $val * $mult }"
}

# Human-readable byte size for banners ("1.50 GB", "512.00 MB").
ff_bytes_human() {
    local b=${1:-0}
    [[ "$b" =~ ^[0-9]+$ ]] || b=0
    if   (( b >= 1073741824 )); then awk "BEGIN { printf \"%.2f GB\", $b/1073741824 }"
    elif (( b >= 1048576 ));    then awk "BEGIN { printf \"%.2f MB\", $b/1048576 }"
    elif (( b >= 1024 ));       then awk "BEGIN { printf \"%.0f KB\", $b/1024 }"
    else printf '%d B' "$b"; fi
}

# Immediately drop / restore all traffic owned by a user's UID so auto-locks
# (expiry, quota, connection-limit) cut live SSH and SSH-tunnel sessions at once.
ff_block_uid() {
    local u="$1" uid x
    uid=$(id -u "$u" 2>/dev/null) || return 0
    [[ "$uid" =~ ^[0-9]+$ ]] || return 0
    for x in iptables ip6tables; do
        command -v "$x" &>/dev/null || continue
        "$x" -D OUTPUT -m owner --uid-owner "$uid" -j DROP 2>/dev/null
        "$x" -I OUTPUT -m owner --uid-owner "$uid" -j DROP 2>/dev/null
    done
}
ff_unblock_uid() {
    local u="$1" uid x
    uid=$(id -u "$u" 2>/dev/null) || return 0
    [[ "$uid" =~ ^[0-9]+$ ]] || return 0
    for x in iptables ip6tables; do
        command -v "$x" &>/dev/null || continue
        while "$x" -D OUTPUT -m owner --uid-owner "$uid" -j DROP 2>/dev/null; do :; done
    done
}
EOF

# Append ZiVPN utility functions + remaining limiter loop to the limiter script.
cat >> "$LIMITER_SCRIPT" << 'EOF'

# Default excluded ports for udp-custom (53 = DNS, 5300 = DNS-over-TLS).
# These ports bypass the tunnel so server-local DNS (or DNSTT) still works.
UDP_CUSTOM_EXCLUDE_DEFAULT="53,5300"

# Bounce the UDP relays so a just-locked user's LIVE root-owned session dies at
# once (the relays run as root, so UID drops and pkill can't reach them). Flush
# conntrack first so kernel UDP/NAT state is gone the instant they come back; the
# blip is ~0.3s and healthy clients re-handshake automatically. Bounce ZiVPN only
# when its auth list actually changed, to avoid disturbing other ZiVPN users.
ff_udp_session_blip() {
    local do_zivpn="$1"
    if command -v conntrack &>/dev/null; then
        conntrack -D -p udp --dport "$UDP_CUSTOM_LISTEN_PORT" &>/dev/null
        conntrack -D -p udp --dport "$BADVPN_LISTEN_PORT" &>/dev/null
        if [[ "$do_zivpn" == "1" ]]; then
            conntrack -D -p udp --dport "$ZIVPN_LISTEN_PORT" &>/dev/null
            conntrack -D -p udp --dport 6000:19999 &>/dev/null || true
        fi
    fi
    systemctl is-active --quiet udp-custom 2>/dev/null && systemctl try-restart udp-custom.service 2>/dev/null
    systemctl is-active --quiet badvpn 2>/dev/null && systemctl try-restart badvpn.service 2>/dev/null
    systemctl is-active --quiet udpgw 2>/dev/null && systemctl try-restart udpgw.service 2>/dev/null
    if [[ "$do_zivpn" == "1" ]]; then
        systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
    fi
}

write_banner_if_changed() {
    local user="$1"
    local content="$2"
    local banner_file="$BANNER_DIR/${user}.txt"
    local tmp_file="${banner_file}.tmp"

    printf "%s" "$content" > "$tmp_file"
    if ! cmp -s "$tmp_file" "$banner_file" 2>/dev/null; then
        mv "$tmp_file" "$banner_file"
    else
        rm -f "$tmp_file"
    fi
}

while true; do
    if [[ ! -s "$DB_FILE" ]]; then
        sleep "$SCAN_INTERVAL"
        continue
    fi

    printf -v current_ts '%(%s)T' -1
    dynamic_banners_enabled=false
    # Per-cycle UDP cutoff flags: when any user is newly auto-locked this pass we
    # bounce the relays exactly once (after the scan), not once per user.
    udp_blip_needed=false
    udp_blip_zivpn=false

    # Reset associative arrays each cycle (unset first to avoid stale data)
    unset session_pids locked_users uid_to_user loginuid_pids
    declare -A session_pids=()
    declare -A locked_users=()
    declare -A uid_to_user=()
    declare -A loginuid_pids=()

    while IFS=: read -r username _ uid _rest; do
        [[ -n "$username" && "$uid" =~ ^[0-9]+$ ]] && uid_to_user["$uid"]="$username"
    done < /etc/passwd

    # Method 1: process owner from ps
    while read -r ssh_pid ssh_owner; do
        [[ "$ssh_pid" =~ ^[0-9]+$ ]] || continue
        if [[ -n "$ssh_owner" && "$ssh_owner" != "root" && "$ssh_owner" != "sshd" ]]; then
            session_pids["$ssh_owner"]+="$ssh_pid "
        fi
    done < <(ps -C sshd -o pid=,user= 2>/dev/null)

    # Method 2: kernel loginuid (reliable even when sshd runs as root)
    for p in /proc/[0-9]*/loginuid; do
        [[ -f "$p" ]] || continue
        login_uid=""
        read -r login_uid < "$p" || login_uid=""
        [[ "$login_uid" =~ ^[0-9]+$ && "$login_uid" != "4294967295" ]] || continue

        session_user="${uid_to_user[$login_uid]}"
        [[ -n "$session_user" ]] || continue

        pid_dir=$(dirname "$p")
        pid_num=$(basename "$pid_dir")
        comm=""
        read -r comm < "$pid_dir/comm" || comm=""
        [[ "$comm" == "sshd" ]] || continue

        ppid_val=""
        while read -r key value; do
            if [[ "$key" == "PPid:" ]]; then
                ppid_val="${value:-}"
                break
            fi
        done < "$pid_dir/status"
        [[ "$ppid_val" == "1" ]] && continue

        loginuid_pids["$session_user"]+="$pid_num "
    done

    # Detect locked users via /etc/shadow (cheaper than passwd -Sa)
    if [[ -r /etc/shadow ]]; then
        while IFS=: read -r shadow_user shadow_hash _rest; do
            [[ -n "$shadow_user" && "${shadow_hash:0:1}" == "!" ]] && locked_users["$shadow_user"]=1
        done < /etc/shadow
    else
        while read -r passwd_user _ passwd_status _rest; do
            [[ "$passwd_status" == "L" ]] && locked_users["$passwd_user"]=1
        done < <(passwd -Sa 2>/dev/null)
    fi

    if [[ -f "/etc/VPS_superScript/banners_enabled" ]]; then
        mkdir -p "$BANNER_DIR"
        dynamic_banners_enabled=true
    fi

    while IFS=: read -r user pass expiry limit bandwidth_gb _extra; do
        [[ -z "$user" || "$user" == \#* ]] && continue

        # CRITICAL: unset before declare to reset per-user (bash declare is function-scoped)
        unset unique_pids
        declare -A unique_pids=()

        # Merge BOTH sources (union) for reliable counting
        for pid in ${session_pids[$user]} ${loginuid_pids[$user]}; do
            [[ "$pid" =~ ^[0-9]+$ ]] && unique_pids["$pid"]=1
        done

        online_count=${#unique_pids[@]}
        user_locked=false
        if [[ -n "${locked_users[$user]+x}" ]]; then
            user_locked=true
        fi

        # Precise expiry: a per-user epoch timestamp (.ts) enforces sub-day
        # durations exactly (and any duration even if 'at' was lost). Trials are
        # deleted when they end; normal accounts are locked like a date expiry.
        trial_ts_file="$TRIAL_DIR/${user}.ts"
        if [[ -f "$trial_ts_file" ]]; then
            trial_expiry=0
            read -r trial_expiry < "$trial_ts_file" || trial_expiry=0
            if [[ "$trial_expiry" =~ ^[0-9]+$ ]] && (( trial_expiry > 0 && trial_expiry <= current_ts )); then
                if [[ "$_extra" == "trial" ]]; then
                    usermod -L "$user" &>/dev/null
                    ff_block_uid "$user"
                    killall -u "$user" -9 &>/dev/null
                    # Kill live ZiVPN session before deleting the user.
                    [[ "$(ff_zivpn_lock_user "$user" "$pass")" == "changed" ]] && udp_blip_zivpn=true
                    udp_blip_needed=true
                    ff_unblock_uid "$user"
                    userdel -r "$user" &>/dev/null
                    sed -i "/^${user}:/d" "$DB_FILE" 2>/dev/null
                    rm -f "$BW_DIR/${user}.usage" "$trial_ts_file"
                    rm -rf "$PID_DIR/${user}" 2>/dev/null
                    continue
                else
                    if ! $user_locked; then
                        usermod -L "$user" &>/dev/null
                        ff_block_uid "$user"
                        killall -u "$user" -9 &>/dev/null
                        udp_blip_needed=true
                        [[ "$(ff_zivpn_lock_user "$user" "$pass")" == "changed" ]] && udp_blip_zivpn=true
                        locked_users["$user"]=1
                    fi
                    continue
                fi
            fi
        fi

        expiry_ts=0
        if [[ "$expiry" != "Never" && -n "$expiry" && "$expiry" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            expiry_ts=$(date -d "$expiry" +%s 2>/dev/null || echo 0)
            if [[ "$expiry_ts" =~ ^[0-9]+$ ]] && (( expiry_ts > 0 && expiry_ts < current_ts )); then
                if ! $user_locked; then
                    usermod -L "$user" &>/dev/null
                    ff_block_uid "$user"
                    killall -u "$user" -9 &>/dev/null
                    udp_blip_needed=true
                    [[ "$(ff_zivpn_lock_user "$user" "$pass")" == "changed" ]] && udp_blip_zivpn=true
                    locked_users["$user"]=1
                fi
                continue
            fi
        fi

        [[ "$limit" =~ ^[0-9]+$ ]] || limit=1
        if (( online_count > limit )); then
            if ! $user_locked; then
                usermod -L "$user" &>/dev/null
                ff_block_uid "$user"
                killall -u "$user" -9 &>/dev/null
                udp_blip_needed=true
                [[ "$(ff_zivpn_lock_user "$user" "$pass")" == "changed" ]] && udp_blip_zivpn=true
                (sleep 120; usermod -U "$user" &>/dev/null; ff_unblock_uid "$user"; ff_zivpn_unlock_user "$user"; systemctl try-restart udp-custom.service &>/dev/null) &
                locked_users["$user"]=1
                user_locked=true
            else
                killall -u "$user" -9 &>/dev/null
            fi
        fi

        if $dynamic_banners_enabled; then
            days_left="N/A"
            if [[ "$expiry" != "Never" && -n "$expiry" && "$expiry_ts" =~ ^[0-9]+$ && $expiry_ts -gt 0 ]]; then
                diff_secs=$((expiry_ts - current_ts))
                if (( diff_secs <= 0 )); then
                    days_left="EXPIRED"
                else
                    d_l=$(( diff_secs / 86400 ))
                    h_l=$(( (diff_secs % 86400) / 3600 ))
                    if (( d_l == 0 )); then
                        days_left="${h_l}h left"
                    else
                        days_left="${d_l}d ${h_l}h"
                    fi
                fi
            fi

            bw_info="Unlimited"
            quota_b=$(ff_quota_to_bytes "$bandwidth_gb")
            if (( quota_b > 0 )); then
                usagefile="$BW_DIR/${user}.usage"
                accum_disp=0
                if [[ -f "$usagefile" ]]; then
                    read -r accum_disp < "$usagefile"
                    [[ "$accum_disp" =~ ^[0-9]+$ ]] || accum_disp=0
                fi
                remain_b=$(( quota_b - accum_disp ))
                (( remain_b < 0 )) && remain_b=0
                bw_info="$(ff_bytes_human "$accum_disp") / $(ff_bytes_human "$quota_b") used | $(ff_bytes_human "$remain_b") left"
            fi

            banner_content="<br><font color=\"yellow\"><b>      ✨ ACCOUNT STATUS ✨      </b></font><br><br>"
            banner_content+="<font color=\"white\">👤 <b>Username   :</b> $user</font><br>"
            banner_content+="<font color=\"white\">📅 <b>Expiration :</b> $expiry ($days_left)</font><br>"
            banner_content+="<font color=\"white\">📊 <b>Bandwidth  :</b> $bw_info</font><br>"
            banner_content+="<font color=\"white\">🔌 <b>Sessions   :</b> $online_count/$limit</font><br><br>"
            write_banner_if_changed "$user" "$banner_content"
        fi

        quota_bytes=$(ff_quota_to_bytes "$bandwidth_gb")
        (( quota_bytes > 0 )) || continue

        usagefile="$BW_DIR/${user}.usage"
        accumulated=0
        if [[ -f "$usagefile" ]]; then
            read -r accumulated < "$usagefile"
            [[ "$accumulated" =~ ^[0-9]+$ ]] || accumulated=0
        fi

        if (( ${#unique_pids[@]} == 0 )); then
            rm -f "$PID_DIR/${user}__"*.last 2>/dev/null
            continue
        fi

        delta_total=0
        for pid in "${!unique_pids[@]}"; do
            io_file="/proc/$pid/io"
            cur=0
            if [[ -r "$io_file" ]]; then
                rchar=0
                wchar=0
                while read -r key value; do
                    case "$key" in
                        rchar:) rchar=${value:-0} ;;
                        wchar:) wchar=${value:-0} ;;
                    esac
                done < "$io_file"
                cur=$((rchar + wchar))
            fi

            pidfile="$PID_DIR/${user}__${pid}.last"
            if [[ -f "$pidfile" ]]; then
                read -r prev < "$pidfile"
                [[ "$prev" =~ ^[0-9]+$ ]] || prev=0
                if (( cur >= prev )); then
                    d=$((cur - prev))
                else
                    d=$cur
                fi
                delta_total=$((delta_total + d))
            fi
            printf "%s\n" "$cur" > "$pidfile"
        done

        for f in "$PID_DIR/${user}__"*.last; do
            [[ -f "$f" ]] || continue
            fpid=${f##*__}
            fpid=${fpid%.last}
            [[ -d "/proc/$fpid" ]] || rm -f "$f"
        done

        new_total=$((accumulated + delta_total))
        printf "%s\n" "$new_total" > "$usagefile"

        if [[ "$quota_bytes" =~ ^[0-9]+$ ]] && (( new_total >= quota_bytes )); then
            if ! $user_locked; then
                usermod -L "$user" &>/dev/null
                ff_block_uid "$user"
                killall -u "$user" -9 &>/dev/null
                udp_blip_needed=true
                [[ "$(ff_zivpn_lock_user "$user" "$pass")" == "changed" ]] && udp_blip_zivpn=true
                locked_users["$user"]=1
            fi
        fi
    done < "$DB_FILE"

    # One relay blip for the whole pass so newly auto-locked users' live UDP
    # sessions (zivpn / udp-custom) drop at once — fastest without restart storms.
    if $udp_blip_needed; then
        if $udp_blip_zivpn; then ff_udp_session_blip 1; else ff_udp_session_blip 0; fi
    fi

    sleep "$SCAN_INTERVAL"
done
EOF
    chmod +x "$LIMITER_SCRIPT"
    # Strip DOS line endings in case menu.sh was uploaded from Windows
    sed -i 's/\r$//' "$LIMITER_SCRIPT" 2>/dev/null

    cat > "$LIMITER_SERVICE" << EOF
[Unit]
Description=VPS_superScript Active User Limiter
After=network.target

[Service]
Type=simple
ExecStart=$LIMITER_SCRIPT
Restart=always
RestartSec=10
Nice=10
IOSchedulingClass=best-effort
IOSchedulingPriority=7
MemoryHigh=48M
MemoryMax=64M

[Install]
WantedBy=multi-user.target
EOF
    sed -i 's/\r$//' "$LIMITER_SERVICE" 2>/dev/null

    pkill -f "VPS_superScript-limiter" 2>/dev/null

    if ! systemctl is-active --quiet VPS_superScript-limiter; then
        systemctl daemon-reload
        systemctl enable VPS_superScript-limiter &>/dev/null
        systemctl start VPS_superScript-limiter --no-block &>/dev/null
        
    else
        systemctl restart VPS_superScript-limiter --no-block &>/dev/null
        
    fi
}

# --- UDP cutoff for auto-locks (mirrors the menu's manual lock) ---------------
# A system shadow lock (usermod -L) stops SSH and udp-custom re-auth, but ZiVPN
# authenticates against a password list in config.json, so an auto-locked user
# could still reconnect over ZiVPN. Pull that password out (recording it under
# ZIVPN_LOCK_DIR so the menu's unlock/renew can restore it precisely).
# Echoes "changed" only when config.json was actually modified.
ff_zivpn_lock_user() {
    local user="$1" pass="$2"
    [[ -n "$pass" ]] || return 1
    [[ -f "$ZIVPN_CONFIG_FILE" ]] || return 1
    command -v jq &>/dev/null || return 1
    jq -e --arg p "$pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null || return 1
    local tmp; tmp=$(mktemp) || return 1
    if jq --arg p "$pass" '.auth.config |= map(select(. != $p))' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null; then
        mv "$tmp" "$ZIVPN_CONFIG_FILE"
        mkdir -p "$ZIVPN_LOCK_DIR" 2>/dev/null
        printf '%s' "$pass" > "$ZIVPN_LOCK_DIR/${user}"
        echo "changed"; return 0
    fi
    rm -f "$tmp" 2>/dev/null
    return 1
}

ff_zivpn_unlock_user() {
    local user="$1" pass marker="$ZIVPN_LOCK_DIR/${user}"
    [[ -f "$ZIVPN_CONFIG_FILE" ]] || return 1
    command -v jq &>/dev/null || return 1
    # Prefer the marker lock wrote; fall back to the DB password so a ZiVPN
    # account is never left unable to reconnect if the marker was lost.
    pass=$(cat "$marker" 2>/dev/null)
    [[ -n "$pass" ]] || pass=$(awk -F: -v u="$user" '$1==u{print $2; exit}' "$DB_FILE" 2>/dev/null)
    [[ -n "$pass" ]] || { rm -f "$marker" 2>/dev/null; return 1; }
    # Already present: just clear the marker.
    if jq -e --arg p "$pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null; then
        rm -f "$marker" 2>/dev/null; return 1
    fi
    local tmp; tmp=$(mktemp) || return 1
    if jq --arg p "$pass" '.auth.config += [$p]' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null; then
        mv "$tmp" "$ZIVPN_CONFIG_FILE"
        rm -f "$marker" 2>/dev/null
        systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
        return 0
    fi
    rm -f "$tmp" 2>/dev/null
    return 1
}

_ff_zivpn_add_pass() {
    local pass="$1"
    [[ -f "$ZIVPN_CONFIG_FILE" ]] || return 0
    command -v jq &>/dev/null || return 0
    jq -e --arg p "$pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null && return 0
    local tmp; tmp=$(mktemp) || return 1
    if jq --arg p "$pass" '.auth.config += [$p]' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null; then
        mv "$tmp" "$ZIVPN_CONFIG_FILE"
        return 0
    fi
    rm -f "$tmp" 2>/dev/null
    return 1
}

sync_runtime_components_if_needed() {
    local limiter_marker="# VPS_superScript limiter version 2026-10-11.5"
    # Safety net: guarantee core directories and the user group exist even when
    # the menu is launched directly (e.g. `bash menu.sh` from a git clone)
    # without the one-time `--install-setup` having been run first.
    ensure_VPS_superScript_dirs
    ensure_VPS_superScript_system_group
    # Restore user database from uninstall backup if the DB is missing.
    local _db_backup="/etc/.VPS_superScript-db-backup"
    if [[ ! -f "$DB_FILE" && -d "$_db_backup" ]]; then
        cp -a "$_db_backup/." "$DB_DIR/" 2>/dev/null
        rm -rf "$_db_backup" 2>/dev/null
    fi
    cleanup_legacy_bandwidth_runtime
    setup_trial_cleanup_script >/dev/null 2>&1
    if [[ ! -f "$LIMITER_SCRIPT" ]] || ! grep -Fqx "$limiter_marker" "$LIMITER_SCRIPT" 2>/dev/null; then
        setup_limiter_service >/dev/null 2>&1
    fi
    if [[ -f "$BADVPN_SERVICE_FILE" ]]; then
        ensure_badvpn_service_is_quiet
    fi
    if [[ -f "/etc/VPS_superScript/banners_enabled" ]]; then
        update_ssh_banners_config
    elif [[ -f "$SSHD_FF_CONFIG" ]]; then
        disable_dynamic_ssh_banner_system
        systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || true
    fi
    # Refresh the HWID mirror and re-arm the enforcer if it was left enabled.
    touch "$HWID_ALLOWED_DB" 2>/dev/null && chmod 600 "$HWID_ALLOWED_DB" 2>/dev/null
    hwid_sync_allowed_db
    if [[ "$(cat "$HWID_STATE_FILE" 2>/dev/null)" == "on" ]]; then
        local hwid_enforcer_marker="# VPS_superScript HWID enforcer version 2026-07-29.1"
        if ! systemctl is-active --quiet VPS_superScript-hwid-enforcer 2>/dev/null; then
            enable_hwid_lock >/dev/null 2>&1
        elif ! grep -Fq "$hwid_enforcer_marker" "$HWID_ENFORCER_SCRIPT" 2>/dev/null; then
            # Already running an older enforcer (single-HWID match) — rewrite the
            # script with the comma-list matcher and restart so it takes effect.
            write_hwid_enforcer
            systemctl restart VPS_superScript-hwid-enforcer 2>/dev/null
        fi
    fi
    # Re-arm UDP anti-sharing enforcement across an upgrade/re-setup.
    if [[ "$(cat "$UDP_SHARE_STATE_FILE" 2>/dev/null)" == "on" ]]; then
        local udpshare_marker="# VPS_superScript udp-share enforcer version 2026-07-30.3"
        if ! systemctl is-active --quiet VPS_superScript-udp-share 2>/dev/null; then
            enable_udp_share >/dev/null 2>&1
        elif ! grep -Fq "$udpshare_marker" "$UDP_SHARE_ENFORCER_SCRIPT" 2>/dev/null; then
            # Older build: naive IP counter with unscoped UDP drops. Rewrite with
            # the overlap-detection + account-action daemon and restart.
            write_udp_share_enforcer
            systemctl restart VPS_superScript-udp-share 2>/dev/null
        fi
    fi

    # Self-heal NAT on older installs: drop the legacy blanket TCP DNAT
    # (tcp:1:65535 -> 36712) that hijacked HTTP Custom's TCP traffic into the
    # udp-custom relay. Only act when it's actually present in the saved rules or
    # the live table, so we don't flush PREROUTING on every launch.
    if grep -q '^DNAT=tcp:1:65535:36712$' "$NAT_RULES_CONF" 2>/dev/null \
       || iptables -t nat -C PREROUTING -p tcp --dport 1:65535 -j DNAT --to-destination :36712 2>/dev/null; then
        echo -e "${C_BLUE}🔧 Migrating NAT rules: removing legacy blanket TCP DNAT (HTTP Custom / ZiVPN conflict)...${C_RESET}"
        sed -i '/^DNAT=tcp:1:65535:36712$/d' "$NAT_RULES_CONF" 2>/dev/null
        _nat_load_rules
        _nat_apply
    fi

    # Self-heal NAT on installs that forwarded only the narrow 61000:62000 UDP
    # window to ZiVPN. Widen it to the standard 6000:19999 band (the file rewrite
    # happens in _nat_load_rules) and re-apply live so port-hopping ZiVPN clients
    # reach 5667 without a manual NAT reset. Only acts when the old rule is still
    # present in the saved file or the live table. Idempotent.
    if grep -q '^DNAT=udp:61000:62000:5667$' "$NAT_RULES_CONF" 2>/dev/null \
       || iptables -t nat -C PREROUTING -p udp --dport 61000:62000 -j DNAT --to-destination :5667 2>/dev/null; then
        echo -e "${C_BLUE}🔧 Migrating NAT rules: widening ZiVPN UDP range to 6000-19999...${C_RESET}"
        _nat_load_rules
        _nat_apply
    fi
}

setup_bandwidth_service() {
    mkdir -p "$BANDWIDTH_DIR"
    # Bandwidth monitoring is now integrated into the limiter service above.
    cleanup_legacy_bandwidth_runtime
}

cleanup_legacy_bandwidth_runtime() {
    local needs_reload=false

    systemctl stop VPS_superScript-bandwidth &>/dev/null || true
    systemctl disable VPS_superScript-bandwidth &>/dev/null || true
    pkill -f "VPS_superScript-bandwidth" &>/dev/null || true

    if [[ -e "$BANDWIDTH_SERVICE" || -e "$BANDWIDTH_SCRIPT" || -e "$LEGACY_BANDWIDTH_DIR" ]]; then
        rm -f "$BANDWIDTH_SERVICE" "$BANDWIDTH_SCRIPT" 2>/dev/null
        rm -rf "$LEGACY_BANDWIDTH_DIR" 2>/dev/null
        needs_reload=true
    fi

    if $needs_reload; then
        systemctl daemon-reload &>/dev/null || true
    fi
}

setup_trial_cleanup_script() {
    cat > "$TRIAL_CLEANUP_SCRIPT" << 'TREOF'
#!/bin/bash
# VPS_superScript Trial Account Auto-Cleanup
# Usage: VPS_superScript-trial-cleanup.sh <username>
DB_FILE="/etc/VPS_superScript/users.db"
BW_DIR="/etc/VPS_superScript/bandwidth"
TRIAL_DIR="/etc/VPS_superScript/trials"

username="$1"
if [[ -z "$username" ]]; then exit 1; fi

db_line=$(grep "^${username}:" "$DB_FILE" 2>/dev/null | head -n 1)
if [[ -z "$db_line" ]]; then exit 0; fi

IFS=: read -r _ _ _ _ _ trial_marker _rest <<< "$db_line"
if [[ "$trial_marker" != "trial" ]]; then
    exit 0
fi

# Kill active sessions
killall -u "$username" -9 &>/dev/null
sleep 1

# Delete system user
userdel -r "$username" &>/dev/null

# Remove from DB
sed -i "/^${username}:/d" "$DB_FILE"

# Remove bandwidth tracking
rm -f "$BW_DIR/${username}.usage"
rm -rf "$BW_DIR/pidtrack/${username}"
rm -f "$TRIAL_DIR/${username}.ts"
TREOF
    chmod +x "$TRIAL_CLEANUP_SCRIPT"
}

disable_dynamic_ssh_banner_system() {
    rm -f "/etc/VPS_superScript/banners_enabled" "$SSHD_FF_CONFIG" /usr/local/bin/VPS_superScript-login-info.sh 2>/dev/null
    rm -rf "/etc/VPS_superScript/banners" 2>/dev/null
    invalidate_banner_cache
}

disable_static_ssh_banner_in_sshd_config() {
    sed -i.bak -E "s|^[[:space:]]*Banner[[:space:]]+${SSH_BANNER_FILE}[[:space:]]*$|# Banner $SSH_BANNER_FILE|" /etc/ssh/sshd_config 2>/dev/null
}

is_static_ssh_banner_enabled() {
    grep -q -E "^[[:space:]]*Banner[[:space:]]+${SSH_BANNER_FILE}[[:space:]]*$" /etc/ssh/sshd_config 2>/dev/null && [ -f "$SSH_BANNER_FILE" ]
}

is_dynamic_ssh_banner_enabled() {
    [[ -f "/etc/VPS_superScript/banners_enabled" && -f "$SSHD_FF_CONFIG" ]]
}

get_ssh_banner_mode() {
    if is_dynamic_ssh_banner_enabled; then
        echo "dynamic"
    elif is_static_ssh_banner_enabled; then
        echo "static"
    else
        echo "disabled"
    fi
}

refresh_dynamic_banner_routing_if_enabled() {
    if is_dynamic_ssh_banner_enabled; then
        update_ssh_banners_config
    fi
}

update_ssh_banners_config() {
    local tmp_conf

    if [[ ! -f "/etc/VPS_superScript/banners_enabled" ]]; then
        if [[ -f "$SSHD_FF_CONFIG" ]]; then
            rm -f "$SSHD_FF_CONFIG" 2>/dev/null
            systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
        fi
        return
    fi

    ensure_VPS_superScript_dirs
    tmp_conf="/tmp/ff_banners_new.conf"
    echo "# VPS_superScript - Dynamic per-user SSH banners" > "$tmp_conf"

    if [[ -f "$DB_FILE" ]]; then
        while IFS=: read -r u _rest; do
            [[ -z "$u" || "$u" == \#* ]] && continue
            echo "Match User $u" >> "$tmp_conf"
            echo "    Banner /etc/VPS_superScript/banners/${u}.txt" >> "$tmp_conf"
        done < "$DB_FILE"
    fi

    if ! cmp -s "$tmp_conf" "$SSHD_FF_CONFIG" 2>/dev/null; then
        mv "$tmp_conf" "$SSHD_FF_CONFIG"
        if ! grep -q "^Include /etc/ssh/sshd_config.d/" /etc/ssh/sshd_config 2>/dev/null; then
            echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config
        fi
        systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
    else
        rm -f "$tmp_conf"
    fi
}

setup_ssh_login_info() {
    ensure_VPS_superScript_dirs || return 1
    if ! touch "/etc/VPS_superScript/banners_enabled"; then
        echo -e "${C_RED}❌ Failed to enable dynamic SSH banners.${C_RESET}"
        return 1
    fi
    disable_static_ssh_banner_in_sshd_config
    update_ssh_banners_config
    return 0
}


_select_user_interface() {
    local title="$1"
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}${title}${C_RESET}\n"
    if [[ ! -s $DB_FILE ]]; then
        echo -e "${C_YELLOW}ℹ️ No users found in the database.${C_RESET}"
        SELECTED_USER="NO_USERS"; return
    fi
    
    _ff_load_trial_users
    mapfile -t all_users < <(_ff_sorted_user_names)
    local -A all_user_lookup=()
    local username
    for username in "${all_users[@]}"; do
        all_user_lookup["$username"]=1
    done
    
    if [ ${#all_users[@]} -ge 15 ]; then
        read -p "👉 Enter a search term (or press Enter to list all): " search_term
        if [[ -n "$search_term" ]]; then
            mapfile -t users < <(printf "%s\n" "${all_users[@]}" | grep -i "$search_term")
        else
            users=("${all_users[@]}")
        fi
    else
        users=("${all_users[@]}")
    fi

    if [ ${#users[@]} -eq 0 ]; then
        echo -e "\n${C_YELLOW}ℹ️ No users found matching your criteria.${C_RESET}"
        SELECTED_USER="NO_USERS"; return
    fi
    echo -e "\nPlease select a user:\n"
    local _disp_user
    for i in "${!users[@]}"; do
        _disp_user="${users[$i]}"
        [[ -n "${FF_TRIAL_USERS[$_disp_user]+x}" ]] && _disp_user="${C_PURPLE}${_disp_user}${C_RESET}"
        printf "  ${C_GREEN}[%2d]${C_RESET} %s\n" "$((i+1))" "$_disp_user"
    done
    echo -e "\n  ${C_RED} [ 0]${C_RESET} ↩️ Cancel"
    echo -e "${C_CYAN}💡 Tip: you can also type the exact username directly.${C_RESET}"
    echo
    local choice
    while true; do
        if ! read -r -p "👉 Enter the number or exact username: " choice; then
            echo
            SELECTED_USER=""
            return
        fi
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le "${#users[@]}" ]; then
            if [ "$choice" -eq 0 ]; then
                SELECTED_USER=""; return
            else
                SELECTED_USER="${users[$((choice-1))]}"; return
            fi
        elif [[ -n "${all_user_lookup[$choice]+x}" ]]; then
            SELECTED_USER="$choice"; return
        else
            echo -e "${C_RED}❌ Invalid selection. Please try again.${C_RESET}"
        fi
    done
}

_select_multi_user_interface() {
    local title="$1"
    local include_orphan_users="${2:-false}"
    # Delegated admins may never see or touch unmanaged/orphan system accounts.
    [[ -n "${VSS_ACTOR:-}" ]] && include_orphan_users=false
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}${title}${C_RESET}\n"
    SELECTED_USERS=()
    local -a all_users=()
    local -a orphan_users=()
    local -A all_user_lookup=()
    local -A orphan_user_lookup=()
    local username

    _ff_load_trial_users
    if [[ -s $DB_FILE ]]; then
        mapfile -t all_users < <(_ff_sorted_user_names)
    fi

    if [[ "$include_orphan_users" == "true" ]]; then
        # Orphans are system-only accounts (never trials), so merge and sort them
        # with the normal group and keep trial accounts at the very bottom.
        local -a _normals=() _trials=()
        for username in "${all_users[@]}"; do
            if [[ -n "${FF_TRIAL_USERS[$username]+x}" ]]; then _trials+=("$username"); else _normals+=("$username"); fi
        done
        mapfile -t orphan_users < <(get_VPS_superScript_orphan_users)
        for username in "${orphan_users[@]}"; do
            orphan_user_lookup["$username"]=1
            if ! printf "%s\n" "${all_users[@]}" | grep -Fxq "$username"; then
                _normals+=("$username")
            fi
        done
        all_users=()
        if [[ ${#_normals[@]} -gt 0 ]]; then
            mapfile -t _normals < <(printf "%s\n" "${_normals[@]}" | LC_ALL=C sort)
            all_users+=("${_normals[@]}")
        fi
        if [[ ${#_trials[@]} -gt 0 ]]; then
            mapfile -t _trials < <(printf "%s\n" "${_trials[@]}" | LC_ALL=C sort)
            all_users+=("${_trials[@]}")
        fi
    fi

    if [[ ${#all_users[@]} -eq 0 ]]; then
        echo -e "${C_YELLOW}ℹ️ No users found in the manager database.${C_RESET}"
        if [[ "$include_orphan_users" == "true" ]]; then
            echo -e "${C_DIM}No orphan VPS_superScript system users were found either.${C_RESET}"
        fi
        SELECTED_USERS=("NO_USERS"); return
    fi

    for username in "${all_users[@]}"; do
        all_user_lookup["$username"]=1
    done
    
    if [ ${#all_users[@]} -ge 15 ]; then
        read -p "👉 Enter a search term (or press Enter to list all): " search_term
        if [[ -n "$search_term" ]]; then
            mapfile -t users < <(printf "%s\n" "${all_users[@]}" | grep -i "$search_term")
        else
            users=("${all_users[@]}")
        fi
    else
        users=("${all_users[@]}")
    fi

    if [ ${#users[@]} -eq 0 ]; then
        echo -e "\n${C_YELLOW}ℹ️ No users found matching your criteria.${C_RESET}"
        SELECTED_USERS=("NO_USERS"); return
    fi
    echo -e "\nPlease select users:\n"
    for i in "${!users[@]}"; do
        local display_user="${users[$i]}"
        if [[ "$include_orphan_users" == "true" && -n "${orphan_user_lookup[${users[$i]}]+x}" ]]; then
            display_user="${display_user} ${C_DIM}(system-only)${C_RESET}"
        fi
        [[ -n "${FF_TRIAL_USERS[${users[$i]}]+x}" ]] && display_user="${C_PURPLE}${display_user}${C_RESET}"
        printf "  ${C_GREEN}[%2d]${C_RESET} %s\n" "$((i+1))" "$display_user"
    done
    echo -e "\n  ${C_GREEN}[all]${C_RESET} Select ALL listed users"
    echo -e "  ${C_RED}  [0]${C_RESET} ↩️ Cancel and return to main menu"
    echo -e "\n${C_CYAN}💡 You can select multiple by number, range, or exact username.${C_RESET}"
    echo -e "${C_CYAN}   Examples: '1 3 5' or '1,3' or '1-4' or 'alice bob'${C_RESET}"
    if [[ "$include_orphan_users" == "true" ]]; then
        echo -e "${C_CYAN}   Users marked '(system-only)' are old accounts still on the VPS but missing from users.db${C_RESET}"
    fi
    echo
    local choice
    while true; do
        if ! read -r -p "👉 Enter user numbers or usernames: " choice; then
            echo
            SELECTED_USERS=()
            return
        fi
        choice=${choice//,/ } # Replace commas with spaces
        
        if [[ -z "$choice" ]]; then
            echo -e "${C_RED}❌ Invalid selection. Please try again.${C_RESET}"
            continue
        fi

        if [[ "$choice" == "0" ]]; then
            SELECTED_USERS=(); return
        fi
        
        if [[ "${choice,,}" == "all" ]]; then
            SELECTED_USERS=("${users[@]}")
            return
        fi
        
        local valid=true
        local selected_indices=()
        local selected_names=()
        for token in $choice; do
            if [[ "$token" =~ ^[0-9]+-[0-9]+$ ]]; then
                local start=${token%-*}
                local end=${token#*-}
                if [ "$start" -le "$end" ]; then
                    for (( idx=start; idx<=end; idx++ )); do
                        if [ "$idx" -ge 1 ] && [ "$idx" -le "${#users[@]}" ]; then
                            selected_indices+=($idx)
                        else
                            valid=false; break
                        fi
                    done
                else
                    valid=false; break
                fi
            elif [[ "$token" =~ ^[0-9]+$ ]]; then
                if [ "$token" -ge 1 ] && [ "$token" -le "${#users[@]}" ]; then
                    selected_indices+=($token)
                elif [[ -n "${all_user_lookup[$token]+x}" ]]; then
                    selected_names+=("$token")
                else
                    valid=false; break
                fi
            elif [[ -n "${all_user_lookup[$token]+x}" ]]; then
                selected_names+=("$token")
            else
                valid=false; break
            fi
        done
        
        if [[ "$valid" == true && ( ${#selected_indices[@]} -gt 0 || ${#selected_names[@]} -gt 0 ) ]]; then
            # printf "%s\n" over an EMPTY array still prints one blank line, which
            # mapfile then captures as a spurious "" element — surfacing later as
            # "User '' does not exist". Only expand each list when it has entries.
            if [[ ${#selected_indices[@]} -gt 0 ]]; then
                mapfile -t unique_indices < <(printf "%s\n" "${selected_indices[@]}" | sort -u -n)
                for idx in "${unique_indices[@]}"; do
                    SELECTED_USERS+=("${users[$((idx-1))]}")
                done
            fi
            if [[ ${#selected_names[@]} -gt 0 ]]; then
                mapfile -t unique_names < <(printf "%s\n" "${selected_names[@]}" | sort -u)
                for username in "${unique_names[@]}"; do
                    if ! printf "%s\n" "${SELECTED_USERS[@]}" | grep -Fxq "$username"; then
                        SELECTED_USERS+=("$username")
                    fi
                done
            fi
            return
        else
            echo -e "${C_RED}❌ Invalid selection. Please check your numbers or usernames.${C_RESET}"
            SELECTED_USERS=()
            selected_indices=()
            selected_names=()
        fi
    done
}

create_user() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- ✨ Create New SSH User ---${C_RESET}"
    read -r -p "👤 user: " username
    local adopt_existing=false
    if [[ "$username" == "0" ]]; then
        echo -e "\n${C_YELLOW}❌ User creation cancelled.${C_RESET}"
        return
    fi
    if [[ -z "$username" ]]; then
        echo -e "\n${C_RED}❌ Error: Username cannot be empty.${C_RESET}"
        return
    fi
    if [[ -n "${VSS_ACTOR:-}" ]] && ! _ff_valid_managed_username "$username"; then
        echo -e "\n${C_RED}❌ Invalid username. Use 2-32 chars: a-z, 0-9, '_' or '-' (must start with a letter/underscore).${C_RESET}"
        return
    fi
    if db_has_user "$username"; then
        echo -e "\n${C_RED}❌ Error: User '$username' already exists in VPS_superScript.${C_RESET}"
        return
    fi
    if id "$username" &>/dev/null; then
        if is_VPS_superScript_orphan_user "$username"; then
            if [[ -n "${VSS_ACTOR:-}" ]]; then
                echo -e "\n${C_RED}❌ That existing system account is not managed by you. Ask the server owner to adopt it.${C_RESET}"
                return
            fi
            echo -e "\n${C_YELLOW}⚠️ User '$username' already exists on the system but is missing from users.db.${C_RESET}"
            echo -e "${C_DIM}This usually happens after uninstalling the script without deleting the SSH users.${C_RESET}"
            read -p "👉 Do you want to take control of this existing user and manage it with VPS_superScript? (y/n): " adopt_confirm
            if [[ "$adopt_confirm" == "y" || "$adopt_confirm" == "Y" ]]; then
                adopt_existing=true
            else
                echo -e "\n${C_YELLOW}❌ User creation cancelled.${C_RESET}"
                return
            fi
        else
            echo -e "\n${C_RED}❌ Error: System user '$username' already exists and does not look like a VPS_superScript SSH account.${C_RESET}"
            return
        fi
    fi
    local password=""
    while true; do
        read -r -p "🔑 password: " password
        if [[ -z "$password" ]]; then
            password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
            echo -e "${C_GREEN}🔑 generated: ${C_YELLOW}$password${C_RESET}"
            break
        else
            break
        fi
    done
    read -r -p "🗓️ duration (e.g. 20d5h30m): " duration_input
    duration_input=${duration_input:-30d}
    local duration_secs; duration_secs=$(_ff_dur_to_seconds "$duration_input")
    if [[ "$duration_secs" -le 0 ]]; then echo -e "\n${C_RED}❌ Invalid duration. Use e.g. 30m, 2h, 1d, 2d4h30m.${C_RESET}"; return; fi
    local duration_display; duration_display=$(expiry_human_left "$duration_secs")
    read -r -p "📶 limit [1]: " limit
    limit=${limit:-1}
    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    read -r -p "📦 quota (MB/GB) [0]: " quota_input
    quota_input=${quota_input:-0}
    if ! _ff_quota_valid "$quota_input"; then echo -e "\n${C_RED}❌ Invalid quota. Use e.g. 500MB, 1GB, 10GB.${C_RESET}"; return; fi
    local bandwidth_gb; bandwidth_gb=$(_ff_quota_canonical "$quota_input")
    # App type selector
    local app="http"
    echo -e "\n📱 app:  [1] HTTP Custom    [2] ZiVPN"
    read -r -p "👉 [1]: " app_choice
    app_choice=${app_choice:-1}
    case "$app_choice" in
        2|z|Z|zivpn|ZiVPN) app="zivpn" ;;
        *) app="http" ;;
    esac

    # Optional HWID device lock. Blank = no restriction (credentials usable on any
    # device). Only offered for apps whose service logs can report a device token.
    local hwid="" strict="0"
    case "$app" in
        http|zivpn)
            read -r -p "🔒 hwid (optional, comma for many): " hwid
            hwid=$(_ff_normalize_hwids "$hwid")
            if [[ -n "$hwid" ]]; then
                local s_choice="y"
                read -r -p "🛡️ strict? (y/n) [y]: " s_choice
                s_choice=${s_choice:-y}
                [[ "$s_choice" == "y" || "$s_choice" == "Y" ]] && strict=1
            fi
            ;;
        *)
            echo -e "${C_DIM}ℹ️ HWID device lock isn't applicable for this app — skipping.${C_RESET}"
            ;;
    esac
    # NOTE: per-user UDP port ranges are intentionally not assigned. The NAT layer
    # forwards the whole UDP range to the relays globally, so every account works
    # without carving out per-user ranges.
    # chage only accepts a date; round UP to the calendar date of the true
    # cutoff so the shadow expiry can never fire early. The limiter's precise
    # .ts timestamp (written below) enforces the exact sub-day moment.
    local expire_date expiry_epoch
    expire_date=$(date -d "+${duration_secs} seconds" +%Y-%m-%d)
    [[ "$expire_date" == "$(date +%Y-%m-%d)" ]] && expire_date=$(date -d "tomorrow" +%Y-%m-%d)
    expiry_epoch=$(( $(date +%s) + duration_secs ))
    ensure_VPS_superScript_system_group
    if [[ "$adopt_existing" == "true" ]]; then
        usermod -s /usr/sbin/nologin "$username" &>/dev/null
    else
        useradd -m -s /usr/sbin/nologin "$username"
    fi
    usermod -aG "$FF_USERS_GROUP" "$username" 2>/dev/null
    if ! _ff_set_password "$username" "$password"; then
        echo -e "\n${C_RED}❌ Could not set a valid password for '$username' on this host.${C_RESET}"
        echo -e "${C_DIM}   chpasswd and every fallback failed, so the account would be created${C_RESET}"
        echo -e "${C_DIM}   locked with no password to restore. Aborting to avoid a broken user.${C_RESET}"
        [[ "$adopt_existing" != "true" ]] && userdel -r "$username" &>/dev/null
        read -p "Press [Enter] to continue..."
        return
    fi
    chage -E "$expire_date" "$username"
    # Fields: user:pass:expiry:limit:bw:marker:hwid:strict
    # 6th field is the account marker: empty = normal account, "trial" = auto-expiring trial.
    echo "$username:$password:$expire_date:$limit:$bandwidth_gb::$hwid:$strict:$app" >> "$DB_FILE"
    [[ -n "${VSS_ACTOR:-}" ]] && _own_set "$username" "$VSS_ACTOR"
    # Record creation time shown in User Details (falls back to home-dir date if absent).
    mkdir -p "$CREATED_DIR"; printf '%s\n' "$(date +%s)" > "$CREATED_DIR/${username}"
    # Precise expiry timestamp so sub-day durations end on time; the limiter
    # locks a normal account (and deletes a trial) when this epoch passes.
    mkdir -p "$TRIAL_EXPIRY_DIR"
    printf '%s\n' "$expiry_epoch" > "$TRIAL_EXPIRY_DIR/${username}.ts"
    hwid_sync_allowed_db

    if [[ "$app" == "zivpn" ]]; then
        if ! command -v jq &>/dev/null; then
            echo -e "${C_YELLOW}⚠️ 'jq' not installed — could not add password to ZiVPN config.${C_RESET}"
        elif [[ ! -f "$ZIVPN_CONFIG_FILE" ]]; then
            echo -e "${C_YELLOW}⚠️ ZiVPN config ($ZIVPN_CONFIG_FILE) not found — is ZiVPN installed?${C_RESET}"
        elif _ff_zivpn_add_pass "$password"; then
            systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
        fi
    fi

    # ── OpenVPN per-user config ──
    if [[ "$app" == "openvpn" && -d /etc/openvpn/easy-rsa/pki ]]; then
        local _ovpn_ip; _ovpn_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        ( cd /etc/openvpn/easy-rsa 2>/dev/null && EASYRSA_BATCH=1 ./easyrsa build-client-full "$username" nopass 2>/dev/null )
        local _ovpn_file="$EXPORTS_DIR/${username}.ovpn"
        mkdir -p "$EXPORTS_DIR" 2>/dev/null
        cat > "$_ovpn_file" <<OVPNEOF
client
dev tun
proto tcp
remote ${_ovpn_ip} ${OPENVPN_TCP_PORT}
<connection>
remote ${_ovpn_ip} ${OPENVPN_UDP_PORT}
proto udp
</connection>
<connection>
remote ${_ovpn_ip} ${OPENVPN_SDNS_PORT}
proto udp
</connection>
resolv-retry infinite
nobind
persist-key
persist-tun
auth SHA256
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
auth-user-pass
<ca>
$(cat /etc/openvpn/easy-rsa/pki/ca.crt 2>/dev/null)
</ca>
<cert>
$(cat /etc/openvpn/easy-rsa/pki/issued/${username}.crt 2>/dev/null)
</cert>
<key>
$(cat /etc/openvpn/easy-rsa/pki/private/${username}.key 2>/dev/null)
</key>
<tls-auth>
$(cat /etc/openvpn/ta.key 2>/dev/null)
</tls-auth>
key-direction 1
OVPNEOF
        echo -e "\n${C_GREEN}✅ OpenVPN config generated: ${C_YELLOW}$_ovpn_file${C_RESET}"
    fi

    # ── WireGuard per-user config ──
    if [[ "$app" == "wireguard" && -f /etc/wireguard/wg0.conf ]]; then
        local _wg_ip; _wg_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        local _wg_priv; _wg_priv=$(wg genkey)
        local _wg_pub; _wg_pub=$(echo "$_wg_priv" | wg pubkey)
        local _wg_srv_pub; _wg_srv_pub=$(cat /etc/wireguard/server.pub 2>/dev/null)
        local _wg_file="$EXPORTS_DIR/${username}.conf"
        mkdir -p "$EXPORTS_DIR" 2>/dev/null
        local _wg_octet=2
        local _wg_last; _wg_last=$(grep -oP '10\.66\.66\.\d+' /etc/wireguard/wg0.conf 2>/dev/null | sort -t. -k4 -n | tail -1)
        [[ -n "$_wg_last" ]] && _wg_octet=$((${_wg_last##*.} + 1))
        local _wg_addr="10.66.66.${_wg_octet}"
        cat >> /etc/wireguard/wg0.conf <<WGPEOF
# BEGIN ${username}
[Peer]
PublicKey = ${_wg_pub}
AllowedIPs = ${_wg_addr}/32
# END ${username}
WGPEOF
        cat > "$_wg_file" <<WGCEOF
[Interface]
PrivateKey = ${_wg_priv}
Address = ${_wg_addr}/24
DNS = 8.8.8.8, 1.1.1.1
[Peer]
PublicKey = ${_wg_srv_pub}
Endpoint = ${_wg_ip}:${WIREGUARD_PORT}
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
WGCEOF
        wg-quick down wg0 2>/dev/null; wg-quick up wg0 2>/dev/null
        echo -e "\n${C_GREEN}✅ WireGuard config generated: ${C_YELLOW}$_wg_file${C_RESET}"
    fi

    # ── Hysteria2 per-user config ──
    if [[ "$app" == "hysteria2" && -f /etc/hysteria/config.json ]] && command -v jq &>/dev/null; then
        local _hy_ip; _hy_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        local _hy_file="$EXPORTS_DIR/${username}-hysteria.json"
        mkdir -p "$EXPORTS_DIR" 2>/dev/null
        local _tmp; _tmp=$(mktemp) 2>/dev/null || true
        if [[ -n "$_tmp" ]]; then
            jq --arg u "$username" --arg p "$password" '.auth.config += [{"user": $u, "pass": $p}]' /etc/hysteria/config.json > "$_tmp" 2>/dev/null && mv "$_tmp" /etc/hysteria/config.json
            rm -f "$_tmp" 2>/dev/null
        fi
        cat > "$_hy_file" <<HYCEOF
{
  "server": "${_hy_ip}:${HYSTERIA2_PORT}",
  "auth": "${password}",
  "tls": { "sni": "${_hy_ip}", "insecure": true },
  "quic": { "initStreamReceiveWindow": 8388608, "maxIdleTimeout": "30s", "keepAliveInterval": "10s" },
  "fastOpen": true,
  "lazy": true,
  "socks5": { "listen": "127.0.0.1:1080" }
}
HYCEOF
        systemctl restart hysteria-server 2>/dev/null
        echo -e "\n${C_GREEN}✅ Hysteria2 config generated: ${C_YELLOW}$_hy_file${C_RESET}"
    fi

    local bw_display; bw_display=$(_ff_quota_label "$bandwidth_gb")

    clear; show_banner
    if [[ "$adopt_existing" == "true" ]]; then
        echo -e "${C_GREEN}✅ Existing system user '$username' has been imported into VPS_superScript!${C_RESET}\n"
    else
        echo -e "${C_GREEN}✅ User '$username' created successfully!${C_RESET}\n"
    fi
    echo -e "  - 👤 Username:          ${C_YELLOW}$username${C_RESET}"
    echo -e "  - 🔑 Password:          ${C_YELLOW}$password${C_RESET}"
    echo -e "  - 🗓️ Expires on:        ${C_YELLOW}$expire_date${C_RESET}  (${C_CYAN}$duration_display${C_RESET})"
    echo -e "  - 📶 Connection Limit:  ${C_YELLOW}$limit${C_RESET}"
    echo -e "  - 📦 Bandwidth Limit:   ${C_YELLOW}$bw_display${C_RESET}"
    if [[ -n "$hwid" ]]; then
        echo -e "  - 🔒 HWID Lock:         ${C_YELLOW}$(_ff_hwid_label "$hwid" "$strict" strict)${C_RESET}"
    else
        echo -e "  - 🔒 HWID Lock:         ${C_DIM}none (multi-device)${C_RESET}"
    fi
    if [[ "$app" == "http" ]]; then
        local _udp_ip; _udp_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        echo -e "  - 📡 UDP-CUSTOM:        ${C_CYAN}${_udp_ip}:1-65535@${username}:${password}${C_RESET}"
    fi

    # Auto-ask for config generation
    echo
    read -r -p "📱 generate client config? (y/n): " gen_conf
    if [[ "$gen_conf" == "y" || "$gen_conf" == "Y" ]]; then
        generate_client_config "$username" "$password"
    fi
    
    _send_telegram "🔔 <b>User Created</b>%0A👤 $username%0A🗓️ Expires: $expire_date%0A📱 App: $app"
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

delete_user() {
    _select_multi_user_interface "--- 🗑️ Delete VPS_superScript Users ---" "true"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi
    
    echo -e "\n${C_RED}⚠️ You selected ${#SELECTED_USERS[@]} user(s) to delete: ${C_YELLOW}${SELECTED_USERS[*]}${C_RESET}"
    read -p "👉 Are you sure you want to PERMANENTLY delete them? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then echo -e "\n${C_YELLOW}❌ Deletion cancelled.${C_RESET}"; return; fi
    
    echo -e "\n${C_BLUE}🗑️ Deleting selected users...${C_RESET}"
    delete_VPS_superScript_user_accounts "${SELECTED_USERS[@]}"
}

view_user_details() {
    _select_user_interface "--- 👁️ View User Details ---"
    local username=$SELECTED_USER
    if [[ "$username" == "NO_USERS" ]] || [[ -z "$username" ]]; then return; fi
    _own_guard "$username" || return

    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 👁️ User Details: ${C_YELLOW}$username${C_PURPLE} ---${C_RESET}"

    local line; line=$(grep "^$username:" "$DB_FILE")
    if [[ -z "$line" ]]; then
        echo -e "\n${C_RED}❌ User '$username' not found in database.${C_RESET}"
        return
    fi

    local cur_pass cur_expiry cur_limit cur_bw cur_marker cur_hwid cur_strict cur_app
    IFS=: read -r _ cur_pass cur_expiry cur_limit cur_bw cur_marker cur_hwid cur_strict cur_app <<< "$line"
    [[ -z "$cur_bw" ]] && cur_bw="0"
    [[ -z "$cur_strict" ]] && cur_strict="0"
    [[ -z "$cur_app" ]] && cur_app="http"

    local bw_display; bw_display=$(_ff_quota_label "$cur_bw")

    local bw_used_display="N/A"
    if [[ -f "$BANDWIDTH_DIR/${username}.usage" ]]; then
        local used_bytes=0; read -r used_bytes < "$BANDWIDTH_DIR/${username}.usage" 2>/dev/null || used_bytes=0
        if [[ -n "$used_bytes" && "$used_bytes" != "0" ]]; then
            bw_used_display=$(awk "BEGIN {printf \"%.2f GB\", $used_bytes / 1073741824}")
        else
            bw_used_display="0.00 GB"
        fi
    fi

    local _now_ts; printf -v _now_ts '%(%s)T' -1
    local _days_str; _days_str=$(_ff_days_left_str "$cur_expiry" "$_now_ts" "$username")
    local _days_color; _days_color=$(_ff_days_left_color "$_days_str")

    local hwid_display="${C_DIM}none (multi-device)${C_RESET}"
    if [[ -n "$cur_hwid" ]]; then
        hwid_display="${C_YELLOW}$(_ff_hwid_label "$cur_hwid" "$cur_strict" enforce)${C_RESET}"
    fi

    local marker_display="${C_DIM}normal${C_RESET}"
    [[ "$cur_marker" == "trial" ]] && marker_display="${C_YELLOW}trial${C_RESET}"

    local app_display="${C_CYAN}HTTP Custom${C_RESET}"
    case "$cur_app" in
        zivpn)       app_display="${C_CYAN}ZiVPN${C_RESET}" ;;
        openvpn)     app_display="${C_CYAN}OpenVPN${C_RESET}" ;;
        wireguard)   app_display="${C_CYAN}WireGuard${C_RESET}" ;;
        hysteria2)   app_display="${C_CYAN}Hysteria2${C_RESET}" ;;
        shadowsocks) app_display="${C_CYAN}ShadowSocks${C_RESET}" ;;
        socks5)      app_display="${C_CYAN}SOCKS5${C_RESET}" ;;
    esac

    # Creation date (tracked file; fallback to home-dir mtime for older accounts).
    local created_date="—"
    if [[ -f "$CREATED_DIR/${username}" ]]; then
        local _cts=0; read -r _cts < "$CREATED_DIR/${username}" 2>/dev/null || _cts=0
        [[ "$_cts" =~ ^[0-9]+$ ]] && created_date=$(date -d "@$_cts" +"%Y-%m-%d %H:%M")
    elif [[ -d "/home/${username}" ]]; then
        created_date=$(stat -c '%y' "/home/${username}" 2>/dev/null | cut -d'.' -f1)
    fi

    echo
    echo -e "  ${C_DIM}Field${C_RESET}               ${C_DIM}Value${C_RESET}"
    echo -e "  ${C_GREEN}──────────────────────────────────────────${C_RESET}"
    echo -e "  👤 ${C_BOLD}Username${C_RESET}:        ${C_YELLOW}$username${C_RESET}"
    echo -e "  🔑 ${C_BOLD}Password${C_RESET}:        ${C_YELLOW}$cur_pass${C_RESET}"
    echo -e "  📅 ${C_BOLD}Created${C_RESET}:        ${C_YELLOW}$created_date${C_RESET}"
    echo -e "  🗓️ ${C_BOLD}Expires${C_RESET}:         ${C_YELLOW}$cur_expiry${C_RESET}  (${_days_color}${_days_str} left${C_RESET})"
    echo -e "  📶 ${C_BOLD}Conn Limit${C_RESET}:      ${C_YELLOW}$cur_limit${C_RESET}"
    echo -e "  📦 ${C_BOLD}BW Limit${C_RESET}:        ${C_YELLOW}$bw_display${C_RESET}"
    echo -e "  📊 ${C_BOLD}BW Used${C_RESET}:         ${C_CYAN}$bw_used_display${C_RESET}"
    echo -e "  🔒 ${C_BOLD}HWID Lock${C_RESET}:       ${hwid_display}"
    echo -e "  🏷️ ${C_BOLD}Account Type${C_RESET}:   ${marker_display}"
    echo -e "  📱 ${C_BOLD}Target App${C_RESET}:      ${app_display}"

    # Client connection config, shown right below the details.
    echo -e "\n${C_PURPLE}────────────────── 📱 CLIENT CONFIG ──────────────────${C_RESET}"
    generate_client_config "$username" "$cur_pass"

    echo -e "\n${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

edit_user() {
    _select_user_interface "--- ✏️ Edit a User ---"
    local username=$SELECTED_USER
    if [[ "$username" == "NO_USERS" ]] || [[ -z "$username" ]]; then return; fi
    _own_guard "$username" || return
    while true; do
        clear; show_banner; echo -e "${C_BOLD}${C_PURPLE}--- Editing User: ${C_YELLOW}$username${C_PURPLE} ---${C_RESET}"
        
        # Show current user details
        local current_line; current_line=$(grep "^$username:" "$DB_FILE")
        local cur_pass cur_expiry cur_limit cur_bw cur_marker cur_hwid cur_strict cur_app
        IFS=: read -r _ cur_pass cur_expiry cur_limit cur_bw cur_marker cur_hwid cur_strict cur_app <<< "$current_line"
        [[ -z "$cur_bw" ]] && cur_bw="0"
        [[ -z "$cur_strict" ]] && cur_strict="0"
        [[ -z "$cur_app" ]] && cur_app="http"
        local cur_bw_display; cur_bw_display=$(_ff_quota_label "$cur_bw")
        
        # Show bandwidth usage
        local bw_used_display="N/A"
        if [[ -f "$BANDWIDTH_DIR/${username}.usage" ]]; then
            local used_bytes=0; read -r used_bytes < "$BANDWIDTH_DIR/${username}.usage" 2>/dev/null || used_bytes=0
            if [[ -n "$used_bytes" && "$used_bytes" != "0" ]]; then
                bw_used_display=$(awk "BEGIN {printf \"%.2f GB\", $used_bytes / 1073741824}")
            else
                bw_used_display="0.00 GB"
            fi
        fi
        
        local _now_ts; printf -v _now_ts '%(%s)T' -1
        local _days_disp; _days_disp=$(_ff_days_left_str "$cur_expiry" "$_now_ts" "$username")
        local app_display="${C_CYAN}HTTP Custom${C_RESET}"
        case "$cur_app" in
            zivpn)       app_display="${C_CYAN}ZiVPN${C_RESET}" ;;
            openvpn)     app_display="${C_CYAN}OpenVPN${C_RESET}" ;;
            wireguard)   app_display="${C_CYAN}WireGuard${C_RESET}" ;;
            hysteria2)   app_display="${C_CYAN}Hysteria2${C_RESET}" ;;
            shadowsocks) app_display="${C_CYAN}ShadowSocks${C_RESET}" ;;
            socks5)      app_display="${C_CYAN}SOCKS5${C_RESET}" ;;
        esac
        # Compact two-column CURRENT SETTINGS panel. Absolute cursor columns keep
        # emoji labels aligned regardless of glyph width; long values (HWID) get a
        # full-width row so they can never collide with the right border.
        local _ptop="" _pbot="" _pi
        for ((_pi=0;_pi<48;_pi++)); do _ptop+="─"; done
        for ((_pi=0;_pi<67;_pi++)); do _pbot+="─"; done
        local _left_cell
        if [[ "$_days_disp" == "Expired" ]]; then
            _left_cell="${C_RED}Expired${C_RESET}"
        elif [[ "$_days_disp" == "Never" || "$_days_disp" == "N/A" ]]; then
            _left_cell="${C_YELLOW}${_days_disp}${C_RESET}"
        else
            _left_cell="${C_CYAN}${_days_disp} left${C_RESET}"
        fi
        local _hwid_icon="🔓" _hwid_cell="${C_DIM}none (multi-device)${C_RESET}"
        if [[ -n "$cur_hwid" ]]; then
            _hwid_icon="🔒"
            # Compact summary for the panel; the full device list stays in the
            # Add/Remove/Toggle menus so long HWIDs can't overflow the box.
            _ff_hwid_parse "$cur_hwid"
            local _htot=${#FF_HWID_IDS[@]} _hen=0 _hi _hst="off"
            for _hi in "${!FF_HWID_STATES[@]}"; do [[ "${FF_HWID_STATES[$_hi]}" == "on" ]] && _hen=$((_hen+1)); done
            [[ "$cur_strict" == "1" ]] && _hst="ON"
            if (( _htot == 1 )); then _hwid_cell="${C_YELLOW}1 device${C_RESET}"; else _hwid_cell="${C_YELLOW}${_htot} devices${C_RESET}"; fi
            (( _hen < _htot )) && _hwid_cell+=" ${C_DIM}(${_hen} enabled)${C_RESET}"
            _hwid_cell+=" ${C_DIM}· strict ${_hst}${C_RESET}"
        fi
        echo -e "\n  ${C_PURPLE}╭─ ${C_BOLD}CURRENT SETTINGS${C_RESET}${C_PURPLE} ${_ptop}╮${C_RESET}"
        printf '  %s│%s\033[5G🔑\033[8G%sPassword%s\033[23G%s%s%s\033[40G📱\033[43G%sApp%s\033[57G%s\033[71G%s│%s\n' \
            "$C_PURPLE" "$C_RESET" "$C_DIM" "$C_RESET" "$C_YELLOW" "$cur_pass" "$C_RESET" "$C_DIM" "$C_RESET" "$app_display" "$C_PURPLE" "$C_RESET"
        printf '  %s│%s\033[5G🗓️\033[8G%sExpires%s\033[23G%s%s%s\033[40G⏳\033[43G%sLeft%s\033[57G%s\033[71G%s│%s\n' \
            "$C_PURPLE" "$C_RESET" "$C_DIM" "$C_RESET" "$C_YELLOW" "$cur_expiry" "$C_RESET" "$C_DIM" "$C_RESET" "$_left_cell" "$C_PURPLE" "$C_RESET"
        printf '  %s│%s\033[5G📶\033[8G%sConn Limit%s\033[23G%s%s%s\033[40G📦\033[43G%sBandwidth%s\033[57G%s%s%s\033[71G%s│%s\n' \
            "$C_PURPLE" "$C_RESET" "$C_DIM" "$C_RESET" "$C_YELLOW" "$cur_limit" "$C_RESET" "$C_DIM" "$C_RESET" "$C_YELLOW" "$cur_bw_display" "$C_RESET" "$C_PURPLE" "$C_RESET"
        printf '  %s│%s\033[5G📊\033[8G%sUsed%s\033[23G%s%s%s\033[71G%s│%s\n' \
            "$C_PURPLE" "$C_RESET" "$C_DIM" "$C_RESET" "$C_CYAN" "$bw_used_display" "$C_RESET" "$C_PURPLE" "$C_RESET"
        printf '  %s│%s\033[5G%s\033[8G%sHWID%s\033[23G%s\033[71G%s│%s\n' \
            "$C_PURPLE" "$C_RESET" "$_hwid_icon" "$C_DIM" "$C_RESET" "$_hwid_cell" "$C_PURPLE" "$C_RESET"
        echo -e "  ${C_PURPLE}╰${_pbot}╯${C_RESET}"
        echo -e "\nSelect a detail to edit:\n"
        printf "  ${C_GREEN}[ 1]${C_RESET} %-35s\n" "🔑 Change Password"
        printf "  ${C_GREEN}[ 2]${C_RESET} %-35s\n" "🗓️ Change Expiration Date"
        printf "  ${C_GREEN}[ 3]${C_RESET} %-35s\n" "📶 Change Connection Limit"
        printf "  ${C_GREEN}[ 4]${C_RESET} %-35s\n" "📦 Change Bandwidth Limit"
        printf "  ${C_GREEN}[ 5]${C_RESET} %-35s\n" "🔄 Reset Bandwidth Counter"
        printf "  ${C_GREEN}[ 6]${C_RESET} %-35s\n" "🔒 Add HWID device(s)"
        printf "  ${C_GREEN}[ 7]${C_RESET} %-35s\n" "🧹 Remove HWID device(s)"
        printf "  ${C_GREEN}[ 8]${C_RESET} %-35s\n" "🛡️ Toggle Strict Enforcement"
        printf "  ${C_GREEN}[ 9]${C_RESET} %-35s\n" "🔁 Enable / Disable a device"
        printf "  ${C_GREEN}[10]${C_RESET} %-35s\n" "📱 Change Target App Type"
        echo -e "\n  ${C_RED}[ 0]${C_RESET} ✅ Finish Editing"
        echo
        if ! read -r -p "👉 Enter your choice: " edit_choice; then
            echo
            return
        fi
        case $edit_choice in
            1)
               local new_pass=""
               read -p "Enter new password (or press Enter for auto-generated): " new_pass
               if [[ -z "$new_pass" ]]; then
                   new_pass=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
                   echo -e "${C_GREEN}🔑 Auto-generated: ${C_YELLOW}$new_pass${C_RESET}"
               fi
                if ! _ff_set_password "$username" "$new_pass"; then
                    echo -e "\n${C_RED}❌ Failed to set the password on this host (chpasswd + fallbacks all failed).${C_RESET}"
                    echo -e "${C_DIM}   The account was left unchanged.${C_RESET}"
                else
                    db_set_user "$username" "$new_pass" "$cur_expiry" "$cur_limit" "$cur_bw" "$cur_marker" "$cur_hwid" "$cur_strict" "$cur_app"
                    # Password is part of the enforcer's identity match for ZiVPN, so resync.
                    hwid_sync_allowed_db
                    if [[ "$cur_app" == "zivpn" ]] && _ff_zivpn_add_pass "$new_pass"; then
                        systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
                    fi
                    # Writing a fresh hash also clears any '!' lock, so changing the
                    # password doubles as recovery for an account stuck locked with none.
                    echo -e "\n${C_GREEN}✅ Password for '$username' changed to: ${C_YELLOW}$new_pass${C_RESET}"
                fi
               ;;
            2) read -r -p "🗓️ new duration (e.g. 20d5h30m) [30d]: " duration_input
               duration_input=${duration_input:-30d}
               local duration_secs; duration_secs=$(_ff_dur_to_seconds "$duration_input")
               if [[ "$duration_secs" -le 0 ]]; then
                   echo -e "\n${C_RED}❌ Invalid duration. Use e.g. 30m, 2h, 1d, 2d4h30m.${C_RESET}"
               else
                   local duration_display; duration_display=$(expiry_human_left "$duration_secs")
                   # chage only accepts a date; round UP to the calendar date of the
                   # true cutoff so the shadow expiry can never fire early. The precise
                   # .ts timestamp (written below) enforces the exact sub-day moment.
                   local new_expire_date; new_expire_date=$(date -d "+${duration_secs} seconds" +%Y-%m-%d)
                   [[ "$new_expire_date" == "$(date +%Y-%m-%d)" ]] && new_expire_date=$(date -d "tomorrow" +%Y-%m-%d)
                   local expiry_epoch=$(( $(date +%s) + duration_secs ))
                   chage -E "$new_expire_date" "$username"
                   # Setting a duration promotes a trial to a normal account: drop the
                   # trial marker, then rewrite the precise-expiry timestamp for the new
                   # duration (same as Create User / Renew).
                   cur_marker=""
                    db_set_user "$username" "$cur_pass" "$new_expire_date" "$cur_limit" "$cur_bw" "$cur_marker" "$cur_hwid" "$cur_strict" "$cur_app"
                   mkdir -p "$TRIAL_EXPIRY_DIR"
                   printf '%s\n' "$expiry_epoch" > "$TRIAL_EXPIRY_DIR/${username}.ts"
                    echo -e "\n${C_GREEN}✅ Expiration for '$username' set to ${C_YELLOW}$new_expire_date${C_RESET}  (${C_CYAN}$duration_display${C_RESET})."
               fi ;;
            3) read -p "Enter new simultaneous connection limit: " new_limit
               if [[ "$new_limit" =~ ^[0-9]+$ ]]; then
                    db_set_user "$username" "$cur_pass" "$cur_expiry" "$new_limit" "$cur_bw" "$cur_marker" "$cur_hwid" "$cur_strict" "$cur_app"
                    echo -e "\n${C_GREEN}✅ Connection limit for '$username' set to ${C_YELLOW}$new_limit${C_RESET}."
               else echo -e "\n${C_RED}❌ Invalid limit.${C_RESET}"; fi ;;
            4) read -p "Enter new bandwidth quota (e.g. 500MB, 1GB; 0 = unlimited): " quota_input
               local new_bw; new_bw=$(_ff_quota_canonical "$quota_input")
               if _ff_quota_valid "$quota_input"; then
                    db_set_user "$username" "$cur_pass" "$cur_expiry" "$cur_limit" "$new_bw" "$cur_marker" "$cur_hwid" "$cur_strict" "$cur_app"
                    local bw_msg; bw_msg=$(_ff_quota_label "$new_bw")
                   echo -e "\n${C_GREEN}✅ Bandwidth limit for '$username' set to ${C_YELLOW}$bw_msg${C_RESET}."
                   # Unlock user if they were locked due to bandwidth
                   if [[ "$new_bw" == "0" ]] || [[ -f "$BANDWIDTH_DIR/${username}.usage" ]]; then
                       local used_bytes; used_bytes=$(cat "$BANDWIDTH_DIR/${username}.usage" 2>/dev/null || echo 0)
                       local new_quota_bytes; new_quota_bytes=$(_ff_quota_to_bytes "$new_bw")
                       if [[ "$new_bw" == "0" ]] || [[ "$used_bytes" -lt "$new_quota_bytes" ]]; then
                           _ff_restore_user_all_protocols "$username"
                       fi
                   fi
               else echo -e "\n${C_RED}❌ Invalid bandwidth value.${C_RESET}"; fi ;;
            5)
               echo "0" > "$BANDWIDTH_DIR/${username}.usage"
               # Unlock user if they were locked due to bandwidth (all protocols).
               _ff_restore_user_all_protocols "$username"
               echo -e "\n${C_GREEN}✅ Bandwidth counter for '$username' has been reset to 0.${C_RESET}"
               ;;
            6) local add_hwid="" merged="" new_strict="$cur_strict"
               echo -e "${C_DIM}Paste the device HWID shown in the client VPN app.${C_RESET}"
               echo -e "${C_DIM}Separate multiple devices with commas (e.g. hwidA,hwidB).${C_RESET}"
               read -p "🔒 Enter HWID(s) to ADD for '$username': " add_hwid
               add_hwid=$(_ff_normalize_hwids "$add_hwid")
               if [[ -z "$add_hwid" ]]; then
                   echo -e "\n${C_YELLOW}⚠️ No HWID entered — unchanged. Use [7] to remove a device.${C_RESET}"
               else
                   if [[ -n "$cur_hwid" ]]; then
                       local repl="n"
                       read -p "🔁 Replace existing HWID(s) instead of adding? (y/N): " repl
                       if [[ "$repl" == "y" || "$repl" == "Y" ]]; then
                           merged="$add_hwid"
                       else
                           merged=$(_ff_normalize_hwids "${cur_hwid},${add_hwid}")
                       fi
                   else
                       merged="$add_hwid"
                   fi
                   # Strict is a per-user flag. Ask only when the user had no HWIDs
                   # before; when growing an existing set, added devices inherit it.
                   if [[ -z "$cur_hwid" ]]; then
                       local s_choice="y"
                       read -p "🛡️ Strict-enforce these device(s) now? (y/n) [y]: " s_choice
                       s_choice=${s_choice:-y}
                       new_strict=0; [[ "$s_choice" == "y" || "$s_choice" == "Y" ]] && new_strict=1
                   else
                       local inh="off"; [[ "$cur_strict" == "1" ]] && inh="ON"
                       echo -e "${C_DIM}ℹ️ Added device(s) inherit current strict enforcement: ${inh}.${C_RESET}"
                   fi
                    db_set_user "$username" "$cur_pass" "$cur_expiry" "$cur_limit" "$cur_bw" "$cur_marker" "$merged" "$new_strict" "$cur_app"
                    cur_hwid="$merged"; cur_strict="$new_strict"
                   hwid_sync_allowed_db
                   # A freshly-assigned device shouldn't stay blocked from a prior session.
                   _ff_unblock_user_traffic "$username"
                   echo -e "\n${C_GREEN}✅ HWID(s) for '$username': ${C_YELLOW}$(_ff_hwid_label "$cur_hwid" "$cur_strict" strict)${C_RESET}"
                   if ! systemctl is-active --quiet VPS_superScript-hwid-enforcer 2>/dev/null; then
                       echo -e "${C_DIM}ℹ️ Global HWID Lock is OFF — enable it in Protocol Manager to enforce.${C_RESET}"
                   fi
               fi ;;
            7) if [[ -z "$cur_hwid" ]]; then
                   echo -e "\n${C_YELLOW}ℹ️ '$username' has no HWID set.${C_RESET}"
               else
                   _ff_hwid_parse "$cur_hwid"
                   echo -e "\n${C_DIM}Registered devices for '$username':${C_RESET}"
                   local i badge
                   for i in "${!FF_HWID_IDS[@]}"; do
                       if [[ "${FF_HWID_STATES[$i]}" == "off" ]]; then badge="${C_DIM}⚪ disabled${C_RESET}"; else badge="${C_GREEN}🟢 enabled${C_RESET}"; fi
                       printf "  ${C_GREEN}[%d]${C_RESET} %-24s %b\n" "$((i+1))" "${FF_HWID_IDS[$i]}" "$badge"
                   done
                   echo -e "${C_DIM}Enter number(s) to remove (e.g. 1 3), or 'all' to clear every device.${C_RESET}"
                   local sel; read -p "🧹 Remove which device(s)? " sel
                   if [[ -z "$sel" ]]; then
                       echo -e "\n${C_YELLOW}⚠️ Nothing entered — no devices removed.${C_RESET}"
                   else
                       local -A drop_idx=()
                       local remaining=""
                       if [[ "$sel" == "all" || "$sel" == "ALL" ]]; then
                           remaining=""
                       else
                           local tok
                           for tok in $sel; do
                               [[ "$tok" =~ ^[0-9]+$ ]] && drop_idx["$tok"]=1
                           done
                           for i in "${!FF_HWID_IDS[@]}"; do
                               [[ -n "${drop_idx[$((i+1))]+x}" ]] && continue
                               [[ -n "$remaining" ]] && remaining+=","
                               [[ "${FF_HWID_STATES[$i]}" == "off" ]] && remaining+="!"
                               remaining+="${FF_HWID_IDS[$i]}"
                           done
                       fi
                       remaining=$(_ff_normalize_hwids "$remaining")
                       if [[ "$remaining" == "$cur_hwid" ]]; then
                           echo -e "\n${C_YELLOW}⚠️ No valid selection — nothing removed.${C_RESET}"
                       else
                           local new_strict="$cur_strict"
                           [[ -z "$remaining" ]] && new_strict="0"
                            db_set_user "$username" "$cur_pass" "$cur_expiry" "$cur_limit" "$cur_bw" "$cur_marker" "$remaining" "$new_strict" "$cur_app"
                            cur_hwid="$remaining"; cur_strict="$new_strict"
                           hwid_sync_allowed_db
                           _ff_unblock_user_traffic "$username"
                           # Clear lingering IP drops; enforcer re-adds within seconds
                           # for any device still in violation of the remaining list.
                           _hwid_flush_drops
                           if [[ -z "$cur_hwid" ]]; then
                               echo -e "\n${C_GREEN}✅ All HWIDs removed for '$username'. Device lock cleared (multi-device allowed).${C_RESET}"
                           else
                               echo -e "\n${C_GREEN}✅ HWID(s) for '$username' now: ${C_YELLOW}$(_ff_hwid_label "$cur_hwid" "$cur_strict" strict)${C_RESET}"
                           fi
                       fi
                   fi
               fi ;;
            8) if [[ -z "$cur_hwid" ]]; then
                   echo -e "\n${C_YELLOW}⚠️ Assign an HWID first ([6]) before toggling strict enforcement.${C_RESET}"
               else
                   local new_strict=1; [[ "$cur_strict" == "1" ]] && new_strict=0
                    db_set_user "$username" "$cur_pass" "$cur_expiry" "$cur_limit" "$cur_bw" "$cur_marker" "$cur_hwid" "$new_strict" "$cur_app"
                    cur_strict="$new_strict"
                    hwid_sync_allowed_db
                   [[ "$new_strict" == "0" ]] && { _ff_unblock_user_traffic "$username"; _hwid_flush_drops; }
                   local st_msg="OFF"; [[ "$new_strict" == "1" ]] && st_msg="ON"
                   echo -e "\n${C_GREEN}✅ Strict enforcement for '$username' is now ${C_YELLOW}${st_msg}${C_GREEN}.${C_RESET}"
               fi ;;
            9) if [[ -z "$cur_hwid" ]]; then
                   echo -e "\n${C_YELLOW}ℹ️ '$username' has no HWID set. Add one with [6] first.${C_RESET}"
               else
                   _ff_hwid_parse "$cur_hwid"
                   echo -e "\n${C_DIM}Registered devices for '$username':${C_RESET}"
                   local i badge
                   for i in "${!FF_HWID_IDS[@]}"; do
                       if [[ "${FF_HWID_STATES[$i]}" == "off" ]]; then badge="${C_DIM}⚪ disabled${C_RESET}"; else badge="${C_GREEN}🟢 enabled${C_RESET}"; fi
                       printf "  ${C_GREEN}[%d]${C_RESET} %-24s %b\n" "$((i+1))" "${FF_HWID_IDS[$i]}" "$badge"
                   done
                   local pick; read -p "🔁 Toggle which device on/off? (number) " pick
                   if ! [[ "$pick" =~ ^[0-9]+$ ]] || (( pick < 1 || pick > ${#FF_HWID_IDS[@]} )); then
                       echo -e "\n${C_RED}❌ Invalid device number.${C_RESET}"
                   else
                       local idx=$((pick-1)) was="${FF_HWID_STATES[$((pick-1))]}" devid="${FF_HWID_IDS[$((pick-1))]}"
                       local disabling=false
                       if [[ "$was" == "on" ]]; then FF_HWID_STATES[$idx]="off"; disabling=true; else FF_HWID_STATES[$idx]="on"; fi
                        cur_hwid=$(_ff_hwid_join)
                        db_set_user "$username" "$cur_pass" "$cur_expiry" "$cur_limit" "$cur_bw" "$cur_marker" "$cur_hwid" "$cur_strict" "$cur_app"
                        hwid_sync_allowed_db
                       # Count remaining enabled devices for the warning below.
                       local still_enabled=0
                       for i in "${!FF_HWID_STATES[@]}"; do [[ "${FF_HWID_STATES[$i]}" == "on" ]] && still_enabled=$((still_enabled+1)); done
                       if $disabling; then
                           echo -e "\n${C_GREEN}✅ Device ${C_YELLOW}${devid}${C_GREEN} is now ${C_RED}DISABLED${C_GREEN}.${C_RESET}"
                           # Instant cutoff: bounce the UDP relays so the just-disabled
                           # device re-handshakes and is dropped by the enforcer at once.
                            if [[ "$cur_strict" == "1" ]] && systemctl is-active --quiet VPS_superScript-hwid-enforcer 2>/dev/null; then
                                local -a blip=()
                                systemctl is-active --quiet udp-custom 2>/dev/null && blip+=(udp-custom)
                                systemctl is-active --quiet badvpn 2>/dev/null && blip+=(badvpn)
                                systemctl is-active --quiet udpgw 2>/dev/null && blip+=(udpgw)
                                systemctl is-active --quiet zivpn 2>/dev/null && blip+=(zivpn)
                                if [[ ${#blip[@]} -gt 0 ]]; then
                                    echo -e "${C_DIM}⚡ Bouncing UDP relays (${blip[*]}) — all UDP users blip ~0.3s; the disabled device is cut now.${C_RESET}"
                                    _ff_udp_session_blip "${blip[@]}"
                                fi
                               if (( still_enabled == 0 )); then
                                   echo -e "${C_YELLOW}⚠️ No enabled devices remain — '$username' is now effectively un-enforced (multi-device) until you re-enable a device or turn strict off.${C_RESET}"
                               fi
                           fi
                       else
                           echo -e "\n${C_GREEN}✅ Device ${C_YELLOW}${devid}${C_GREEN} is now ${C_GREEN}ENABLED${C_GREEN}.${C_RESET}"
                           # Clear any stale enforcer drop so the device can reconnect now.
                           _ff_unblock_user_traffic "$username"
                           _hwid_flush_drops
                       fi
                    fi
                fi ;;
              10) local new_app="$cur_app"
                  echo -e "\n${C_DIM}Current target app: ${app_display}${C_RESET}"
                  echo -e "${C_DIM}Select new application type:${C_RESET}"
                  printf "  ${C_GREEN}[1]${C_RESET} %-16s\n" "HTTP Custom"
                  printf "  ${C_GREEN}[2]${C_RESET} %-16s\n" "ZiVPN"
                  printf "  ${C_GREEN}[3]${C_RESET} %-16s\n" "OpenVPN"
                  printf "  ${C_GREEN}[4]${C_RESET} %-16s\n" "WireGuard"
                  printf "  ${C_GREEN}[5]${C_RESET} %-16s\n" "Hysteria2"
                  printf "  ${C_GREEN}[6]${C_RESET} %-16s\n" "ShadowSocks"
                  printf "  ${C_GREEN}[7]${C_RESET} %-16s\n" "SOCKS5"
                  read -p "👉 App type [1]: " app_choice
                  app_choice=${app_choice:-1}
                  case "$app_choice" in
                      2|z|Z|zivpn|ZiVPN)           new_app="zivpn" ;;
                      3|o|O|openvpn|OpenVPN)       new_app="openvpn" ;;
                      4|w|W|wireguard|WireGuard)   new_app="wireguard" ;;
                      5|h|H|hysteria|Hysteria2)    new_app="hysteria2" ;;
                      6|s|S|shadowsocks|ShadowSocks) new_app="shadowsocks" ;;
                      7|socks5|SOCKS5)             new_app="socks5" ;;
                      *)                           new_app="http" ;;
                  esac
                  db_set_user "$username" "$cur_pass" "$cur_expiry" "$cur_limit" "$cur_bw" "$cur_marker" "$cur_hwid" "$cur_strict" "$new_app"
                 # Sync ZiVPN auth list when app type changes.
                 if [[ "$new_app" != "$cur_app" ]]; then
                     if [[ "$new_app" == "zivpn" ]]; then
                         _ff_zivpn_add_pass "$cur_pass"
                     elif [[ "$cur_app" == "zivpn" && -f "$ZIVPN_CONFIG_FILE" ]] && command -v jq &>/dev/null; then
                         local tmp; tmp=$(mktemp) 2>/dev/null || true
                         if [[ -n "$tmp" ]]; then
                             jq --arg p "$cur_pass" '.auth.config |= map(select(. != $p))' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null && mv "$tmp" "$ZIVPN_CONFIG_FILE"
                             rm -f "$tmp" 2>/dev/null
                         fi
                     fi
                     systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
                 fi
                 cur_app="$new_app"
                 echo -e "\n${C_GREEN}✅ Target app for '$username' changed to ${C_YELLOW}$new_app${C_RESET}"
                 ;;
             0) return ;;
             *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" ;;
        esac
        echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to continue editing..." && read -r || return
    done
}

# --- Immediate per-user network cutoff ------------------------------------
# Drop every packet owned by a user's UID so live SSH / SSH-tunnel sessions die
# at once instead of waiting for the 30s limiter pass. The owner match applies
# to locally-generated (OUTPUT) traffic, severing the return path for any
# session the user's own processes carry.
# NOTE: udp-custom / zivpn / badvpn run as root, so their *live* sessions are
# not user-owned and cannot be singled out here; the usermod -L password lock
# blocks any new or re-authenticated UDP connection immediately.
_ff_block_user_traffic() {
    local user="$1" uid ipt
    command -v iptables &>/dev/null || return 0
    uid=$(id -u "$user" 2>/dev/null) || return 0
    [[ "$uid" =~ ^[0-9]+$ ]] || return 0
    for ipt in iptables ip6tables; do
        command -v "$ipt" &>/dev/null || continue
        # Delete first (idempotent), then insert at the top of OUTPUT.
        "$ipt" -D OUTPUT -m owner --uid-owner "$uid" -j DROP 2>/dev/null
        "$ipt" -I OUTPUT -m owner --uid-owner "$uid" -j DROP 2>/dev/null
    done
}

_ff_unblock_user_traffic() {
    local user="$1" uid ipt
    command -v iptables &>/dev/null || return 0
    uid=$(id -u "$user" 2>/dev/null) || return 0
    [[ "$uid" =~ ^[0-9]+$ ]] || return 0
    for ipt in iptables ip6tables; do
        command -v "$ipt" &>/dev/null || continue
        # Remove every copy of the rule in case duplicates accumulated.
        while "$ipt" -D OUTPUT -m owner --uid-owner "$uid" -j DROP 2>/dev/null; do :; done
    done
}

_ff_kill_user_sessions() {
    local user="$1"
    killall -u "$user" -9 &>/dev/null
    pkill -9 -u "$user" &>/dev/null
}

# --- Cross-protocol "very fast blip" UDP session kill -----------------------
# UDP relays (udp-custom / zivpn / udpgw) run as root, so a locked user's LIVE
# session is not user-owned and cannot be dropped by UID match or pkill. The only
# reliable, immediate lever is to bounce the relay: every client re-handshakes,
# and a locked user fails re-auth (shadow lock for udp-custom; password removed
# from config.json for zivpn). conntrack is flushed first so stale UDP/NAT state
# is gone the instant the relay comes back. The blip is ~0.3s; healthy users
# reconnect automatically. Pass the services to bounce as args.
_ff_udp_session_blip() {
    local svc port
    local -a targets=("$@")
    [[ ${#targets[@]} -eq 0 ]] && targets=(udp-custom zivpn)

    # 1) Flush conntrack for the relay listen ports so kernel state dies at once.
    if command -v conntrack &>/dev/null; then
        for svc in "${targets[@]}"; do
            case "$svc" in
                udp-custom)              port="$UDP_CUSTOM_LISTEN_PORT" ;;
                zivpn)                   port="$ZIVPN_LISTEN_PORT" ;;
                badvpn)                  port="$BADVPN_LISTEN_PORT" ;;
                udpgw)                   port="" ;;  # localhost only, no external port to flush
                hysteria-server)         port="$HYSTERIA2_PORT" ;;
                shadowsocks-libev) port="$SHADOWSOCKS_PORT" ;;
                *)                       port="" ;;
            esac
            [[ -n "$port" ]] && conntrack -D -p udp --dport "$port" &>/dev/null
        done
        # ZiVPN also accepts the 6000-19999 range (DNAT -> 5667); clear those
        # too, matched by their pre-DNAT (original) destination port.
        if printf '%s\n' "${targets[@]}" | grep -qx zivpn; then
            conntrack -D -p udp --dport 6000:19999 &>/dev/null || true
        fi
    fi

    # 2) Bounce only the relays that are actually running (fast blip).
    for svc in "${targets[@]}"; do
        systemctl is-active --quiet "$svc" 2>/dev/null && \
            systemctl try-restart "${svc}.service" 2>/dev/null
    done
}

# Remove a user's password from the ZiVPN auth list (config.json) so a ZiVPN
# client using those credentials can no longer authenticate. Records what was
# removed under ZIVPN_LOCK_DIR so unlock can restore it precisely.
# Echoes "changed" when the config was actually modified.
_ff_zivpn_lock_user() {
    local user="$1" pass
    [[ -f "$ZIVPN_CONFIG_FILE" ]] || return 1
    command -v jq &>/dev/null || return 1
    pass=$(db_get_field "$user" 2)
    [[ -n "$pass" ]] || return 1
    # Only act if this password is actually present in the auth list.
    jq -e --arg p "$pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null || return 1
    local tmp; tmp=$(mktemp) || return 1
    if jq --arg p "$pass" '.auth.config |= map(select(. != $p))' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null; then
        mv "$tmp" "$ZIVPN_CONFIG_FILE"
        mkdir -p "$ZIVPN_LOCK_DIR" 2>/dev/null
        printf '%s' "$pass" > "$ZIVPN_LOCK_DIR/${user}"
        echo "changed"; return 0
    fi
    rm -f "$tmp" 2>/dev/null
    return 1
}

# Restore a user's ZiVPN password so they can reconnect after an unlock.
# Robust by design: the password comes from the marker lock wrote, but if the
# marker is missing or empty we fall back to the user's DB password (field 2) so
# a ZiVPN account is never left unable to reconnect. The marker is only removed
# AFTER the password is confirmed present in config.json, so a failed re-add
# can be retried instead of losing the password permanently.
# Echoes "changed" when the config was actually modified.
_ff_zivpn_unlock_user() {
    local user="$1" pass marker="$ZIVPN_LOCK_DIR/${user}"
    command -v jq &>/dev/null || return 1
    [[ -f "$ZIVPN_CONFIG_FILE" ]] || return 1
    # Only relevant for ZiVPN accounts.
    [[ "$(db_get_field "$user" 9)" == "zivpn" ]] || { rm -f "$marker" 2>/dev/null; return 1; }

    # Prefer what lock recorded; fall back to the DB password.
    pass=$(cat "$marker" 2>/dev/null)
    [[ -n "$pass" ]] || pass=$(db_get_field "$user" 2)
    [[ -n "$pass" ]] || { rm -f "$marker" 2>/dev/null; return 1; }

    # Already present (someone restored it / never removed): just drop the marker.
    if jq -e --arg p "$pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null; then
        rm -f "$marker" 2>/dev/null
        return 1
    fi
    local tmp; tmp=$(mktemp) || return 1
    if jq --arg p "$pass" '.auth.config += [$p]' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null; then
        mv "$tmp" "$ZIVPN_CONFIG_FILE"
        rm -f "$marker" 2>/dev/null
        echo "changed"; return 0
    fi
    rm -f "$tmp" 2>/dev/null
    return 1
}

# Single-user "fully restore access" used by renew / edit-user unlock paths:
# clear the SSH/traffic block, restore any ZiVPN password that lock removed, and
# reload zivpn only when that actually changed the auth list.
_ff_restore_user_all_protocols() {
    local u="$1"
    usermod -U "$u" &>/dev/null
    # usermod -U only strips the first '!'; force-clear a stubborn double lock
    # so renew/restore reliably reopens an account locked by two subsystems.
    _ff_is_shadow_locked "$u" && _ff_force_shadow_unlock "$u"
    _ff_unblock_user_traffic "$u"
    if [[ "$(_ff_zivpn_unlock_user "$u")" == "changed" ]]; then
        systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
    fi
    systemctl is-active --quiet udp-custom 2>/dev/null && systemctl try-restart udp-custom.service 2>/dev/null
    systemctl is-active --quiet hysteria-server 2>/dev/null && systemctl try-restart hysteria-server 2>/dev/null
    systemctl is-active --quiet shadowsocks-libev 2>/dev/null && systemctl try-restart shadowsocks-libev 2>/dev/null
}

# True (0) when the account's /etc/shadow password field is locked (leading '!').
# Mirrors how the user list and the limiter daemon detect a system lock, so the
# unlock path agrees with what the admin actually sees in the list.
_ff_is_shadow_locked() {
    local u="$1" f2
    f2=$(awk -F: -v user="$u" '$1==user{print $2; exit}' /etc/shadow 2>/dev/null)
    [[ "${f2:0:1}" == "!" ]]
}

# Force-clear ANY system (shadow) lock on a managed account. 'usermod -U' only
# strips the FIRST '!', so an account locked by two subsystems (the limiter and
# the UDP anti-sharing guard, or a manual lock stacked on an auto-lock) keeps a
# '!!' prefix and stays locked after a normal unlock. This rewrites the password
# field to the stored hash with every leading '!' removed. Returns 1 (changing
# nothing) when there is no real password to restore — the caller then tells the
# admin to reset it. Only ever touches accounts present in users.db.
_ff_force_shadow_unlock() {
    local u="$1" cur stripped
    grep -q "^${u}:" "$DB_FILE" 2>/dev/null || return 1
    cur=$(awk -F: -v user="$u" '$1==user{print $2; exit}' /etc/shadow 2>/dev/null)
    stripped="$cur"
    while [[ "$stripped" == '!'* ]]; do stripped="${stripped#!}"; done
    [[ -z "$stripped" || "$stripped" == '*' ]] && return 1
    usermod -p "$stripped" "$u" 2>/dev/null
}

# Read a user's /etc/shadow password field (field 2). Empty if the user is absent.
_ff_shadow_field2() {
    awk -F: -v user="$1" '$1==user{print $2; exit}' /etc/shadow 2>/dev/null
}

# Set a managed account's system password and VERIFY it actually landed as a
# real crypt hash. A bare 'echo user:pass | chpasswd' is fire-and-forget: on
# some hosts it silently no-ops — a PAM password-quality gate rejecting a weak
# password (e.g. one equal to the username), or a custom chpasswd config — and
# leaves the account at useradd's default '!'. That is an account created
# "locked" with no hash behind it, which can never be unlocked because there is
# nothing to restore (exactly the "users stuck locked" report). Here we set the
# password, then confirm field-2 is a genuine hash (starts with '$'). If the
# normal path didn't take, we generate the SHA-512 hash ourselves and write it
# straight to the shadow field with 'usermod -p', which bypasses any quality
# gate. Writing a fresh hash also clears any leading '!', so calling this on a
# locked account both sets the password AND unlocks it. Returns 0 only once a
# real hash is present, 1 if every method failed.
_ff_set_password() {
    local u="$1" p="$2" f2 hash

    echo "$u:$p" | chpasswd 2>/dev/null
    f2=$(_ff_shadow_field2 "$u"); [[ "$f2" == '$'* ]] && return 0

    # Retry forcing SHA-512 explicitly, in case the host's default method balked.
    echo "$u:$p" | chpasswd -c SHA512 2>/dev/null
    f2=$(_ff_shadow_field2 "$u"); [[ "$f2" == '$'* ]] && return 0

    # Last resort: hash it ourselves and write it directly, bypassing chpasswd
    # (and therefore any PAM/quality gate that was refusing the password).
    hash=""
    if command -v openssl >/dev/null 2>&1; then
        hash=$(openssl passwd -6 -stdin <<<"$p" 2>/dev/null)
    fi
    if [[ "$hash" != '$'* ]] && command -v python3 >/dev/null 2>&1; then
        hash=$(python3 -c 'import crypt,sys; print(crypt.crypt(sys.argv[1], crypt.mksalt(crypt.METHOD_SHA512)))' "$p" 2>/dev/null)
    fi
    if [[ "$hash" == '$'* ]]; then
        usermod -p "$hash" "$u" 2>/dev/null
        f2=$(_ff_shadow_field2 "$u"); [[ "$f2" == '$'* ]] && return 0
    fi
    return 1
}

lock_user() {
    _select_multi_user_interface "--- 🔒 Lock Users (from DB) ---"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi

    echo -e "\n${C_BLUE}🔒 Locking selected users...${C_RESET}"
    local any_locked=false zivpn_changed=false
    for u in "${SELECTED_USERS[@]}"; do
        _own_guard "$u" || continue
        if ! id "$u" &>/dev/null; then
             echo -e " ❌ User '${C_YELLOW}$u${C_RESET}' does not exist on this system."
             continue
        fi

        usermod -L "$u"
        if [ $? -eq 0 ]; then
            # SSH + udp-custom: shadow lock blocks re-auth; drop owned traffic and
            # kill the user's own processes (SSH / SSH-tunnel sessions) instantly.
            _ff_block_user_traffic "$u"
            _ff_kill_user_sessions "$u"
            # ZiVPN: pull the password from the auth list (system lock can't touch it).
            [[ "$(_ff_zivpn_lock_user "$u")" == "changed" ]] && zivpn_changed=true
            any_locked=true
            echo -e " ✅ ${C_YELLOW}$u${C_RESET} locked — SSH/UDP auth blocked, owned sessions killed."
        else
            echo -e " ❌ Failed to lock ${C_YELLOW}$u${C_RESET}."
        fi
    done

    # One fast blip for the whole batch so live root-owned UDP sessions die now.
    # udp-custom: any FF user can auth against shadow, so we can't know which
    # locked user holds a live session — bounce it whenever it's running.
    # zivpn: identity is the password, so we only bounce it when we actually
    # removed a locked user's password (no collateral drop for other zivpn users).
    if [[ "$any_locked" == true ]]; then
        local -a blip=()
        systemctl is-active --quiet udp-custom 2>/dev/null && blip+=(udp-custom)
        systemctl is-active --quiet badvpn 2>/dev/null && blip+=(badvpn)
        systemctl is-active --quiet udpgw 2>/dev/null && blip+=(udpgw)
        systemctl is-active --quiet hysteria-server 2>/dev/null && blip+=(hysteria-server)
        systemctl is-active --quiet shadowsocks-libev 2>/dev/null && blip+=(shadowsocks-libev)
        [[ "$zivpn_changed" == true ]] && blip+=(zivpn)
        if [[ ${#blip[@]} -gt 0 ]]; then
            echo -e "${C_DIM}⚡ Dropping live UDP sessions (fast blip: ${blip[*]})...${C_RESET}"
            _ff_udp_session_blip "${blip[@]}"
        fi
    fi
}

unlock_user() {
    _select_multi_user_interface "--- 🔓 Unlock Users (from DB) ---"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi

    echo -e "\n${C_BLUE}🔓 Unlocking selected users...${C_RESET}"
    local zivpn_changed=false
    local share_locks="$DB_DIR/udp_share.locks"
    local now_ts; printf -v now_ts '%(%s)T' -1
    for u in "${SELECTED_USERS[@]}"; do
        _own_guard "$u" || continue
        if ! id "$u" &>/dev/null; then
             echo -e " ❌ User '${C_YELLOW}$u${C_RESET}' does not exist on this system."
             continue
        fi

        # Authoritatively clear the system (shadow) lock. usermod -U handles the
        # common single-'!' case cleanly (preserving password aging); if the
        # account is still locked afterwards (double '!!' from two lockers, or a
        # stale field) force-clear it directly.
        usermod -U "$u" &>/dev/null
        if _ff_is_shadow_locked "$u"; then
            _ff_force_shadow_unlock "$u"
        fi
        if _ff_is_shadow_locked "$u"; then
            # Nothing to restore — the account was created without a usable hash
            # (a chpasswd that silently failed), so usermod -U/-p have nothing to
            # unlock. Re-establish the password from the copy stored in users.db
            # so a plain Unlock repairs these "locked from birth" accounts instead
            # of dead-ending at Edit User.
            local db_pass
            db_pass=$(awk -F: -v user="$u" '$1==user{print $2; exit}' "$DB_FILE" 2>/dev/null)
            if [[ -n "$db_pass" ]] && _ff_set_password "$u" "$db_pass"; then
                echo -e "    ${C_DIM}↳ system password was missing — restored it from the database.${C_RESET}"
            fi
        fi
        if _ff_is_shadow_locked "$u"; then
            echo -e " ⚠️  ${C_YELLOW}$u${C_RESET} is still locked at the system level — the account has no valid password to restore. Use 📝 Edit User to set a new password."
            continue
        fi

        # Drop the anti-sharing auto-lock ledger entry, or the UDP share-guard
        # daemon still counts this account as under its temporary lock and can
        # re-apply usermod -L on its next scan.
        if [[ -f "$share_locks" ]] && grep -q "^${u} " "$share_locks" 2>/dev/null; then
            grep -v "^${u} " "$share_locks" > "${share_locks}.tmp" 2>/dev/null && mv "${share_locks}.tmp" "$share_locks" 2>/dev/null
        fi

        # Clear the limiter's re-lock CAUSES so the unlock actually holds.
        local dbline exp bw
        dbline=$(grep "^${u}:" "$DB_FILE" 2>/dev/null)
        IFS=: read -r _ _ exp _ bw _ <<< "$dbline"
        # (a) Bandwidth quota: reset usage to 0 when at/over the cap so the
        #     limiter daemon does not immediately re-lock (admin-chosen policy).
        local quota_note=""
        if [[ -n "$bw" && "$bw" != "0" ]]; then
            local usagefile="$BANDWIDTH_DIR/${u}.usage" used=0 quota
            if [[ -f "$usagefile" ]]; then read -r used < "$usagefile" 2>/dev/null; [[ "$used" =~ ^[0-9]+$ ]] || used=0; fi
            quota=$(_ff_quota_to_bytes "$bw")
            if [[ "$quota" =~ ^[0-9]+$ ]] && (( quota > 0 && used >= quota )); then
                echo "0" > "$usagefile"
                rm -f "$BANDWIDTH_DIR/pidtrack/${u}__"*.last 2>/dev/null
                quota_note="    ${C_DIM}↳ bandwidth usage was over the ${bw} quota — reset to 0 so the unlock holds.${C_RESET}"
            fi
        fi
        # (b) Expiry: a shadow unlock cannot survive a past expiry date — the
        #     limiter re-locks expired accounts within one scan. Point the admin
        #     at Renew instead of silently letting the unlock bounce back.
        local exp_note=""
        if [[ -n "$exp" && "$exp" != "Never" && "$exp" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            local exp_ts; exp_ts=$(date -d "$exp" +%s 2>/dev/null || echo 0)
            if [[ "$exp_ts" =~ ^[0-9]+$ ]] && (( exp_ts > 0 && exp_ts < now_ts )); then
                exp_note="    ${C_YELLOW}⚠️  $u is EXPIRED ($exp) — this unlock will not hold; use 🔄 Renew to extend the account.${C_RESET}"
            fi
        fi

        # Restore traffic + protocol auth (SSH/UDP/ZiVPN).
        _ff_unblock_user_traffic "$u"
        # ZiVPN: restore the password we removed at lock time, if any.
        [[ "$(_ff_zivpn_unlock_user "$u")" == "changed" ]] && zivpn_changed=true
        echo -e " ✅ ${C_YELLOW}$u${C_RESET} unlocked — can reconnect immediately (all protocols)."
        [[ -n "$quota_note" ]] && echo -e "$quota_note"
        [[ -n "$exp_note" ]] && echo -e "$exp_note"
    done

    # Reload ZiVPN so restored passwords take effect.
    if [[ "$zivpn_changed" == true ]] && systemctl is-active --quiet zivpn 2>/dev/null; then
        systemctl try-restart zivpn.service 2>/dev/null
    fi
    # Restart UDP services to clear any stale auth cache from the lock period.
    systemctl is-active --quiet udp-custom 2>/dev/null && systemctl try-restart udp-custom.service 2>/dev/null
    systemctl is-active --quiet hysteria-server 2>/dev/null && systemctl try-restart hysteria-server 2>/dev/null
    systemctl is-active --quiet shadowsocks-libev 2>/dev/null && systemctl try-restart shadowsocks-libev 2>/dev/null
}

# Compact "time left until expiry" string in official trial-duration style
# (e.g. "20d5h30m"), given an expiry date (YYYY-MM-DD) and the current epoch.
# An optional 3rd arg (username) makes it prefer the precise .ts epoch, so
# sub-day durations count down accurately instead of rounding to a full day.
_ff_days_left_str() {
    local expiry="$1" now="$2" user="${3:-}" ts diff dd hh mm
    [[ -z "$expiry" || "$expiry" == "Never" ]] && { printf 'Never'; return; }
    # Precise sub-day epoch beats the rounded calendar date when present.
    if [[ -n "$user" && -f "$TRIAL_EXPIRY_DIR/${user}.ts" ]]; then
        local _p=0; read -r _p < "$TRIAL_EXPIRY_DIR/${user}.ts" 2>/dev/null || _p=0
        [[ "$_p" =~ ^[0-9]+$ ]] && (( _p > 0 )) && ts="$_p" || ts=0
    else
        ts=0
    fi
    if (( ts <= 0 )); then
        ts=$(date -d "$expiry 23:59:59" +%s 2>/dev/null || date -d "$expiry" +%s 2>/dev/null || echo 0)
    fi
    [[ "$ts" =~ ^[0-9]+$ ]] && (( ts > 0 )) || { printf 'N/A'; return; }
    diff=$(( ts - now ))
    (( diff <= 0 )) && { printf 'Expired'; return; }
    dd=$(( diff / 86400 )); diff=$(( diff % 86400 ))
    hh=$(( diff / 3600 ));  diff=$(( diff % 3600 ))
    mm=$(( diff / 60 ))
    local out=""
    [ "$dd" -gt 0 ] && out="${dd}d"
    [ "$hh" -gt 0 ] && out="${out}${hh}h"
    [ "$mm" -gt 0 ] && out="${out}${mm}m"
    [ -z "$out" ] && out="<1m"
    printf '%s' "$out"
}

# Pick a color for a days-left string produced by _ff_days_left_str.
_ff_days_left_color() {
    local s="$1"
    case "$s" in
        Never)   printf '%s' "$C_DIM" ;;
        Expired) printf '%s' "$C_RED" ;;
        "<1m"*)  printf '%s' "$C_RED" ;;
        N/A)     printf '%s' "$C_DIM" ;;
        *) local n="${s%%[!0-9]*}"
           if [[ "$n" =~ ^[0-9]+$ ]] && (( n <= 3 )); then printf '%s' "$C_RED"
           elif [[ "$n" =~ ^[0-9]+$ ]] && (( n <= 7 )); then printf '%s' "$C_YELLOW"
           else printf '%s' "$C_GREEN"; fi ;;
    esac
}

list_users() {
    clear; show_banner

    # Fixed absolute columns (cursor-positioned). Unlike %-Ns padding — which
    # counts ANSI bytes and double-width emojis wrongly — placing each field on
    # a screen column forces perfect vertical alignment and prevents clipping.
    local TW; TW=$(tput cols 2>/dev/null); [[ "$TW" =~ ^[0-9]+$ ]] && (( TW >= 20 )) || TW=80
    local T=66; (( T > TW )) && T=$TW          # total table width incl. box corners
    local W=$(( T - 2 )); (( W < 20 )) && W=20 # ═ fill width
    local LEAD=0                                # centering disabled (left-aligned)
    local PAD; PAD="$(printf '%*s' "$LEAD" '')"
    local rule_e rule_d _i; rule_e=""; rule_d=""
    for ((_i=0;_i<W;_i++)); do rule_e+="═"; rule_d+="─"; done

    # Top decorative header box (centered)
    echo -e "${PAD}${C_BOLD}${C_PURPLE}╔${rule_e}╗${C_RESET}"
    echo -e "${PAD}  ${C_PURPLE}📋  MANAGED USERS${C_RESET}"
    echo -e "${PAD}${C_BOLD}${C_PURPLE}╚${rule_e}╝${C_RESET}"

    # Column headers row (absolute columns)
    printf '\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[K\n' \
        "$((LEAD+1))" "${C_BOLD}${C_WHITE}#${C_RESET}" \
        "$((LEAD+4))" "${C_DIM}│${C_RESET}" \
        "$((LEAD+6))" "${C_BOLD}${C_YELLOW}USERNAME${C_RESET}" \
        "$((LEAD+20))" "${C_DIM}│${C_RESET}" \
        "$((LEAD+22))" "${C_BOLD}${C_ORANGE}STATUS${C_RESET}" \
        "$((LEAD+33))" "${C_DIM}│${C_RESET}" \
        "$((LEAD+35))" "${C_BOLD}${C_GREEN}HWID${C_RESET}" \
        "$((LEAD+46))" "${C_DIM}│${C_RESET}" \
        "$((LEAD+48))" "${C_BOLD}${C_BLUE}BW CAP${C_RESET}" \
        "$((LEAD+55))" "${C_DIM}│${C_RESET}" \
        "$((LEAD+57))" "${C_BOLD}${C_CYAN}EXPIRES${C_RESET}"
    echo -e "${PAD}${C_CYAN}${rule_d}${C_RESET}"

    if [[ ! -s "$DB_FILE" ]]; then
        echo -e "\n${C_YELLOW}ℹ️ No users are currently being managed.${C_RESET}"
        return
    fi

    local current_ts
    printf -v current_ts '%(%s)T' -1
    local -A system_user_lookup=()
    local -A locked_user_lookup=()

    while IFS=: read -r system_user _rest; do
        [[ -n "$system_user" ]] && system_user_lookup["$system_user"]=1
    done < /etc/passwd

    if [[ -r /etc/shadow ]]; then
        while IFS=: read -r shadow_user shadow_hash _rest; do
            [[ -n "$shadow_user" && "${shadow_hash:0:1}" == "!" ]] && locked_user_lookup["$shadow_user"]=1
        done < /etc/shadow
    else
        while read -r passwd_user _ passwd_status _rest; do
            [[ -z "$passwd_user" ]] && continue
            [[ "$passwd_status" == "L" ]] && locked_user_lookup["$passwd_user"]=1
        done < <(passwd -Sa 2>/dev/null)
    fi
    refresh_ssh_session_cache

    local total_users=0 active_count=0 quota_exceeded=0 expired_count=0 locked_hwid=0 paused_count=0
    local idx=0 _trial_divider_shown=0

    while IFS=: read -r user pass expiry limit bandwidth_gb marker user_hwid strict app; do
        _own_visible "$user" || continue
        ((total_users++)); ((idx++))

        local online_count="${SSH_SESSION_COUNTS[$user]:-0}"
        local connection_string="$online_count / $limit"
        local plain_status="Active"
        local status="${C_GREEN}🟢 Active${C_RESET}"
        local _quota_hit=false

        [[ -z "$bandwidth_gb" ]] && bandwidth_gb="0"
        local bw_string; bw_string=$(_ff_quota_label "$bandwidth_gb")
        local quota_bytes; quota_bytes=$(_ff_quota_to_bytes "$bandwidth_gb")
        local used_bytes=0
        if (( quota_bytes > 0 )); then
            if [[ -f "$BANDWIDTH_DIR/${user}.usage" ]]; then
                read -r used_bytes < "$BANDWIDTH_DIR/${user}.usage" 2>/dev/null || used_bytes=0
                [[ "$used_bytes" =~ ^[0-9]+$ ]] || used_bytes=0
            fi
            local used_h
            used_h=$(awk "BEGIN {b=$used_bytes; if (b>=1073741824) printf \"%.1f GB\", b/1073741824; else if (b>=1048576) printf \"%.1f MB\", b/1048576; else printf \"%.0f KB\", b/1024}")
            bw_string="${used_h}/${bandwidth_gb}"
            if (( used_bytes >= quota_bytes )); then
                _quota_hit=true
            fi
        fi

        # BANDWIDTH dot: usage level (left, big circle) + cap (right, small dot).
        # Use U+25CF ● for the cap — it renders fully everywhere, unlike the
        # variable-selector ⦿ which some terminals clip. Level colour:
        # green <50%, yellow 50-79%, red >=80%, grey = unlimited.
        local bw_dot
        if (( quota_bytes <= 0 )); then
            bw_dot="${C_GRAY}⚪${C_RESET}${C_BLUE}●${C_RESET}"
        elif (( used_bytes * 10 >= quota_bytes * 8 )); then
            bw_dot="${C_RED}🔴${C_RESET}${C_BLUE}●${C_RESET}"
        elif (( used_bytes * 10 >= quota_bytes * 5 )); then
            bw_dot="${C_YELLOW}🟡${C_RESET}${C_BLUE}●${C_RESET}"
        else
            bw_dot="${C_GREEN}🟢${C_RESET}${C_BLUE}●${C_RESET}"
        fi

        # HWID Status (emoji + locked/unlocked text)
        if [[ -n "$user_hwid" ]]; then
            hwid_display="🔒 locked"
        else
            hwid_display="🔓 unlocked"
        fi

        # Pause Status
        local pause_display="--"
        if [ -n "$pass" ] && [ -f "$PAUSE_DB" ]; then
            pause_ts=$(grep "^${pass}|" "$PAUSE_DB" 2>/dev/null | cut -d'|' -f2)
            if [ -n "$pause_ts" ] && [ "$(date +%s)" -lt "$pause_ts" ]; then
                seconds=$((pause_ts - $(date +%s)))
                if [ $seconds -ge 3600 ]; then
                    pause_human="$((seconds / 3600))h $((seconds % 3600 / 60))m"
                else
                    pause_human="$((seconds / 60))m"
                fi
                pause_display="⏱ ${pause_human}"
            else
                pause_display="✅ Active"
            fi
        else
            pause_display="⏱ --"
        fi

        # Expires format (trial duration). Prefer the precise .ts epoch so
        # sub-day durations count down accurately (as the official panel does),
        # falling back to the stored calendar date when no timestamp exists.
        if [[ -z "$expiry" || "$expiry" == "Never" ]]; then
            expires_display="N/A"
        else
            local _precise_ts=0
            if [[ -f "$TRIAL_EXPIRY_DIR/${user}.ts" ]]; then
                read -r _precise_ts < "$TRIAL_EXPIRY_DIR/${user}.ts" 2>/dev/null || _precise_ts=0
            fi
            [[ "$_precise_ts" =~ ^[0-9]+$ ]] || _precise_ts=0
            if (( _precise_ts > 0 )); then
                if (( _precise_ts > current_ts )); then
                    expires_display=$(expiry_human $(( _precise_ts - current_ts )))
                else
                    expires_display="0d"
                fi
            elif [[ "$expiry" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                expiry_ts=$(date -d "$expiry 23:59:59" +%s 2>/dev/null || echo 0)
                if [[ "$expiry_ts" =~ ^[0-9]+$ ]] && (( expiry_ts > current_ts )); then
                    expires_display=$(expiry_human $(( expiry_ts - current_ts )))
                else
                    expires_display="0d"
                fi
            else
                # Already a duration string like "2d4h30m"
                expires_display="${expiry}"
            fi
        fi

        # Status coloring
        if [[ -z "${system_user_lookup[$user]+x}" ]]; then
            plain_status="Not Found"
            status="${C_RED}Not Found${C_RESET}"
            ((expired_count++))
        elif [[ -n "$expiry" && "$expiry" != "Never" ]]; then
            # Use the same effective epoch as the countdown (precise .ts wins),
            # so "Expired" and the EXPIRES column never disagree for sub-day trials.
            local _eff_ts=0
            if [[ -f "$TRIAL_EXPIRY_DIR/${user}.ts" ]]; then
                read -r _eff_ts < "$TRIAL_EXPIRY_DIR/${user}.ts" 2>/dev/null || _eff_ts=0
            fi
            [[ "$_eff_ts" =~ ^[0-9]+$ ]] && (( _eff_ts > 0 )) || _eff_ts=$(date -d "$expiry" +%s 2>/dev/null || echo 0)
            if [[ "$_eff_ts" =~ ^[0-9]+$ ]] && (( _eff_ts > 0 && _eff_ts < current_ts )); then
                plain_status="Expired"
                status="${C_RED}🗓️ Expired${C_RESET}"
                ((expired_count++))
            fi
        fi

        if [[ "$plain_status" == "Active" && "$_quota_hit" == true ]]; then
            if [[ -n "${locked_user_lookup[$user]+x}" ]]; then
                plain_status="BW Locked"
                status="${C_RED}🔒 BW Locked${C_RESET}"
            else
                plain_status="Quota Exceeded"
                status="${C_RED}📦 exce..${C_RESET}"
            fi
            ((quota_exceeded++))
        elif [[ "$plain_status" == "Active" && -n "${locked_user_lookup[$user]+x}" ]]; then
            plain_status="Locked"
            status="${C_YELLOW}🔒 Locked${C_RESET}"
        fi

        [[ "$plain_status" == "Active" ]] && ((active_count++))

        local line_color="$C_WHITE"
        case "$plain_status" in
            "Active") line_color="$C_GREEN" ;;
            "Locked") line_color="$C_YELLOW" ;;
            "Expired") line_color="$C_RED" ;;
            "BW Locked") line_color="$C_RED" ;;
            "Quota Exceeded") line_color="$C_RED" ;;
            "Not Found") line_color="$C_DIM" ;;
        esac

        # Trial accounts stand out: purple row so you can eyeball exactly where the
        # trial section begins (trials also sort to the bottom of the list).
        if [[ "$marker" == "trial" ]]; then
            line_color="$C_PURPLE"
            [[ "$plain_status" == "Active" ]] && status="${C_YELLOW}⏳ Active${C_RESET}"
            if [[ "$_trial_divider_shown" != "1" ]]; then
                _trial_divider_shown=1
                echo -e "${PAD}${C_PURPLE}${rule_d}${C_RESET}"
                echo -e "${PAD}  ${C_PURPLE}⏳ TRIAL ACCOUNTS${C_RESET} ${C_DIM}(auto-expiring)${C_RESET}"
                echo -e "${PAD}${C_PURPLE}${rule_d}${C_RESET}"
            fi
        fi

        printf '\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[%dG%s\033[K\n' \
                "$((LEAD+1))" "${line_color}${idx}${C_RESET}" \
                "$((LEAD+4))" "${C_DIM}│${C_RESET}" \
                "$((LEAD+6))" "${line_color}${user}${C_RESET}" \
                "$((LEAD+20))" "${C_DIM}│${C_RESET}" \
                "$((LEAD+22))" "${status}" \
                "$((LEAD+33))" "${C_DIM}│${C_RESET}" \
                "$((LEAD+35))" "${C_ORANGE}${hwid_display}${C_RESET}" \
                "$((LEAD+46))" "${C_DIM}│${C_RESET}" \
                "$((LEAD+48))" "${bw_dot}" \
                "$((LEAD+55))" "${C_DIM}│${C_RESET}" \
                "$((LEAD+57))" "${C_GREEN}${expires_display}${C_RESET}"
    done < <(LC_ALL=C sort -t: -k6,6 -k1,1 "$DB_FILE")

    # Footer stats — 2x2 summary grid
    echo -e "${PAD}${C_BOLD}${C_PURPLE}╔${rule_e}╗${C_RESET}"
    echo -e "${PAD}  ${C_BOLD}📊  SUMMARY${C_RESET}"
    printf "%s  %s        %s\n" "$PAD" "${C_WHITE}👥 Total: ${total_users}${C_RESET}" "${C_GREEN}🟢 Active: ${active_count}${C_RESET}"
    printf "%s  %s        %s\n" "$PAD" "${C_WHITE}📦 Quota: ${quota_exceeded}${C_RESET}" "${C_RED}🗓️ Expired: ${expired_count}${C_RESET}"
    echo -e "${PAD}${C_BOLD}${C_PURPLE}╚${rule_e}╝${C_RESET}"
    echo ""
}

renew_user() {
    _select_multi_user_interface "--- 🔄 Renew Users ---"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi
    read -p "👉 Enter duration to extend the account(s) (e.g. 30d, 7d, 2h, 2d4h30m): " duration_input
    local duration_secs; duration_secs=$(_ff_dur_to_seconds "$duration_input")
    if [[ "$duration_secs" -le 0 ]]; then echo -e "\n${C_RED}❌ Invalid duration. Use e.g. 30d, 7d, 2h.${C_RESET}"; return; fi
    local duration_display; duration_display=$(expiry_human_left "$duration_secs")
    local new_expire_date; new_expire_date=$(date -d "+${duration_secs} seconds" +%Y-%m-%d)
    [[ "$new_expire_date" == "$(date +%Y-%m-%d)" ]] && new_expire_date=$(date -d "tomorrow" +%Y-%m-%d)
    
    echo -e "\n${C_BLUE}🔄 Renewing selected users for $duration_input (${C_CYAN}$duration_display${C_BLUE})...${C_RESET}"
    for u in "${SELECTED_USERS[@]}"; do
        _own_guard "$u" || continue
        chage -E "$new_expire_date" "$u"
        local line pass _expiry limit bw marker hwid strict app
        line=$(grep "^$u:" "$DB_FILE")
        IFS=: read -r _ pass _expiry limit bw marker hwid strict app <<< "$line"
        [[ -z "$bw" ]] && bw="0"
        [[ -z "$strict" ]] && strict="0"
        [[ -z "$app" ]] && app="http"
        # Renewing promotes a trial to a normal dated account (marker cleared) and
        # rewrites the precise-expiry timestamp for the new duration.
        db_set_user "$u" "$pass" "$new_expire_date" "$limit" "$bw" "" "$hwid" "$strict" "$app"
        mkdir -p "$TRIAL_EXPIRY_DIR"
        printf '%s\n' "$(( $(date +%s) + duration_secs ))" > "$TRIAL_EXPIRY_DIR/${u}.ts"
        # Restore access immediately in case the account was auto-locked/blocked
        # for expiry before this renewal (SSH + UDP, incl. ZiVPN password).
        _ff_restore_user_all_protocols "$u"
        echo -e " ✅ ${C_YELLOW}$u${C_RESET} renewed until ${C_GREEN}${new_expire_date}${C_RESET}  (${C_CYAN}$duration_display${C_RESET})."
    done
    local _renewed="${SELECTED_USERS[*]}"
    _send_telegram "🔔 <b>User(s) Renewed</b>%0A👤 $_renewed%0A🗓️ New expiry: $new_expire_date"
}

cleanup_expired() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🧹 Cleanup Expired Users ---${C_RESET}"
    
    local expired_users=()
    local current_ts
    current_ts=$(date +%s)

    if [[ ! -s "$DB_FILE" ]]; then
        echo -e "\n${C_GREEN}✅ User database is empty. No expired users found.${C_RESET}"
        return
    fi
    
    while IFS=: read -r user pass expiry limit bandwidth_gb _extra; do
        _own_visible "$user" || continue
        local expiry_ts
        expiry_ts=$(date -d "$expiry" +%s 2>/dev/null || echo 0)
        
        if [[ $expiry_ts -lt $current_ts && $expiry_ts -ne 0 ]]; then
            expired_users+=("$user")
        fi
    done < "$DB_FILE"

    if [ ${#expired_users[@]} -eq 0 ]; then
        echo -e "\n${C_GREEN}✅ No expired users found.${C_RESET}"
        return
    fi

    echo -e "\nThe following users have expired: ${C_RED}${expired_users[*]}${C_RESET}"
    read -p "👉 Do you want to delete all of them? (y/n): " confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo -e "\n${C_BLUE}🗑️ Deleting expired users...${C_RESET}"
        delete_VPS_superScript_user_accounts "${expired_users[@]}"
        echo -e "\n${C_GREEN}✅ Expired users have been cleaned up.${C_RESET}"
    else
        echo -e "\n${C_YELLOW}❌ Cleanup cancelled.${C_RESET}"
    fi
}


backup_user_data() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 💾 Backup User Data ---${C_RESET}"
    if [ ! -d "$DB_DIR" ] || [ ! -s "$DB_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ No user data found to back up.${C_RESET}"
        return
    fi
    mkdir -p "$BACKUP_DIR"
    local auto_name="VPS_superScript_users_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
    local auto_path="$BACKUP_DIR/$auto_name"
    read -p "👉 Enter path or press Enter for auto-named backup [$auto_path]: " backup_path
    backup_path=${backup_path:-$auto_path}
    local parent_dir; parent_dir=$(dirname "$backup_path")
    mkdir -p "$parent_dir"
    echo -e "\n${C_BLUE}⚙️ Backing up user database and settings to ${C_YELLOW}$backup_path${C_RESET}..."
    tar -czf "$backup_path" -C "$(dirname "$DB_DIR")" "$(basename "$DB_DIR")"
    if [ $? -eq 0 ]; then
        echo -e "\n${C_GREEN}✅ SUCCESS: User data backup created at ${C_YELLOW}$backup_path${C_RESET}"
        echo -e "${C_DIM}   Size: $(du -h "$backup_path" | cut -f1)${C_RESET}"
    else
        echo -e "\n${C_RED}❌ ERROR: Backup failed.${C_RESET}"
    fi
}

restore_user_data() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📥 Restore User Data ---${C_RESET}"

    local -a backups=()
    local dir f
    for dir in "$BACKUP_DIR" /root; do
        [[ -d "$dir" ]] || continue
        while IFS= read -r f; do
            [[ -n "$f" ]] && backups+=("$f")
        done < <(find "$dir" -maxdepth 1 -name 'VPS_superScript_users*.tar.gz' -printf '%T@ %p\n' 2>/dev/null | sort -rn | cut -d' ' -f2-)
    done

    local backup_path=""
    if [[ ${#backups[@]} -gt 0 ]]; then
        echo -e "\n${C_DIM}Select a backup file or enter a custom path:${C_RESET}\n"
        local idx=0
        for f in "${backups[@]}"; do
            idx=$((idx + 1))
            local size; size=$(du -h "$f" 2>/dev/null | cut -f1)
            printf "     ${C_CHOICE}[%2s]${C_RESET}  %s  ${C_DIM}(%s)${C_RESET}\n" "$idx" "$f" "${size:-?}"
        done
        echo
        printf "     ${C_CHOICE}[ C]${C_RESET}  Enter custom path\n"
        printf "     ${C_WARN}[ 0]${C_RESET}  Cancel\n"
        echo
        read -p "$(echo -e ${C_PROMPT}"👉 Select option: "${C_RESET})" sel
        if [[ "$sel" == "0" ]]; then
            echo -e "\n${C_YELLOW}❌ Restore cancelled.${C_RESET}"; return
        fi
        if [[ "$sel" =~ ^[Cc]$ ]]; then
            read -p "👉 Enter the full path to the backup file: " backup_path
        elif [[ "$sel" =~ ^[0-9]+$ ]] && (( sel >= 1 && sel <= ${#backups[@]} )); then
            backup_path="${backups[$((sel - 1))]}"
        else
            echo -e "\n${C_RED}❌ Invalid selection.${C_RESET}"; return
        fi
    else
        echo -e "\n${C_YELLOW}ℹ️ No saved backups found.${C_RESET}"
        read -p "👉 Enter the full path to the backup file: " backup_path
    fi

    [[ -z "$backup_path" ]] && { echo -e "\n${C_YELLOW}❌ No file selected.${C_RESET}"; return; }
    if [ ! -f "$backup_path" ]; then
        echo -e "\n${C_RED}❌ ERROR: Backup file not found at '$backup_path'.${C_RESET}"
        return
    fi
    echo -e "\n${C_RED}${C_BOLD}⚠️ WARNING:${C_RESET} This will overwrite all current users and settings."
    echo -e "It will restore user accounts, passwords, limits, and expiration dates from the backup file."
    read -p "👉 Are you absolutely sure you want to proceed? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then echo -e "\n${C_YELLOW}❌ Restore cancelled.${C_RESET}"; return; fi
    local temp_dir
    temp_dir=$(mktemp -d)
    echo -e "\n${C_BLUE}⚙️ Extracting backup file to a temporary location...${C_RESET}"
    tar -xzf "$backup_path" -C "$temp_dir"
    if [ $? -ne 0 ]; then
        echo -e "\n${C_RED}❌ ERROR: Failed to extract backup file. Aborting.${C_RESET}"
        rm -rf "$temp_dir"
        return
    fi
    local restored_db_file="$temp_dir/VPS_superScript/users.db"
    if [ ! -f "$restored_db_file" ]; then
        echo -e "\n${C_RED}❌ ERROR: users.db not found in the backup. Cannot restore user accounts.${C_RESET}"
        rm -rf "$temp_dir"
        return
    fi
    echo -e "${C_BLUE}⚙️ Overwriting current user database...${C_RESET}"
    mkdir -p "$DB_DIR"
    cp "$restored_db_file" "$DB_FILE"
    if [ -d "$temp_dir/VPS_superScript/ssl" ]; then
        cp -r "$temp_dir/VPS_superScript/ssl" "$DB_DIR/"
    fi
    if [ -d "$temp_dir/VPS_superScript/dnstt" ]; then
        cp -r "$temp_dir/VPS_superScript/dnstt" "$DB_DIR/"
    fi
    if [ -f "$temp_dir/VPS_superScript/dnstt_info.conf" ]; then
        cp "$temp_dir/VPS_superScript/dnstt_info.conf" "$DB_DIR/"
    fi
    if [ -f "$temp_dir/VPS_superScript/falconproxy_config.conf" ]; then
        cp "$temp_dir/VPS_superScript/falconproxy_config.conf" "$DB_DIR/"
    fi
    
    echo -e "${C_BLUE}⚙️ Re-synchronizing system accounts with the restored database...${C_RESET}"
    ensure_VPS_superScript_system_group
    
    while IFS=: read -r user pass expiry limit bandwidth_gb marker hwid strict app; do
        [[ -z "$user" || "$user" == \#* ]] && continue
        echo "Processing user: ${C_YELLOW}$user${C_RESET}"
        if ! id "$user" &>/dev/null; then
            echo " - User does not exist in system. Creating..."
            useradd -m -s /usr/sbin/nologin "$user"
        fi
        usermod -aG "$FF_USERS_GROUP" "$user" 2>/dev/null
        echo " - Setting password..."
        if ! _ff_set_password "$user" "$pass"; then
            echo -e "${C_RED}   ⚠️ Could not set password for '$user' — set it later via Edit User.${C_RESET}"
        fi
        echo " - Setting expiration to $expiry..."
        chage -E "$expiry" "$user"
        [[ -z "$bandwidth_gb" ]] && bandwidth_gb="0"
        local bw_note; bw_note=$(_ff_quota_label "$bandwidth_gb")
        echo " - Connection limit ${limit:-1}, bandwidth ${bw_note} (enforced by the limiter service)"
    done < "$DB_FILE"

    # Sync all ZiVPN-app user passwords into the ZiVPN auth list.
    if [[ -f "$ZIVPN_CONFIG_FILE" ]] && command -v jq &>/dev/null; then
        local zivpn_reloaded=false
        while IFS=: read -r user pass _ _ _ _ _ _ app; do
            [[ -z "$user" || "$user" == \#* ]] && continue
            if [[ "$app" == "zivpn" ]] && _ff_zivpn_add_pass "$pass"; then
                zivpn_reloaded=true
            fi
        done < "$DB_FILE"
        if [[ "$zivpn_reloaded" == true ]]; then
            systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
        fi
    fi

    rm -rf "$temp_dir"
    # Rebuild the HWID mirror from the restored database.
    hwid_sync_allowed_db
    echo -e "\n${C_GREEN}✅ SUCCESS: User data restore completed.${C_RESET}"
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

_enable_banner_in_sshd_config() {
    echo -e "\n${C_BLUE}⚙️ Configuring sshd_config...${C_RESET}"
    disable_dynamic_ssh_banner_system
    sed -i.bak -E 's/^( *Banner *).*/#\1/' /etc/ssh/sshd_config
    if ! grep -q -E "^Banner $SSH_BANNER_FILE" /etc/ssh/sshd_config; then
        echo -e "\n# VPS_superScript SSH Banner\nBanner $SSH_BANNER_FILE" >> /etc/ssh/sshd_config
    fi
    echo -e "${C_GREEN}✅ sshd_config updated.${C_RESET}"
}

_restart_ssh() {
    echo -e "\n${C_BLUE}🔄 Restarting SSH service to apply changes...${C_RESET}"
    local ssh_service_name=""
    if [ -f /lib/systemd/system/sshd.service ]; then
        ssh_service_name="sshd.service"
    elif [ -f /lib/systemd/system/ssh.service ]; then
        ssh_service_name="ssh.service"
    else
        echo -e "${C_RED}❌ Could not find sshd.service or ssh.service. Cannot restart SSH.${C_RESET}"
        return 1
    fi

    systemctl restart "${ssh_service_name}"
    if [ $? -eq 0 ]; then
        echo -e "${C_GREEN}✅ SSH service ('${ssh_service_name}') restarted successfully.${C_RESET}"
    else
        echo -e "${C_RED}❌ Failed to restart SSH service ('${ssh_service_name}'). Please check 'journalctl -u ${ssh_service_name}' for errors.${C_RESET}"
    fi
}

set_ssh_banner_paste() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📋 Paste Static SSH Banner ---${C_RESET}"
    echo -e "Paste your custom banner below. Press ${C_YELLOW}[Ctrl+D]${C_RESET} when you are finished."
    echo -e "${C_DIM}This will be shown to all SSH users through 'Banner $SSH_BANNER_FILE'.${C_RESET}"
    echo -e "${C_DIM}The current banner (if any) will be overwritten.${C_RESET}"
    echo -e "--------------------------------------------------"
    cat > "$SSH_BANNER_FILE"
    chmod 644 "$SSH_BANNER_FILE"
    echo -e "\n--------------------------------------------------"
    echo -e "\n${C_GREEN}✅ Static banner content saved.${C_RESET}"
    _enable_banner_in_sshd_config
    _restart_ssh
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

view_ssh_banner() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 👁️ Current SSH Banner ---${C_RESET}"
    if [ -f "$SSH_BANNER_FILE" ]; then
        echo -e "\n${C_CYAN}--- BEGIN BANNER ---${C_RESET}"
        cat "$SSH_BANNER_FILE"
        echo -e "${C_CYAN}---- END BANNER ----${C_RESET}"
    else
        echo -e "\n${C_YELLOW}ℹ️ No banner file found at $SSH_BANNER_FILE.${C_RESET}"
    fi
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

remove_ssh_banner() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🗑️ Disable SSH Banners ---${C_RESET}"
    read -p "👉 Are you sure you want to disable all SSH banners? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        echo -e "\n${C_YELLOW}❌ Action cancelled.${C_RESET}"
        echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
        return
    fi
    if [ -f "$SSH_BANNER_FILE" ]; then
        rm -f "$SSH_BANNER_FILE"
        echo -e "\n${C_GREEN}✅ Removed banner file: $SSH_BANNER_FILE${C_RESET}"
    else
        echo -e "\n${C_YELLOW}ℹ️ No banner file to remove.${C_RESET}"
    fi
    disable_dynamic_ssh_banner_system
    echo -e "\n${C_BLUE}⚙️ Disabling banner in sshd_config...${C_RESET}"
    disable_static_ssh_banner_in_sshd_config
    echo -e "${C_GREEN}✅ Banner disabled in configuration.${C_RESET}"
    _restart_ssh
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

preview_dynamic_ssh_banner() {
    if ! is_dynamic_ssh_banner_enabled; then
        echo -e "\n${C_RED}❌ Dynamic banners are not enabled right now.${C_RESET}"
        press_enter
        return
    fi

    echo -e "${C_DIM}Refreshing dynamic banner worker...${C_RESET}"
    setup_limiter_service >/dev/null 2>&1
    _select_user_interface "--- 📝 Preview Dynamic Banner ---"
    local u=$SELECTED_USER
    if [[ -z "$u" || "$u" == "NO_USERS" ]]; then
        return
    fi

    echo -e "\n${C_CYAN}--- Dynamic Banner Preview for user '$u' ---${C_RESET}\n"
    if [[ -f "/etc/VPS_superScript/banners/${u}.txt" ]]; then
        cat "/etc/VPS_superScript/banners/${u}.txt"
    else
        echo -e "${C_RED}Banner file not generated yet. Waiting up to 10s for the worker...${C_RESET}"
        sleep 5
        if ! cat "/etc/VPS_superScript/banners/${u}.txt" 2>/dev/null; then
            echo -e "\n${C_RED}Still not generated. Here are the last limiter logs:${C_RESET}"
            echo -e "----------------------------------------------------------------------"
            journalctl -u VPS_superScript-limiter -n 15 --no-pager
            echo -e "----------------------------------------------------------------------"
        fi
    fi
    press_enter
}

install_udp_custom() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing udp-custom ---${C_RESET}"
    if [ -f "$UDP_CUSTOM_SERVICE_FILE" ] || [ -f "$UDPGW_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ udp-custom is already installed.${C_RESET}"
        ff_service_kick udpgw "udpgw backend"
        ff_service_kick udp-custom "udp-custom"
        return
    fi

    check_and_free_ports 36712 7800 || return
    check_and_open_firewall_port 36712 udp || return

    echo -e "\n${C_GREEN}⚙️ Creating directory for udp-custom...${C_RESET}"
    rm -rf "$UDP_CUSTOM_DIR"
    if ! mkdir -p "$UDP_CUSTOM_DIR"; then
        echo -e "\n${C_RED}❌ Could not create $UDP_CUSTOM_DIR.${C_RESET}"
        return
    fi

    echo -e "\n${C_GREEN}⚙️ Detecting system architecture...${C_RESET}"
    local arch
    arch=$(uname -m)
    local binary_url="" binary_asset=""
    if [[ "$arch" == "x86_64" ]]; then
        binary_asset="udp-custom-linux-amd64"
        echo -e "${C_BLUE}ℹ️ Detected x86_64 (amd64) architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        binary_asset="udp-custom-linux-arm"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Unsupported architecture: $arch. Cannot install udp-custom.${C_RESET}"
        rm -rf "$UDP_CUSTOM_DIR"
        return
    fi
    binary_url="$FF_RAW_BASE/udp/$binary_asset"

    echo -e "\n${C_GREEN}📥 Downloading udp-custom binary...${C_RESET}"
    if ! ff_fetch_binary "$UDP_CUSTOM_DIR/udp-custom" "$binary_url"; then
        # Fall back to a copy bundled alongside this script (offline / fork safety).
        local bundled="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/udp/$binary_asset"
        if [[ -s "$bundled" ]]; then
            echo -e "${C_YELLOW}ℹ️ Remote download failed; using bundled binary: $bundled${C_RESET}"
            if ! cp "$bundled" "$UDP_CUSTOM_DIR/udp-custom"; then
                echo -e "\n${C_RED}❌ Failed to copy the bundled udp-custom binary.${C_RESET}"
                rm -rf "$UDP_CUSTOM_DIR"
                return
            fi
        else
            echo -e "\n${C_RED}❌ Failed to download a valid udp-custom binary from:${C_RESET}"
            echo -e "   ${C_YELLOW}$binary_url${C_RESET}"
            rm -rf "$UDP_CUSTOM_DIR"
            return
        fi
    fi
    chmod +x "$UDP_CUSTOM_DIR/udp-custom"

    echo -e "\n${C_GREEN}📦 Setting up udpgw helper...${C_RESET}"
    if [[ "$arch" == "x86_64" ]]; then
        if ! ff_fetch_binary "$UDPGW_BINARY" "https://raw.githubusercontent.com/http-custom/udp-custom/main/module/udpgw"; then
            echo -e "\n${C_RED}❌ Failed to download a valid udpgw helper binary.${C_RESET}"
            rm -rf "$UDP_CUSTOM_DIR"
            return
        fi
        chmod +x "$UDPGW_BINARY"
    else
        echo -e "${C_YELLOW}ℹ️ Architecture is $arch. Compiling udpgw from source (this may take a minute)...${C_RESET}"
        ff_pkg_install cmake g++ make git >/dev/null 2>&1
        local temp_build="/tmp/badvpn_build"
        rm -rf "$temp_build"
        # Check the clone: without this a network failure fell through to the
        # build and the user was told "failed to compile" instead of the truth.
        if ! git clone -q --depth 1 https://github.com/ambrop72/badvpn.git "$temp_build"; then
            echo -e "\n${C_RED}❌ Failed to clone the badvpn source for the udpgw helper.${C_RESET}"
            echo -e "${C_YELLOW}ℹ️ Check network/DNS, then try again.${C_RESET}"
            rm -rf "$UDP_CUSTOM_DIR" "$temp_build"
            return
        fi
        # Same CMake 4 incompatibility as install_badvpn: badvpn's
        # cmake_minimum_required is older than CMake 4 accepts, so fall back to
        # the policy-minimum override before treating it as a build failure.
        ( cd "$temp_build" && cmake . >/dev/null 2>&1 ) \
            || ( cd "$temp_build" && cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 . >/dev/null 2>&1 )
        ( cd "$temp_build" && make >/dev/null 2>&1 )
        local compiled_bin=$(find "$temp_build" -name "badvpn-udpgw" -type f | head -n 1)
        if [[ -n "$compiled_bin" && -f "$compiled_bin" ]]; then
            # A silent cp failure here would leave the unit's ExecStart pointing
            # at a binary that does not exist, so the install "succeeds" and the
            # service dies at start.
            if ! cp "$compiled_bin" "$UDPGW_BINARY"; then
                echo -e "\n${C_RED}❌ Failed to install the compiled udpgw binary.${C_RESET}"
                rm -rf "$UDP_CUSTOM_DIR" "$temp_build"
                return
            fi
            chmod +x "$UDPGW_BINARY"
        else
            echo -e "\n${C_RED}❌ Failed to compile udpgw helper for $arch.${C_RESET}"
            rm -rf "$UDP_CUSTOM_DIR" "$temp_build"
            return
        fi
        rm -rf "$temp_build"
    fi

    echo -e "\n${C_GREEN}📝 Creating default config.json...${C_RESET}"
    cat > "$UDP_CUSTOM_DIR/config.json" <<EOF
{
  "listen": ":36712",
  "stream_buffer": 33554432,
  "receive_buffer": 83886080,
  "auth": {
    "mode": "passwords"
  }
}
EOF
    chmod 644 "$UDP_CUSTOM_DIR/config.json"

    echo -e "\n${C_GREEN}📝 Creating udpgw systemd service file...${C_RESET}"
    cat > "$UDPGW_SERVICE_FILE" <<EOF
[Unit]
Description=VPS_superScript UDPGW Backend
After=network.target

[Service]
User=root
Type=simple
ExecStart=$UDPGW_BINARY --listen-addr 127.0.0.1:7800 --max-clients 1000 --max-connections-for-client 100
Restart=always
RestartSec=2s

[Install]
WantedBy=multi-user.target
EOF

    echo -e "\n${C_GREEN}📝 Creating systemd service file...${C_RESET}"
    # Write default exclude list if not already present
    local _excl_file="$DB_DIR/udp_custom_exclude.conf"
    if [[ ! -f "$_excl_file" ]]; then
        printf '%s' "$UDP_CUSTOM_EXCLUDE_DEFAULT" > "$_excl_file"
    fi
    local _exclude_ports; _exclude_ports=$(cat "$_excl_file" 2>/dev/null)
    [[ -n "$_exclude_ports" ]] && _exclude_ports="-exclude $_exclude_ports"
    cat > "$UDP_CUSTOM_SERVICE_FILE" <<EOF
[Unit]
Description=UDP Custom by VPS_superScript
After=network.target

[Service]
User=root
Type=simple
ExecStart=$UDP_CUSTOM_DIR/udp-custom server $_exclude_ports
WorkingDirectory=$UDP_CUSTOM_DIR/
Restart=always
# Near-instant restart so a lock-triggered restart drops a user's live UDP
# session with a sub-second outage for other connected clients.
RestartSec=100ms

[Install]
WantedBy=multi-user.target
EOF

    echo -e "\n${C_GREEN}▶️ Enabling and starting udp-custom service...${C_RESET}"
    # Delegate to the verified helper chain: enable + restart + is-active check,
    # instead of two bare `start` calls whose failure was only inspected after.
    local _udp_ok=true
    ff_service_up udpgw.service "udpgw backend" 2 || _udp_ok=false
    ff_service_up udp-custom.service "udp-custom" 2 || _udp_ok=false
    if $_udp_ok; then
        echo -e "\n${C_GREEN}✅ SUCCESS: udp-custom is installed and active.${C_RESET}"
    fi
}

uninstall_udp_custom() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling udp-custom ---${C_RESET}"
    if [ ! -f "$UDP_CUSTOM_SERVICE_FILE" ] && [ ! -f "$UDPGW_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ udp-custom is not installed, skipping.${C_RESET}"
        return
    fi
    echo -e "${C_GREEN}🛑 Stopping and disabling udpgw service...${C_RESET}"
    systemctl stop udpgw.service >/dev/null 2>&1
    systemctl disable udpgw.service >/dev/null 2>&1
    echo -e "${C_GREEN}🛑 Stopping and disabling udp-custom service...${C_RESET}"
    systemctl stop udp-custom.service >/dev/null 2>&1
    systemctl disable udp-custom.service >/dev/null 2>&1
    echo -e "${C_GREEN}🗑️ Removing systemd service file...${C_RESET}"
    rm -f "$UDP_CUSTOM_SERVICE_FILE"
    rm -f "$UDPGW_SERVICE_FILE"
    systemctl daemon-reload
    echo -e "${C_GREEN}🗑️ Removing udp-custom directory and files...${C_RESET}"
    rm -rf "$UDP_CUSTOM_DIR"
    rm -f "$UDPGW_BINARY"
    echo -e "${C_GREEN}✅ udp-custom has been uninstalled successfully.${C_RESET}"
}

# Rewrite the udp-custom service file with the current exclude list, then
# daemon-reload and restart so the change takes effect immediately.
_reload_udp_custom_service() {
    local _excl_file="$DB_DIR/udp_custom_exclude.conf"
    local _exclude_ports; _exclude_ports=$(cat "$_excl_file" 2>/dev/null)
    [[ -n "$_exclude_ports" ]] && _exclude_ports="-exclude $_exclude_ports"

    local _tmp; _tmp=$(mktemp) || return 1
    awk -v excl="$_exclude_ports" '
        /^ExecStart=/ {
            print "ExecStart='"$UDP_CUSTOM_DIR"'/udp-custom server " excl
            next
        }
        { print }
    ' "$UDP_CUSTOM_SERVICE_FILE" > "$_tmp" && mv "$_tmp" "$UDP_CUSTOM_SERVICE_FILE"

    systemctl daemon-reload
    systemctl restart udp-custom.service 2>/dev/null
    echo -e "${C_GREEN}✅ udp-custom service reloaded with exclusions: ${_exclude_ports:-"(none)"}${C_RESET}"
}

# View and edit which ports udp-custom excludes from tunnelling.
manage_udp_custom_exclude() {
    local _excl_file="$DB_DIR/udp_custom_exclude.conf"
    if [[ ! -f "$UDP_CUSTOM_SERVICE_FILE" ]]; then
        echo -e "\n${C_YELLOW}⚠️ udp-custom is not installed. Install it first.${C_RESET}"
        return
    fi
    while true; do
        local current; current=$(cat "$_excl_file" 2>/dev/null)
        clear
        echo -e "\n   ${C_TITLE}════════════[ ${C_BOLD}🚀 UDP-CUSTOM EXCLUDE PORTS ${C_RESET}${C_TITLE}]════════════${C_RESET}"
        echo -e "\n   ${C_DIM}Ports in this list are NOT tunnelled — they reach the server directly.${C_RESET}"
        echo -e "   ${C_DIM}Remove 53 here to let DNS queries flow through the tunnel.${C_RESET}"
        echo -e "   ${C_DIM}Add 53 back when running DNSTT so it can claim port 53.${C_RESET}"
        echo -e "\n   ${C_BOLD}Current excludes:${C_RESET} ${C_YELLOW}${current:-"(none)"}${C_RESET}"
        echo
        printf "     ${C_CHOICE}[1]${C_RESET} %-35s\n" "➕ Add port to exclude"
        printf "     ${C_CHOICE}[2]${C_RESET} %-35s\n" "🗑️ Remove port from exclude"
        printf "     ${C_CHOICE}[3]${C_RESET} %-35s\n" "🔄 Reset to defaults ($UDP_CUSTOM_EXCLUDE_DEFAULT)"
        printf "     ${C_CHOICE}[4]${C_RESET} %-35s\n" "⚡ Apply & Reload udp-custom"
        echo -e "   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[0]${C_RESET} ↩️ Return"
        echo
        read -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice

        case $choice in
            1)
                read -p "👉 Port to exclude (e.g. 53): " _port
                [[ -z "$_port" || ! "$_port" =~ ^[0-9]+$ ]] && { echo -e "${C_RED}❌ Invalid.${C_RESET}"; sleep 1; continue; }
                if grep -qw "$_port" "$_excl_file" 2>/dev/null; then
                    echo -e "${C_YELLOW}⚠️ Port $_port is already excluded.${C_RESET}"; sleep 1; continue
                fi
                if [[ -n "$current" ]]; then
                    printf '%s,%s' "$current" "$_port" > "$_excl_file"
                else
                    printf '%s' "$_port" > "$_excl_file"
                fi
                echo -e "${C_GREEN}✅ Port $_port added to exclude list.${C_RESET}"
                echo -e "${C_DIM}Use option 4 to apply changes.${C_RESET}"
                press_enter
                ;;
            2)
                if [[ -z "$current" ]]; then
                    echo -e "${C_YELLOW}⚠️ No ports to remove.${C_RESET}"; sleep 1; continue
                fi
                IFS=',' read -r -a _ports <<< "$current"
                echo -e "\n${C_BOLD}Select port to remove:${C_RESET}\n"
                for i in "${!_ports[@]}"; do
                    printf "  ${C_CHOICE}[%2s]${C_RESET}  %s\n" "$((i+1))" "${_ports[$i]}"
                done
                echo -e "\n  ${C_WARN}[0]${C_RESET} Cancel"
                read -p "👉 Choice: " _idx
                [[ "$_idx" == "0" ]] && continue
                [[ ! "$_idx" =~ ^[0-9]+$ || "$_idx" -lt 1 || "$_idx" -gt "${#_ports[@]}" ]] && { echo -e "${C_RED}❌ Invalid.${C_RESET}"; sleep 1; continue; }
                unset "_ports[$((_idx-1))]"
                IFS=',' _new="${_ports[*]}"; unset IFS
                printf '%s' "$_new" > "$_excl_file"
                echo -e "\n${C_GREEN}✅ Port removed.${C_RESET}"
                echo -e "${C_DIM}Use option 4 to apply changes.${C_RESET}"
                press_enter
                ;;
            3)
                printf '%s' "$UDP_CUSTOM_EXCLUDE_DEFAULT" > "$_excl_file"
                echo -e "\n${C_GREEN}✅ Excludes reset to: $UDP_CUSTOM_EXCLUDE_DEFAULT${C_RESET}"
                echo -e "${C_DIM}Use option 4 to apply changes.${C_RESET}"
                press_enter
                ;;
            4)
                _reload_udp_custom_service
                press_enter
                ;;
            0) return ;;
            *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}"; sleep 1 ;;
        esac
    done
}

ensure_badvpn_service_is_quiet() {
    if [[ ! -f "$BADVPN_SERVICE_FILE" ]] || grep -q "^StandardOutput=null$" "$BADVPN_SERVICE_FILE" 2>/dev/null; then
        return
    fi

    local tmp_service
    tmp_service=$(mktemp)
    awk '
        /^\[Service\]$/ {
            print
            print "StandardOutput=null"
            print "StandardError=null"
            next
        }
        { print }
    ' "$BADVPN_SERVICE_FILE" > "$tmp_service" && mv "$tmp_service" "$BADVPN_SERVICE_FILE"
    rm -f "$tmp_service" 2>/dev/null
    systemctl daemon-reload
    systemctl restart badvpn.service >/dev/null 2>&1 || true
}

install_badvpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing badvpn (udpgw) ---${C_RESET}"
    if [ -f "$BADVPN_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ badvpn is already installed.${C_RESET}"
        ff_service_kick badvpn "badvpn"
        return
    fi
    check_and_open_firewall_port 7300 udp || return

    local badvpn_binary=""
    # Prefer the prebuilt binary. badvpn-udpgw and the udpgw helper that
    # install_udp_custom fetches are the same program — only the --listen-addr
    # differs — so on x86_64 there is no reason to compile at all. Upstream
    # (ambrop72/badvpn) has been archived since Aug 2021 and its CMakeLists
    # predates CMake 4, so the source build now needs a policy override and
    # will keep rotting. Compiling stays as the fallback for other arches.
    local arch; arch=$(uname -m 2>/dev/null || echo "unknown")
    if [[ "$arch" == "x86_64" ]]; then
        echo -e "\n${C_GREEN}📥 Fetching prebuilt udpgw binary...${C_RESET}"
        # Deliberately a separate path from $UDPGW_BINARY: uninstall_udp_custom
        # does `rm -f "$UDPGW_BINARY"`, so sharing one file would let removing
        # udp-custom silently break the badvpn service the user never touched.
        if ff_fetch_binary "$BADVPN_BINARY" "https://raw.githubusercontent.com/http-custom/udp-custom/main/module/udpgw"; then
            chmod +x "$BADVPN_BINARY"
            badvpn_binary="$BADVPN_BINARY"
            echo -e "${C_GREEN}✅ Using prebuilt binary — no compilation needed.${C_RESET}"
        else
            echo -e "${C_YELLOW}⚠️ Prebuilt download failed; falling back to building from source.${C_RESET}"
        fi
    fi

    if [[ -z "$badvpn_binary" ]]; then
    echo -e "\n${C_GREEN}🔄 Updating package lists...${C_RESET}"
    ff_apt_update || return
    echo -e "\n${C_GREEN}📦 Installing all required packages...${C_RESET}"
    ff_pkg_install cmake g++ make screen git build-essential libssl-dev libnspr4-dev libnss3-dev pkg-config || {
        echo -e "${C_RED}❌ Failed to install badvpn build dependencies.${C_RESET}"
        return
    }
    echo -e "\n${C_GREEN}📥 Cloning badvpn from github...${C_RESET}"
    # Start from a directory we know exists. If a previous run left this shell
    # parked inside a build dir that was later deleted, git refuses to run at
    # all ("Unable to read current working directory") and every later step
    # fails for reasons that look unrelated.
    cd / 2>/dev/null || true
    rm -rf "$BADVPN_BUILD_DIR"
    if ! git clone --depth 1 https://github.com/ambrop72/badvpn.git "$BADVPN_BUILD_DIR"; then
        echo -e "${C_RED}❌ Failed to clone the badvpn source.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Check network/DNS, then try again.${C_RESET}"
        rm -rf "$BADVPN_BUILD_DIR"
        return
    fi
    [[ -d "$BADVPN_BUILD_DIR" ]] || { echo -e "${C_RED}❌ Build folder missing after clone.${C_RESET}"; return; }
    # Build inside a subshell so the menu's own working directory never moves
    # into a tree we are about to delete on failure.
    echo -e "\n${C_GREEN}⚙️ Running CMake...${C_RESET}"
    # badvpn's CMakeLists declares a cmake_minimum_required older than CMake 4
    # will accept ("Compatibility with CMake < 3.5 has been removed"), so on
    # Ubuntu 25.10+/26.04 the bare `cmake .` fails. Retry with the documented
    # escape hatch before giving up.
    ( cd "$BADVPN_BUILD_DIR" && cmake . ) \
        || ( cd "$BADVPN_BUILD_DIR" && cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 . ) \
        || { echo -e "${C_RED}❌ CMake configuration failed.${C_RESET}"; rm -rf "$BADVPN_BUILD_DIR"; return; }
    echo -e "\n${C_GREEN}🛠️ Compiling source...${C_RESET}"
    ( cd "$BADVPN_BUILD_DIR" && make ) || {
        echo -e "${C_RED}❌ Compilation (make) failed.${C_RESET}"; rm -rf "$BADVPN_BUILD_DIR"; return; }
    badvpn_binary=$(find "$BADVPN_BUILD_DIR" -name "badvpn-udpgw" -type f | head -n 1)
    if [[ -z "$badvpn_binary" || ! -f "$badvpn_binary" ]]; then
        echo -e "${C_RED}❌ ERROR: Could not find the compiled 'badvpn-udpgw' binary after compilation.${C_RESET}"
        rm -rf "$BADVPN_BUILD_DIR"
        return
    fi
    echo -e "${C_GREEN}ℹ️ Found binary at: $badvpn_binary${C_RESET}"
    chmod +x "$badvpn_binary"
    fi   # end source-build fallback

    echo -e "\n${C_GREEN}📝 Creating systemd service file...${C_RESET}"
    cat > "$BADVPN_SERVICE_FILE" <<-EOF
[Unit]
Description=BadVPN UDP Gateway
After=network.target
[Service]
ExecStart=$badvpn_binary --listen-addr 0.0.0.0:7300 --max-clients 1000 --max-connections-for-client 8
User=root
Restart=always
RestartSec=3
StandardOutput=null
StandardError=null
[Install]
WantedBy=multi-user.target
EOF
    echo -e "\n${C_GREEN}▶️ Enabling and starting badvpn service...${C_RESET}"
    if ff_service_up badvpn "badvpn (udpgw)" 2; then
        echo -e "\n${C_GREEN}✅ SUCCESS: badvpn (udpgw) is installed and active on port 7300.${C_RESET}"
    fi
}

uninstall_badvpn() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling badvpn (udpgw) ---${C_RESET}"
    if [ ! -f "$BADVPN_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ badvpn is not installed, skipping.${C_RESET}"
        return
    fi
    echo -e "${C_GREEN}🛑 Stopping and disabling badvpn service...${C_RESET}"
    systemctl stop badvpn.service >/dev/null 2>&1
    systemctl disable badvpn.service >/dev/null 2>&1
    echo -e "${C_GREEN}🗑️ Removing systemd service file...${C_RESET}"
    rm -f "$BADVPN_SERVICE_FILE"
    systemctl daemon-reload
    echo -e "${C_GREEN}🗑️ Removing badvpn binary and build directory...${C_RESET}"
    rm -f "$BADVPN_BINARY"
    rm -rf "$BADVPN_BUILD_DIR"
    echo -e "${C_GREEN}✅ badvpn has been uninstalled successfully.${C_RESET}"
}

load_edge_cert_info() {
    EDGE_CERT_MODE=""
    EDGE_DOMAIN=""
    EDGE_EMAIL=""
    if [ -f "$EDGE_CERT_INFO_FILE" ]; then
        source "$EDGE_CERT_INFO_FILE"
    fi
}

save_edge_cert_info() {
    local cert_mode="$1"
    local cert_domain="$2"
    local cert_email="$3"
    mkdir -p "$DB_DIR"
    cat > "$EDGE_CERT_INFO_FILE" <<EOF
EDGE_CERT_MODE="$cert_mode"
EDGE_DOMAIN="$cert_domain"
EDGE_EMAIL="$cert_email"
EOF
}

detect_preferred_host() {
    local host_domain=""
    load_edge_cert_info
    if [[ -n "$EDGE_DOMAIN" ]]; then
        host_domain="$EDGE_DOMAIN"
    fi
    if [[ -z "$host_domain" && -f "$NGINX_CONFIG_FILE" ]]; then
        local nginx_domain
        nginx_domain=$(grep -oP 'server_name \K[^\s;]+' "$NGINX_CONFIG_FILE" 2>/dev/null | head -n 1)
        if [[ "$nginx_domain" != "_" && -n "$nginx_domain" ]]; then
            host_domain="$nginx_domain"
        fi
    fi
    if [[ -z "$host_domain" ]]; then
        host_domain=$(curl -s -4 icanhazip.com)
    fi
    echo "$host_domain"
}

backup_edge_configs() {
    if [ -f "$NGINX_CONFIG_FILE" ] && [ ! -f "${NGINX_CONFIG_FILE}.bak.VPS_superScript" ]; then
        cp "$NGINX_CONFIG_FILE" "${NGINX_CONFIG_FILE}.bak.VPS_superScript" 2>/dev/null
    fi
}

ensure_edge_stack_packages() {
    local missing_packages=()
    if ! command -v nginx &> /dev/null || [ ! -f "/etc/nginx/nginx.conf" ]; then
        missing_packages+=("nginx")
    fi
    command -v openssl &> /dev/null || missing_packages+=("openssl")

    if (( ${#missing_packages[@]} > 0 )); then
        echo -e "\n${C_BLUE}📦 Installing required packages: ${missing_packages[*]}${C_RESET}"
        if ! ff_pkg_install "${missing_packages[@]}"; then
            echo -e "${C_YELLOW}⚠️ Package installation failed. Attempting to fix broken configurations...${C_RESET}"
            if command -v apt-get &>/dev/null; then
                apt-get purge -y nginx nginx-common >/dev/null 2>&1
            fi
            if ! ff_pkg_install "${missing_packages[@]}"; then
                echo -e "${C_RED}❌ Failed to install the required packages.${C_RESET}"
                return 1
            fi
        fi
    fi
    return 0
}

build_shared_tls_bundle() {
    if [ ! -s "$SSL_CERT_CHAIN_FILE" ] || [ ! -s "$SSL_CERT_KEY_FILE" ]; then
        echo -e "${C_RED}❌ Certificate chain or key is missing.${C_RESET}"
        return 1
    fi
    cat "$SSL_CERT_CHAIN_FILE" "$SSL_CERT_KEY_FILE" > "$SSL_CERT_FILE" || return 1
    chmod 644 "$SSL_CERT_CHAIN_FILE"
    chmod 600 "$SSL_CERT_KEY_FILE" "$SSL_CERT_FILE"
    return 0
}

generate_self_signed_edge_cert() {
    local common_name="$1"
    mkdir -p "$SSL_CERT_DIR"
    echo -e "\n${C_GREEN}🔐 Generating a shared self-signed certificate...${C_RESET}"
    openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout "$SSL_CERT_KEY_FILE" \
        -out "$SSL_CERT_CHAIN_FILE" \
        -subj "/CN=$common_name" \
        >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to generate the self-signed certificate.${C_RESET}"
            return 1
        }
    build_shared_tls_bundle || return 1
    save_edge_cert_info "self-signed" "$common_name" ""
    echo -e "${C_GREEN}✅ Shared certificate created for ${C_YELLOW}$common_name${C_RESET}"
    return 0
}

_install_certbot() {
    if command -v certbot &> /dev/null; then
        echo -e "${C_GREEN}✅ Certbot is already installed.${C_RESET}"
        return 0
    fi
    echo -e "${C_BLUE}📦 Installing Certbot...${C_RESET}"
    ff_pkg_install certbot || {
        echo -e "${C_RED}❌ Failed to install Certbot.${C_RESET}"
        return 1
    }
    echo -e "${C_GREEN}✅ Certbot installed successfully.${C_RESET}"
    return 0
}

obtain_certbot_edge_cert() {
    local domain_name="$1"
    local email="$2"

    mkdir -p "$SSL_CERT_DIR"
    _install_certbot || return 1

    if systemctl is-active --quiet nginx; then restart_nginx=1; fi

    echo -e "\n${C_BLUE}🛑 Stopping Nginx for Certbot validation...${C_RESET}"
    systemctl stop nginx >/dev/null 2>&1
    sleep 2

    check_and_free_ports "$EDGE_PUBLIC_HTTP_PORT" "$EDGE_PUBLIC_TLS_PORT" || {
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        return 1
    }

    echo -e "\n${C_BLUE}🚀 Requesting a Certbot certificate for ${C_YELLOW}$domain_name${C_RESET}"
    certbot certonly --standalone -d "$domain_name" --non-interactive --agree-tos -m "$email"
    if [ $? -ne 0 ]; then
        echo -e "\n${C_RED}❌ Certbot failed to obtain a certificate.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Make sure the domain points to this server and port 80 is reachable.${C_RESET}"
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        return 1
    fi

    local certbot_chain="/etc/letsencrypt/live/$domain_name/fullchain.pem"
    local certbot_key="/etc/letsencrypt/live/$domain_name/privkey.pem"
    if [ ! -f "$certbot_chain" ] || [ ! -f "$certbot_key" ]; then
        echo -e "\n${C_RED}❌ Certbot completed, but the certificate files were not found.${C_RESET}"
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        return 1
    fi

    cp "$certbot_chain" "$SSL_CERT_CHAIN_FILE"
    cp "$certbot_key" "$SSL_CERT_KEY_FILE"
    build_shared_tls_bundle || {
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        return 1
    }
    save_edge_cert_info "certbot" "$domain_name" "$email"
    echo -e "${C_GREEN}✅ Certbot certificate copied into ${C_YELLOW}$SSL_CERT_DIR${C_RESET}"
    return 0
}

select_edge_certificate() {
    local preferred_host
    local cert_choice
    local has_existing_cert=false

    preferred_host=$(detect_preferred_host)
    if [[ -z "$preferred_host" ]]; then
        preferred_host="VPS_superScript.local"
    fi

    if [ -s "$SSL_CERT_FILE" ] && [ -s "$SSL_CERT_CHAIN_FILE" ] && [ -s "$SSL_CERT_KEY_FILE" ]; then
        has_existing_cert=true
    fi

    load_edge_cert_info

    echo -e "\n${C_BOLD}${C_PURPLE}--- 🔐 Shared TLS Certificate ---${C_RESET}"
    echo -e "${C_DIM}The same certificate will be used by the internal Nginx proxy and the services behind it.${C_RESET}"

    if $has_existing_cert; then
        local existing_label="${EDGE_CERT_MODE:-existing}"
        if [[ -n "$EDGE_DOMAIN" ]]; then
            existing_label="$existing_label - $EDGE_DOMAIN"
        fi
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-52s\n" "Reuse existing certificate (${existing_label})"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-52s\n" "Replace with a new self-signed certificate"
        printf "  ${C_CHOICE}[ 3]${C_RESET} %-52s\n" "Replace with a Certbot certificate"
        echo
        read -p "👉 Enter choice [1]: " cert_choice
        cert_choice=${cert_choice:-1}
    else
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-52s\n" "Generate a self-signed certificate"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-52s\n" "Use a Certbot certificate"
        echo
        read -p "👉 Enter choice [1]: " cert_choice
        cert_choice=${cert_choice:-1}
    fi

    case "$cert_choice" in
        1)
            if $has_existing_cert; then
                echo -e "${C_GREEN}✅ Reusing the existing shared certificate.${C_RESET}"
                return 0
            fi
            local common_name
            read -p "👉 Enter the certificate Common Name / SNI label [$preferred_host]: " common_name
            common_name=${common_name:-$preferred_host}
            generate_self_signed_edge_cert "$common_name"
            ;;
        2)
            if $has_existing_cert; then
                local common_name
                read -p "👉 Enter the certificate Common Name / SNI label [$preferred_host]: " common_name
                common_name=${common_name:-$preferred_host}
                generate_self_signed_edge_cert "$common_name"
            else
                local default_domain=""
                local domain_name
                local email
                if ! _is_valid_ipv4 "$preferred_host"; then
                    default_domain="$preferred_host"
                fi
                if [[ -n "$default_domain" ]]; then
                    read -p "👉 Enter your domain name [$default_domain]: " domain_name
                    domain_name=${domain_name:-$default_domain}
                else
                    read -p "👉 Enter your domain name (e.g. vpn.example.com): " domain_name
                fi
                if [[ -z "$domain_name" ]]; then
                    echo -e "${C_RED}❌ Domain name cannot be empty.${C_RESET}"
                    return 1
                fi
                if _is_valid_ipv4 "$domain_name"; then
                    echo -e "${C_RED}❌ Certbot requires a real domain name, not a raw IP address.${C_RESET}"
                    return 1
                fi
                read -p "👉 Enter your email for Let's Encrypt: " email
                if [[ -z "$email" ]]; then
                    echo -e "${C_RED}❌ Email cannot be empty.${C_RESET}"
                    return 1
                fi
                obtain_certbot_edge_cert "$domain_name" "$email"
            fi
            ;;
        3)
            if ! $has_existing_cert; then
                echo -e "${C_RED}❌ Invalid option.${C_RESET}"
                return 1
            fi
            local default_domain=""
            local domain_name
            local email
            if [[ -n "$EDGE_DOMAIN" ]] && ! _is_valid_ipv4 "$EDGE_DOMAIN"; then
                default_domain="$EDGE_DOMAIN"
            fi
            if [[ -z "$default_domain" ]] && ! _is_valid_ipv4 "$preferred_host"; then
                default_domain="$preferred_host"
            fi
            if [[ -n "$default_domain" ]]; then
                read -p "👉 Enter your domain name [$default_domain]: " domain_name
                domain_name=${domain_name:-$default_domain}
            else
                read -p "👉 Enter your domain name (e.g. vpn.example.com): " domain_name
            fi
            if [[ -z "$domain_name" ]]; then
                echo -e "${C_RED}❌ Domain name cannot be empty.${C_RESET}"
                return 1
            fi
            if _is_valid_ipv4 "$domain_name"; then
                echo -e "${C_RED}❌ Certbot requires a real domain name, not a raw IP address.${C_RESET}"
                return 1
            fi
            read -p "👉 Enter your email for Let's Encrypt [${EDGE_EMAIL}]: " email
            email=${email:-$EDGE_EMAIL}
            if [[ -z "$email" ]]; then
                echo -e "${C_RED}❌ Email cannot be empty.${C_RESET}"
                return 1
            fi
            obtain_certbot_edge_cert "$domain_name" "$email"
            ;;
        *)
            echo -e "${C_RED}❌ Invalid option.${C_RESET}"
            return 1
            ;;
    esac
}

write_internal_nginx_config() {
    local server_name="$1"
    [[ -z "$server_name" ]] && server_name="_"
    mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
    cat > "$NGINX_CONFIG_FILE" <<EOF
server {
    listen 127.0.0.1:${NGINX_INTERNAL_HTTP_PORT} default_server;
    listen 127.0.0.1:${NGINX_INTERNAL_TLS_PORT} ssl http2 default_server;
    server_tokens off;
    server_name ${server_name};

    ssl_certificate ${SSL_CERT_CHAIN_FILE};
    ssl_certificate_key ${SSL_CERT_KEY_FILE};
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!eNULL:!MD5:!DES:!RC4:!ADH:!SSLv3:!EXP:!PSK:!DSS;
    resolver 1.1.1.1 8.8.8.8 ipv6=off valid=300s;

    location ~ ^/(?<fwdport>\d+)/(?<fwdpath>.*)$ {
        client_max_body_size 0;
        client_body_timeout 1d;
        grpc_read_timeout 1d;
        grpc_socket_keepalive on;
        proxy_read_timeout 1d;
        proxy_http_version 1.1;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_socket_keepalive on;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        if (\$content_type ~* "GRPC") { grpc_pass grpc://127.0.0.1:\$fwdport\$is_args\$args; break; }
        proxy_pass http://127.0.0.1:\$fwdport\$is_args\$args;
        break;
    }

    location / {
        proxy_read_timeout 3600s;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_socket_keepalive on;
        tcp_nodelay on;
        tcp_nopush off;
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
    ln -sf "$NGINX_CONFIG_FILE" /etc/nginx/sites-enabled/default
}

save_edge_ports_info() {
    cat > "$NGINX_PORTS_FILE" <<EOF
EDGE_HTTP_PORT="${EDGE_PUBLIC_HTTP_PORT}"
EDGE_TLS_PORT="${EDGE_PUBLIC_TLS_PORT}"
HTTP_PORTS="${NGINX_INTERNAL_HTTP_PORT}"
TLS_PORTS="${NGINX_INTERNAL_TLS_PORT}"
EOF
}

configure_edge_stack() {
    local server_name="$1"
    [[ -z "$server_name" ]] && server_name="_"

    backup_edge_configs

    echo -e "\n${C_BLUE}📝 Writing internal Nginx config (127.0.0.1:${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT})...${C_RESET}"
    write_internal_nginx_config "$server_name"

    echo -e "\n${C_BLUE}🧪 Validating Nginx configuration...${C_RESET}"
    if ! nginx -t >/dev/null 2>&1; then
        echo -e "${C_RED}❌ Nginx configuration validation failed.${C_RESET}"
        nginx -t
        return 1
    fi

    systemctl daemon-reload
    systemctl enable nginx >/dev/null 2>&1

    echo -e "\n${C_BLUE}▶️ Restarting internal Nginx...${C_RESET}"
    if ! ff_service_up nginx "Nginx" 2; then
        systemctl status nginx --no-pager
        return 1
    fi

    save_edge_ports_info
    return 0
}

cleanup_legacy_haproxy() {
    # Legacy cleanup, kept only for machines that ran an older release with the
    # HAProxy edge. Strips the leftover unit and config without touching the
    # Nginx proxy that replaced it.
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Removing leftover HAProxy edge ---${C_RESET}"
    systemctl stop haproxy >/dev/null 2>&1
    systemctl disable haproxy >/dev/null 2>&1
    rm -f /etc/systemd/system/haproxy.service /lib/systemd/system/haproxy.service 2>/dev/null
    if [ -f /etc/haproxy/haproxy.cfg ]; then
        rm -f /etc/haproxy/haproxy.cfg 2>/dev/null
    fi
    systemctl daemon-reload >/dev/null 2>&1
    echo -e "${C_GREEN}✅ HAProxy edge removed.${C_RESET}"
    if systemctl is-active --quiet nginx; then
        echo -e "${C_DIM}The internal Nginx proxy is still installed on ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"
    fi
}

show_dnstt_details() {
    if [ -f "$DNSTT_CONFIG_FILE" ]; then
        source "$DNSTT_CONFIG_FILE"
        echo -e "\n${C_GREEN}=====================================================${C_RESET}"
        echo -e "${C_GREEN}            📡 DNSTT Connection Details             ${C_RESET}"
        echo -e "${C_GREEN}=====================================================${C_RESET}"
        echo -e "\n${C_WHITE}Your connection details:${C_RESET}"
        echo -e "  - ${C_CYAN}Tunnel Domain:${C_RESET} ${C_YELLOW}$TUNNEL_DOMAIN${C_RESET}"
        echo -e "  - ${C_CYAN}Public Key:${C_RESET}    ${C_YELLOW}$PUBLIC_KEY${C_RESET}"
        if [[ -n "$FORWARD_DESC" ]]; then
            echo -e "  - ${C_CYAN}Forwarding To:${C_RESET} ${C_YELLOW}$FORWARD_DESC${C_RESET}"
        else
            echo -e "  - ${C_CYAN}Forwarding To:${C_RESET} ${C_YELLOW}Unknown (config_missing)${C_RESET}"
        fi
        if [[ -n "$MTU_VALUE" ]]; then
            echo -e "  - ${C_CYAN}MTU Value:${C_RESET}     ${C_YELLOW}$MTU_VALUE${C_RESET}"
        fi
        if [[ "$DNSTT_RECORDS_MANAGED" == "false" && -n "$NS_DOMAIN" ]]; then
             echo -e "  - ${C_CYAN}NS Record:${C_RESET}     ${C_YELLOW}$NS_DOMAIN${C_RESET}"
        fi
        
        if [[ "$FORWARD_DESC" == *"V2Ray"* ]]; then
             echo -e "  - ${C_CYAN}Action Required:${C_RESET} ${C_YELLOW}Ensure a V2Ray service (vless/vmess/trojan) listens on port 8787 (no TLS)${C_RESET}"
        elif [[ "$FORWARD_DESC" == *"SSH"* ]]; then
             echo -e "  - ${C_CYAN}Action Required:${C_RESET} ${C_YELLOW}Ensure your SSH client is configured to use the DNS tunnel.${C_RESET}"
        fi
        
        echo -e "\n${C_DIM}Use these details in your client configuration.${C_RESET}"
    else
        echo -e "\n${C_YELLOW}ℹ️ DNSTT configuration file not found. Details are unavailable.${C_RESET}"
    fi
}

install_dnstt() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📡 DNSTT (DNS Tunnel) Management ---${C_RESET}"
    if [ -f "$DNSTT_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ DNSTT is already installed.${C_RESET}"
        ff_service_kick dnstt.service "DNSTT"
        show_dnstt_details
        return
    fi
    
    # --- FIX: Force release of Port 53 / Disable systemd-resolved ---
    echo -e "${C_GREEN}⚙️ Forcing release of Port 53 (stopping systemd-resolved)...${C_RESET}"
    systemctl stop systemd-resolved >/dev/null 2>&1
    systemctl disable systemd-resolved >/dev/null 2>&1
    # A previous DNSTT install sets chattr +i on this file (see below). Without
    # clearing it first, both the rm and the write fail silently and DNS keeps
    # pointing at the old resolver with no error shown.
    chattr -i /etc/resolv.conf &>/dev/null
    rm -f /etc/resolv.conf
    if ! echo "nameserver 8.8.8.8" > /etc/resolv.conf 2>/dev/null; then
        echo -e "${C_YELLOW}⚠️ Could not update /etc/resolv.conf (immutable or read-only?).${C_RESET}"
        echo -e "${C_DIM}   DNSTT may still work, but name resolution could be stale.${C_RESET}"
    fi
    # ----------------------------------------------------------------
    
    echo -e "\n${C_BLUE}🔎 Checking if port 53 (UDP) is available...${C_RESET}"
    if ss -lunp | grep -q ':53\s'; then
        if [[ $(ps -p $(ss -lunp | grep ':53\s' | grep -oP 'pid=\K[0-9]+') -o comm=) == "systemd-resolve" ]]; then
            echo -e "${C_YELLOW}⚠️ Warning: Port 53 is in use by 'systemd-resolved'.${C_RESET}"
            echo -e "${C_YELLOW}This is the system's DNS stub resolver. It must be disabled to run DNSTT.${C_RESET}"
            read -p "👉 Allow the script to automatically disable it and reconfigure DNS? (y/n): " resolve_confirm
            if [[ "$resolve_confirm" == "y" || "$resolve_confirm" == "Y" ]]; then
                echo -e "${C_GREEN}⚙️ Stopping and disabling systemd-resolved to free port 53...${C_RESET}"
                systemctl stop systemd-resolved
                systemctl disable systemd-resolved
                chattr -i /etc/resolv.conf &>/dev/null
                rm -f /etc/resolv.conf
                echo "nameserver 8.8.8.8" > /etc/resolv.conf
                chattr +i /etc/resolv.conf
                echo -e "${C_GREEN}✅ Port 53 has been freed and DNS set to 8.8.8.8.${C_RESET}"
            else
                echo -e "${C_RED}❌ Cannot proceed without freeing port 53. Aborting.${C_RESET}"
                return
            fi
        else
            check_and_free_ports "53" || return
        fi
    else
        echo -e "${C_GREEN}✅ Port 53 (UDP) is free to use.${C_RESET}"
    fi

    check_and_open_firewall_port 53 udp || return



    local forward_port=""
    local forward_desc=""
    echo -e "\n${C_BLUE}Please choose where DNSTT should forward traffic:${C_RESET}"
    echo -e "  ${C_GREEN}[ 1]${C_RESET} ➡️ Forward to local SSH service (port 22)"
    echo -e "  ${C_GREEN}[ 2]${C_RESET} ➡️ Forward to local V2Ray backend (port 8787)"
    read -p "👉 Enter your choice [2]: " fwd_choice
    fwd_choice=${fwd_choice:-2}
    if [[ "$fwd_choice" == "1" ]]; then
        forward_port="22"
        forward_desc="SSH (port 22)"
        echo -e "${C_GREEN}ℹ️ DNSTT will forward to SSH on 127.0.0.1:22.${C_RESET}"
        

        
    elif [[ "$fwd_choice" == "2" ]]; then
        forward_port="8787"
        forward_desc="V2Ray (port 8787)"
        echo -e "${C_GREEN}ℹ️ DNSTT will forward to V2Ray on 127.0.0.1:8787.${C_RESET}"
    else
        echo -e "${C_RED}❌ Invalid choice. Aborting.${C_RESET}"
        return
    fi
    local FORWARD_TARGET="127.0.0.1:$forward_port"
    
    local NS_DOMAIN=""
    local TUNNEL_DOMAIN=""
    local DNSTT_RECORDS_MANAGED="true"
    local NS_SUBDOMAIN=""
    local TUNNEL_SUBDOMAIN=""
    local HAS_IPV6="false"

    read -p "👉 Auto-generate DNS records or use custom ones? (auto/custom) [auto]: " dns_choice
    dns_choice=${dns_choice:-auto}

    if [[ "$dns_choice" == "custom" ]]; then
        DNSTT_RECORDS_MANAGED="false"
        read -p "👉 Enter your full nameserver domain (e.g., ns1.yourdomain.com): " NS_DOMAIN
        if [[ -z "$NS_DOMAIN" ]]; then echo -e "\n${C_RED}❌ Nameserver domain cannot be empty. Aborting.${C_RESET}"; return; fi
        read -p "👉 Enter your full tunnel domain (e.g., tun.yourdomain.com): " TUNNEL_DOMAIN
        if [[ -z "$TUNNEL_DOMAIN" ]]; then echo -e "\n${C_RED}❌ Tunnel domain cannot be empty. Aborting.${C_RESET}"; return; fi
    else
        echo -e "\n${C_BLUE}⚙️ Configuring DNS records for DNSTT...${C_RESET}"
        local SERVER_IPV4
        SERVER_IPV4=$(curl -s -4 icanhazip.com)
        if ! _is_valid_ipv4 "$SERVER_IPV4"; then
            echo -e "\n${C_RED}❌ Error: Could not retrieve a valid public IPv4 address from icanhazip.com.${C_RESET}"
            echo -e "${C_YELLOW}ℹ️ Please check your server's network connection and DNS resolver settings.${C_RESET}"
            echo -e "   Output received: '$SERVER_IPV4'"
            return 1
        fi
        
        local SERVER_IPV6
        SERVER_IPV6=$(curl -s -6 icanhazip.com --max-time 5)
        
        local RANDOM_STR
        RANDOM_STR=$(tr -dc a-z0-9 < /dev/urandom | head -c 6)
        NS_SUBDOMAIN="ns-$RANDOM_STR"
        TUNNEL_SUBDOMAIN="tun-$RANDOM_STR"
        NS_DOMAIN="$NS_SUBDOMAIN.$DESEC_DOMAIN"
        TUNNEL_DOMAIN="$TUNNEL_SUBDOMAIN.$DESEC_DOMAIN"

        local API_DATA
        API_DATA=$(printf '[{"subname": "%s", "type": "A", "ttl": 3600, "records": ["%s"]}, {"subname": "%s", "type": "NS", "ttl": 3600, "records": ["%s."]}]' \
            "$NS_SUBDOMAIN" "$SERVER_IPV4" "$TUNNEL_SUBDOMAIN" "$NS_DOMAIN")

        if [[ -n "$SERVER_IPV6" ]]; then
            local aaaa_record
            aaaa_record=$(printf ',{"subname": "%s", "type": "AAAA", "ttl": 3600, "records": ["%s"]}' "$NS_SUBDOMAIN" "$SERVER_IPV6")
            API_DATA="${API_DATA%?}${aaaa_record}]"
            HAS_IPV6="true"
        fi

        local CREATE_RESPONSE
        CREATE_RESPONSE=$(curl -s -w "%{http_code}" -X POST "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/" \
            -H "Authorization: Token $DESEC_TOKEN" -H "Content-Type: application/json" \
            --data "$API_DATA")
        
        local HTTP_CODE=${CREATE_RESPONSE: -3}
        local RESPONSE_BODY=${CREATE_RESPONSE:0:${#CREATE_RESPONSE}-3}

        if [[ "$HTTP_CODE" -ne 201 ]]; then
            echo -e "${C_RED}❌ Failed to create DNSTT records. API returned HTTP $HTTP_CODE.${C_RESET}"
            echo "Response: $RESPONSE_BODY" | jq
            return 1
        fi
    fi
    
    read -p "👉 Enter MTU value (e.g., 512, 1200) or press [Enter] for default: " mtu_value
    local mtu_string=""
    if [[ "$mtu_value" =~ ^[0-9]+$ ]]; then
        mtu_string=" -mtu $mtu_value"
        echo -e "${C_GREEN}ℹ️ Using MTU: $mtu_value${C_RESET}"
    else
        mtu_value=""
        echo -e "${C_YELLOW}ℹ️ Using default MTU.${C_RESET}"
    fi

    echo -e "\n${C_BLUE}📥 Downloading pre-compiled DNSTT server binary...${C_RESET}"
    local arch
    arch=$(uname -m)
    local binary_url=""
    if [[ "$arch" == "x86_64" ]]; then
        binary_url="https://dnstt.network/dnstt-server-linux-amd64"
        echo -e "${C_BLUE}ℹ️ Detected x86_64 (amd64) architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        binary_url="https://dnstt.network/dnstt-server-linux-arm64"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Unsupported architecture: $arch. Cannot install DNSTT.${C_RESET}"
        return
    fi
    
    if ! ff_fetch_binary "$DNSTT_BINARY" "$binary_url"; then
        echo -e "\n${C_RED}❌ Failed to download a valid DNSTT binary from:${C_RESET}"
        echo -e "   ${C_YELLOW}$binary_url${C_RESET}"
        return
    fi
    chmod +x "$DNSTT_BINARY"

    echo -e "${C_BLUE}🔐 Generating cryptographic keys...${C_RESET}"
    mkdir -p "$DNSTT_KEYS_DIR"
    "$DNSTT_BINARY" -gen-key -privkey-file "$DNSTT_KEYS_DIR/server.key" -pubkey-file "$DNSTT_KEYS_DIR/server.pub"
    # Check BOTH keys. Only server.key was verified before, so a missing pubkey
    # left PUBLIC_KEY empty, got saved to the config, and printed a blank key in
    # the client details that nobody could connect with.
    if [[ ! -s "$DNSTT_KEYS_DIR/server.key" || ! -s "$DNSTT_KEYS_DIR/server.pub" ]]; then
        echo -e "${C_RED}❌ Failed to generate DNSTT keys.${C_RESET}"
        return
    fi

    local PUBLIC_KEY
    PUBLIC_KEY=$(cat "$DNSTT_KEYS_DIR/server.pub")
    if [[ -z "$PUBLIC_KEY" ]]; then
        echo -e "${C_RED}❌ DNSTT public key is empty — refusing to write a broken config.${C_RESET}"
        return
    fi
    
    echo -e "\n${C_BLUE}📝 Creating systemd service...${C_RESET}"
    cat > "$DNSTT_SERVICE_FILE" <<-EOF
[Unit]
Description=DNSTT (DNS Tunnel) Server for $forward_desc
After=network.target
[Service]
Type=simple
User=root
ExecStart=$DNSTT_BINARY -udp :53$mtu_string -privkey-file $DNSTT_KEYS_DIR/server.key $TUNNEL_DOMAIN $FORWARD_TARGET
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
    echo -e "\n${C_BLUE}💾 Saving configuration and starting service...${C_RESET}"
    cat > "$DNSTT_CONFIG_FILE" <<-EOF
NS_SUBDOMAIN="$NS_SUBDOMAIN"
TUNNEL_SUBDOMAIN="$TUNNEL_SUBDOMAIN"
NS_DOMAIN="$NS_DOMAIN"
TUNNEL_DOMAIN="$TUNNEL_DOMAIN"
PUBLIC_KEY="$PUBLIC_KEY"
FORWARD_DESC="$forward_desc"
DNSTT_RECORDS_MANAGED="$DNSTT_RECORDS_MANAGED"
HAS_IPV6="$HAS_IPV6"
MTU_VALUE="$mtu_value"
EOF
    # Ensure port 53 is excluded from udp-custom so DNSTT can claim it
    local _excl_file="$DB_DIR/udp_custom_exclude.conf"
    if [[ -f "$UDP_CUSTOM_SERVICE_FILE" ]]; then
        if [[ ! -f "$_excl_file" ]]; then
            printf '%s' "$UDP_CUSTOM_EXCLUDE_DEFAULT" > "$_excl_file"
        fi
        local _curr; _curr=$(cat "$_excl_file")
        if ! echo ",$_curr," | grep -q ',53,'; then
            _curr="${_curr},53"
            printf '%s' "$_curr" > "$_excl_file"
            echo -e "${C_GREEN}✅ Port 53 auto-excluded from udp-custom for DNSTT.${C_RESET}"
            _reload_udp_custom_service
        fi
    fi
    # Port 53 may take a moment to be released by systemd-resolved, so allow a
    # longer verify window than the usual 2s before calling this a failure.
    if ff_service_up dnstt.service "DNSTT" 3; then
        echo -e "\n${C_GREEN}✅ SUCCESS: DNSTT has been installed and started!${C_RESET}"
        show_dnstt_details
    fi
}

uninstall_dnstt() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling DNSTT ---${C_RESET}"
    if [ ! -f "$DNSTT_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ DNSTT does not appear to be installed, skipping.${C_RESET}"
        return
    fi
    local confirm="y"
    if [[ "$UNINSTALL_MODE" != "silent" ]]; then
        read -p "👉 Are you sure you want to uninstall DNSTT? This will delete DNS records if they were auto-generated. (y/n): " confirm
    fi
    if [[ "$confirm" != "y" ]]; then
        echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
        return
    fi
    echo -e "${C_BLUE}🛑 Stopping and disabling DNSTT service...${C_RESET}"
    systemctl stop dnstt.service > /dev/null 2>&1
    systemctl disable dnstt.service > /dev/null 2>&1
    if [ -f "$DNSTT_CONFIG_FILE" ]; then
        source "$DNSTT_CONFIG_FILE"
        if [[ "$DNSTT_RECORDS_MANAGED" == "true" ]]; then
            echo -e "${C_BLUE}🗑️ Removing auto-generated DNS records...${C_RESET}"
            curl -s -X DELETE "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/$TUNNEL_SUBDOMAIN/NS/" \
                 -H "Authorization: Token $DESEC_TOKEN" > /dev/null
            curl -s -X DELETE "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/$NS_SUBDOMAIN/A/" \
                 -H "Authorization: Token $DESEC_TOKEN" > /dev/null
            if [[ "$HAS_IPV6" == "true" ]]; then
                curl -s -X DELETE "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/$NS_SUBDOMAIN/AAAA/" \
                     -H "Authorization: Token $DESEC_TOKEN" > /dev/null
            fi
            echo -e "${C_GREEN}✅ DNS records have been removed.${C_RESET}"
        else
            echo -e "${C_YELLOW}⚠️ DNS records were manually configured. Please delete them from your DNS provider.${C_RESET}"
        fi
    fi
    echo -e "${C_BLUE}🗑️ Removing service files and binaries...${C_RESET}"
    rm -f "$DNSTT_SERVICE_FILE"
    rm -f "$DNSTT_BINARY"
    rm -rf "$DNSTT_KEYS_DIR"
    rm -f "$DNSTT_CONFIG_FILE"
    systemctl daemon-reload
    
    echo -e "${C_YELLOW}ℹ️ Making /etc/resolv.conf writable again...${C_RESET}"
    chattr -i /etc/resolv.conf &>/dev/null

    echo -e "\n${C_GREEN}✅ DNSTT has been successfully uninstalled.${C_RESET}"
}

install_falcon_proxy() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🦅 Installing Falcon Proxy (Websockets/Socks) ---${C_RESET}"
    
    if [ -f "$FALCONPROXY_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ Falcon Proxy is already installed.${C_RESET}"
        if [ -f "$FALCONPROXY_CONFIG_FILE" ]; then
            source "$FALCONPROXY_CONFIG_FILE"
            echo -e "   It is configured to run on port(s): ${C_YELLOW}$PORTS${C_RESET}"
            echo -e "   Installed Version: ${C_YELLOW}${INSTALLED_VERSION:-Unknown}${C_RESET}"
        fi
        read -p "👉 Do you want to reinstall/update? (y/n): " confirm_reinstall
        if [[ "$confirm_reinstall" != "y" ]]; then
            ff_service_kick falconproxy.service "Falcon Proxy"
            return
        fi
    fi

    echo -e "\n${C_BLUE}🌐 Fetching available versions from $FF_REPO_HOST...${C_RESET}"
    local releases_json=$(curl -s "$FF_RELEASES_API")
    if [[ -z "$releases_json" || "$releases_json" == "[]" ]]; then
        echo -e "${C_RED}❌ Error: Could not fetch releases. Check internet or API limits.${C_RESET}"
        return
    fi

    # Extract tag names
    mapfile -t versions < <(echo "$releases_json" | jq -r '.[].tag_name')
    
    if [ ${#versions[@]} -eq 0 ]; then
        echo -e "${C_RED}❌ No releases found in the repository.${C_RESET}"
        return
    fi

    echo -e "\n${C_CYAN}Select a version to install:${C_RESET}"
    for i in "${!versions[@]}"; do
        printf "  ${C_GREEN}[%2d]${C_RESET} %s\n" "$((i+1))" "${versions[$i]}"
    done
    echo -e "  ${C_RED} [ 0]${C_RESET} ↩️ Cancel"
    
    local choice
    while true; do
        if ! read -r -p "👉 Enter version number [1]: " choice; then
            echo
            return
        fi
        choice=${choice:-1}
        if [[ "$choice" == "0" ]]; then return; fi
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -le "${#versions[@]}" ]; then
            SELECTED_VERSION="${versions[$((choice-1))]}"
            break
        else
            echo -e "${C_RED}❌ Invalid selection.${C_RESET}"
        fi
    done

    local ports
    read -p "👉 Enter port(s) for Falcon Proxy (e.g., 8080 or 8080 8888) [8080]: " ports
    ports=${ports:-8080}

    local port_array=($ports)
    for port in "${port_array[@]}"; do
        if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
            echo -e "\n${C_RED}❌ Invalid port number: $port. Aborting.${C_RESET}"
            return
        fi
        check_and_free_ports "$port" || return
        check_and_open_firewall_port "$port" tcp || return
    done

    echo -e "\n${C_GREEN}⚙️ Detecting system architecture...${C_RESET}"
    local arch=$(uname -m)
    local binary_name=""
    if [[ "$arch" == "x86_64" ]]; then
        binary_name="falconproxy"
        echo -e "${C_BLUE}ℹ️ Detected x86_64 (amd64) architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        binary_name="falconproxyarm"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Unsupported architecture: $arch. Cannot install Falcon Proxy.${C_RESET}"
        return
    fi
    
    # Construct download URL based on selected version
    local download_url="$FF_RELEASE_DL_BASE/$SELECTED_VERSION/$binary_name"

    echo -e "\n${C_GREEN}📥 Downloading Falcon Proxy $SELECTED_VERSION ($binary_name)...${C_RESET}"
    if ! ff_fetch_binary "$FALCONPROXY_BINARY" "$download_url"; then
        echo -e "\n${C_RED}❌ Failed to download a valid binary from:${C_RESET}"
        echo -e "   ${C_YELLOW}$download_url${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Ensure release '$SELECTED_VERSION' on $FF_REPO_OWNER/$FF_REPO_NAME has an asset named '$binary_name'.${C_RESET}"
        echo -e "${C_YELLOW}   (If you forked this project, set FF_REPO_HOST/FF_REPO_OWNER/FF_REPO_NAME and upload the falconproxy assets to your own releases.)${C_RESET}"
        return
    fi
    chmod +x "$FALCONPROXY_BINARY"

    echo -e "\n${C_GREEN}📝 Creating systemd service file...${C_RESET}"
    cat > "$FALCONPROXY_SERVICE_FILE" <<EOF
[Unit]
Description=Falcon Proxy ($SELECTED_VERSION)
After=network.target

[Service]
User=root
Type=simple
ExecStart=$FALCONPROXY_BINARY -p $ports
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF

    echo -e "\n${C_GREEN}💾 Saving configuration...${C_RESET}"
    cat > "$FALCONPROXY_CONFIG_FILE" <<EOF
PORTS="$ports"
INSTALLED_VERSION="$SELECTED_VERSION"
EOF

    echo -e "\n${C_GREEN}▶️ Enabling and starting Falcon Proxy service...${C_RESET}"
    if ff_service_up falconproxy.service "Falcon Proxy" 2; then
        echo -e "\n${C_GREEN}✅ SUCCESS: Falcon Proxy $SELECTED_VERSION is installed and active.${C_RESET}"
        echo -e "   Listening on port(s): ${C_YELLOW}$ports${C_RESET}"
    fi
}

uninstall_falcon_proxy() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling Falcon Proxy ---${C_RESET}"
    if [ ! -f "$FALCONPROXY_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ Falcon Proxy is not installed, skipping.${C_RESET}"
        return
    fi
    echo -e "${C_GREEN}🛑 Stopping and disabling Falcon Proxy service...${C_RESET}"
    systemctl stop falconproxy.service >/dev/null 2>&1
    systemctl disable falconproxy.service >/dev/null 2>&1
    echo -e "${C_GREEN}🗑️ Removing service file...${C_RESET}"
    rm -f "$FALCONPROXY_SERVICE_FILE"
    systemctl daemon-reload
    echo -e "${C_GREEN}🗑️ Removing binary and config files...${C_RESET}"
    rm -f "$FALCONPROXY_BINARY"
    rm -f "$FALCONPROXY_CONFIG_FILE"
    echo -e "${C_GREEN}✅ Falcon Proxy has been uninstalled successfully.${C_RESET}"
}

# --- ZiVPN Installation Logic ---
install_zivpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing ZiVPN (UDP/VPN) ---${C_RESET}"
    
    if [ -f "$ZIVPN_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ ZiVPN is already installed.${C_RESET}"
        ff_service_kick zivpn.service "ZiVPN"
        return
    fi

    if [ ! -f "$BADVPN_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}⚠️ ZiVPN requires the badvpn (udpgw) backend to provide internet access.${C_RESET}"
        echo -e "${C_GREEN}📦 Automatically installing badvpn backend...${C_RESET}"
        sleep 2
        install_badvpn
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Resuming ZiVPN Installation ---${C_RESET}"
    fi

    check_and_free_ports 5667 || return
    check_and_open_firewall_port 5667 udp || return
    check_and_open_firewall_port_range "6000:19999" udp || return

    echo -e "\n${C_GREEN}⚙️ Checking system architecture...${C_RESET}"
    local arch=$(uname -m)
    local zivpn_url=""
    
    if [[ "$arch" == "x86_64" ]]; then
        zivpn_url="https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-amd64"
        echo -e "${C_BLUE}ℹ️ Detected AMD64/x86_64 architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" ]]; then
        zivpn_url="https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-arm64"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    elif [[ "$arch" == "armv7l" || "$arch" == "arm" ]]; then
         zivpn_url="https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-arm"
         echo -e "${C_BLUE}ℹ️ Detected ARM architecture.${C_RESET}"
    else
        echo -e "${C_RED}❌ Unsupported architecture: $arch${C_RESET}"
        return
    fi

    echo -e "\n${C_GREEN}📦 Downloading ZiVPN binary...${C_RESET}"
    if ! ff_fetch_binary "$ZIVPN_BIN" "$zivpn_url"; then
        echo -e "${C_RED}❌ Failed to download a valid ZiVPN binary from:${C_RESET}"
        echo -e "   ${C_YELLOW}$zivpn_url${C_RESET}"
        return
    fi
    chmod +x "$ZIVPN_BIN"

    echo -e "\n${C_GREEN}⚙️ Configuring ZIVPN...${C_RESET}"
    mkdir -p "$ZIVPN_DIR"
    
    # Generate Certificates
    echo -e "${C_BLUE}🔐 Generating self-signed certificates...${C_RESET}"
    if ! command -v openssl &>/dev/null; then
        ff_pkg_install openssl >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to install openssl for ZiVPN certificate generation.${C_RESET}"
            return
        }
    fi
    
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=US/ST=California/L=Los Angeles/O=Example Corp/OU=IT Department/CN=zivpn" \
        -keyout "$ZIVPN_KEY_FILE" -out "$ZIVPN_CERT_FILE" 2>/dev/null

    if [ ! -f "$ZIVPN_CERT_FILE" ]; then
        echo -e "${C_RED}❌ Failed to generate certificates.${C_RESET}"
        return
    fi

    # System Tuning
    echo -e "${C_BLUE}🔧 Tuning system network parameters...${C_RESET}"
    sysctl -w net.core.rmem_max=16777216 >/dev/null
    sysctl -w net.core.wmem_max=16777216 >/dev/null

    # Create Service
    echo -e "${C_BLUE}📝 Creating systemd service file...${C_RESET}"
    cat <<EOF > "$ZIVPN_SERVICE_FILE"
[Unit]
Description=zivpn VPN Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$ZIVPN_DIR
ExecStart=$ZIVPN_BIN server -c $ZIVPN_CONFIG_FILE
Restart=always
RestartSec=3
Environment=ZIVPN_LOG_LEVEL=info
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

    # Configure Passwords
    echo -e "\n${C_YELLOW}🔑 ZiVPN Password Setup${C_RESET}"
    read -p "👉 Enter passwords separated by commas (e.g., user1,user2) [Default: 'zi']: " input_config
    
    if [ -n "$input_config" ]; then
        IFS=',' read -r -a config_array <<< "$input_config"
        # Ensure array format for JSON
        json_passwords=$(printf '"%s",' "${config_array[@]}")
        json_passwords="[${json_passwords%,}]"
    else
        json_passwords='["zi"]'
    fi

    # Create Config File
    cat <<EOF > "$ZIVPN_CONFIG_FILE"
{
  "listen": ":5667",
   "cert": "$ZIVPN_CERT_FILE",
   "key": "$ZIVPN_KEY_FILE",
   "obfs":"zivpn",
   "auth": {
    "mode": "passwords", 
    "config": $json_passwords
  }
}
EOF

    # Auto-import existing zivpn users from the manager database so users created
    # before ZiVPN was installed (or re-installed) can authenticate immediately.
    local _import_count=0
    if [[ -f "$DB_FILE" ]] && command -v jq &>/dev/null; then
        while IFS=: read -r _user _pass _rest; do
            [[ -n "$_user" && -n "$_pass" ]] || continue
            if jq -e --arg p "$_pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null; then
                continue
            fi
            local _tmp; _tmp=$(mktemp) || continue
            if jq --arg p "$_pass" '.auth.config += [$p]' "$ZIVPN_CONFIG_FILE" > "$_tmp" 2>/dev/null; then
                mv "$_tmp" "$ZIVPN_CONFIG_FILE"
                ((_import_count++))
            fi
            rm -f "$_tmp" 2>/dev/null
    done < <(awk -F: '$9 == "zivpn" { print $1":"$2 }' "$DB_FILE" 2>/dev/null)
        if [[ $_import_count -gt 0 ]]; then
            echo -e "${C_GREEN}ℹ️ Imported ${_import_count} existing ZiVPN user(s) from database.${C_RESET}"
        fi
    fi

    echo -e "\n${C_GREEN}🚀 Starting ZiVPN Service...${C_RESET}"
    local _zivpn_ok=true
    ff_service_up zivpn.service "ZiVPN" 2 || _zivpn_ok=false

    # Port Forwarding / Firewall
    echo -e "${C_BLUE}🔥 Configuring Firewall Rules (ZiVPN on UDP 5667, forwarded from 6000-19999)...${C_RESET}"
    # Ensure all DNAT rules (badvpn + zivpn) are applied together so the previous
    # badvpn rules aren't silently dropped when this rule is added independently.
    # NOTE: defaults forward the 6000-19999 UDP range to ZiVPN's 5667 listener
    # (udp-custom takes 1:5999 + 20000:65535), plus a RETURN exception for direct 5667.
    _nat_load_rules
    _nat_apply

    # Cleanup
    rm -f zi.sh zi2.sh 2>/dev/null

    if $_zivpn_ok; then
        echo -e "\n${C_GREEN}✅ ZiVPN Installed Successfully!${C_RESET}"
        echo -e "   - UDP Port: 5667 (Direct)"
        echo -e "   - UDP Ports: 6000-19999 (Forwarded → 5667)"
    fi
}

uninstall_zivpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🗑️ Uninstall ZiVPN ---${C_RESET}"
    
    if [ ! -f "$ZIVPN_SERVICE_FILE" ] && [ ! -f "$ZIVPN_BIN" ]; then
        echo -e "\n${C_YELLOW}ℹ️ ZiVPN does not appear to be installed.${C_RESET}"
        return
    fi

    read -p "👉 Are you sure you want to uninstall ZiVPN? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then echo -e "${C_YELLOW}Cancelled.${C_RESET}"; return; fi

    echo -e "\n${C_BLUE}🛑 Stopping services...${C_RESET}"
    systemctl stop zivpn.service 2>/dev/null
    systemctl disable zivpn.service 2>/dev/null

    local iface
    iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
    if [ -n "$iface" ]; then
        iptables -t nat -D PREROUTING -i "$iface" -p udp --dport 6000:19999 -j DNAT --to-destination :5667 2>/dev/null || true
    fi
    
    echo -e "${C_BLUE}🗑️ Removing files...${C_RESET}"
    rm -f "$ZIVPN_SERVICE_FILE"
    rm -rf "$ZIVPN_DIR"
    rm -f "$ZIVPN_BIN"
    
    systemctl daemon-reload
    
    # Clean cache (from original uninstall script logic)
    echo -e "${C_BLUE}🧹 Cleaning memory cache...${C_RESET}"
    sync; echo 3 > /proc/sys/vm/drop_caches

    echo -e "\n${C_GREEN}✅ ZiVPN Uninstalled Successfully.${C_RESET}"
}

# --- HWID Lock Enforcer ----------------------------------------------------
# Best-effort, reactive device lock. The daemon tails udp-custom + zivpn journals
# and, for any connection log line that carries an identifiable device token, kicks
# the source IP when it doesn't match the user's allowed HWID (strict rows only).
# It NEVER blocks when the log line lacks an HWID token, so users on binaries that
# don't emit HWID are left untouched rather than false-blocked.

# Remove any HWID-origin INPUT DROP rules the enforcer added (keyed by a stable
# iptables comment) — used on disable / remove-HWID so blocks don't linger.
_hwid_flush_drops() {
    command -v iptables &>/dev/null || return 0
    local ip ips
    # Collect every source IP currently carrying our tagged DROP rule. The comment
    # appears as "ffhwid" in iptables-save output; we delete by full rule spec so
    # the running-rule match (comment stored without quotes) succeeds.
    ips=$(iptables-save 2>/dev/null | awk '/--comment "ffhwid"/ {
        for (i=1; i<=NF; i++) if ($i == "-s") { print $(i+1); break }
    }' | sort -u)
    for ip in $ips; do
        # Strip any /32 CIDR iptables-save may append.
        ip="${ip%/*}"
        # Delete every duplicate copy for this IP.
        while iptables -D INPUT -p udp -s "$ip" -m comment --comment "ffhwid" -j DROP 2>/dev/null; do :; done
    done
}

write_hwid_enforcer() {
    cat > "$HWID_ENFORCER_SCRIPT" <<'HWIDEOF'
#!/bin/bash
# VPS_superScript HWID enforcer version 2026-07-29.1
# VPS_superScript HWID Lock Enforcer (best-effort, reactive).
# Reads username|hwid|strict|password from the allowed DB and watches the VPN
# journals. The hwid column may be a comma-separated list of allowed devices; a
# connection is OK if its device id matches ANY entry. On a strict mismatch it
# drops the offending source IP (tagged with an iptables comment so it can be
# cleanly removed later).
#
# Unverifiable-connection policy (deny-by-default): when a STRICT, HWID-locked
# identity connects but the channel exposes no device id, the secure default is
# to DROP it — otherwise a decrypted/reused config sails straight through on any
# protocol that doesn't report an HWID. An operator who accepts that gap can set
# the policy to "allow" (legacy behaviour) from the HWID menu.
# Force a UTF-8 locale so grep -P (PCRE) is always available.
export LC_ALL=C.UTF-8 LANG=C.UTF-8
HWID_DB="/etc/VPS_superScript/hwid_allowed.db"
HWID_POLICY_FILE="/etc/VPS_superScript/hwid_policy"
LOG_FILE="/var/log/VPS_superScript_hwid.log"
KICK_LOG="/var/log/VPS_superScript_hwid.log"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"; }

# Policy for strict identities whose connection carries no verifiable device id.
# Re-read per connection (cheap) so a menu toggle takes effect without a restart.
# "allow" = legacy pass-through; anything else (incl. missing file) = "block".
unverified_policy() {
    local p="block"
    [ -f "$HWID_POLICY_FILE" ] && read -r p < "$HWID_POLICY_FILE" 2>/dev/null
    [ "$p" = "allow" ] && echo "allow" || echo "block"
}

touch "$LOG_FILE" 2>/dev/null
log "HWID enforcer started."

# Look up the allowed hwid list + strict for a token that may be a username OR a
# password. Echoes the (possibly comma-separated) hwid list, or empty if the
# token isn't an enforced (strict, hwid-set) identity.
# Password is the LAST pipe field, so $4 captures it even if it contains '|'.
lookup_identity() {
    local token="$1"
    [ -f "$HWID_DB" ] || return 1
    awk -F'|' -v t="$token" '
        {
            user=$1; hwid=$2; strict=$3;
            pass=$4;
            for (i=5; i<=NF; i++) pass=pass "|" $i;   # rejoin a password containing '|'
        }
        (user == t || pass == t) && strict == "1" && hwid != "" { print hwid; found=1; exit }
        END { exit(found ? 0 : 1) }
    ' "$HWID_DB"
}

drop_ip() {
    local ip="$1" who="$2"
    command -v iptables &>/dev/null || return 0
    # Idempotent: delete a prior identical rule, then insert. Comment lets the
    # menu flush these rules without touching unrelated firewall entries.
    iptables -D INPUT -p udp -s "$ip" -m comment --comment "ffhwid" -j DROP 2>/dev/null
    iptables -I INPUT -p udp -s "$ip" -m comment --comment "ffhwid" -j DROP 2>/dev/null
    command -v conntrack &>/dev/null && conntrack -D -p udp -s "$ip" 2>/dev/null
    echo "$(date '+%Y-%m-%d %H:%M:%S') - KICKED $ip (wrong HWID) for $who" >> "$KICK_LOG"
}

journalctl -u udp-custom -u zivpn -u hysteria-server -u shadowsocks-libev -n0 -f --no-pager 2>/dev/null | while IFS= read -r line; do
    # Only react to lines that look like a successful client connection.
    echo "$line" | grep -qiE 'client connected|user connected|accepted|authenticated|new session' || continue

    # Best-effort token extraction. Patterns are deliberately broad; adjust here
    # if the installed VPN binary uses a different log vocabulary.
    # 1) key=value / key: value forms (require a delimiter so bare words like
    #    "client connected" don't get mistaken for the identity token).
    token=$(echo "$line" | grep -oiP '(username|user|client|account)[=:][ ]*\K[^ ,;]+' | head -1)
    # 2) "user <name>" / "account <name>" space form.
    [ -z "$token" ] && token=$(echo "$line" | grep -oiP '\b(username|user|account)[ ]+\K[A-Za-z0-9._-]+' | head -1)
    # 3) password/auth token fallback (ZiVPN identity is its password).
    [ -z "$token" ] && token=$(echo "$line" | grep -oiP '(password|pass|auth)[=:][ ]*\K[^ ,;]+' | head -1)
    ip=$(echo "$line" | grep -oP '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b' | head -1)
    hwid=$(echo "$line" | grep -oiP 'hwid[=:][ ]*\K[^ ,;]+' | head -1)

    [ -z "$token" ] && continue
    [ -z "$ip" ] && continue

    allowed_list=$(lookup_identity "$token") || continue   # not a strict/locked user

    if [ -z "$hwid" ]; then
        # This is a STRICT, HWID-locked identity, but the channel exposed no
        # verifiable device id. Allowing it here is the old hole that let a
        # decrypted/reused config connect freely on any protocol that doesn't
        # report an HWID. Deny-by-default: drop unless the operator opted into
        # the legacy "allow" policy.
        if [ "$(unverified_policy)" = "allow" ]; then
            log "UNVERIFIED-ALLOW - $token from $ip (no hwid in log; policy=allow); allowed=$allowed_list"
            continue
        fi
        log "UNVERIFIED-BLOCK - $token from $ip (no hwid in log; policy=block); allowed=$allowed_list"
        drop_ip "$ip" "$token"
        continue
    fi

    # allowed_list may hold several comma-separated HWIDs; the device is OK if it
    # matches ANY of them. Otherwise the source IP is dropped.
    matched=0
    IFS=',' read -ra _hlist <<< "$allowed_list"
    for h in "${_hlist[@]}"; do
        # Trim surrounding whitespace before comparing.
        h="${h#"${h%%[![:space:]]*}"}"; h="${h%"${h##*[![:space:]]}"}"
        [ -n "$h" ] && [ "$h" = "$hwid" ] && { matched=1; break; }
    done

    if [ "$matched" -eq 0 ]; then
        log "BLOCK - $token from $ip wrong hwid=$hwid (allowed=$allowed_list)"
        drop_ip "$ip" "$token"
    else
        log "OK - $token from $ip hwid matched"
    fi
done
HWIDEOF
    chmod +x "$HWID_ENFORCER_SCRIPT"
}

enable_hwid_lock() {
    mkdir -p "$DB_DIR" 2>/dev/null
    # Secure default for unverifiable strict connections; created once, then
    # left to the operator's toggle.
    [ -f "$HWID_POLICY_FILE" ] || echo "block" > "$HWID_POLICY_FILE"
    hwid_sync_allowed_db
    write_hwid_enforcer
    cat > "$HWID_ENFORCER_SERVICE" <<EOF
[Unit]
Description=VPS_superScript HWID Lock Enforcer
After=network.target

[Service]
Type=simple
User=root
ExecStart=$HWID_ENFORCER_SCRIPT
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable VPS_superScript-hwid-enforcer 2>/dev/null
    systemctl restart VPS_superScript-hwid-enforcer 2>/dev/null
    echo "on" > "$HWID_STATE_FILE"
    if systemctl is-active --quiet VPS_superScript-hwid-enforcer; then
        echo -e "\n${C_GREEN}✅ HWID Lock enforcement ENABLED.${C_RESET}"
        echo -e "${C_DIM}Only users with an HWID + strict flag are enforced; others stay multi-device.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Enforcer failed to start. Check: journalctl -u VPS_superScript-hwid-enforcer${C_RESET}"
    fi
}

disable_hwid_lock() {
    systemctl stop VPS_superScript-hwid-enforcer 2>/dev/null
    systemctl disable VPS_superScript-hwid-enforcer 2>/dev/null
    rm -f "$HWID_ENFORCER_SERVICE" "$HWID_ENFORCER_SCRIPT"
    systemctl daemon-reload 2>/dev/null
    _hwid_flush_drops
    echo "off" > "$HWID_STATE_FILE"
    echo -e "\n${C_YELLOW}⚠️ HWID Lock enforcement DISABLED. All device blocks cleared.${C_RESET}"
}

hwid_lock_status() {
    if systemctl is-active --quiet VPS_superScript-hwid-enforcer 2>/dev/null; then
        echo -e "  ${C_GREEN}● Enabled${C_RESET} ${C_DIM}(watching udp-custom + zivpn)${C_RESET}"
    else
        echo -e "  ${C_RED}● Disabled${C_RESET}"
    fi
}

# Current unverifiable-connection policy: "block" (secure default) or "allow".
hwid_policy_current() {
    local p="block"
    [[ -f "$HWID_POLICY_FILE" ]] && read -r p < "$HWID_POLICY_FILE" 2>/dev/null
    [[ "$p" == "allow" ]] && echo "allow" || echo "block"
}

hwid_lock_menu() {
    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🔒 HWID Lock Enforcement ---${C_RESET}\n"
        echo -ne "  Status: "; hwid_lock_status
        local locked_count=0
        [[ -f "$HWID_ALLOWED_DB" ]] && locked_count=$(grep -c . "$HWID_ALLOWED_DB" 2>/dev/null || echo 0)
        echo -e "  ${C_DIM}Users with an enforced HWID: ${C_CYAN}${locked_count}${C_RESET}"
        local pol; pol=$(hwid_policy_current)
        if [[ "$pol" == "block" ]]; then
            echo -e "  ${C_DIM}Unverifiable strict connections:${C_RESET} ${C_GREEN}BLOCK${C_RESET} ${C_DIM}(secure default)${C_RESET}"
        else
            echo -e "  ${C_DIM}Unverifiable strict connections:${C_RESET} ${C_YELLOW}ALLOW${C_RESET} ${C_DIM}(legacy — no device check on unreporting protocols)${C_RESET}"
        fi
        echo -e "\n  ${C_DIM}How it works: enforcement is reactive — it reads the VPN service logs and"
        echo -e "  can only verify a device when the protocol reports one. It ${C_RESET}${C_BOLD}cannot${C_RESET}${C_DIM} stop a"
        echo -e "  decrypted/reused config on protocols that don't. For dependable device"
        echo -e "  control, rely on the per-account ${C_RESET}${C_CYAN}connection limit${C_RESET}${C_DIM} (set when you create the"
        echo -e "  account) and issue ${C_RESET}${C_CYAN}one account per device${C_RESET}${C_DIM}.${C_RESET}\n"
        printf "  ${C_GREEN}[ 1]${C_RESET} %-40s\n" "✅ Enable enforcement"
        printf "  ${C_GREEN}[ 2]${C_RESET} %-40s\n" "🛑 Disable enforcement"
        printf "  ${C_GREEN}[ 3]${C_RESET} %-40s\n" "📜 View recent kick log"
        printf "  ${C_GREEN}[ 4]${C_RESET} %-40s\n" "🔀 Toggle unverifiable-connection policy"
        echo -e "\n  ${C_RED}[ 0]${C_RESET} ⬅️  Back"
        echo
        read -r -p "👉 Enter your choice: " hc || return
        case $hc in
            1) enable_hwid_lock; press_enter ;;
            2) disable_hwid_lock; press_enter ;;
            3) if [[ -f "$HWID_KICK_LOG" ]]; then
                   echo; tail -n 30 "$HWID_KICK_LOG" 2>/dev/null
               else echo -e "\n${C_YELLOW}ℹ️ No HWID activity logged yet.${C_RESET}"; fi
               press_enter ;;
            4) mkdir -p "$DB_DIR" 2>/dev/null
               if [[ "$(hwid_policy_current)" == "block" ]]; then
                   echo "allow" > "$HWID_POLICY_FILE"
                   echo -e "\n${C_YELLOW}⚠️ Policy set to ALLOW.${C_RESET}"
                   echo -e "${C_DIM}Strict users may now connect on protocols that don't report an HWID —"
                   echo -e "there is NO device check on those, so a reused config gets through.${C_RESET}"
               else
                   echo "block" > "$HWID_POLICY_FILE"
                   echo -e "\n${C_GREEN}✅ Policy set to BLOCK (secure default).${C_RESET}"
                   echo -e "${C_DIM}Strict users are dropped when their device can't be verified.${C_RESET}"
               fi
               echo -e "${C_DIM}Takes effect immediately — the enforcer re-reads the policy per connection.${C_RESET}"
               press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

# ── UDP Sharing Control (udp-custom per-user concurrent-IP limiter) ──────────
write_udp_share_enforcer() {
    cat > "$UDP_SHARE_ENFORCER_SCRIPT" <<'UDPSHAREEOF'
#!/bin/bash
# VPS_superScript udp-share enforcer version 2026-07-30.3
# Per-user concurrent source-IP limiter for udp-custom.
#
# WHY THIS EXISTS: UDP is connectionless and udp-custom runs as root, so there
# is no per-user process to count or kill (unlike SSH). The only identity signal
# is udp-custom's own auth log. This daemon tails that log and maps each
# accepted connection to (user -> source IP).
#
# WHY IT IS NOT A NAIVE IP COUNTER: on mobile carriers (the common case for
# injector-app users) two things break simple counting:
#   1. Carrier NAT puts many subscribers behind one public IP, so genuine
#      sharing between two users on the same carrier can look like ONE IP.
#   2. A single phone's IP rotates on handover/reconnect, so one honest user
#      can look like TWO IPs within seconds.
# Counting distinct IPs punishes (2) while missing (1). So instead we look for
# SUSTAINED OVERLAP: after a rotation the old IP goes silent, whereas real
# sharing keeps both IPs re-authenticating in an interleaved pattern. An IP only
# counts once it is "established" (>= MIN_HITS auth events) and "live" (seen
# within OVERLAP_WINDOW), and a user must stay over their limit for
# STRIKES_NEEDED consecutive checks before we act. Rotation therefore decays to
# zero strikes on its own.
#
# WHY IT ACTS ON THE ACCOUNT, NOT THE IP: under carrier NAT, DROPping an IP
# punishes every other customer behind that same address. So the default action
# is a temporary shadow lock on the offending ACCOUNT (blocks udp-custom
# re-auth) plus a conntrack flush of only that user's own flows. IP-level DROP
# is available as an opt-in fallback and is scoped to the udp-custom port so it
# can never break DNS or unrelated UDP.
#
# FAIL-VISIBLE: udp-custom's exact log vocabulary can vary by build. If the
# daemon sees connection-shaped lines but cannot extract identities, it records
# an "unparseable" health state so the menu warns loudly instead of pretending
# to protect. Adjust the extraction patterns below to match your build's log.
export LC_ALL=C.UTF-8 LANG=C.UTF-8
DB_FILE="/etc/VPS_superScript/users.db"
HEALTH_FILE="/etc/VPS_superScript/udp_share.health"
LOCK_STATE="/etc/VPS_superScript/udp_share.locks"
LOG_FILE="/var/log/VPS_superScript_udp_share.log"
LISTEN_PORT="__LISTEN_PORT__"   # substituted by enable_udp_share
IDLE_TIMEOUT=300          # seconds before an idle source IP is forgotten
OVERLAP_WINDOW=90         # an IP counts as "live" only if seen within this
MIN_HITS=2                # auth events before an IP counts as established
STRIKES_NEEDED=3          # consecutive over-limit checks before acting
DEFAULT_LIMIT=2           # mobile IPs rotate; 1 is too tight as a default
COOLDOWN=600              # seconds an auto-locked account stays locked
ACTION_FILE="/etc/VPS_superScript/udp_share.action"
# warn = observe only (log what WOULD be acted on, touch nothing)
# lock = temporary shadow lock on the offending account (recommended once tuned)
# drop = port-scoped iptables DROP of the newest source IPs (fallback)
# Defaults to warn: the tuning below cannot be validated against a given
# network's carrier-NAT behaviour in advance, and a false positive locks out a
# paying customer. Observe first, then switch to lock from the menu.
ACTION="warn"
PREV_ACTION=""
read_action() {
    local a
    a=$(cat "$ACTION_FILE" 2>/dev/null | tr -d '[:space:]')
    case "$a" in
        warn|lock|drop) ACTION="$a" ;;
        *)              ACTION="warn" ;;
    esac
    # On a mode change, undo the artefacts of the mode we just left so that
    # switching to a softer mode never leaves a customer locked or blocked.
    if [ -n "$PREV_ACTION" ] && [ "$ACTION" != "$PREV_ACTION" ]; then
        log "MODE $PREV_ACTION -> $ACTION"
        case "$PREV_ACTION" in
            lock) release_all_locks ;;
            drop) flush_our_rules; DROPPED=() ;;
        esac
        ACTED=(); STRIKES=()
    fi
    PREV_ACTION="$ACTION"
}
COMMENT_TAG="ffudpshare"  # iptables comment so we can find/remove only our rules
TICK=15                   # maintenance wakeup interval (prune + health) in seconds
HEALTH_TMP="${HEALTH_FILE}.tmp"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"; }

# Per-account connection limit = 4th colon field of users.db (user:pass:expiry:limit:...)
user_limit() {
    local u="$1" line lim
    line=$(grep -m1 "^${u}:" "$DB_FILE" 2>/dev/null)
    [ -z "$line" ] && { echo "$DEFAULT_LIMIT"; return; }
    lim=$(printf '%s' "$line" | cut -d: -f4)
    [[ "$lim" =~ ^[0-9]+$ ]] || lim="$DEFAULT_LIMIT"
    (( lim < 1 )) && lim="$DEFAULT_LIMIT"
    echo "$lim"
}

# IP-level DROP is the opt-in fallback action only. It is scoped to the
# udp-custom listen port: an unscoped "-p udp -s IP" DROP would also kill DNS
# and every other UDP service for everyone behind a carrier-NAT address.
drop_ip() {
    local ip="$1"
    [ -z "$LISTEN_PORT" ] && { log "SKIP drop ip=$ip (no listen port known)"; return 1; }
    iptables -C INPUT -p udp -s "$ip" --dport "$LISTEN_PORT" -m comment --comment "$COMMENT_TAG" -j DROP 2>/dev/null && return 0
    iptables -I INPUT -p udp -s "$ip" --dport "$LISTEN_PORT" -m comment --comment "$COMMENT_TAG" -j DROP 2>/dev/null
    command -v conntrack >/dev/null 2>&1 && conntrack -D -p udp -s "$ip" --dport "$LISTEN_PORT" >/dev/null 2>&1
}

undrop_ip() {
    local ip="$1"
    [ -z "$LISTEN_PORT" ] && return 0
    while iptables -C INPUT -p udp -s "$ip" --dport "$LISTEN_PORT" -m comment --comment "$COMMENT_TAG" -j DROP 2>/dev/null; do
        iptables -D INPUT -p udp -s "$ip" --dport "$LISTEN_PORT" -m comment --comment "$COMMENT_TAG" -j DROP 2>/dev/null || break
    done
}

# Temporarily shadow-lock the offending ACCOUNT. This is the default action:
# it targets the person actually sharing instead of an address that may be
# shared by unrelated customers. Only ever applied to accounts present in
# users.db, so system accounts can never be touched. Recorded in LOCK_STATE so
# a daemon restart still releases the lock.
lock_account() {
    local u="$1" now="$2"
    grep -q "^${u}:" "$DB_FILE" 2>/dev/null || { log "REFUSE lock user=$u (not in users.db)"; return 1; }
    passwd -S "$u" 2>/dev/null | awk '{print $2}' | grep -q '^L' && return 0
    usermod -L "$u" 2>/dev/null || return 1
    echo "$u $now" >> "$LOCK_STATE"
    # Kill this user's live UDP flows so the lock bites immediately rather than
    # only at their next re-auth.
    if command -v conntrack >/dev/null 2>&1; then
        local key ip
        for key in "${!LAST_SEEN[@]}"; do
            [ "${key%%|*}" = "$u" ] || continue
            ip="${key#*|}"
            [ -n "$LISTEN_PORT" ] && conntrack -D -p udp -s "$ip" --dport "$LISTEN_PORT" >/dev/null 2>&1
        done
    fi
    return 0
}

unlock_account() {
    local u="$1"
    grep -q "^${u}:" "$DB_FILE" 2>/dev/null || return 1
    usermod -U "$u" 2>/dev/null
    if [ -f "$LOCK_STATE" ]; then
        grep -v "^${u} " "$LOCK_STATE" > "${LOCK_STATE}.tmp" 2>/dev/null \
            && mv "${LOCK_STATE}.tmp" "$LOCK_STATE" 2>/dev/null
    fi
}

# Release any auto-lock whose cooldown has elapsed.
release_expired_locks() {
    local now u ts
    [ -f "$LOCK_STATE" ] || return 0
    now=$(date +%s)
    while read -r u ts; do
        [ -z "$u" ] && continue
        [[ "$ts" =~ ^[0-9]+$ ]] || ts=0
        if (( now - ts >= COOLDOWN )); then
            unlock_account "$u"
            log "RELEASE user=$u (cooldown elapsed)"
        fi
    done < "$LOCK_STATE"
}

# Health states: starting | active | unparseable
write_health() {
    local state="$1" note="$2"
    { echo "state=$state"
      echo "updated=$(date '+%Y-%m-%d %H:%M:%S')"
      echo "epoch=$(date +%s)"
      echo "lines_seen=$LINES_SEEN"
      echo "ids_parsed=$IDS_PARSED"
      echo "active_ips=$ACTIVE_TOTAL"
      echo "violations=$VIOLATIONS"
      echo "action=$ACTION"
      echo "note=$note"
    } > "$HEALTH_TMP" 2>/dev/null && mv "$HEALTH_TMP" "$HEALTH_FILE" 2>/dev/null
}

declare -A LAST_SEEN      # "user|ip" -> epoch last seen
declare -A FIRST_SEEN     # "user|ip" -> epoch first seen
declare -A HITS           # "user|ip" -> auth-event count (established >= MIN_HITS)
declare -A DROPPED        # "user|ip" -> 1 if we have an iptables DROP for it
declare -A STRIKES        # user -> consecutive over-limit checks
declare -A ACTED          # user -> epoch we last acted, suppresses repeat action
LINES_SEEN=0              # total log lines read
CONN_SHAPED=0            # lines that looked like a connect/auth event
IDS_PARSED=0             # connect-shaped lines we extracted user+ip from
ACTIVE_TOTAL=0           # distinct active (user,ip) pairs
VIOLATIONS=0             # users we have acted on since start

# Extraction — adjust to match your udp-custom build's log vocabulary.
# Sets KIND=conn plus USR and IP when a connection-shaped line is parsed.
extract_line() {
    local line="$1"
    KIND=""; USR=""; IP=""
    printf '%s' "$line" | grep -qiE 'connect|accept|auth|login|session|new client' || return
    CONN_SHAPED=$((CONN_SHAPED+1))
    KIND="conn"
    IP=$(printf '%s' "$line" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1)
    USR=$(printf '%s' "$line" | grep -oiP '(?:user(?:name)?[:=[:space:]]+)\K[A-Za-z0-9._-]+' | head -n1)
    [ -z "$USR" ] && USR=$(printf '%s' "$line" | grep -oiP '(?:\bfor[[:space:]]+)\K[A-Za-z0-9._-]+' | head -n1)
}

# Count a user's ESTABLISHED + LIVE source IPs. "Established" (>= MIN_HITS auth
# events) filters one-off rotation artefacts; "live" (seen within
# OVERLAP_WINDOW) means a rotated-away IP stops counting quickly even though we
# keep it in LAST_SEEN until IDLE_TIMEOUT for logging.
live_ip_count() {
    local u="$1" now="$2" key n=0
    for key in "${!LAST_SEEN[@]}"; do
        [ "${key%%|*}" = "$u" ] || continue
        (( ${HITS[$key]:-0} >= MIN_HITS )) || continue
        (( now - LAST_SEEN[$key] <= OVERLAP_WINDOW )) || continue
        n=$((n+1))
    done
    echo "$n"
}

# Decide whether a user is really sharing, and act if so. A user must exceed
# their limit on STRIKES_NEEDED consecutive checks; a single check back under
# the limit resets the count, so IP rotation never accumulates strikes.
enforce_user() {
    local u="$1" now lim n
    now=$(date +%s)
    lim=$(user_limit "$u")
    n=$(live_ip_count "$u" "$now")

    if (( n <= lim )); then
        [ -n "${STRIKES[$u]}" ] && unset "STRIKES[$u]"
        return
    fi

    STRIKES[$u]=$(( ${STRIKES[$u]:-0} + 1 ))
    (( STRIKES[$u] < STRIKES_NEEDED )) && {
        log "WATCH user=$u limit=$lim live_ips=$n strike=${STRIKES[$u]}/$STRIKES_NEEDED"
        return
    }

    # Already acted on this user recently — let the cooldown run its course.
    (( now - ${ACTED[$u]:-0} < COOLDOWN )) && return

    ACTED[$u]=$now
    VIOLATIONS=$((VIOLATIONS+1))
    case "$ACTION" in
        lock)
            if lock_account "$u" "$now"; then
                log "SHARING user=$u limit=$lim live_ips=$n -> ACCOUNT LOCKED ${COOLDOWN}s"
            else
                log "SHARING user=$u limit=$lim live_ips=$n -> lock FAILED"
            fi
            ;;
        drop)
            # Fallback: drop the newest established IPs, keeping the oldest $lim.
            local key ip first entry i=0
            local ips=()
            for key in "${!LAST_SEEN[@]}"; do
                [ "${key%%|*}" = "$u" ] || continue
                (( ${HITS[$key]:-0} >= MIN_HITS )) || continue
                (( now - LAST_SEEN[$key] <= OVERLAP_WINDOW )) || continue
                first="${FIRST_SEEN[$key]:-${LAST_SEEN[$key]}}"
                ips+=("$first|$key")
            done
            local sorted=()
            while IFS= read -r entry; do sorted+=("$entry"); done \
                < <(printf '%s\n' "${ips[@]}" | sort -t'|' -k1,1n)
            for entry in "${sorted[@]}"; do
                i=$((i+1))
                (( i <= lim )) && continue
                key="${entry#*|}"; ip="${key#*|}"
                [ -n "${DROPPED[$key]}" ] && continue
                drop_ip "$ip" && DROPPED[$key]=1
                log "SHARING user=$u limit=$lim live_ips=$n -> DROP ip=$ip (port $LISTEN_PORT)"
            done
            ;;
        *)
            # warn: observe only. Log exactly what would have happened so the
            # operator can judge the tuning against real traffic before any
            # account is ever locked.
            log "WOULD-ACT user=$u limit=$lim live_ips=$n (observe mode; no action taken)"
            ;;
    esac
}

# Forget idle (user,ip) pairs; undrop an IP once no active dropped pair needs it.
prune() {
    local now key ip k2 other
    now=$(date +%s)
    for key in "${!LAST_SEEN[@]}"; do
        (( now - LAST_SEEN[$key] <= IDLE_TIMEOUT )) && continue
        if [ -n "${DROPPED[$key]}" ]; then
            ip="${key#*|}"; other=0
            for k2 in "${!DROPPED[@]}"; do
                [ "$k2" = "$key" ] && continue
                [ "${k2#*|}" = "$ip" ] && { other=1; break; }
            done
            (( other == 0 )) && { undrop_ip "$ip"; log "EXPIRE ip=$ip user=${key%%|*} (idle)"; }
            unset "DROPPED[$key]"
        fi
        unset "LAST_SEEN[$key]" "FIRST_SEEN[$key]" "HITS[$key]"
    done
    ACTIVE_TOTAL=${#LAST_SEEN[@]}
    release_expired_locks
}

# Remove every rule we ever added (used at startup and on shutdown). Deletes by
# rule NUMBER rather than by matching the rule form, so it also clears unscoped
# rules left behind by an older build of this daemon on upgrade.
flush_our_rules() {
    local rulenum
    while true; do
        rulenum=$(iptables -L INPUT --line-numbers -n 2>/dev/null \
            | grep "$COMMENT_TAG" | head -n1 | awk '{print $1}')
        [ -z "$rulenum" ] && break
        iptables -D INPUT "$rulenum" 2>/dev/null || break
    done
}

# On shutdown, release every account we auto-locked. Leaving a paying user
# locked because the daemon stopped would be worse than not enforcing at all.
release_all_locks() {
    local u ts
    [ -f "$LOCK_STATE" ] || return 0
    while read -r u ts; do
        [ -n "$u" ] && unlock_account "$u"
    done < "$LOCK_STATE"
    : > "$LOCK_STATE"
}

trap 'flush_our_rules; release_all_locks; exit 0' TERM INT

flush_our_rules
release_all_locks   # clear anything left behind by an unclean previous exit
touch "$LOCK_STATE" 2>/dev/null; chmod 600 "$LOCK_STATE" 2>/dev/null
read_action
LAST_PRUNE=$(date +%s)
write_health starting "daemon started in ${ACTION} mode, awaiting udp-custom log lines"

while true; do
    while true; do
        if IFS= read -r -t "$TICK" line; then
            LINES_SEEN=$((LINES_SEEN+1))
            extract_line "$line"
            if [ "$KIND" = "conn" ] && [ -n "$USR" ] && [ -n "$IP" ]; then
                IDS_PARSED=$((IDS_PARSED+1))
                key="$USR|$IP"; now=$(date +%s)
                [ -z "${FIRST_SEEN[$key]}" ] && FIRST_SEEN[$key]=$now
                LAST_SEEN[$key]=$now
                HITS[$key]=$(( ${HITS[$key]:-0} + 1 ))
                enforce_user "$USR"
            fi
        else
            (( $? <= 128 )) && break   # EOF: journalctl stream ended
        fi
        now=$(date +%s)
        if (( now - LAST_PRUNE >= TICK )); then
            prune; LAST_PRUNE=$now
            read_action   # pick up a menu-side mode change without a restart
            if (( CONN_SHAPED > 0 && IDS_PARSED == 0 )); then
                write_health unparseable "saw $CONN_SHAPED connection-shaped log lines but extracted 0 identities — udp-custom log format not recognized; adjust extract_line() patterns"
            else
                write_health active "tracking $ACTIVE_TOTAL source IPs; parsed $IDS_PARSED identities from $LINES_SEEN lines; acted on $VIOLATIONS users (action=$ACTION)"
            fi
        fi
    done < <(journalctl -u udp-custom -n0 -f --no-pager 2>/dev/null)
    write_health starting "udp-custom log stream ended; retrying in 5s (is udp-custom running?)"
    sleep 5
done
UDPSHAREEOF
    # Bake in the real udp-custom listen port so IP drops can be scoped to it.
    sed -i "s|__LISTEN_PORT__|${UDP_CUSTOM_LISTEN_PORT}|" "$UDP_SHARE_ENFORCER_SCRIPT" 2>/dev/null
    chmod +x "$UDP_SHARE_ENFORCER_SCRIPT"
    sed -i 's/\r$//' "$UDP_SHARE_ENFORCER_SCRIPT" 2>/dev/null
}

enable_udp_share() {
    mkdir -p "$DB_DIR" 2>/dev/null
    # Default to observe-only on first enable so switching this on can never
    # lock a paying customer before the operator has seen what it detects.
    if [[ ! -f "$UDP_SHARE_ACTION_FILE" ]]; then
        echo "warn" > "$UDP_SHARE_ACTION_FILE"
        chmod 600 "$UDP_SHARE_ACTION_FILE" 2>/dev/null
    fi
    write_udp_share_enforcer
    cat > "$UDP_SHARE_ENFORCER_SERVICE" <<EOF
[Unit]
Description=VPS_superScript UDP Anti-Sharing Enforcer
After=network.target udp-custom.service

[Service]
Type=simple
User=root
ExecStart=$UDP_SHARE_ENFORCER_SCRIPT
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable VPS_superScript-udp-share 2>/dev/null
    systemctl restart VPS_superScript-udp-share 2>/dev/null
    echo "on" > "$UDP_SHARE_STATE_FILE"
    if systemctl is-active --quiet VPS_superScript-udp-share; then
        echo -e "\n${C_GREEN}✅ UDP anti-sharing enforcement ENABLED.${C_RESET}"
        echo -e "${C_DIM}Watches the udp-custom log and enforces each account's connection limit"
        echo -e "by source IP. Give it ~15s, then check the health line in this menu — if it"
        echo -e "reports ${C_RESET}${C_YELLOW}UNPARSEABLE${C_RESET}${C_DIM}, the log format wasn't recognised and nothing is being"
        echo -e "enforced yet (see the note in the menu).${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Enforcer failed to start. Check: journalctl -u VPS_superScript-udp-share${C_RESET}"
    fi
}

disable_udp_share() {
    systemctl stop VPS_superScript-udp-share 2>/dev/null
    systemctl disable VPS_superScript-udp-share 2>/dev/null
    rm -f "$UDP_SHARE_ENFORCER_SERVICE" "$UDP_SHARE_ENFORCER_SCRIPT"
    systemctl daemon-reload 2>/dev/null
    # Clear any iptables drops this enforcer left behind. Rules are matched by
    # their comment tag and deleted by rule number, so this works regardless of
    # which rule form (scoped or not) an older build inserted.
    local rulenum
    while true; do
        rulenum=$(iptables -L INPUT --line-numbers -n 2>/dev/null | grep "ffudpshare" | head -n1 | awk '{print $1}')
        [[ -z "$rulenum" ]] && break
        iptables -D INPUT "$rulenum" 2>/dev/null || break
    done
    # Release any account this enforcer auto-locked for sharing.
    if [[ -f "$DB_DIR/udp_share.locks" ]]; then
        local _lu _lts
        while read -r _lu _lts; do
            [[ -n "$_lu" ]] && usermod -U "$_lu" 2>/dev/null
        done < "$DB_DIR/udp_share.locks"
        rm -f "$DB_DIR/udp_share.locks"
    fi
    rm -f "$UDP_SHARE_HEALTH_FILE"
    echo "off" > "$UDP_SHARE_STATE_FILE"
    echo -e "\n${C_YELLOW}⚠️ UDP anti-sharing enforcement DISABLED. All UDP share-blocks cleared.${C_RESET}"
}

udp_share_status() {
    if systemctl is-active --quiet VPS_superScript-udp-share 2>/dev/null; then
        echo -e "  ${C_GREEN}● Enabled${C_RESET} ${C_DIM}(watching udp-custom log)${C_RESET}"
    else
        echo -e "  ${C_RED}● Disabled${C_RESET}"
    fi
}

# Read a single field out of the health file (state|updated|lines_seen|
# ids_parsed|active_ips|note). Echoes empty string when absent.
udp_share_health_field() {
    local key="$1" val=""
    [[ -f "$UDP_SHARE_HEALTH_FILE" ]] || { echo ""; return; }
    val=$(grep -m1 "^${key}=" "$UDP_SHARE_HEALTH_FILE" 2>/dev/null | cut -d= -f2-)
    echo "$val"
}

# Choose what the enforcer does when it decides an account is being shared.
# The daemon re-reads this file every ~15s, so no restart is needed.
udp_share_set_action() {
    echo
    echo -e "${C_BOLD}--- 🎚️ UDP Anti-Sharing Action Mode ---${C_RESET}\n"
    echo -e "  ${C_CYAN}[1] Observe${C_RESET} ${C_DIM}(recommended first)${C_RESET}"
    echo -e "      ${C_DIM}Logs every account it would act on, changes nothing. Run this for a"
    echo -e "      week and read the log before trusting it with live customers.${C_RESET}\n"
    echo -e "  ${C_YELLOW}[2] Lock account${C_RESET}"
    echo -e "      ${C_DIM}Temporarily locks the sharing account (auto-released after a cooldown)."
    echo -e "      Targets the sharer, not their IP, so other customers behind the same"
    echo -e "      carrier NAT are unaffected. Use once observe mode looks correct.${C_RESET}\n"
    echo -e "  ${C_RED}[3] Drop source IPs${C_RESET}"
    echo -e "      ${C_DIM}Blocks the newest source IPs on the udp-custom port only. Under carrier"
    echo -e "      NAT this can affect unrelated customers sharing that address — prefer"
    echo -e "      option 2 unless you have a specific reason.${C_RESET}\n"
    read -r -p "👉 Select mode (1-3, blank to cancel): " _m
    case "$_m" in
        1) echo "warn" > "$UDP_SHARE_ACTION_FILE"
           echo -e "\n${C_GREEN}✅ Mode set to OBSERVE — nothing will be enforced.${C_RESET}"
           echo -e "${C_DIM}   Watch for WOULD-ACT lines in option 3.${C_RESET}" ;;
        2) echo "lock" > "$UDP_SHARE_ACTION_FILE"
           echo -e "\n${C_YELLOW}⚠️ Mode set to LOCK — sharing accounts will be temporarily locked.${C_RESET}" ;;
        3) echo -e "\n${C_YELLOW}⚠️ Under carrier NAT this can block customers who are not sharing.${C_RESET}"
           read -r -p "👉 Type 'yes' to confirm DROP mode: " _c
           if [[ "$_c" == "yes" ]]; then
               echo "drop" > "$UDP_SHARE_ACTION_FILE"
               echo -e "\n${C_RED}⚠️ Mode set to DROP.${C_RESET}"
           else
               echo -e "\n${C_DIM}Cancelled — mode unchanged.${C_RESET}"; return
           fi ;;
        "") echo -e "\n${C_DIM}Cancelled — mode unchanged.${C_RESET}"; return ;;
        *) echo -e "\n${C_RED}❌ Invalid choice — mode unchanged.${C_RESET}"; return ;;
    esac
    chmod 600 "$UDP_SHARE_ACTION_FILE" 2>/dev/null
    echo -e "${C_DIM}   The enforcer picks this up within ~15s; no restart needed.${C_RESET}"
}

udp_share_menu() {
    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 📡 UDP Anti-Sharing (udp-custom) ---${C_RESET}\n"
        echo -ne "  Status: "; udp_share_status
        if systemctl is-active --quiet VPS_superScript-udp-share 2>/dev/null; then
            local hstate note active ids
            hstate=$(udp_share_health_field state)
            note=$(udp_share_health_field note)
            active=$(udp_share_health_field active_ips)
            ids=$(udp_share_health_field ids_parsed)
            case "$hstate" in
                active)
                    echo -e "  Health: ${C_GREEN}● ACTIVE${C_RESET} ${C_DIM}(identities parsed: ${ids:-0}, IPs blocked now: ${active:-0})${C_RESET}" ;;
                unparseable)
                    echo -e "  Health: ${C_RED}● UNPARSEABLE — NOT ENFORCING${C_RESET}"
                    echo -e "  ${C_YELLOW}The udp-custom log is being read, but no user identity could be parsed"
                    echo -e "  out of it, so no limit is being applied. This is expected until the log"
                    echo -e "  format is confirmed. ${C_RESET}${C_DIM}${note}${C_RESET}" ;;
                starting|"")
                    echo -e "  Health: ${C_YELLOW}● STARTING${C_RESET} ${C_DIM}${note}${C_RESET}" ;;
                *)
                    echo -e "  Health: ${C_DIM}${hstate} ${note}${C_RESET}" ;;
            esac
        fi
        echo -e "\n  ${C_DIM}How it works: UDP has no connection to count, so this reads udp-custom's"
        echo -e "  own log and ties each source IP to the account that authenticated. Because"
        echo -e "  mobile IPs rotate, it only acts when an account stays over its ${C_RESET}${C_CYAN}connection"
        echo -e "  limit${C_RESET}${C_DIM} across several checks — not on a single extra IP. It ${C_RESET}${C_BOLD}cannot${C_RESET}${C_DIM} tell two"
        echo -e "  devices behind one carrier NAT apart, and enforces nothing if the log can't"
        echo -e "  be parsed. Pair it with ${C_RESET}${C_CYAN}one account per device${C_RESET}${C_DIM} and ${C_RESET}${C_CYAN}bandwidth quotas${C_RESET}${C_DIM} —"
        echo -e "  quotas are unaffected by NAT and catch what this cannot.${C_RESET}\n"
        local curmode; curmode=$(cat "$UDP_SHARE_ACTION_FILE" 2>/dev/null | tr -d '[:space:]')
        case "$curmode" in
            lock) echo -e "  Mode: ${C_YELLOW}🔒 LOCK${C_RESET} ${C_DIM}(temporarily locks the sharing account)${C_RESET}" ;;
            drop) echo -e "  Mode: ${C_YELLOW}⛔ DROP${C_RESET} ${C_DIM}(blocks newest source IPs on the udp-custom port)${C_RESET}" ;;
            *)    echo -e "  Mode: ${C_CYAN}👁️ OBSERVE${C_RESET} ${C_DIM}(logs what it would do — nothing is enforced)${C_RESET}" ;;
        esac
        echo
        printf "  ${C_GREEN}[ 1]${C_RESET} %-40s\n" "✅ Enable enforcement"
        printf "  ${C_GREEN}[ 2]${C_RESET} %-40s\n" "🛑 Disable enforcement"
        printf "  ${C_GREEN}[ 3]${C_RESET} %-40s\n" "📜 View recent activity log"
        printf "  ${C_GREEN}[ 4]${C_RESET} %-40s\n" "🩺 View raw health state"
        printf "  ${C_GREEN}[ 5]${C_RESET} %-40s\n" "🎚️ Change action mode"
        echo -e "\n  ${C_RED}[ 0]${C_RESET} ⬅️  Back"
        echo
        read -r -p "👉 Enter your choice: " uc || return
        case $uc in
            1) enable_udp_share; press_enter ;;
            2) disable_udp_share; press_enter ;;
            3) if [[ -f "$UDP_SHARE_LOG" ]]; then
                   echo; tail -n 30 "$UDP_SHARE_LOG" 2>/dev/null
               else echo -e "\n${C_YELLOW}ℹ️ No UDP anti-sharing activity logged yet.${C_RESET}"; fi
               press_enter ;;
            4) if [[ -f "$UDP_SHARE_HEALTH_FILE" ]]; then
                   echo; cat "$UDP_SHARE_HEALTH_FILE" 2>/dev/null
               else echo -e "\n${C_YELLOW}ℹ️ No health state written yet (enforcer not started?).${C_RESET}"; fi
               press_enter ;;
            5) udp_share_set_action; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

purge_nginx() {
    local mode="$1"
    if [[ "$mode" != "silent" ]]; then
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🔥 Purge Internal Nginx Proxy ---${C_RESET}"
        if ! command -v nginx &> /dev/null; then
            rm -f "$NGINX_PORTS_FILE"
            echo -e "\n${C_YELLOW}ℹ️ Nginx is not installed. Nothing to do.${C_RESET}"
            return
        fi
        echo -e "\n${C_YELLOW}⚠️ This removes the internal Nginx proxy on ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"
        read -p "👉 Continue and purge Nginx? (y/n): " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
            return
        fi
    fi
    echo -e "\n${C_BLUE}🛑 Stopping Nginx service...${C_RESET}"
    systemctl stop nginx >/dev/null 2>&1
    systemctl disable nginx >/dev/null 2>&1
    echo -e "\n${C_BLUE}🗑️ Purging Nginx packages...${C_RESET}"
    ff_pkg_purge nginx nginx-common >/dev/null 2>&1
    ff_pkg_autoremove
    echo -e "\n${C_BLUE}🗑️ Removing leftover files...${C_RESET}"
    rm -f /etc/ssl/certs/nginx-selfsigned.pem
    rm -f /etc/ssl/private/nginx-selfsigned.key
    rm -rf /etc/nginx
    rm -f "${NGINX_CONFIG_FILE}.bak"
    rm -f "${NGINX_CONFIG_FILE}.bak.certbot"
    rm -f "${NGINX_CONFIG_FILE}.bak.selfsigned"
    rm -f "${NGINX_CONFIG_FILE}.bak.VPS_superScript"
    rm -f "$NGINX_PORTS_FILE"
    if [[ "$mode" != "silent" ]]; then
        echo -e "\n${C_GREEN}✅ Internal Nginx proxy purged. Shared VPS_superScript certificates were kept.${C_RESET}"
    fi
}

install_nginx_proxy() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Reconfiguring Internal Nginx Proxy (8880/8443) ---${C_RESET}"
    echo -e "\n${C_CYAN}This rewrites the internal Nginx proxy on ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"

    if [ ! -s "$SSL_CERT_FILE" ] || [ ! -s "$SSL_CERT_CHAIN_FILE" ] || [ ! -s "$SSL_CERT_KEY_FILE" ]; then
        echo -e "\n${C_YELLOW}⚠️ No shared VPS_superScript certificate was found.${C_RESET}"
        echo -e "${C_DIM}Generating one before the proxy is written, so Nginx can start with a valid TLS cert.${C_RESET}"
        mkdir -p "$SSL_CERT_DIR"
        # Straight to the certificate, not back through install_nginx_proxy:
        # that function delegates here when the cert is missing, so calling it
        # would recurse.
        local _cn; _cn=$(detect_preferred_host)
        [[ -z "$_cn" ]] && _cn="_"
        generate_self_signed_edge_cert "$_cn" || return
        load_edge_cert_info
    fi

    mkdir -p "$DB_DIR" "$SSL_CERT_DIR"
    ensure_edge_stack_packages || return

    systemctl stop nginx >/dev/null 2>&1
    sleep 1

    check_and_free_ports \
        "$NGINX_INTERNAL_HTTP_PORT" \
        "$NGINX_INTERNAL_TLS_PORT" || return

    check_and_open_firewall_port "$EDGE_PUBLIC_HTTP_PORT" tcp || return
    check_and_open_firewall_port "$EDGE_PUBLIC_TLS_PORT" tcp || return

    load_edge_cert_info
    local server_name="${EDGE_DOMAIN:-$(detect_preferred_host)}"
    [[ -z "$server_name" ]] && server_name="_"

    configure_edge_stack "$server_name" || return

    echo -e "\n${C_GREEN}✅ Internal Nginx proxy reconfigured successfully.${C_RESET}"
    echo -e "   • Internal Nginx: ${C_YELLOW}${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}${C_RESET}"
}

request_certbot_ssl() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔒 Shared Certbot Certificate (Nginx) ---${C_RESET}"
    echo -e "\n${C_DIM}This will replace the shared certificate used by internal Nginx on ${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"

    mkdir -p "$DB_DIR" "$SSL_CERT_DIR"
    ensure_edge_stack_packages || return
    load_edge_cert_info

    local preferred_host
    local default_domain=""
    local domain_name
    local email

    preferred_host=$(detect_preferred_host)
    if [[ -n "$EDGE_DOMAIN" ]] && ! _is_valid_ipv4 "$EDGE_DOMAIN"; then
        default_domain="$EDGE_DOMAIN"
    elif [[ -n "$preferred_host" ]] && ! _is_valid_ipv4 "$preferred_host"; then
        default_domain="$preferred_host"
    fi

    if [[ -n "$default_domain" ]]; then
        read -p "👉 Enter your domain name [$default_domain]: " domain_name
        domain_name=${domain_name:-$default_domain}
    else
        read -p "👉 Enter your domain name (e.g. vpn.example.com): " domain_name
    fi
    if [[ -z "$domain_name" ]]; then
        echo -e "\n${C_RED}❌ Domain name cannot be empty.${C_RESET}"
        return
    fi
    if _is_valid_ipv4 "$domain_name"; then
        echo -e "\n${C_RED}❌ Certbot requires a real domain name, not a raw IP address.${C_RESET}"
        return
    fi

    read -p "👉 Enter your email for Let's Encrypt [${EDGE_EMAIL}]: " email
    email=${email:-$EDGE_EMAIL}
    if [[ -z "$email" ]]; then
        echo -e "\n${C_RED}❌ Email address cannot be empty.${C_RESET}"
        return
    fi

    check_and_open_firewall_port "$EDGE_PUBLIC_HTTP_PORT" tcp || return
    check_and_open_firewall_port "$EDGE_PUBLIC_TLS_PORT" tcp || return

    obtain_certbot_edge_cert "$domain_name" "$email" || return
    configure_edge_stack "$domain_name" || return

    echo -e "\n${C_GREEN}✅ Shared Certbot certificate applied successfully.${C_RESET}"
    echo -e "   • Domain: ${C_YELLOW}${domain_name}${C_RESET}"
    echo -e "   • Public edge: ${C_YELLOW}${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT}${C_RESET}"
}

nginx_proxy_menu() {
    while true; do
    show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🌐 Internal Nginx Proxy Management ---${C_RESET}"

    local nginx_status="🔴"
    if systemctl is-active --quiet nginx; then
        nginx_status="🟢"
    fi

    load_edge_cert_info
    local cert_info="${EDGE_CERT_MODE:-Not configured}"
    if [[ -n "$EDGE_DOMAIN" ]]; then
        cert_info="${cert_info} - ${EDGE_DOMAIN}"
    fi

    echo -e "\n${C_WHITE}Nginx:${C_RESET} ${nginx_status}"
    echo -e "${C_DIM}Public Edge: ${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT} | Internal Nginx: ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}${C_RESET}"
    echo -e "${C_DIM}Shared Certificate: ${cert_info}${C_RESET}"

    echo -e "\n${C_BOLD}Select an action:${C_RESET}\n"
    
    if systemctl is-active --quiet nginx; then
         printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🛑 Stop Nginx Service"
         printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔄 Restart Nginx Service"
         printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "⚙️ Re-install/Re-configure Edge Stack"
         printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "🔒 Switch/Renew Shared SSL (Certbot)"
         printf "  ${C_CHOICE}[ 5]${C_RESET} %-40s\n" "🔥 Uninstall/Purge Nginx"
    else
         printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "▶️ Start Nginx Service"
         printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "⚙️ Install/Configure Edge Stack"
         printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "🔒 Switch/Renew Shared SSL (Certbot)"
         printf "  ${C_CHOICE}[ 5]${C_RESET} %-40s\n" "🔥 Uninstall/Purge Nginx"
    fi

    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
        echo
        return
    fi
    
    case $choice in
        1)
            if systemctl is-active --quiet nginx; then
                echo -e "\n${C_BLUE}🛑 Stopping Nginx...${C_RESET}"
                systemctl stop nginx
                echo -e "${C_GREEN}✅ Nginx stopped.${C_RESET}"
            else
                echo -e "\n${C_BLUE}▶️ Starting Nginx...${C_RESET}"
                if ff_service_up nginx "Nginx" 2; then
                    echo -e "${C_GREEN}✅ Nginx started.${C_RESET}"
                fi
            fi
            press_enter
            ;;
        2)
            echo -e "\n${C_BLUE}🔄 Restarting Nginx...${C_RESET}"
            if ff_service_up nginx "Nginx" 2; then
                echo -e "${C_GREEN}✅ Nginx restarted.${C_RESET}"
            fi
            press_enter
            ;;
        3) 
             install_nginx_proxy; press_enter
             ;;
        4)
             request_certbot_ssl; press_enter
             ;;
        5)
             purge_nginx; press_enter
             ;;
        0) return ;;
        *) invalid_option ;;
    esac
    done
}

install_panel_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 💻 Install X-UI / 3X-UI Panel ---${C_RESET}"
    echo -e "\n${C_CYAN}Select which panel to install:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-45s %s\n" "🚀 3X-UI Panel (MHSanaei)" "${C_STATUS_A}⭐ Default${C_RESET}"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-45s %s\n" "📦 X-UI Panel (alireza0)" ""
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ❌ Cancel"
    echo
    read -p "👉 Select panel [1]: " panel_choice
    panel_choice=${panel_choice:-1}
    case $panel_choice in
        1) install_3xui_panel ;;
        2) install_xui_panel ;;
        0) echo -e "\n${C_YELLOW}❌ Installation cancelled.${C_RESET}" ;;
        *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" ;;
    esac
}

install_3xui_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Install 3X-UI Panel ---${C_RESET}"
    echo -e "\nThis will download and run the official installation script for 3X-UI (MHSanaei)."
    echo -e "Choose an installation option:\n"
    printf "  ${C_GREEN}[ 1]${C_RESET} %-40s\n" "Install the latest version of 3X-UI"
    printf "  ${C_GREEN}[ 2]${C_RESET} %-40s\n" "Install a specific version of 3X-UI"
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ❌ Cancel Installation"
    echo
    read -p "👉 Select an option: " choice
    case $choice in
        1)
            echo -e "\n${C_BLUE}⚙️ Installing the latest version...${C_RESET}"
            ff_run_remote_installer "https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh" || return
            ;;
        2)
            read -p "👉 Enter the version to install (e.g., 2.4.5): " version
            if [[ -z "$version" ]]; then
                echo -e "\n${C_RED}❌ Version number cannot be empty.${C_RESET}"
                return
            fi
            echo -e "\n${C_BLUE}⚙️ Installing version ${C_YELLOW}$version...${C_RESET}"
            ff_run_remote_installer "https://raw.githubusercontent.com/mhsanaei/3x-ui/v$version/install.sh" "v$version" || return
            ;;
        0)
            echo -e "\n${C_YELLOW}❌ Installation cancelled.${C_RESET}"
            ;;
        *)
            echo -e "\n${C_RED}❌ Invalid option.${C_RESET}"
            ;;
    esac
}

install_xui_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📦 Install X-UI Panel (Legacy) ---${C_RESET}"
    echo -e "\nThis will download and run the installation script for X-UI (alireza0)."
    echo -e "Choose an installation option:\n"
    printf "  ${C_GREEN}[ 1]${C_RESET} %-40s\n" "Install the latest version of X-UI"
    printf "  ${C_GREEN}[ 2]${C_RESET} %-40s\n" "Install a specific version of X-UI"
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ❌ Cancel Installation"
    echo
    read -p "👉 Select an option: " choice
    case $choice in
        1)
            echo -e "\n${C_BLUE}⚙️ Installing the latest version...${C_RESET}"
            ff_run_remote_installer "https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh" || return
            ;;
        2)
            read -p "👉 Enter the version to install (e.g., 1.8.0): " version
            if [[ -z "$version" ]]; then
                echo -e "\n${C_RED}❌ Version number cannot be empty.${C_RESET}"
                return
            fi
            echo -e "\n${C_BLUE}⚙️ Installing version ${C_YELLOW}$version...${C_RESET}"
            VERSION=$version ff_run_remote_installer "https://raw.githubusercontent.com/alireza0/x-ui/$version/install.sh" "$version" || return
            ;;
        0)
            echo -e "\n${C_YELLOW}❌ Installation cancelled.${C_RESET}"
            ;;
        *)
            echo -e "\n${C_RED}❌ Invalid option.${C_RESET}"
            ;;
    esac
}

uninstall_xui_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🗑️ Uninstall X-UI / 3X-UI Panel ---${C_RESET}"
    if ! command -v x-ui &> /dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ No X-UI/3X-UI panel appears to be installed.${C_RESET}"
        return
    fi
    read -p "👉 Are you sure you want to thoroughly uninstall X-UI/3X-UI? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        echo -e "\n${C_BLUE}⚙️ Running the default uninstaller first...${C_RESET}"
        x-ui uninstall >/dev/null 2>&1
        echo -e "\n${C_BLUE}🧹 Performing a full cleanup to ensure complete removal...${C_RESET}"
        echo " - Stopping and disabling x-ui service..."
        systemctl stop x-ui >/dev/null 2>&1
        systemctl disable x-ui >/dev/null 2>&1
        echo " - Removing x-ui files and directories..."
        rm -f /etc/systemd/system/x-ui.service
        rm -f /usr/local/bin/x-ui
        rm -rf /usr/local/x-ui/
        rm -rf /etc/x-ui/
        echo " - Reloading systemd daemon..."
        systemctl daemon-reload
        echo -e "\n${C_GREEN}✅ X-UI/3X-UI has been thoroughly uninstalled.${C_RESET}"
    else
        echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
    fi
}

refresh_ssh_session_cache() {
    local now db_mtime
    printf -v now '%(%s)T' -1
    db_mtime=$(stat -c %Y "$DB_FILE" 2>/dev/null || echo 0)

    if (( SSH_SESSION_CACHE_TS > 0 && now - SSH_SESSION_CACHE_TS < SSH_SESSION_CACHE_TTL && db_mtime == SSH_SESSION_CACHE_DB_MTIME )); then
        return
    fi

    SSH_SESSION_COUNTS=()
    SSH_SESSION_PIDS=()
    SSH_SESSION_TOTAL=0
    SSH_SESSION_CACHE_DB_MTIME=$db_mtime

    if [[ ! -s "$DB_FILE" ]]; then
        SSH_SESSION_CACHE_TS=$now
        return
    fi

    local -A managed_user_lookup=()
    local -A uid_user_lookup=()
    local -A session_pids=()
    local -A loginuid_pids=()
    local managed_user system_user system_uid ssh_pid ssh_owner candidate_user login_uid

    while IFS=: read -r managed_user _rest; do
        [[ -n "$managed_user" && "$managed_user" != \#* ]] && managed_user_lookup["$managed_user"]=1
    done < "$DB_FILE"

    while IFS=: read -r system_user _ system_uid _rest; do
        [[ -n "$system_user" && "$system_uid" =~ ^[0-9]+$ ]] && uid_user_lookup["$system_uid"]="$system_user"
    done < /etc/passwd

    while read -r ssh_pid ssh_owner; do
        [[ "$ssh_pid" =~ ^[0-9]+$ ]] || continue

        # Method 1: process owner matches a managed user directly
        if [[ -n "$ssh_owner" && "$ssh_owner" != "root" && "$ssh_owner" != "sshd" && -n "${managed_user_lookup[$ssh_owner]+x}" ]]; then
            session_pids["$ssh_owner"]+="$ssh_pid "
        fi
    done < <(ps -C sshd,sshd-session -o pid=,user= 2>/dev/null)

    # Method 2: kernel loginuid with comm/PPid validation (more robust — matches limiter logic)
    local p pid_dir pid_num comm ppid_val session_user
    for p in /proc/[0-9]*/loginuid; do
        [[ -f "$p" ]] || continue
        login_uid=""
        read -r login_uid < "$p" || login_uid=""
        [[ "$login_uid" =~ ^[0-9]+$ && "$login_uid" != "4294967295" ]] || continue

        candidate_user="${uid_user_lookup[$login_uid]}"
        [[ -n "$candidate_user" && -n "${managed_user_lookup[$candidate_user]+x}" ]] || continue

        pid_dir=$(dirname "$p")
        pid_num=$(basename "$pid_dir")
        comm=""
        read -r comm < "$pid_dir/comm" 2>/dev/null || comm=""
        [[ "$comm" == "sshd" || "$comm" == "sshd-session" ]] || continue

        # Filter out the master sshd process (PPid=1)
        ppid_val=""
        while read -r key value; do
            [[ "$key" == "PPid:" ]] && { ppid_val="$value"; break; }
        done < "$pid_dir/status" 2>/dev/null
        [[ "$ppid_val" == "1" ]] && continue

        loginuid_pids["$candidate_user"]+="$pid_num "
    done

    local user pid
    for user in "${!managed_user_lookup[@]}"; do
        # CRITICAL: unset before declare to reset per-user (bash declare is function-scoped)
        unset unique_pids
        local -A unique_pids=()

        # Merge BOTH sources (union) — not fallback
        for pid in ${session_pids[$user]} ${loginuid_pids[$user]}; do
            [[ "$pid" =~ ^[0-9]+$ ]] && unique_pids["$pid"]=1
        done

        SSH_SESSION_COUNTS["$user"]=${#unique_pids[@]}
        if (( ${#unique_pids[@]} > 0 )); then
            for pid in "${!unique_pids[@]}"; do
                SSH_SESSION_PIDS["$user"]+="$pid "
            done
            SSH_SESSION_TOTAL=$((SSH_SESSION_TOTAL + ${#unique_pids[@]}))
        fi
    done

    SSH_SESSION_CACHE_TS=$now
}

count_managed_online_sessions() {
    refresh_ssh_session_cache
    echo "$SSH_SESSION_TOTAL"
}

invalidate_banner_cache() {
    BANNER_CACHE_TS=0
    SSH_SESSION_CACHE_TS=0
}

refresh_banner_cache() {
    local now
    printf -v now '%(%s)T' -1
    if (( BANNER_CACHE_TS > 0 && now - BANNER_CACHE_TS < BANNER_CACHE_TTL )); then
        return
    fi

    if [[ -z "$BANNER_CACHE_OS_NAME" ]]; then
        BANNER_CACHE_OS_NAME=$(grep -oP 'PRETTY_NAME="\K[^"]+' /etc/os-release 2>/dev/null || echo "Linux")
    fi
    # Uptime: prefer /proc/uptime (kernel source, always present and reliable).
    # Show weeks + days when up ≥ 24h, else hours + minutes. Fall back to
    # parsing `uptime -p` only if /proc/uptime is unreadable (rare/minimal images).
    local w=0 d=0 h=0 m=0 up_secs=""
    if [[ -r /proc/uptime ]]; then
        read -r up_secs _ < /proc/uptime
        up_secs=${up_secs%.*}
    fi
    if [[ "$up_secs" =~ ^[0-9]+$ ]]; then
        w=$(( up_secs / 604800 ))
        d=$(( (up_secs % 604800) / 86400 ))
        h=$(( (up_secs % 86400) / 3600 ))
        m=$(( (up_secs % 3600) / 60 ))
    else
        local up_p; up_p=$(uptime -p 2>/dev/null | sed 's/up //' || echo "")
        [[ "$up_p" =~ ([0-9]+)[[:space:]]*week ]]   && w=${BASH_REMATCH[1]}
        [[ "$up_p" =~ ([0-9]+)[[:space:]]*day ]]    && d=${BASH_REMATCH[1]}
        [[ "$up_p" =~ ([0-9]+)[[:space:]]*hour ]]   && h=${BASH_REMATCH[1]}
        [[ "$up_p" =~ ([0-9]+)[[:space:]]*minute ]] && m=${BASH_REMATCH[1]}
    fi
    local parts=()
    if (( w > 0 || d > 0 )); then
        # ≥ 24h uptime → weeks + days
        ((w)) && parts+=("${w}w")
        ((d)) && parts+=("${d}d")
    else
        # < 24h uptime → hours + minutes
        ((h)) && parts+=("${h}h")
        ((m)) && parts+=("${m}m")
    fi
    local IFS=' '
    BANNER_CACHE_UP_TIME="${parts[*]}"
    [[ -z "$BANNER_CACHE_UP_TIME" ]] && BANNER_CACHE_UP_TIME="just now"
    BANNER_CACHE_RAM_USAGE=$(free -m | awk '/^Mem:/{if($2>0){printf "%.2f", $3*100/$2}else{print "0.00"}}')
    BANNER_CACHE_CPU_LOAD=$(awk '{print $1}' /proc/loadavg 2>/dev/null)
    if [[ -z "$BANNER_CACHE_IP" ]]; then
        BANNER_CACHE_IP=$(curl -s -4 --max-time 3 icanhazip.com 2>/dev/null || echo "unknown")
    fi
    if [[ -z "$BANNER_CACHE_BASE" ]]; then
        local arch
        arch=$(uname -m 2>/dev/null || echo "unknown")
        case "$arch" in
            x86_64)  BANNER_CACHE_BASE="x64" ;;
            aarch64) BANNER_CACHE_BASE="ARM64" ;;
            armv7l)  BANNER_CACHE_BASE="ARM32" ;;
            i686|i386) BANNER_CACHE_BASE="x86" ;;
            *)       BANNER_CACHE_BASE="$arch" ;;
        esac
    fi
    BANNER_CACHE_CPU_COUNT=$(nproc 2>/dev/null || echo "1")
    if [[ -z "$BANNER_CACHE_DOMAIN" ]]; then
        if [[ -f "$DOMAIN_OVERRIDE_FILE" ]]; then
            BANNER_CACHE_DOMAIN=$(<"$DOMAIN_OVERRIDE_FILE")
        else
            BANNER_CACHE_DOMAIN=$(dig +short -x "$BANNER_CACHE_IP" 2>/dev/null | sed 's/\.$//' || true)
            BANNER_CACHE_DOMAIN="${BANNER_CACHE_DOMAIN:-$(hostname -f 2>/dev/null || hostname 2>/dev/null || echo "unknown")}"
        fi
    fi
    if [[ -s "$DB_FILE" ]]; then
        BANNER_CACHE_TOTAL_USERS=0
        BANNER_CACHE_EXPIRED_USERS=0
        local _today_ts _exp_ts
        _today_ts=$(date +%s)
        while IFS=: read -r _u _p _exp _rest; do
            [[ -n "$_u" && "$_u" != \#* ]] || continue
            # Only count users owned by the current delegated actor
            [[ -n "${VSS_ACTOR:-}" ]] && (_own_get "$_u" != "$VSS_ACTOR") && continue
            (( BANNER_CACHE_TOTAL_USERS++ ))
            _exp_ts=$(date -d "$_exp" +%s 2>/dev/null || echo 0)
            [[ "$_exp_ts" =~ ^[0-9]+$ ]] && (( _exp_ts > 0 && _exp_ts <= _today_ts )) \
                && (( BANNER_CACHE_EXPIRED_USERS++ ))
        done < "$DB_FILE"
    else
        BANNER_CACHE_TOTAL_USERS=0
        BANNER_CACHE_EXPIRED_USERS=0
    fi
    # Memory figures for the stats block (single free(1) call, not top(1) —
    # top -b -n1 blocks ~1s and would defeat this cache entirely).
    read -r BANNER_CACHE_MEM_TOTAL BANNER_CACHE_MEM_USED BANNER_CACHE_MEM_FREE BANNER_CACHE_MEM_BUFF < <(
        free -m | awk '/^Mem:/{printf "%sM %sM %sM %sM", $2, $3, $4, ($6==""?0:$6)}'
    )
    BANNER_CACHE_ONLINE_USERS=$(count_managed_online_sessions)
    BANNER_CACHE_TS=$now
}

show_banner() {
    refresh_banner_cache
    printf '\033[2J\033[H'
    # ADMcgh-style layout: heavy bars, tight line stacking, no blank spacers.
    local BAR="${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
    local DOT="${C_BLUE}∘${C_RESET}"
    # Live enforcement indicators — cheap is-active checks, same as the menu items.
    local _hwid _ushare
    if systemctl is-active --quiet VPS_superScript-hwid-enforcer 2>/dev/null; then
        _hwid="${C_RED}[${C_GREEN}ON${C_RED}]${C_RESET}"
    else
        _hwid="${C_RED}[OFF]${C_RESET}"
    fi
    if systemctl is-active --quiet VPS_superScript-udp-share 2>/dev/null; then
        _ushare="${C_RED}[${C_GREEN}ON${C_RED}]${C_RESET}"
    else
        _ushare="${C_RED}[OFF]${C_RESET}"
    fi
    # CPU load colours red above 70% of core count (mirrors ADMcgh's hot-CPU cue)
    # but uses the cached loadavg rather than a blocking top(1) call.
    local _cpu_col="$C_GREEN"
    awk -v l="${BANNER_CACHE_CPU_LOAD:-0}" -v c="${BANNER_CACHE_CPU_COUNT:-1}" \
        'BEGIN{exit !(l > c*0.7)}' && _cpu_col="$C_RED"

    echo -e "$BAR"
    echo -e "${C_TITLE}           🦅  SkylarSCRIPT | Premium Edition  🦅${C_RESET}"
    echo -e "        ${C_YELLOW}📧 ${SUPPORT_EMAIL}${C_RESET}      ${C_CYAN}📲 ${SUPPORT_TG}${C_RESET}"
    echo -e "$BAR"
    echo -e "  $DOT ${C_YELLOW}IP:${C_RESET}      ${C_GRAY}${BANNER_CACHE_IP}${C_RESET}"
    echo -e "  $DOT ${C_YELLOW}S.O:${C_RESET} ${C_WHITE}${BANNER_CACHE_OS_NAME}${C_RESET}   $DOT ${C_YELLOW}Base:${C_RESET} ${C_WHITE}${BANNER_CACHE_BASE}${C_RESET}   $DOT ${C_YELLOW}CPU's:${C_RESET} ${C_WHITE}${BANNER_CACHE_CPU_COUNT}${C_RESET}"
    # ---------- UPTIME: "2 weeks · 1 day · 1 hour" ----------
    secs=$(cut -d. -f1 /proc/uptime)
    w=$((secs / 604800))
    d=$((secs % 604800 / 86400))
    h=$((secs % 86400 / 3600))
    m=$((secs % 3600 / 60))

    plural() { [ "$1" -eq 1 ] && echo "$1 $2" || echo "$1 ${2}s"; }

    parts=()
    [ "$w" -gt 0 ] && parts+=("$(plural $w week)")
    [ "$d" -gt 0 ] && parts+=("$(plural $d day)")
    [ "$h" -gt 0 ] && parts+=("$(plural $h hour)")
    [ "${#parts[@]}" -eq 0 ] && parts+=("$(plural $m minute)")

    uptime_str=""
    for p in "${parts[@]}"; do
      uptime_str+="${uptime_str:+ · }$p"
    done

    # ---------- LOAD + RAM BAR ----------
    load=$(awk '{print $1}' /proc/loadavg)
    read -r ram_total ram_used <<< "$(free -m | awk '/Mem:/ {print $2, $3}')"

    pct=$(awk -v u="$ram_used" -v t="$ram_total" 'BEGIN {printf "%.1f", u*100/t}')
    filled=$(( ram_used * 10 / ram_total ))
    empty=$(( 10 - filled ))

    bar=""
    for ((i=0; i<filled; i++)); do bar+="▰"; done
    for ((i=0; i<empty;  i++)); do bar+="▱"; done

    # Color: green < 70%, yellow 70-89%, red 90%+
    pct_int=${pct%.*}
    if   [ "$pct_int" -ge 90 ]; then c='\e[31m'
    elif [ "$pct_int" -ge 70 ]; then c='\e[33m'
    else                             c='\e[32m'
    fi
    RESET='\e[0m'

    echo -e "  $DOT ${C_YELLOW}UPTIME:${C_RESET}   ${C_GREEN}${uptime_str}${C_RESET}"
    echo -e "  $DOT ${C_YELLOW}USERS:${C_RESET}   ${C_GREEN}${BANNER_CACHE_TOTAL_USERS} managed · ${BANNER_CACHE_ONLINE_USERS} online · ${BANNER_CACHE_EXPIRED_USERS} expired${C_RESET}"
    echo -e "  $DOT ${C_YELLOW}LOCKS:${C_RESET}   ${C_YELLOW}HWID ${_hwid} · UDP-LOCK ${_ushare}${C_RESET}"
    
    # STATUS line with RAM bar - fixed width to keep ports aligned
    # Column width after "STATUS:" label is 34 characters
    local status_width=34
    local status_content="load ${_cpu_col}${load}${C_RESET} · ${c}${bar}${RESET} ${pct}%"
    local status_len=${#status_content}
    local status_pad=$(( status_width - status_len ))
    status_pad=$(( status_pad < 0 ? 0 : status_pad ))
    local status_padding=""
    for ((i=0; i<status_pad; i++)); do status_padding+=" "; done
    
    echo -e "  $DOT ${C_YELLOW}STATUS:${C_RESET} ${status_padding}${status_content}"
    echo -e ""

    _add_port "SSH"         "ssh"                "22"
    _add_port "ZiVPN"       "zivpn.service"      "${ZIVPN_LISTEN_PORT:-5667}"
    _add_port "UDP-Custom"  "udp-custom"         "${UDP_CUSTOM_LISTEN_PORT:-36712}"
    _add_port "BadVPN"      "badvpn"             "${BADVPN_LISTEN_PORT:-7300}"
    _add_port "FalconProxy" "falconproxy"        "$(grep -oP '^PORTS="\K[^"]*' "$FALCONPROXY_CONFIG_FILE" 2>/dev/null | cut -d',' -f1 | grep . || echo "${FALCONPROXY_PORT:-8080}")"
    _add_port "DNSTT"       "dnstt.service"      "53"
    _add_port "Dropbear"    "dropbear"           "${DROPBEAR_PORTS:-109,143}"
    _add_port "Nginx"       "nginx"              "${NGINX_INTERNAL_HTTP_PORT:-8880}/${NGINX_INTERNAL_TLS_PORT:-8443}"
    _add_port "OpenVPN"     "openvpn@server-tcp" "${OPENVPN_TCP_PORT:-1194}"
    _add_port "WireGuard"   "wg-quick@wg0"       "${WIREGUARD_PORT:-51820}"
    _add_port "Hysteria"    "hysteria-server"    "${HYSTERIA2_PORT:-20001}"
    _add_port "ShadowSocks" "shadowsocks-libev"  "${SHADOWSOCKS_PORT:-2443}"
    _add_port "Socks5"      "danted"             "${SOCKS5_PORT:-1080}"
    _add_port "Stunnel"     "stunnel4"           "${STUNNEL_PORT:-777}"
    _add_port "WS-SSH"      "ws-ssh"             "${WS_SSH_INTERNAL_PORT:-2080}"

    local pi a b; local total=${#p_ent[@]}
    if (( total > 0 )); then
        for ((pi=0; pi<total; pi+=2)); do
            a="${p_ent[pi]}"
            b=""
            (( pi+1 < total )) && b="${p_ent[pi+1]}"
            if [[ -n "$b" ]]; then
                printf '%s  %*s %s\n' "$a" 30 "$b"
            else
                printf '%s\n' "$a"
            fi
        done
    fi

    echo -e "$BAR"
}

# Coloured (Active)/(Inactive) tag for a systemd unit. Replaces the ~20
# hand-written status locals the protocol menu used to compute up front.
_pstat() {
    if systemctl is-active --quiet "$1" 2>/dev/null; then
        printf '%s' "🟢"
    else
        printf '%s' "🔴"
    fi
}

# The protocol roster, shared by the install and uninstall submenus so the
# numbering can never drift between them. Format: number|label|unit
_PROTO_LIST=(
    "01|BADVPN|badvpn"
    "02|UDP-CUSTOM|udp-custom"
    "03|DNSTT (SLOWDNS)|dnstt.service"
    "04|FALCON PROXY|falconproxy"
    "05|ZIVPN|zivpn.service"
    "06|DROPBEAR|dropbear"
    "07|OPENVPN|openvpn@server-tcp"
    "08|WIREGUARD|wg-quick@wg0"
    "09|HYSTERIA 1/2|hysteria-server"
    "10|SHADOWSOCKS|shadowsocks-libev"
    "11|SOCKS5 PROXY|danted"
    "12|STUNNEL|stunnel4"
    "13|WS-SSH|ws-ssh"
)

# Print the roster two per row with live status tags. $1 is the arrow/verb
# colour hint: "in" for installs, "un" for uninstalls.
_proto_grid() {
    local mode="$1" i total=${#_PROTO_LIST[@]}
    local n1 l1 u1 n2 l2 u2
    for ((i=0; i<total; i+=2)); do
        IFS='|' read -r n1 l1 u1 <<<"${_PROTO_LIST[i]}"
        if (( i+1 < total )); then
            IFS='|' read -r n2 l2 u2 <<<"${_PROTO_LIST[i+1]}"
            printf "\033[3G${C_PURPLE}[${C_GREEN}%s${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-18s${C_RESET}%s\033[34G${C_PURPLE}[${C_GREEN}%s${C_PURPLE}]${C_RESET}\033[40G${C_WARN}⇨${C_RESET} ${C_WHITE}%-18s${C_RESET}%s\033[K\n" \
                "$n1" "$l1" "$(_pstat "$u1")" "$n2" "$l2" "$(_pstat "$u2")"
        else
            printf "\033[3G${C_PURPLE}[${C_GREEN}%s${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-18s${C_RESET}%s\033[K\n" \
                "$n1" "$l1" "$(_pstat "$u1")"
        fi
    done
}

# Panels kept separate from the protocol lists, as they are a different kind of
# thing (web UIs, not tunnels) and there are only two actions.
panel_manage_menu() {
    while true; do
        show_banner
        local xui_st
        if command -v x-ui &>/dev/null; then
            xui_st="${C_STATUS_A}(Installed)${C_RESET}"
        else
            xui_st="${C_STATUS_I}(Not Installed)${C_RESET}"
        fi
        echo -e "  ${C_TITLE}              💻 MANAGEMENT PANELS${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        printf "\033[3G${C_PURPLE}[${C_GREEN}01${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-28s${C_RESET}%s\033[K\n" "📥 INSTALL X-UI / 3X-UI" "$xui_st"
        _mi "02" "🗑️ UNINSTALL X-UI / 3X-UI"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ BACK ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" pc; then
            echo; return
        fi
        case $pc in
            01|1) install_panel_menu; press_enter ;;
            02|2) uninstall_xui_panel; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

install_protocols_menu() {
    while true; do
        show_banner
        echo -e "  ${C_TITLE}                📥 INSTALL PROTOCOLS${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        _proto_grid in
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ BACK ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select protocol to install: "${C_RESET})" ic; then
            echo; return
        fi
        case $ic in
            01|1)  install_badvpn; press_enter ;;
            02|2)  install_udp_custom; press_enter ;;
            03|3)  install_dnstt; press_enter ;;
            04|4)  install_falcon_proxy; press_enter ;;
            05|5)  install_zivpn; press_enter ;;
            06|6)  install_dropbear; press_enter ;;
            07|7)  install_openvpn; press_enter ;;
            08|8)  install_wireguard; press_enter ;;
            09|9)  install_hysteria; press_enter ;;
            10) install_shadowsocks; press_enter ;;
            11) install_socks5; press_enter ;;
            12) install_stunnel; press_enter ;;
            13) install_ws_ssh; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

uninstall_protocols_menu() {
    while true; do
        show_banner
        echo -e "  ${C_DANGER}               🗑️ UNINSTALL PROTOCOLS${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        _proto_grid un
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ BACK ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select protocol to uninstall: "${C_RESET})" uc; then
            echo; return
        fi
        case $uc in
            01|1)  uninstall_badvpn; press_enter ;;
            02|2)  uninstall_udp_custom; press_enter ;;
            03|3)  uninstall_dnstt; press_enter ;;
            04|4)  uninstall_falcon_proxy; press_enter ;;
            05|5)  uninstall_zivpn; press_enter ;;
            06|6)  uninstall_dropbear; press_enter ;;
            07|7)  uninstall_openvpn; press_enter ;;
            08|8)  uninstall_wireguard; press_enter ;;
            09|9)  uninstall_hysteria; press_enter ;;
            10) uninstall_shadowsocks; press_enter ;;
            11) uninstall_socks5; press_enter ;;
            12) uninstall_stunnel; press_enter ;;
            13) uninstall_ws_ssh; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

protocol_menu() {
    while true; do
        show_banner
        # Only the four statuses this hub actually shows. The per-protocol
        # status tags now live in _proto_grid, computed on demand by _pstat.
        local nginx_status; nginx_status=$(_pstat nginx)
        local xui_status
        if command -v x-ui &>/dev/null; then xui_status="${C_STATUS_A}(Installed)${C_RESET}"; else xui_status="${C_STATUS_I}(Not Installed)${C_RESET}"; fi
        local hwid_status; if systemctl is-active --quiet VPS_superScript-hwid-enforcer 2>/dev/null; then hwid_status="${C_STATUS_A}(On)${C_RESET}"; else hwid_status="${C_STATUS_I}(Off)${C_RESET}"; fi
        local udpshare_status; if systemctl is-active --quiet VPS_superScript-udp-share 2>/dev/null; then udpshare_status="${C_STATUS_A}(On)${C_RESET}"; else udpshare_status="${C_STATUS_I}(Off)${C_RESET}"; fi
        echo -e "  ${C_TITLE}           🔌 PROTOCOL & PANEL MANAGEMENT${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        _mi "01" "📥 INSTALL PROTOCOLS" "▸"
        _mi "02" "🗑️ UNINSTALL PROTOCOLS" "▸"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        printf "\033[3G${C_PURPLE}[${C_GREEN}03${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-28s${C_RESET}%s\033[K\n" "💻 X-UI / 3X-UI PANEL" "$xui_status"
        printf "\033[3G${C_PURPLE}[${C_GREEN}04${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-28s${C_RESET}%s\033[K\n" "🌐 INTERNAL NGINX (8880/8443)" "$nginx_status"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        printf "\033[3G${C_PURPLE}[${C_GREEN}05${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-28s${C_RESET}%s\033[K\n" "🔒 HWID LOCK" "$hwid_status"
        printf "\033[3G${C_PURPLE}[${C_GREEN}06${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%-28s${C_RESET}%s\033[K\n" "🚦 UDP ANTI-SHARING" "$udpshare_status"
        _mi "07" "🚀 EXCLUDE PORTS (udp-custom / DNSTT)"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ BACK ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
            echo
            return
        fi
        case $choice in
            01|1) install_protocols_menu ;;
            02|2) uninstall_protocols_menu ;;
            03|3) panel_manage_menu ;;
            04|4) nginx_proxy_menu ;;
            05|5) hwid_lock_menu ;;
            06|6) udp_share_menu ;;
            07|7) manage_udp_custom_exclude; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

set_domain() {
    echo
    echo -e "${C_TITLE}--- 🌐 Set Custom Domain ---${C_RESET}"
    echo -e "${C_DIM}💡 Don't have a domain? Use DuckDNS (Integrations → option 3) to get a${C_RESET}"
    echo -e "${C_DIM}   free subdomain like ${C_CYAN}yourname.duckdns.org${C_RESET}"
    echo
    local current=""
    if [[ -f "$DOMAIN_OVERRIDE_FILE" ]]; then
        current=$(<"$DOMAIN_OVERRIDE_FILE")
        echo -e "${C_GRAY}Current override:${C_RESET} ${C_GREEN}$current${C_RESET}"
    else
        echo -e "${C_GRAY}No custom domain set. Using auto-detected value.${C_RESET}"
    fi
    echo
    read -r -p "$(echo -e ${C_PROMPT}"👉 Enter domain (leave empty to clear override): "${C_RESET})" new_domain
    if [[ -z "$new_domain" ]]; then
        rm -f "$DOMAIN_OVERRIDE_FILE"
        echo -e "${C_GREEN}✅ Domain override cleared. Will auto-detect on next refresh.${C_RESET}"
    else
        echo "$new_domain" > "$DOMAIN_OVERRIDE_FILE"
        echo -e "${C_GREEN}✅ Domain set to: ${new_domain}${C_RESET}"
    fi
    BANNER_CACHE_DOMAIN=""
    press_enter
}

uninstall_script() {
    clear; show_banner
    echo -e "${C_RED}=====================================================${C_RESET}"
    echo -e "${C_RED}       🔥 DANGER: UNINSTALL SCRIPT & ALL DATA 🔥      ${C_RESET}"
    echo -e "${C_RED}=====================================================${C_RESET}"
    echo -e "${C_YELLOW}This will PERMANENTLY remove this script and all its components, including:"
    echo -e " - The main command ($(command -v menu))"
    echo -e " - All configuration and user data ($DB_DIR)"
    echo -e " - The active limiter service ($LIMITER_SERVICE)"
    echo -e " - All installed services (badvpn, udp-custom, Nginx, DNSTT)"
    echo -e "\n${C_RED}This action is irreversible.${C_RESET}"
    echo ""
    read -p "👉 Type 'yes' to confirm and proceed with uninstallation: " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo -e "\n${C_GREEN}✅ Uninstallation cancelled.${C_RESET}"
        return
    fi
    local -a removable_users=()
    local remove_users_confirm
    local remove_users_on_uninstall=false
    mapfile -t removable_users < <(get_VPS_superScript_known_users)
    if [[ ${#removable_users[@]} -gt 0 ]]; then
        echo -e "\n${C_YELLOW}VPS_superScript SSH users detected on this VPS:${C_RESET} ${removable_users[*]}"
        read -p "👉 Do you also want to permanently delete these SSH users before uninstalling? (y/n): " remove_users_confirm
        if [[ "$remove_users_confirm" == "y" || "$remove_users_confirm" == "Y" ]]; then
            remove_users_on_uninstall=true
        fi
    fi
    export UNINSTALL_MODE="silent"
    echo -e "\n${C_BLUE}--- 💥 Starting Uninstallation 💥 ---${C_RESET}"
    
    if [[ "$remove_users_on_uninstall" == "true" ]]; then
        echo -e "\n${C_BLUE}🗑️ Removing VPS_superScript SSH users before uninstall...${C_RESET}"
        delete_VPS_superScript_user_accounts "${removable_users[@]}"
    fi
    
    echo -e "\n${C_BLUE}🗑️ Removing active limiter service...${C_RESET}"
    systemctl stop VPS_superScript-limiter &>/dev/null
    systemctl disable VPS_superScript-limiter &>/dev/null
    rm -f "$LIMITER_SERVICE"
    rm -f "$LIMITER_SCRIPT"
    
    echo -e "\n${C_BLUE}🗑️ Removing bandwidth monitoring service...${C_RESET}"
    systemctl stop VPS_superScript-bandwidth &>/dev/null
    systemctl disable VPS_superScript-bandwidth &>/dev/null
    rm -f "$BANDWIDTH_SERVICE"
    rm -f "$BANDWIDTH_SCRIPT"
    rm -rf "$LEGACY_BANDWIDTH_DIR"
    rm -f "$TRIAL_CLEANUP_SCRIPT"
    
    echo -e "\n${C_BLUE}\ud83d\uddd1\ufe0f Removing SSH login banner...${C_RESET}"
    rm -f "$LOGIN_INFO_SCRIPT"
    rm -f "$SSHD_FF_CONFIG"
    systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
    
    chattr -i /etc/resolv.conf &>/dev/null

    purge_nginx "silent"
    uninstall_dnstt
    uninstall_badvpn
    uninstall_udp_custom
    cleanup_legacy_haproxy
    uninstall_falcon_proxy
    uninstall_zivpn
    uninstall_dropbear 2>/dev/null
    uninstall_openvpn 2>/dev/null
    uninstall_wireguard 2>/dev/null
    uninstall_hysteria 2>/dev/null
    uninstall_shadowsocks 2>/dev/null
    uninstall_socks5 2>/dev/null
    uninstall_stunnel 2>/dev/null
    uninstall_ws_ssh 2>/dev/null
    systemctl stop rest-api 2>/dev/null; systemctl disable rest-api 2>/dev/null
    echo -e "\n${C_BLUE}🗑️ Removing HWID lock enforcer...${C_RESET}"
    systemctl stop VPS_superScript-hwid-enforcer &>/dev/null
    systemctl disable VPS_superScript-hwid-enforcer &>/dev/null
    rm -f "$HWID_ENFORCER_SERVICE" "$HWID_ENFORCER_SCRIPT"
    _hwid_flush_drops

    echo -e "\n${C_BLUE}🗑️ Removing UDP anti-sharing enforcer...${C_RESET}"
    systemctl stop VPS_superScript-udp-share &>/dev/null
    systemctl disable VPS_superScript-udp-share &>/dev/null
    rm -f "$UDP_SHARE_ENFORCER_SERVICE" "$UDP_SHARE_ENFORCER_SCRIPT"
    while true; do
        _ushare_rn=$(iptables -L INPUT --line-numbers -n 2>/dev/null | grep "ffudpshare" | head -n1 | awk '{print $1}')
        [[ -z "$_ushare_rn" ]] && break
        iptables -D INPUT "$_ushare_rn" 2>/dev/null || break
    done
    if [[ -f "$DB_DIR/udp_share.locks" ]]; then
        while read -r _lu _lts; do
            [[ -n "$_lu" ]] && usermod -U "$_lu" 2>/dev/null
        done < "$DB_DIR/udp_share.locks"
        rm -f "$DB_DIR/udp_share.locks"
    fi
    
    echo -e "\n${C_BLUE}🔄 Reloading systemd daemon...${C_RESET}"
    systemctl daemon-reload
    
    echo -e "\n${C_BLUE}🗑️ Removing script and configuration files...${C_RESET}"
    rm -f "$BADVPN_BINARY"
    rm -rf "$BADVPN_BUILD_DIR"
    rm -rf "$UDP_CUSTOM_DIR"
    # Back up user database before removal so a reinstall can restore it.
    echo -e "\n${C_BLUE}🗑️ Removing DuckDNS auto-update cron...${C_RESET}"
    crontab -l 2>/dev/null | grep -v "duckdns.org/update" | crontab - 2>/dev/null && echo -e "${C_GREEN}✅ DuckDNS cron removed${C_RESET}" || true

    if [[ -d "$DB_DIR" ]]; then
        local _db_backup="/etc/.VPS_superScript-db-backup"
        rm -rf "$_db_backup" 2>/dev/null
        cp -a "$DB_DIR" "$_db_backup" 2>/dev/null && echo -e "${C_GREEN}📦 User database backed up to $_db_backup${C_RESET}"
    fi
    rm -rf "$DB_DIR"
    rm -f "$(command -v menu)"
    
    echo -e "\n${C_GREEN}=============================================${C_RESET}"
    echo -e "${C_GREEN}      Script has been successfully uninstalled.     ${C_RESET}"
    echo -e "${C_GREEN}=============================================${C_RESET}"
    echo -e "\nAll associated files and services have been removed."
    echo "The 'menu' command will no longer work."
    exit 0
}

# --- NEW FEATURES ---

create_trial_account() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- ⏱️ Create Trial/Test Account ---${C_RESET}"
    
    # Ensure 'at' daemon is available
    if ! command -v at &>/dev/null; then
        echo -e "${C_YELLOW}⚠️ 'at' command not found. Installing...${C_RESET}"
        ff_pkg_install at >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to install 'at'. Cannot schedule auto-expiry.${C_RESET}"
            return
        }
        systemctl enable atd &>/dev/null
        systemctl start atd &>/dev/null
    fi
    
    # Ensure atd is running
    if ! systemctl is-active --quiet atd; then
        systemctl start atd &>/dev/null
    fi
    
    echo -e "\n${C_CYAN}Enter trial duration (official format). Examples: 30m · 2h · 1d · 2d4h30m${C_RESET}"
    local duration_input=""
    read -p "🗓️ Duration (e.g. 30m, 2h, 1d, 2d4h30m): " duration_input
    if [[ -z "$duration_input" ]]; then
        echo -e "\n${C_YELLOW}❌ Cancelled.${C_RESET}"; return
    fi
    local duration_secs=0
    duration_secs=$(_ff_dur_to_seconds "$duration_input")
    if [[ "$duration_secs" -lt 60 ]]; then
        echo -e "\n${C_RED}❌ Invalid duration (minimum 1 minute). Use e.g. 30m, 2h, 1d, 2d4h30m.${C_RESET}"; return
    fi
    local duration_minutes=$(( (duration_secs + 59) / 60 ))
    
    # Username
    local rand_suffix=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 5)
    local default_username="trial_${rand_suffix}"
    read -p "👤 Username [${default_username}]: " username
    username=${username:-$default_username}
    
    if id "$username" &>/dev/null || grep -q "^$username:" "$DB_FILE"; then
        echo -e "\n${C_RED}❌ Error: User '$username' already exists.${C_RESET}"; return
    fi
    if [[ -n "${VSS_ACTOR:-}" ]] && ! _ff_valid_managed_username "$username"; then
        echo -e "\n${C_RED}❌ Invalid username. Use lowercase letters, numbers, '_' or '-' (must start with a letter/underscore).${C_RESET}"; return
    fi

    # Password
    local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
    read -p "🔑 Password [${password}]: " custom_pass
    password=${custom_pass:-$password}
    
    # Connection limit
    read -p "📶 Connection limit [1]: " limit
    limit=${limit:-1}
    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    # Bandwidth quota (OnePesewa-style: 100MB / 1GB / 10GB; 0 = unlimited).
    read -p "📦 Data quota (e.g. 100MB, 1GB, 10GB; 0 = unlimited) [100MB]: " quota_input
    quota_input=${quota_input:-100MB}
    if ! _ff_quota_valid "$quota_input"; then echo -e "\n${C_RED}❌ Invalid quota. Use e.g. 100MB, 1GB.${C_RESET}"; return; fi
    local bandwidth_gb; bandwidth_gb=$(_ff_quota_canonical "$quota_input")
    
    # App type selector
    local app="http"
    echo -e "\n${C_DIM}Select target application:${C_RESET}"
    printf "  ${C_GREEN}[1]${C_RESET} %-16s ${C_DIM}(HTTP Custom)${C_RESET}\n" "HTTP Custom"
    printf "  ${C_GREEN}[2]${C_RESET} %-16s ${C_DIM}(ZiVPN)${C_RESET}\n" "ZiVPN"
    read -p "👉 App type [1]: " app_choice
    app_choice=${app_choice:-1}
    case "$app_choice" in
        2|z|Z|zivpn|ZiVPN)           app="zivpn" ;;
        *)                           app="http" ;;
    esac

    # Calculate expiry from the exact duration in seconds. chage gets the
    # rounded-up date; the precise .ts file drives the real cutoff.
    local expire_date expiry_timestamp expiry_epoch
    expire_date=$(date -d "+${duration_secs} seconds" +%Y-%m-%d)
    [[ "$expire_date" == "$(date +%Y-%m-%d)" ]] && expire_date=$(date -d "tomorrow" +%Y-%m-%d)
    expiry_timestamp=$(date -d "+${duration_secs} seconds" '+%Y-%m-%d %H:%M:%S')
    expiry_epoch=$(( $(date +%s) + duration_secs ))

    # Create the system user
    ensure_VPS_superScript_system_group
    useradd -m -s /usr/sbin/nologin "$username"
    usermod -aG "$FF_USERS_GROUP" "$username" 2>/dev/null
    if ! _ff_set_password "$username" "$password"; then
        echo -e "\n${C_RED}❌ Could not set a password for trial user '$username'; aborting.${C_RESET}"
        userdel -r "$username" &>/dev/null
        read -p "Press [Enter] to continue..."
        return
    fi
    chage -E "$expire_date" "$username"
    echo "$username:$password:$expire_date:$limit:$bandwidth_gb:trial::0:$app" >> "$DB_FILE"
    [[ -n "${VSS_ACTOR:-}" ]] && _own_set "$username" "$VSS_ACTOR"
    mkdir -p "$CREATED_DIR"; printf '%s\n' "$(date +%s)" > "$CREATED_DIR/${username}"

    if [[ "$app" == "zivpn" ]]; then
        if ! command -v jq &>/dev/null; then
            echo -e "${C_YELLOW}⚠️ 'jq' not installed — could not add password to ZiVPN config. Install jq, then re-add.${C_RESET}"
        elif [[ ! -f "$ZIVPN_CONFIG_FILE" ]]; then
            echo -e "${C_YELLOW}⚠️ ZiVPN config ($ZIVPN_CONFIG_FILE) not found — is ZiVPN installed?${C_RESET}"
        elif _ff_zivpn_add_pass "$password"; then
            systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
        fi
    fi

    # ── OpenVPN per-user config ──
    if [[ "$app" == "openvpn" && -d /etc/openvpn/easy-rsa/pki ]]; then
        local _ovpn_ip; _ovpn_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        ( cd /etc/openvpn/easy-rsa 2>/dev/null && EASYRSA_BATCH=1 ./easyrsa build-client-full "$username" nopass 2>/dev/null )
        local _ovpn_file="$EXPORTS_DIR/${username}.ovpn"
        mkdir -p "$EXPORTS_DIR" 2>/dev/null
        cat > "$_ovpn_file" <<OVPNEOF
client
dev tun
proto tcp
remote ${_ovpn_ip} ${OPENVPN_TCP_PORT}
<connection>
remote ${_ovpn_ip} ${OPENVPN_UDP_PORT}
proto udp
</connection>
<connection>
remote ${_ovpn_ip} ${OPENVPN_SDNS_PORT}
proto udp
</connection>
resolv-retry infinite
nobind
persist-key
persist-tun
auth SHA256
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
auth-user-pass
<ca>
$(cat /etc/openvpn/easy-rsa/pki/ca.crt 2>/dev/null)
</ca>
<cert>
$(cat /etc/openvpn/easy-rsa/pki/issued/${username}.crt 2>/dev/null)
</cert>
<key>
$(cat /etc/openvpn/easy-rsa/pki/private/${username}.key 2>/dev/null)
</key>
<tls-auth>
$(cat /etc/openvpn/ta.key 2>/dev/null)
</tls-auth>
key-direction 1
OVPNEOF
        echo -e "\n${C_GREEN}✅ OpenVPN config generated: ${C_YELLOW}$_ovpn_file${C_RESET}"
    fi

    # ── WireGuard per-user config ──
    if [[ "$app" == "wireguard" && -f /etc/wireguard/wg0.conf ]]; then
        local _wg_ip; _wg_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        local _wg_priv; _wg_priv=$(wg genkey)
        local _wg_pub; _wg_pub=$(echo "$_wg_priv" | wg pubkey)
        local _wg_srv_pub; _wg_srv_pub=$(cat /etc/wireguard/server.pub 2>/dev/null)
        local _wg_file="$EXPORTS_DIR/${username}.conf"
        mkdir -p "$EXPORTS_DIR" 2>/dev/null
        local _wg_octet=2
        local _wg_last; _wg_last=$(grep -oP '10\.66\.66\.\d+' /etc/wireguard/wg0.conf 2>/dev/null | sort -t. -k4 -n | tail -1)
        [[ -n "$_wg_last" ]] && _wg_octet=$((${_wg_last##*.} + 1))
        local _wg_addr="10.66.66.${_wg_octet}"
        cat >> /etc/wireguard/wg0.conf <<WGPEOF
# BEGIN ${username}
[Peer]
PublicKey = ${_wg_pub}
AllowedIPs = ${_wg_addr}/32
# END ${username}
WGPEOF
        cat > "$_wg_file" <<WGCEOF
[Interface]
PrivateKey = ${_wg_priv}
Address = ${_wg_addr}/24
DNS = 8.8.8.8, 1.1.1.1
[Peer]
PublicKey = ${_wg_srv_pub}
Endpoint = ${_wg_ip}:${WIREGUARD_PORT}
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
WGCEOF
        wg-quick down wg0 2>/dev/null; wg-quick up wg0 2>/dev/null
        echo -e "\n${C_GREEN}✅ WireGuard config generated: ${C_YELLOW}$_wg_file${C_RESET}"
    fi

    # ── Hysteria2 per-user config ──
    if [[ "$app" == "hysteria2" && -f /etc/hysteria/config.json ]] && command -v jq &>/dev/null; then
        local _hy_ip; _hy_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        local _hy_file="$EXPORTS_DIR/${username}-hysteria.json"
        mkdir -p "$EXPORTS_DIR" 2>/dev/null
        local _tmp; _tmp=$(mktemp) 2>/dev/null || true
        if [[ -n "$_tmp" ]]; then
            jq --arg u "$username" --arg p "$password" '.auth.config += [{"user": $u, "pass": $p}]' /etc/hysteria/config.json > "$_tmp" 2>/dev/null && mv "$_tmp" /etc/hysteria/config.json
            rm -f "$_tmp" 2>/dev/null
        fi
        cat > "$_hy_file" <<HYCEOF
{
  "server": "${_hy_ip}:${HYSTERIA2_PORT}",
  "auth": "${password}",
  "tls": { "sni": "${_hy_ip}", "insecure": true },
  "quic": { "initStreamReceiveWindow": 8388608, "maxIdleTimeout": "30s", "keepAliveInterval": "10s" },
  "fastOpen": true,
  "lazy": true,
  "socks5": { "listen": "127.0.0.1:1080" }
}
HYCEOF
        systemctl restart hysteria-server 2>/dev/null
        echo -e "\n${C_GREEN}✅ Hysteria2 config generated: ${C_YELLOW}$_hy_file${C_RESET}"
    fi

    # Record the precise expiry epoch so the limiter can enforce sub-day
    # trials even if the 'at' job is lost (reboot, atd restart, etc.).
    mkdir -p "$TRIAL_EXPIRY_DIR"
    printf '%s\n' "$expiry_epoch" > "$TRIAL_EXPIRY_DIR/${username}.ts"

    # Schedule auto-cleanup via 'at' (best-effort; limiter is the safety net)
    echo "$TRIAL_CLEANUP_SCRIPT $username" | at now + ${duration_minutes} minutes 2>/dev/null
    
    local bw_display; bw_display=$(_ff_quota_label "$bandwidth_gb")
    local duration_human; duration_human=$(expiry_human_left "$duration_secs")

    clear; show_banner
    echo -e "${C_GREEN}✅ Trial account created successfully!${C_RESET}\n"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "  ⏱️  ${C_BOLD}TRIAL ACCOUNT${C_RESET}"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "  - 👤 Username:          ${C_YELLOW}$username${C_RESET}"
    echo -e "  - 🔑 Password:          ${C_YELLOW}$password${C_RESET}"
    echo -e "  - ⏱️ Duration:          ${C_GREEN}$duration_human${C_RESET}"
    echo -e "  - 🕐 Auto-expires at:   ${C_RED}$expiry_timestamp${C_RESET}"
    echo -e "  - 📶 Connection Limit:  ${C_YELLOW}$limit${C_RESET}"
    echo -e "  - 📦 Bandwidth Limit:   ${C_YELLOW}$bw_display${C_RESET}"
    if [[ "$app" == "http" ]]; then
        local _udp_ip; _udp_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
        echo -e "  - 📡 UDP-CUSTOM:        ${C_CYAN}${_udp_ip}:1-65535@${username}:${password}${C_RESET}"
    fi
    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "\n${C_DIM}The account will be automatically deleted when the trial expires.${C_RESET}"
    
    # Auto-ask for config generation
    echo
    read -p "👉 Generate client config for this trial user? (y/n): " gen_conf
    if [[ "$gen_conf" == "y" || "$gen_conf" == "Y" ]]; then
        generate_client_config "$username" "$password"
    fi
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

bulk_create_users() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 👥 Bulk Create Users ---${C_RESET}"
    
    read -p "👉 Enter username prefix (e.g., 'user'): " prefix
    if [[ -z "$prefix" ]]; then echo -e "\n${C_RED}❌ Prefix cannot be empty.${C_RESET}"; return; fi
    if [[ -n "${VSS_ACTOR:-}" ]] && ! _ff_valid_managed_username "$prefix"; then
        echo -e "\n${C_RED}❌ Invalid prefix. Use lowercase letters, numbers, '_' or '-' (must start with a letter/underscore).${C_RESET}"; return
    fi
    
    read -p "🔢 How many users to create? " count
    if ! [[ "$count" =~ ^[0-9]+$ ]] || [[ "$count" -lt 1 ]] || [[ "$count" -gt 100 ]]; then
        echo -e "\n${C_RED}❌ Invalid count (1-100).${C_RESET}"; return
    fi
    
    read -p "🗓️ Account duration (e.g. 30d, 7d, 2d4h30m) [30d]: " duration_input
    duration_input=${duration_input:-30d}
    local duration_secs; duration_secs=$(_ff_dur_to_seconds "$duration_input")
    if [[ "$duration_secs" -le 0 ]]; then echo -e "\n${C_RED}❌ Invalid duration. Use e.g. 30d, 7d, 2d4h30m.${C_RESET}"; return; fi
    local duration_display; duration_display=$(expiry_human_left "$duration_secs")
    
    read -p "📶 Connection limit per user [1]: " limit
    limit=${limit:-1}
    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    read -p "📦 Bandwidth quota per user (e.g. 500MB, 1GB; 0 = unlimited) [0]: " quota_input
    quota_input=${quota_input:-0}
    if ! _ff_quota_valid "$quota_input"; then echo -e "\n${C_RED}❌ Invalid quota. Use e.g. 500MB, 1GB.${C_RESET}"; return; fi
    local bandwidth_gb; bandwidth_gb=$(_ff_quota_canonical "$quota_input")

    # App type for all bulk users
    local app="http"
    echo -e "\n${C_DIM}Select target application for all users:${C_RESET}"
    printf "  ${C_GREEN}[1]${C_RESET} %-16s ${C_DIM}(HTTP Custom)${C_RESET}\n" "HTTP Custom"
    printf "  ${C_GREEN}[2]${C_RESET} %-16s ${C_DIM}(ZiVPN)${C_RESET}\n" "ZiVPN"
    read -p "👉 App type [1]: " app_choice
    app_choice=${app_choice:-1}
    case "$app_choice" in
        2|z|Z|zivpn|ZiVPN)           app="zivpn" ;;
        *)                           app="http" ;;
    esac

    local expire_date
    expire_date=$(date -d "+${duration_secs} seconds" +%Y-%m-%d)
    [[ "$expire_date" == "$(date +%Y-%m-%d)" ]] && expire_date=$(date -d "tomorrow" +%Y-%m-%d)
    local bw_display; bw_display=$(_ff_quota_label "$bandwidth_gb")
    local duration_display; duration_display=$(expiry_human_left "$duration_secs")
    ensure_VPS_superScript_system_group
    
    echo -e "\n${C_BLUE}⚙️ Creating $count users with prefix '${prefix}'...${C_RESET}\n"
    echo -e "${C_YELLOW}================================================================${C_RESET}"
    printf "${C_BOLD}${C_WHITE}%-20s | %-15s | %-20s${C_RESET}\n" "USERNAME" "PASSWORD" "EXPIRES"
    echo -e "${C_YELLOW}----------------------------------------------------------------${C_RESET}"
    
    local created=0
    for ((i=1; i<=count; i++)); do
        local username="${prefix}${i}"
        if id "$username" &>/dev/null || grep -q "^$username:" "$DB_FILE"; then
            echo -e "${C_RED}  ⚠️ Skipping '$username' — already exists${C_RESET}"
            continue
        fi
        local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
        useradd -m -s /usr/sbin/nologin "$username"
        usermod -aG "$FF_USERS_GROUP" "$username" 2>/dev/null
        if ! _ff_set_password "$username" "$password"; then
            echo -e "${C_RED}  ⚠️ Skipping '$username' — could not set a password on this host.${C_RESET}"
            userdel -r "$username" &>/dev/null
            continue
        fi
        chage -E "$expire_date" "$username"
        echo "$username:$password:$expire_date:$limit:$bandwidth_gb:::0:$app" >> "$DB_FILE"
        [[ -n "${VSS_ACTOR:-}" ]] && _own_set "$username" "$VSS_ACTOR"
        mkdir -p "$CREATED_DIR"; printf '%s\n' "$(date +%s)" > "$CREATED_DIR/${username}"
        mkdir -p "$TRIAL_EXPIRY_DIR"
        printf '%s\n' "$(( $(date +%s) + duration_secs ))" > "$TRIAL_EXPIRY_DIR/${username}.ts"
        if [[ "$app" == "zivpn" ]]; then
            _ff_zivpn_add_pass "$password"
        fi
        # ── OpenVPN per-user config ──
        if [[ "$app" == "openvpn" && -d /etc/openvpn/easy-rsa/pki ]]; then
            local _ovpn_ip; _ovpn_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
            ( cd /etc/openvpn/easy-rsa 2>/dev/null && EASYRSA_BATCH=1 ./easyrsa build-client-full "$username" nopass 2>/dev/null )
            local _ovpn_file="$EXPORTS_DIR/${username}.ovpn"
            mkdir -p "$EXPORTS_DIR" 2>/dev/null
            cat > "$_ovpn_file" <<OVPNEOF
client
dev tun
proto tcp
remote ${_ovpn_ip} ${OPENVPN_TCP_PORT}
<connection>
remote ${_ovpn_ip} ${OPENVPN_UDP_PORT}
proto udp
</connection>
<connection>
remote ${_ovpn_ip} ${OPENVPN_SDNS_PORT}
proto udp
</connection>
resolv-retry infinite
nobind
persist-key
persist-tun
auth SHA256
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
auth-user-pass
<ca>
$(cat /etc/openvpn/easy-rsa/pki/ca.crt 2>/dev/null)
</ca>
<cert>
$(cat /etc/openvpn/easy-rsa/pki/issued/${username}.crt 2>/dev/null)
</cert>
<key>
$(cat /etc/openvpn/easy-rsa/pki/private/${username}.key 2>/dev/null)
</key>
<tls-auth>
$(cat /etc/openvpn/ta.key 2>/dev/null)
</tls-auth>
key-direction 1
OVPNEOF
        fi
        # ── WireGuard per-user config ──
        if [[ "$app" == "wireguard" && -f /etc/wireguard/wg0.conf ]]; then
            local _wg_ip; _wg_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
            local _wg_priv; _wg_priv=$(wg genkey)
            local _wg_pub; _wg_pub=$(echo "$_wg_priv" | wg pubkey)
            local _wg_srv_pub; _wg_srv_pub=$(cat /etc/wireguard/server.pub 2>/dev/null)
            local _wg_file="$EXPORTS_DIR/${username}.conf"
            mkdir -p "$EXPORTS_DIR" 2>/dev/null
            local _wg_octet=2
            local _wg_last; _wg_last=$(grep -oP '10\.66\.66\.\d+' /etc/wireguard/wg0.conf 2>/dev/null | sort -t. -k4 -n | tail -1)
            [[ -n "$_wg_last" ]] && _wg_octet=$((${_wg_last##*.} + 1))
            local _wg_addr="10.66.66.${_wg_octet}"
            cat >> /etc/wireguard/wg0.conf <<WGPEOF
# BEGIN ${username}
[Peer]
PublicKey = ${_wg_pub}
AllowedIPs = ${_wg_addr}/32
# END ${username}
WGPEOF
            cat > "$_wg_file" <<WGCEOF
[Interface]
PrivateKey = ${_wg_priv}
Address = ${_wg_addr}/24
DNS = 8.8.8.8, 1.1.1.1
[Peer]
PublicKey = ${_wg_srv_pub}
Endpoint = ${_wg_ip}:${WIREGUARD_PORT}
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
WGCEOF
        fi
        # ── Hysteria2 per-user config ──
        if [[ "$app" == "hysteria2" && -f /etc/hysteria/config.json ]] && command -v jq &>/dev/null; then
            local _hy_ip; _hy_ip=$(curl -s -4 icanhazip.com 2>/dev/null || echo "SERVER_IP")
            local _hy_file="$EXPORTS_DIR/${username}-hysteria.json"
            mkdir -p "$EXPORTS_DIR" 2>/dev/null
            local _tmp; _tmp=$(mktemp) 2>/dev/null || true
            if [[ -n "$_tmp" ]]; then
                jq --arg u "$username" --arg p "$password" '.auth.config += [{"user": $u, "pass": $p}]' /etc/hysteria/config.json > "$_tmp" 2>/dev/null && mv "$_tmp" /etc/hysteria/config.json
                rm -f "$_tmp" 2>/dev/null
            fi
            cat > "$_hy_file" <<HYCEOF
{
  "server": "${_hy_ip}:${HYSTERIA2_PORT}",
  "auth": "${password}",
  "tls": { "sni": "${_hy_ip}", "insecure": true },
  "quic": { "initStreamReceiveWindow": 8388608, "maxIdleTimeout": "30s", "keepAliveInterval": "10s" },
  "fastOpen": true,
  "lazy": true,
  "socks5": { "listen": "127.0.0.1:1080" }
}
HYCEOF
        fi
        printf "  ${C_GREEN}%-20s${C_RESET} | ${C_YELLOW}%-15s${C_RESET} | ${C_CYAN}%-20s${C_RESET}\n" "$username" "$password" "$expire_date  ($duration_display)"
        created=$((created + 1))
    done

    if [[ "$app" == "zivpn" ]]; then
        systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
    fi
    if [[ "$app" == "wireguard" && -f /etc/wireguard/wg0.conf ]]; then
        wg-quick down wg0 2>/dev/null; wg-quick up wg0 2>/dev/null
    fi
    if [[ "$app" == "hysteria2" && -f /etc/hysteria/config.json ]]; then
        systemctl try-restart hysteria-server 2>/dev/null
    fi

    echo -e "${C_YELLOW}================================================================${C_RESET}"
    echo -e "\n${C_GREEN}✅ Created $created users. Conn Limit: ${limit} | BW: ${bw_display}${C_RESET}"
    echo -e "${C_DIM}ℹ️ Bulk users have no HWID lock (HWID is per-device). Assign per-user via Edit User → [6] if needed.${C_RESET}"
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

generate_client_config() {
    local user=$1
    local pass=$2
    
    local host_ip=$(curl -s -4 icanhazip.com)
    local host_domain
    host_domain=$(detect_preferred_host)
    [[ -z "$host_domain" ]] && host_domain="$host_ip"

    echo -e "\n${C_BOLD}${C_PURPLE}--- 📱 Client Connection Configuration ---${C_RESET}"
    echo -e "${C_CYAN}Copy the details below to your clipboard:${C_RESET}\n"

    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "👤 ${C_BOLD}User Details${C_RESET}"
    echo -e "   • Username: ${C_WHITE}$user${C_RESET}"
    echo -e "   • Password: ${C_WHITE}$pass${C_RESET}"
    echo -e "   • Host/IP : ${C_WHITE}$host_domain${C_RESET}"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    
    # 1. SSH Direct
    echo -e "\n🔹 ${C_BOLD}SSH Direct${C_RESET}:"
    echo -e "   • Host: $host_domain"
    echo -e "   • Port: 22"
    echo -e "   • payload: (Standard SSH)"

    # 2. Internal Nginx proxy (the only edge this script installs)
    if systemctl is-active --quiet nginx; then
        echo -e "\n🔹 ${C_BOLD}Internal Nginx Proxy${C_RESET}:"
        echo -e "   • Ports: ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT} (loopback)"
        echo -e "   • SNI (BugHost): $host_domain (or your preferred SNI)"
    fi

    # 3. UDP Custom
    if systemctl is-active --quiet udp-custom; then
        echo -e "\n🔹 ${C_BOLD}UDP Custom${C_RESET}:"
        echo -e "   • IP: $host_ip (Must use numeric IP)"
        echo -e "   • Port: 1-65535 (Exclude 53, 5300)"
        echo -e "   • Obfs: (None/Plain)"
    fi

    # 4. DNSTT
    if systemctl is-active --quiet dnstt; then
        if [ -f "$DNSTT_CONFIG_FILE" ]; then
            source "$DNSTT_CONFIG_FILE"
            echo -e "\n🔹 ${C_BOLD}DNSTT (SlowDNS)${C_RESET}:"
            echo -e "   • Nameserver: $TUNNEL_DOMAIN"
            echo -e "   • PubKey: $PUBLIC_KEY"
            echo -e "   • DNS IP: 1.1.1.1 / 8.8.8.8"
        fi
    fi

    echo -e "${C_YELLOW}========================================${C_RESET}"

}

client_config_menu() {
    _select_user_interface "--- 📱 Generate Client Config ---"
    local u=$SELECTED_USER
    if [[ "$u" == "NO_USERS" || -z "$u" ]]; then return; fi
    
    # We need to find the password. It's in the DB.
    local pass=$(grep "^$u:" "$DB_FILE" | cut -d: -f2)
    generate_client_config "$u" "$pass"
}

format_rate_from_kbps() {
    local kbps=${1:-0}
    if (( kbps >= 1024 )); then
        printf "%d.%02d MB/s" $((kbps / 1024)) $((((kbps % 1024) * 100) / 1024))
    else
        printf "%d KB/s" "$kbps"
    fi
}

# Lightweight Bash Monitor (No vnStat required)
simple_live_monitor() {
    local iface=$1
    local rx_file="/sys/class/net/$iface/statistics/rx_bytes"
    local tx_file="/sys/class/net/$iface/statistics/tx_bytes"
    local interval=2
    local stop_monitor=0
    local rx1 tx1 rx2 tx2 rx_diff tx_diff rx_kbs tx_kbs rx_fmt tx_fmt

    if [[ -z "$iface" || ! -r "$rx_file" || ! -r "$tx_file" ]]; then
        echo -e "\n${C_RED}❌ Could not read interface statistics for '${iface:-unknown}'.${C_RESET}"
        return
    fi

    echo -e "\n${C_BLUE}⚡ Starting Lightweight Traffic Monitor for $iface...${C_RESET}"
    echo -e "${C_DIM}Press [Ctrl+C] to stop.${C_RESET}\n"

    read -r rx1 < "$rx_file"
    read -r tx1 < "$tx_file"

    printf "%-15s | %-15s\n" "⬇️ Download" "⬆️ Upload"
    echo "-----------------------------------"

    trap 'stop_monitor=1' INT TERM
    while (( ! stop_monitor )); do
        sleep "$interval"
        read -r rx2 < "$rx_file" || break
        read -r tx2 < "$tx_file" || break

        rx_diff=$((rx2 - rx1))
        tx_diff=$((tx2 - tx1))
        (( rx_diff < 0 )) && rx_diff=0
        (( tx_diff < 0 )) && tx_diff=0

        rx_kbs=$((rx_diff / 1024 / interval))
        tx_kbs=$((tx_diff / 1024 / interval))
        rx_fmt=$(format_rate_from_kbps "$rx_kbs")
        tx_fmt=$(format_rate_from_kbps "$tx_kbs")

        printf "\r%-15s | %-15s" "$rx_fmt" "$tx_fmt"

        rx1=$rx2
        tx1=$tx2
    done
    trap - INT TERM
    echo
}

traffic_monitor_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📈 Network Traffic Monitor ---${C_RESET}"
    
    # Find active interface
    local iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
    
    echo -e "\nInterface: ${C_CYAN}${iface}${C_RESET}"
    
    echo -e "\n${C_BOLD}Select a monitoring option:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "⚡ Live Monitor ${C_DIM}(Lightweight, No Install)${C_RESET}"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "📊 View Total Traffic Since Boot"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "📅 Daily/Monthly Logs ${C_DIM}(Requires vnStat)${C_RESET}"
    
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Enter choice: " t_choice
    case $t_choice in
        1) 
           simple_live_monitor "$iface"
           ;;
        2)
            local rx_total=$(cat /sys/class/net/$iface/statistics/rx_bytes)
            local tx_total=$(cat /sys/class/net/$iface/statistics/tx_bytes)
            local rx_mb=$((rx_total / 1024 / 1024))
            local tx_mb=$((tx_total / 1024 / 1024))
            echo -e "\n${C_BLUE}📊 Total Traffic (Since Boot):${C_RESET}"
            echo -e "   ⬇️ Download: ${C_WHITE}${rx_mb} MB${C_RESET}"
            echo -e "   ⬆️ Upload:   ${C_WHITE}${tx_mb} MB${C_RESET}"
            press_enter
            ;;
        3) 
           # vnStat Logic
           if ! command -v vnstat &> /dev/null; then
               echo -e "\n${C_YELLOW}⚠️ vnStat is not installed.${C_RESET}"
               echo -e "   This tool provides persistent history (Daily/Monthly reports)."
               echo -e "   It is lightweight but requires installation."
               read -p "👉 Install vnStat now? (y/n): " confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                     echo -e "\n${C_BLUE}📦 Installing vnStat...${C_RESET}"
                     ff_pkg_install vnstat >/dev/null 2>&1 || {
                         echo -e "${C_RED}❌ Failed to install vnStat.${C_RESET}"
                         sleep 1
                         return
                     }
                     systemctl enable vnstat >/dev/null 2>&1
                     systemctl restart vnstat >/dev/null 2>&1
                    local default_iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
                    vnstat --add -i "$default_iface" >/dev/null 2>&1
                    echo -e "${C_GREEN}✅ Installed.${C_RESET}"
                    sleep 1
               else
                    return
               fi
           fi
           echo
           vnstat -i "$iface"
           echo -e "\n${C_DIM}Run 'vnstat -d' or 'vnstat -m' manually for specific views.${C_RESET}"
           press_enter
           ;;
        *) return ;;
    esac
}

CONTENT_FILTER_CONF="$DB_DIR/domain_blocks.conf"

_filter_iptables_save() {
    ff_pkg_is_installed iptables-persistent &>/dev/null && netfilter-persistent save &>/dev/null
}

# ── Torrent blocking ──────────────────────────────────────────────────

_torrent_rules() {
    iptables -A FORWARD -m string --string "BitTorrent" --algo bm -j DROP
    iptables -A FORWARD -m string --string "BitTorrent protocol" --algo bm -j DROP
    iptables -A FORWARD -m string --string "peer_id=" --algo bm -j DROP
    iptables -A FORWARD -m string --string ".torrent" --algo bm -j DROP
    iptables -A FORWARD -m string --string "announce.php?passkey=" --algo bm -j DROP
    iptables -A FORWARD -m string --string "info_hash" --algo bm -j DROP
    iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
    iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
    iptables -A FORWARD -m string --string "magnet:?xt=urn:btih:" --algo bm -j DROP
    iptables -A FORWARD -m string --string "scrape.php" --algo bm -j DROP
    iptables -A FORWARD -m string --string "compact=1" --algo bm -j DROP
    iptables -A FORWARD -m string --string "no_peer_id=1" --algo bm -j DROP
    iptables -A FORWARD -m string --string "/announce" --algo bm -j DROP
}

_flush_torrent_rules() {
    for s in "BitTorrent" "BitTorrent protocol" "peer_id=" ".torrent" "announce.php?passkey=" \
             "torrent" "info_hash" "get_peers" "find_node" \
             "magnet:?xt=urn:btih:" "scrape.php" "compact=1" "no_peer_id=1" "/announce"; do
        iptables -D FORWARD -m string --string "$s" --algo bm -j DROP 2>/dev/null
        iptables -D OUTPUT   -m string --string "$s" --algo bm -j DROP 2>/dev/null
    done
}

# ── Adult-content blocking ────────────────────────────────────────────

_adult_domain_list() {
    cat <<'DOMAINS'
pornhub.com
xvideos.com
xhamster.com
xnxx.com
redtube.com
youporn.com
tube8.com
spankwire.com
brazzers.com
realitykings.com
bangbros.com
naughtyamerica.com
digitalplayground.com
chaturbate.com
stripchat.com
myfreecams.com
livejasmin.com
cam4.com
onlyfans.com
nhentai.net
hentaihaven.org
efukt.com
motherless.com
literotica.com
youjizz.com
xvideos2.com
xvideos3.com
hentaigasm.com
fakku.net
r18.com
javlibrary.com
javhd.com
txxx.com
porncom.com
porn300.com
beeg.com
xfree.com
eporner.com
porntrex.com
pornhd.com
hdsex.org
pornhubpremium.com
pornhub.net
pornhub.org
pornpics.com
sex.com
adult.com
xxx.com
slutload.com
extremetube.com
keezmovies.com
sunporno.com
pornoxo.com
pornktube.com
voyeurweb.com
CAM4.com
CAM4.es
strippoker.com
stripoker.com
adultwork.com
DOMAINS
}

_adult_rules() {
    # 1) Domain-level DPI rules (catches HTTP Host + HTTPS SNI)
    local domain
    while IFS= read -r domain; do
        [[ -z "$domain" || "$domain" == \#* || "$domain" == "DOMAINS" ]] && continue
        iptables -A FORWARD -m string --string "$domain" --algo bm -j DROP 2>/dev/null
    done < <(_adult_domain_list)

    # 2) Load user custom domains
    if [[ -f "$CONTENT_FILTER_CONF" ]]; then
        while IFS= read -r domain; do
            domain="${domain%%#*}"  # strip inline comments
            domain="${domain## }"    # trim leading space
            domain="${domain%% }"    # trim trailing space
            [[ -z "$domain" ]] && continue
            iptables -A FORWARD -m string --string "$domain" --algo bm -j DROP 2>/dev/null
        done < "$CONTENT_FILTER_CONF"
    fi

    # 3) URL-path keywords for HTTP plaintext
    for kw in "/porn" "/xxx" "/adult" "/hentai" "/nude" "/pornstar" "/erotic" \
              "/bdsm" "/fetish" "/sexo" "/incest" "/orgy" "/gangbang" "/blowjob" \
              "/cumshot" "/squirting" "/tranny" "/shemale" "/escort" "/pussy" \
              "/tits" "/boobs" "/milf" "/anal" "/dildo" "/vibrator" "/buttplug"; do
        iptables -A FORWARD -m string --string "$kw" --algo bm -j DROP 2>/dev/null
    done
}

_flush_adult_rules() {
    # Remove all adult domain rules
    local domain
    while IFS= read -r domain; do
        [[ -z "$domain" || "$domain" == \#* || "$domain" == "DOMAINS" ]] && continue
        iptables -D FORWARD -m string --string "$domain" --algo bm -j DROP 2>/dev/null
    done < <(_adult_domain_list)

    # Remove user custom domains
    if [[ -f "$CONTENT_FILTER_CONF" ]]; then
        while IFS= read -r domain; do
            domain="${domain%%#*}"
            domain="${domain## }"
            domain="${domain%% }"
            [[ -z "$domain" ]] && continue
            iptables -D FORWARD -m string --string "$domain" --algo bm -j DROP 2>/dev/null
        done < "$CONTENT_FILTER_CONF"
    fi

    # Remove URL-path keywords
    for kw in "/porn" "/xxx" "/adult" "/hentai" "/nude" "/pornstar" "/erotic" \
              "/bdsm" "/fetish" "/sexo" "/incest" "/orgy" "/gangbang" "/blowjob" \
              "/cumshot" "/squirting" "/tranny" "/shemale" "/escort" "/pussy" \
              "/tits" "/boobs" "/milf" "/anal" "/dildo" "/vibrator" "/buttplug"; do
        iptables -D FORWARD -m string --string "$kw" --algo bm -j DROP 2>/dev/null
    done
}

# ── Menu ──────────────────────────────────────────────────────────────

content_filter_menu() {
    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🚫 Content Filtering ---${C_RESET}"

        local torrent_status="${C_STATUS_I}Disabled${C_RESET}"
        iptables -C FORWARD -m string --string "BitTorrent" --algo bm -j DROP 2>/dev/null && \
            torrent_status="${C_STATUS_A}Enabled${C_RESET}"

        local adult_status="${C_STATUS_I}Disabled${C_RESET}"
        iptables -C FORWARD -m string --string "pornhub.com" --algo bm -j DROP 2>/dev/null && \
            adult_status="${C_STATUS_A}Enabled${C_RESET}"

        local blocklist_count=0
        [[ -f "$CONTENT_FILTER_CONF" ]] && blocklist_count=$(grep -cvE '^\s*(#|$)' "$CONTENT_FILTER_CONF" 2>/dev/null || echo 0)

        echo -e "\n${C_WHITE}Torrent Blocking : ${torrent_status}"
        echo -e "Adult Blocking   : ${adult_status}${C_RESET}"
        echo -e "${C_DIM}Custom domains  : ${blocklist_count} entries in blocklist${C_RESET}"

        echo -e "\n${C_BOLD}Select an action:${C_RESET}\n"
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🔒 Enable Torrent Blocking"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔓 Disable Torrent Blocking"
        printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "🔞 Enable Adult Content Block"
        printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "🙈 Disable Adult Content Block"
        printf "  ${C_CHOICE}[ 5]${C_RESET} %-40s\n" "📝 Edit Custom Domain Blocklist"
        printf "  ${C_DANGER}[ 6]${C_RESET} %-40s\n" "🚫 Disable ALL Content Filters"
        echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -p "👉 Enter choice: " f_choice

        case $f_choice in
            1)
                echo -e "\n${C_BLUE}🛡️ Enabling torrent blocking...${C_RESET}"
                _flush_torrent_rules
                _torrent_rules
                _filter_iptables_save
                echo -e "${C_GREEN}✅ Torrent Blocking Enabled.${C_RESET}"
                press_enter
                ;;
            2)
                echo -e "\n${C_BLUE}🔓 Disabling torrent blocking...${C_RESET}"
                _flush_torrent_rules
                _filter_iptables_save
                echo -e "${C_GREEN}✅ Torrent Blocking Disabled.${C_RESET}"
                press_enter
                ;;
            3)
                echo -e "\n${C_BLUE}🛡️ Enabling adult content blocking...${C_RESET}"
                _flush_adult_rules
                _adult_rules
                _filter_iptables_save
                echo -e "${C_GREEN}✅ Adult Content Blocking Enabled (${C_YELLOW}$(_adult_domain_list | grep -cvE '^(DOMAINS|#|$)' || true)${C_GREEN} domains + 23 URL keywords + custom blocklist).${C_RESET}"
                echo -e "${C_DIM}Note: HTTPS SNI matching catches most major adult sites; HTTP path matching adds coverage for plaintext connections.${C_RESET}"
                press_enter
                ;;
            4)
                echo -e "\n${C_BLUE}🙈 Disabling adult content blocking...${C_RESET}"
                _flush_adult_rules
                _filter_iptables_save
                echo -e "${C_GREEN}✅ Adult Content Blocking Disabled.${C_RESET}"
                press_enter
                ;;
            5)
                if [[ ! -f "$CONTENT_FILTER_CONF" ]]; then
                    cat > "$CONTENT_FILTER_CONF" <<-'CONF'
# VPS_superScript — Custom domain blocklist
# One domain or keyword per line.  Lines starting with # are ignored.
# These run alongside the built-in adult list.
# Examples:
# tiktok.com
# snapchat.com
# instagram.com
CONF
                fi
                ${EDITOR:-nano} "$CONTENT_FILTER_CONF"
                if iptables -C FORWARD -m string --string "pornhub.com" --algo bm -j DROP 2>/dev/null; then
                    echo -e "\n${C_BLUE}⚙️ Reloading adult block with updated blocklist...${C_RESET}"
                    _flush_adult_rules
                    _adult_rules
                    _filter_iptables_save
                    echo -e "${C_GREEN}✅ Blocklist reloaded.${C_RESET}"
                else
                    echo -e "\n${C_YELLOW}ℹ️ Adult blocking is off — changes apply when you enable it via option [3].${C_RESET}"
                fi
                press_enter
                ;;
            6)
                echo -e "\n${C_RED}⚠️ Disabling ALL content filters...${C_RESET}"
                _flush_torrent_rules
                _flush_adult_rules
                _filter_iptables_save
                echo -e "${C_GREEN}✅ All content filters disabled.${C_RESET}"
                press_enter
                ;;
            0) return ;;
            *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" && sleep 1 ;;
        esac
    done
}

ssh_banner_menu() {
    while true; do
        show_banner
        local banner_mode
        local banner_status
        banner_mode=$(get_ssh_banner_mode)
        case "$banner_mode" in
            dynamic) banner_status="${C_STATUS_A}Dynamic${C_RESET}" ;;
            static) banner_status="${C_STATUS_A}Static${C_RESET}" ;;
            *) banner_status="${C_STATUS_I}Disabled${C_RESET}" ;;
        esac

        echo -e "\n   ${C_TITLE}═════════════════[ ${C_BOLD}🎨 SSH BANNER MODE: ${banner_status} ${C_RESET}${C_TITLE}]═════════════════${C_RESET}"
        echo -e "${C_DIM}Static mode uses 'Banner $SSH_BANNER_FILE'. Dynamic mode shows per-user account info.${C_RESET}"
        printf "     ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "✨ Enable Dynamic Account Banner"
        printf "     ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "📋 Paste or Replace Static Banner"
        printf "     ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "👁️ View Current Static Banner"
        printf "     ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "📝 Preview Dynamic Banner"
        printf "     ${C_DANGER}[ 5]${C_RESET} %-40s\n" "🗑️ Disable All SSH Banners"
        echo -e "   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
            echo
            return
        fi
        case $choice in
            1)
                if setup_ssh_login_info; then
                    echo -e "\n${C_GREEN}✅ Dynamic account banner enabled.${C_RESET}"
                    echo -e "${C_DIM}Users will now see their account info banner instead of the static banner.${C_RESET}"
                fi
                press_enter
                ;;
            2) set_ssh_banner_paste ;;
            3) view_ssh_banner ;;
            4) preview_dynamic_ssh_banner ;;
            5) remove_ssh_banner ;;
            0) return ;;
            *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" && sleep 1 ;;
        esac
    done
}

auto_reboot_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔄 Auto-Reboot Management ---${C_RESET}"
    
    # Check status
    local cron_check=$(crontab -l 2>/dev/null | grep "systemctl reboot")
    local status="${C_STATUS_I}Disabled${C_RESET}"
    if [[ -n "$cron_check" ]]; then
        status="${C_STATUS_A}Active (Midnight)${C_RESET}"
    fi
    
    echo -e "\n${C_WHITE}Current Status: ${status}${C_RESET}"
    
    echo -e "\n${C_BOLD}Select an action:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🕐 Enable Daily Reboot (00:00 midnight)"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "❌ Disable Auto-Reboot"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Enter choice: " r_choice
    
    case $r_choice in
        1)
            # Remove existing to prevent duplicates
            (crontab -l 2>/dev/null | grep -v "systemctl reboot") | crontab -
            # Add new job
            (crontab -l 2>/dev/null; echo "0 0 * * * systemctl reboot") | crontab -
            echo -e "\n${C_GREEN}✅ Auto-reboot scheduled for every day at 00:00.${C_RESET}"
            press_enter
            ;;
        2)
            (crontab -l 2>/dev/null | grep -v "systemctl reboot") | crontab -
            echo -e "\n${C_GREEN}✅ Auto-reboot disabled.${C_RESET}"
            press_enter
            ;;
        *) return ;;
    esac
}


# ── NAT Port Forwarding ─────────────────────────────────────────────

NAT_RULES_CONF="$DB_DIR/nat_rules.conf"

_nat_default_rules() {
    cat <<'RULES'
# RETURN rules — these bypass DNAT (format: proto:port)
# TCP ports (SSH, proxies, panel)
RETURN=tcp:22
RETURN=tcp:22741
RETURN=tcp:8888
RETURN=tcp:888
RETURN=tcp:80
RETURN=tcp:443
RETURN=tcp:887
RETURN=tcp:49222
# UDP ports (DNS, badvpn — so they aren't hijacked by the UDP DNAT)
RETURN=udp:53
RETURN=udp:5300
RETURN=udp:7300
# ZiVPN listens on 5667. Clients reach it via the 6000:19999 UDP DNAT range
# below (port hopping — the standard ZiVPN band that injector apps use), and
# 5667 itself is also kept open directly via this RETURN exception (5667 sits
# inside the udp:1:5999 range and would otherwise be hijacked into
# udp-custom/36712). Point ZiVPN configs at UDP 6000-19999.
RETURN=udp:5667
# udp-custom listens on 36712. Clients reach it via the UDP DNAT ranges below
# (port hopping into 36712); its own listen port is also kept directly reachable
# via this RETURN exception (applied before any DNAT) so the relay stays
# reachable on 36712 itself.
RETURN=udp:36712
# DNAT rules  (format: proto:port_or_range:target_port)
# NOTE: no blanket TCP DNAT — HTTP Custom (SSH/SSL over TCP) must reach its own
# listeners untouched. Only UDP is forwarded to the relays, so TCP and UDP
# (ZiVPN / udp-custom) coexist without conflict.
# UDP partition, full coverage, no overlaps (order-independent; no shadowing):
#   1:5999  + 20000:65535  -> udp-custom  (36712)
#   6000:19999             -> ZiVPN       (5667)
# Do NOT put inline "#" comments on DNAT= lines — the value is parsed by ":".
DNAT=udp:6000:19999:5667
DNAT=udp:1:5999:36712
DNAT=udp:20000:65535:36712
RULES
}

_nat_load_rules() {
    if [[ ! -f "$NAT_RULES_CONF" ]]; then
        _nat_default_rules > "$NAT_RULES_CONF"
    fi
    # Self-heal older installs: strip the legacy blanket TCP DNAT
    # (tcp:1:65535:36712) that hijacked HTTP Custom's TCP traffic into the
    # udp-custom relay. Removing it lets HTTP Custom (TCP) and ZiVPN (UDP)
    # coexist. Safe and idempotent — only rewrites the file when present.
    if grep -q '^DNAT=tcp:1:65535:36712$' "$NAT_RULES_CONF" 2>/dev/null; then
        sed -i '/^DNAT=tcp:1:65535:36712$/d' "$NAT_RULES_CONF" 2>/dev/null
    fi
    # Self-heal installs that predate the UDP Request removal: drop its DNAT
    # range (20000:60999 -> 36713) and its RETURN exception (36713). The freed
    # 20000:60999 range simply becomes UDP passthrough. Idempotent.
    if grep -qE '^(DNAT=udp:20000:60999:36713|RETURN=udp:36713)$' "$NAT_RULES_CONF" 2>/dev/null; then
        sed -ri '/^DNAT=udp:20000:60999:36713$/d; /^RETURN=udp:36713$/d' "$NAT_RULES_CONF" 2>/dev/null
    fi
    # Self-heal installs that used the narrow ZiVPN DNAT window (61000:62000).
    # Widen it to the standard 6000:19999 ZiVPN band and hand the freed
    # 20000:65535 back to udp-custom, so port-hopping ZiVPN clients (which use
    # 6000:19999) actually reach 5667 instead of the old 6000:60999 passthrough
    # hole. Fires only on the exact old default lines; idempotent, and leaves
    # any hand-customised DNAT rules untouched.
    if grep -q '^DNAT=udp:61000:62000:5667$' "$NAT_RULES_CONF" 2>/dev/null; then
        sed -ri \
            -e 's/^DNAT=udp:61000:62000:5667$/DNAT=udp:6000:19999:5667/' \
            -e 's/^DNAT=udp:62001:65535:36712$/DNAT=udp:20000:65535:36712/' \
            "$NAT_RULES_CONF" 2>/dev/null
    fi
    # Migrate old-format RETURN=<port> (no protocol) to RETURN=tcp:<port>
    if grep -qP '^RETURN=\d+$' "$NAT_RULES_CONF" 2>/dev/null; then
        sed -ri 's/^RETURN=([0-9]+)$/RETURN=tcp:\1/' "$NAT_RULES_CONF" 2>/dev/null
    fi
    mapfile -t NAT_RETURN < <(grep '^RETURN=' "$NAT_RULES_CONF" | cut -d= -f2)
    mapfile -t NAT_DNAT < <(grep '^DNAT=' "$NAT_RULES_CONF" | cut -d= -f2)
}

_nat_save_rules() {
    {
        for port in "${NAT_RETURN[@]}"; do echo "RETURN=$port"; done
        for rule in "${NAT_DNAT[@]}"; do echo "DNAT=$rule"; done
    } > "$NAT_RULES_CONF"
}

_nat_get_iface() {
    ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1
}

_nat_apply() {
    local iface
    iface=$(_nat_get_iface)
    [[ -z "$iface" ]] && iface="eth0"

    # Flush NAT PREROUTING chain
    iptables -t nat -F PREROUTING

    # Apply RETURN rules
    local rrule rproto rport
    for rrule in "${NAT_RETURN[@]}"; do
        IFS=: read -r rproto rport <<< "$rrule"
        [[ -z "$rport" ]] && rport="$rproto" && rproto="tcp"
        iptables -t nat -A PREROUTING -i "$iface" -p "$rproto" --dport "$rport" -j RETURN 2>/dev/null || true
    done

    # Apply DNAT rules
    local rule proto port_low port_high target
    for rule in "${NAT_DNAT[@]}"; do
        IFS=: read -r proto port_low port_high target <<< "$rule"
        iptables -t nat -A PREROUTING -i "$iface" -p "$proto" --dport "${port_low}:${port_high}" -j DNAT --to-destination ":${target}" 2>/dev/null || true
    done

    _filter_iptables_save
}

_nat_preview_commands() {
    local iface
    iface=$(_nat_get_iface)
    [[ -z "$iface" ]] && iface="eth0"

    echo -e "\n${C_YELLOW}  # Flush existing NAT PREROUTING${C_RESET}"
    echo "  iptables -t nat -F PREROUTING"
    echo
    if [[ ${#NAT_RETURN[@]} -gt 0 ]]; then
        echo -e "  ${C_YELLOW}# RETURN rules (ports bypassing DNAT)${C_RESET}"
        local rrule rproto rport
        for rrule in "${NAT_RETURN[@]}"; do
            IFS=: read -r rproto rport <<< "$rrule"
            [[ -z "$rport" ]] && rport="$rproto" && rproto="tcp"
            echo "  iptables -t nat -A PREROUTING -i $iface -p $rproto --dport $rport -j RETURN"
        done
        echo
    fi
    echo -e "  ${C_YELLOW}# DNAT rules${C_RESET}"
    local rule proto port_low port_high target
    for rule in "${NAT_DNAT[@]}"; do
        IFS=: read -r proto port_low port_high target <<< "$rule"
        echo "  iptables -t nat -A PREROUTING -i $iface -p $proto --dport ${port_low}:${port_high} -j DNAT --to-destination :${target}"
    done
}

_nat_show_rules() {
    _nat_load_rules
    local i

    if [[ ${#NAT_RETURN[@]} -gt 0 ]]; then
        echo -e "\n  ${C_ACCENT}===== RETURN (bypass DNAT) =====${C_RESET}"
        for i in "${!NAT_RETURN[@]}"; do
            local rrule="${NAT_RETURN[$i]}"
            local rproto rport
            IFS=: read -r rproto rport <<< "$rrule"
            [[ -z "$rport" ]] && rport="$rproto" && rproto="tcp"
            printf "  ${C_CHOICE}[R%2s]${C_RESET}  %-4s  %-17s  →  %s\n" "$((i+1))" "${rproto^^}" "$rport" "RETURN"
        done
    fi

    if [[ ${#NAT_DNAT[@]} -gt 0 ]]; then
        echo -e "\n  ${C_ACCENT}===== DNAT (port forwarding) =====${C_RESET}"
        for i in "${!NAT_DNAT[@]}"; do
            local rule="${NAT_DNAT[$i]}"
            local proto port_low port_high target label
            IFS=: read -r proto port_low port_high target <<< "$rule"
            label=""
            case "$target" in
                5667)  label="  (ZiVPN)" ;;
                36712) label="  (udp-custom)" ;;
            esac
            printf "  ${C_CHOICE}[D%2s]${C_RESET}  %-4s  %-17s  →  %-5s%s\n" "$((i+1))" "${proto^^}" "${port_low}:${port_high}" "$target" "$label"
        done
    fi
}

apply_default_nat_rules() {
    echo -e "${C_BLUE}🔥 Applying default NAT port forwarding rules...${C_RESET}"
    _nat_default_rules > "$NAT_RULES_CONF"
    _nat_load_rules
    _nat_apply
    echo -e "${C_GREEN}✅ Default NAT rules applied (14 RETURN + 4 DNAT).${C_RESET}"
}

nat_forward_menu() {
    while true; do
        clear; show_banner
        echo -e "\n   ${C_TITLE}═════════════════[ ${C_BOLD}🔥 NAT PORT FORWARDING ${C_RESET}${C_TITLE}]═════════════════${C_RESET}"
        echo -e "   ${C_DIM}Manage iptables PREROUTING DNAT + RETURN rules${C_RESET}"
        _nat_show_rules

        echo
        echo -e "   ${C_BOLD}Actions:${C_RESET}\n"
        printf "     ${C_CHOICE}[ 1]${C_RESET} %-35s\n" "➕ Add RETURN port"
        printf "     ${C_CHOICE}[ 2]${C_RESET} %-35s\n" "🗑️  Remove RETURN port"
        printf "     ${C_CHOICE}[ 3]${C_RESET} %-35s\n" "➕ Add DNAT rule"
        printf "     ${C_CHOICE}[ 4]${C_RESET} %-35s\n" "✏️  Edit DNAT rule"
        printf "     ${C_CHOICE}[ 5]${C_RESET} %-35s\n" "🗑️  Delete rule"
        printf "     ${C_CHOICE}[ 6]${C_RESET} %-35s\n" "🔄 Reset to defaults"
        printf "     ${C_CHOICE}[ 7]${C_RESET} %-35s\n" "👁️  Preview & Apply All"
        printf "     ${C_CHOICE}[ 8]${C_RESET} %-35s\n" "💾 Save (iptables-persistent)"
        echo -e "   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice

        case $choice in
            1)
                _nat_load_rules
                read -p "👉 Protocol (tcp/udp/both) [tcp]: " rproto
                rproto=${rproto:-tcp}
                case "$rproto" in
                    both) ;;
                    tcp|udp) ;;
                    *) rproto="tcp" ;;
                esac
                read -p "👉 Enter port to exclude from DNAT: " rport
                if [[ -z "$rport" || ! "$rport" =~ ^[0-9]+$ ]]; then
                    echo -e "\n${C_RED}❌ Invalid port.${C_RESET}"; sleep 1; continue
                fi
                if [[ "$rproto" == "both" ]]; then
                    if printf '%s\n' "${NAT_RETURN[@]}" | grep -qx "tcp:$rport"; then
                        echo -e "\n${C_YELLOW}⚠️ TCP port $rport is already a RETURN exception.${C_RESET}"; sleep 1; continue
                    fi
                    if printf '%s\n' "${NAT_RETURN[@]}" | grep -qx "udp:$rport"; then
                        echo -e "\n${C_YELLOW}⚠️ UDP port $rport is already a RETURN exception.${C_RESET}"; sleep 1; continue
                    fi
                    NAT_RETURN+=("tcp:$rport" "udp:$rport")
                    echo -e "\n${C_GREEN}✅ tcp + udp port $rport added as RETURN exception.${C_RESET}"
                else
                    if printf '%s\n' "${NAT_RETURN[@]}" | grep -qx "$rproto:$rport"; then
                        echo -e "\n${C_YELLOW}⚠️ $rproto port $rport is already a RETURN exception.${C_RESET}"; sleep 1; continue
                    fi
                    NAT_RETURN+=("$rproto:$rport")
                    echo -e "\n${C_GREEN}✅ $rproto port $rport added as RETURN exception.${C_RESET}"
                fi
                _nat_save_rules
                _nat_apply
                press_enter
                ;;
            2)
                _nat_load_rules
                if [[ ${#NAT_RETURN[@]} -eq 0 ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No RETURN rules to remove.${C_RESET}"; sleep 1; continue
                fi
                echo -e "\n${C_BOLD}Select RETURN port to remove:${C_RESET}\n"
                local rrule rproto rport
                for i in "${!NAT_RETURN[@]}"; do
                    rrule="${NAT_RETURN[$i]}"
                    IFS=: read -r rproto rport <<< "$rrule"
                    [[ -z "$rport" ]] && rport="$rproto" && rproto="tcp"
                    printf "  ${C_CHOICE}[%2s]${C_RESET}  %-4s  %s\n" "$((i+1))" "${rproto^^}" "$rport"
                done
                echo -e "\n  ${C_WARN}[ 0]${C_RESET} Cancel"
                read -p "👉 Choice: " idx
                [[ "$idx" == "0" ]] && continue
                if [[ ! "$idx" =~ ^[0-9]+$ || "$idx" -lt 1 || "$idx" -gt "${#NAT_RETURN[@]}" ]]; then
                    echo -e "\n${C_RED}❌ Invalid.${C_RESET}"; sleep 1; continue
                fi
                local removed="${NAT_RETURN[$((idx-1))]}"
                unset "NAT_RETURN[$((idx-1))]"
                NAT_RETURN=("${NAT_RETURN[@]}")
                _nat_save_rules
                _nat_apply
                echo -e "\n${C_GREEN}✅ RETURN port $removed removed.${C_RESET}"
                press_enter
                ;;
            3)
                _nat_load_rules
                echo -e "\n${C_DIM}Add a new DNAT forwarding rule.${C_RESET}"
                read -p "👉 Protocol (tcp/udp/both) [tcp]: " proto
                proto=${proto:-tcp}
                case "$proto" in
                    both) ;;
                    tcp|udp) ;;
                    *) proto="tcp" ;;
                esac
                read -p "👉 Port or range (e.g. 8080 or 8000:9000): " prange
                if [[ -z "$prange" ]]; then
                    echo -e "\n${C_RED}❌ Required.${C_RESET}"; sleep 1; continue
                fi
                read -p "👉 Forward to port: " target
                if [[ -z "$target" || ! "$target" =~ ^[0-9]+$ ]]; then
                    echo -e "\n${C_RED}❌ Invalid port.${C_RESET}"; sleep 1; continue
                fi
                # Normalize a single port (e.g. 8080) to low:high form so the
                # 4-field apply parser (proto:low:high:target) always works.
                [[ "$prange" != *:* ]] && prange="$prange:$prange"
                if [[ "$proto" == "both" ]]; then
                    NAT_DNAT+=("tcp:$prange:$target")
                    NAT_DNAT+=("udp:$prange:$target")
                    echo -e "\n${C_GREEN}✅ DNAT rules added: tcp + udp $prange → $target${C_RESET}"
                else
                    NAT_DNAT+=("$proto:$prange:$target")
                    echo -e "\n${C_GREEN}✅ DNAT rule added: $proto $prange → $target${C_RESET}"
                fi
                _nat_save_rules
                _nat_apply
                press_enter
                ;;
            4)
                _nat_load_rules
                if [[ ${#NAT_DNAT[@]} -eq 0 ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No DNAT rules to edit.${C_RESET}"; sleep 1; continue
                fi
                echo -e "\n${C_BOLD}Select DNAT rule to edit:${C_RESET}\n"
                for i in "${!NAT_DNAT[@]}"; do
                    local rule="${NAT_DNAT[$i]}"
                    local p prot plow phigh tgt
                    IFS=: read -r prot plow phigh tgt <<< "$rule"
                    printf "  ${C_CHOICE}[%2s]${C_RESET}  %-4s  %-17s → %s\n" "$((i+1))" "${prot^^}" "${plow}:${phigh}" "$tgt"
                done
                echo -e "\n  ${C_WARN}[ 0]${C_RESET} Cancel"
                read -p "👉 Choice: " idx
                [[ "$idx" == "0" ]] && continue
                if [[ ! "$idx" =~ ^[0-9]+$ || "$idx" -lt 1 || "$idx" -gt "${#NAT_DNAT[@]}" ]]; then
                    echo -e "\n${C_RED}❌ Invalid.${C_RESET}"; sleep 1; continue
                fi
                local old="${NAT_DNAT[$((idx-1))]}"
                local oprot olow ohigh otarget
                IFS=: read -r oprot olow ohigh otarget <<< "$old"
                local orange="${olow}:${ohigh}"
                echo -e "\n${C_DIM}Editing: $oprot $orange → $otarget${C_RESET}"
                read -p "👉 Protocol (tcp/udp/both) [$oprot]: " nproto
                nproto=${nproto:-$oprot}
                read -p "👉 Port or range [$orange]: " nrange
                nrange=${nrange:-$orange}
                read -p "👉 Forward to port [$otarget]: " ntarget
                ntarget=${ntarget:-$otarget}
                if [[ "$nproto" == "both" ]]; then
                    NAT_DNAT[$((idx-1))]="tcp:$nrange:$ntarget"
                    NAT_DNAT+=("udp:$nrange:$ntarget")
                else
                    NAT_DNAT[$((idx-1))]="$nproto:$nrange:$ntarget"
                fi
                _nat_save_rules
                _nat_apply
                echo -e "\n${C_GREEN}✅ DNAT rule updated.${C_RESET}"
                press_enter
                ;;
            5)
                _nat_load_rules
                local total=$(( ${#NAT_RETURN[@]} + ${#NAT_DNAT[@]} ))
                if [[ total -eq 0 ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No rules to delete.${C_RESET}"; sleep 1; continue
                fi
                echo -e "\n${C_BOLD}Select rule to delete:${C_RESET}\n"
                local i idx
                local rrule rproto rport
                for i in "${!NAT_RETURN[@]}"; do
                    rrule="${NAT_RETURN[$i]}"
                    IFS=: read -r rproto rport <<< "$rrule"
                    [[ -z "$rport" ]] && rport="$rproto" && rproto="tcp"
                    printf "  ${C_CHOICE}[R%2s]${C_RESET}  RETURN  %-4s %s\n" "$((i+1))" "${rproto^^}" "$rport"
                done
                for i in "${!NAT_DNAT[@]}"; do
                    local rule="${NAT_DNAT[$i]}"
                    local prot plow phigh tgt
                    IFS=: read -r prot plow phigh tgt <<< "$rule"
                    printf "  ${C_CHOICE}[D%2s]${C_RESET}  DNAT    %-4s %s → %s\n" "$((i+1))" "${prot^^}" "${plow}:${phigh}" "$tgt"
                done
                echo -e "\n  ${C_WARN}[ 0]${C_RESET} Cancel"
                read -p "👉 Enter code (e.g. R1 or D3): " code
                [[ "$code" == "0" ]] && continue
                if [[ "$code" =~ ^[Rr]([0-9]+)$ ]]; then
                    idx="${BASH_REMATCH[1]}"
                    if [[ "$idx" -ge 1 && "$idx" -le "${#NAT_RETURN[@]}" ]]; then
                        local removed="${NAT_RETURN[$((idx-1))]}"
                        unset "NAT_RETURN[$((idx-1))]"
                        NAT_RETURN=("${NAT_RETURN[@]}")
                        _nat_save_rules; _nat_apply
                        echo -e "\n${C_GREEN}✅ RETURN $removed deleted.${C_RESET}"
                    else
                        echo -e "\n${C_RED}❌ Invalid index.${C_RESET}"; sleep 1; continue
                    fi
                elif [[ "$code" =~ ^[Dd]([0-9]+)$ ]]; then
                    idx="${BASH_REMATCH[1]}"
                    if [[ "$idx" -ge 1 && "$idx" -le "${#NAT_DNAT[@]}" ]]; then
                        local removed="${NAT_DNAT[$((idx-1))]}"
                        unset "NAT_DNAT[$((idx-1))]"
                        NAT_DNAT=("${NAT_DNAT[@]}")
                        _nat_save_rules; _nat_apply
                        echo -e "\n${C_GREEN}✅ DNAT $removed deleted.${C_RESET}"
                    else
                        echo -e "\n${C_RED}❌ Invalid index.${C_RESET}"; sleep 1; continue
                    fi
                else
                    echo -e "\n${C_RED}❌ Invalid format. Use R1 or D3.${C_RESET}"; sleep 1; continue
                fi
                press_enter
                ;;
            6)
                echo -e "\n${C_YELLOW}⚠️ This will reset to the 14 RETURN + 4 DNAT defaults and wipe custom rules.${C_RESET}"
                read -p "👉 Type 'yes' to confirm: " confirm
                if [[ "$confirm" != "yes" ]]; then
                    echo -e "\n${C_GREEN}Cancelled.${C_RESET}"; sleep 1; continue
                fi
                apply_default_nat_rules
                press_enter
                ;;
            7)
                _nat_load_rules
                echo -e "\n${C_BOLD}${C_PURPLE}--- 👁️  Preview: Commands to be applied ---${C_RESET}"
                _nat_preview_commands
                echo
                read -p "$(echo -e ${C_PROMPT}"👉 Press [Enter] to apply, or [0] to cancel: "${C_RESET})" confirm
                if [[ "$confirm" == "0" ]]; then
                    echo -e "\n${C_GREEN}Cancelled.${C_RESET}"; sleep 1; continue
                fi
                _nat_apply
                echo -e "\n${C_GREEN}✅ NAT rules applied live.${C_RESET}"
                press_enter
                ;;
            8)
                echo -e "\n${C_BLUE}💾 Saving iptables rules...${C_RESET}"
                _filter_iptables_save
                echo -e "\n${C_GREEN}✅ Saved (iptables-persistent).${C_RESET}"
                press_enter
                ;;
            0) return ;;
            *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" && sleep 1 ;;
        esac
    done
}

press_enter() {
    echo
    echo -e "   ${C_DIM}───────────────────────────────────────────────────${C_RESET}"
    echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️  Press ${C_YELLOW}[Enter]${C_RESET} to go back"
    echo -e "   ${C_DIM}───────────────────────────────────────────────────${C_RESET}"
    read -r || true
}
invalid_option() {
    echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" && sleep 1
}

# ── Clustered submenu (hub) render helpers ─────────────────────────────────
# Shared look for all top-level hubs so grouped tools feel consistent & premium.
_hub_header() {
    echo -e "\n   ${C_TITLE}═══════════════[ ${C_BOLD}$1${C_RESET}${C_TITLE} ]═══════════════${C_RESET}\n"
}
_hub_item() { # $1 num  $2 label  $3 description
    printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "$1" "$2" "$3"
}
_hub_footer() {
    echo -e "\n   ${C_DIM}───────────────────────────────────────────────────${C_RESET}"
    echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️  Back to Main Menu\n"
}

# Resync all ZiVPN passwords from the local DB into /etc/zivpn/config.json.
# Useful as a one-click repair after the old unlock bug left some accounts
# without a password in the auth list.
zivpn_resync_passwords() {
    clear; show_banner
    if [[ ! -f "$ZIVPN_CONFIG_FILE" ]]; then
        echo -e "${C_YELLOW}⚠️ ZiVPN config ($ZIVPN_CONFIG_FILE) not found — is ZiVPN installed?${C_RESET}"
        return
    fi
    if ! command -v jq &>/dev/null; then
        echo -e "${C_YELLOW}⚠️ 'jq' is required but not installed. Install it and try again.${C_RESET}"
        return
    fi
    local added=0 skipped=0 missing=0 tmp
    while IFS=: read -r _user _pass _rest; do
        [[ -n "$_user" && -n "$_pass" ]] || { ((missing++)); continue; }
        if jq -e --arg p "$_pass" '.auth.config | index($p) != null' "$ZIVPN_CONFIG_FILE" &>/dev/null; then
            ((skipped++))
            continue
        fi
        tmp=$(mktemp) || { ((missing++)); continue; }
        if jq --arg p "$_pass" '.auth.config += [$p]' "$ZIVPN_CONFIG_FILE" > "$tmp" 2>/dev/null; then
            mv "$tmp" "$ZIVPN_CONFIG_FILE"
            ((added++))
        else
            rm -f "$tmp" 2>/dev/null
            ((missing++))
        fi
    done < <(awk -F: '$9 == "zivpn" { print $1":"$2 }' "$DB_FILE" 2>/dev/null)

    if [[ "$added" -gt 0 ]]; then
        systemctl is-active --quiet zivpn 2>/dev/null && systemctl try-restart zivpn.service 2>/dev/null
    fi

    echo
    echo -e "${C_BOLD}--- 🔑 ZiVPN Password Resync ---${C_RESET}"
    echo -e "  ${C_GREEN}✅ Added:      ${added}${C_RESET}"
    echo -e "  ${C_BLUE}ℹ️  Skipped:    ${skipped} (already present)${C_RESET}"
    if [[ "$missing" -gt 0 ]]; then
        echo -e "  ${C_YELLOW}⚠️  Failed:     ${missing} (missing DB entry / jq error)${C_RESET}"
    fi
}

# ═══════════════════════════════════════════════════════════
# CLUSTERED MANAGEMENT HUBS
# Each hub groups related tools behind one main-menu entry so the
# top-level screen stays short. Every hub shows [0] Back to Main Menu.
# ═══════════════════════════════════════════════════════════

more_users_hub() {
    while true; do
        show_banner
        _hub_header "➕ MORE USER TOOLS"
        _hub_item "1" "⏱️  Trial Account"   "Create a time-limited trial user"
        _hub_item "2" "💾 Backup Users"      "Export the user database"
        _hub_item "3" "📥 Restore Users"     "Import users from a backup"
        _hub_item "4" "🧹 Cleanup Expired"   "Remove expired accounts"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) create_trial_account; press_enter ;;
            2) backup_user_data; press_enter ;;
            3) restore_user_data; press_enter ;;
            4) cleanup_expired; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

protocols_hub() {
    while true; do
        show_banner
        _hub_header "🔌 PROTOCOLS & SERVICES"
        _hub_item "1" "🔌 Protocol Manager"  "Install/manage VPN protocols & panels"
        _hub_item "2" "🔛 ON/OFF Service"     "Start or stop running services"
        _hub_item "3" "🦘 Dropbear Menu"      "Configure Dropbear SSH"
        _hub_item "4" "♻️  Recover Xray"       "Recover expired Xray accounts"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) protocol_menu ;;
            2) on_off_service_menu ;;
            3) dropbear_config_menu; press_enter ;;
            4) recover_expired_xray; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

monitoring_hub() {
    while true; do
        show_banner
        _hub_header "📊 MONITORING & TRAFFIC"
        _hub_item "1" "📈 Traffic Monitor"    "Live bandwidth & session usage"
        _hub_item "2" "📊 Client Details"     "Per-client connection info"
        _hub_item "3" "ℹ️  Service Info"       "Ports & status of all services"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) traffic_monitor_menu ;;
            2) client_details_menu; press_enter ;;
            3) service_info_menu ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

access_hub() {
    while true; do
        show_banner
        _hub_header "🎨 ACCESS & CONTENT"
        _hub_item "1" "🎨 SSH Banner"         "Set the login banner"
        _hub_item "2" "🔞 Content Filter"     "Block/allow content categories"
        _hub_item "3" "🚫 Bypass Proxy"       "Manage proxy bypass rules"
        _hub_item "4" "👑 Grant Root"         "Grant sudo + SSH shell access"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) ssh_banner_menu ;;
            2) content_filter_menu ;;
            3) bypass_proxy_menu; press_enter ;;
            4) grant_root_menu ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

network_hub() {
    while true; do
        show_banner
        _hub_header "🌐 NETWORK & PORTS"
        _hub_item "1" "🔥 NAT Forwarding"     "Manage port forwarding rules"
        _hub_item "2" "🔌 Port Manager"       "Open/close/free ports"
        _hub_item "3" "🌐 Set Domain"         "Set the custom domain"
        _hub_item "4" "🔄 ZiVPN Resync"       "Resync ZiVPN passwords"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) nat_forward_menu ;;
            2) port_manager_menu; press_enter ;;
            3) set_domain ;;
            4) zivpn_resync_passwords; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

system_hub() {
    while true; do
        show_banner
        _hub_header "⚙️ SYSTEM & SERVER"
        _hub_item "1" "🔄 Auto-Reboot Task"   "Schedule automatic reboots"
        _hub_item "2" "🕐 Timezone"           "Set the server timezone"
        _hub_item "3" "⬇️ Update Script"      "Fetch latest menu.sh from the repo"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) auto_reboot_menu ;;
            2) timezone_menu ;;
            3) update_script ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

# ═══════════════════════════════════════════════════════════════════════════
#  GCP CLOUD RUN — VLESS DEPLOYER
#  Deploys a VLESS (xray) proxy container to Google Cloud Run. Two flavours:
#    • Own Project  — any region, always-on, billed to the user's own GCP
#                     project (unlimited lifetime).
#    • Qwiklabs Lab — locked to us-central1, for the throwaway 5-hour lab
#                     sandbox (upstream saekacutie/script behaviour).
#  Unlike the local protocols above, these run on Google's cloud, not this
#  server — so they live here under Integrations, not in the systemd grid.
# ═══════════════════════════════════════════════════════════════════════════
GCP_VLESS_URI_FILE="$DB_DIR/gcp-vless-uri.txt"

# Stage all container build assets into $1 (a build dir). Faithful copies of
# the upstream saekacutie/script files, with a freshly generated UUID so every
# deployment gets unique credentials instead of the shared hard-coded one.
_gcp_vless_write_assets() {
    local d="$1"
    local uuid
    if [[ -r /proc/sys/kernel/random/uuid ]]; then
        uuid=$(cat /proc/sys/kernel/random/uuid)
    elif command -v uuidgen &>/dev/null; then
        uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
    else
        uuid=$(python3 -c 'import uuid;print(uuid.uuid4())' 2>/dev/null)
    fi
    [[ -n "$uuid" ]] || uuid="9e507b33-65b6-40a4-b37f-eabad158b645"

    cat > "$d/config.json" <<EOF
{
  "log": { "loglevel": "none" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": 8080,
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "${uuid}" }
        ],
        "decryption": "none",
        "fallbacks": [
          { "path": "/prvtspyyy", "dest": "@xhttp" },
          { "dest": "@dashboard" }
        ]
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "none",
        "xhttpSettings": {
          "path": "/prvtspyyy",
          "host": ["*"],
          "method": "GET",
          "maxConnections": 200,
          "maxConcurrentStreams": 200,
          "idleTimeout": 300,
          "pingTimeout": 100
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    },
    {
      "tag": "xhttp",
      "listen": "127.0.0.1",
      "port": 8082,
      "protocol": "vless",
      "settings": { "clients": [], "decryption": "none" },
      "streamSettings": { "network": "xhttp" }
    },
    {
      "tag": "dashboard",
      "listen": "127.0.0.1",
      "port": 8081,
      "protocol": "http",
      "settings": {
        "response": {
          "status": 200,
          "headers": { "Content-Type": ["text/plain", "text/html"] },
          "body": "Prvtspyyy404"
        }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "settings": { "domainStrategy": "UseIPv4" } }
  ]
}
EOF

    cat > "$d/Dockerfile" <<'EOF'
FROM teddysun/xray:latest
RUN apk add --no-cache python3 sqlite curl bash
COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
COPY server.py /server.py
COPY log-user.sh /log-user.sh
COPY network-monitor.sh /network-monitor.sh
COPY ip-manager.sh /ip-manager.sh
RUN chmod +x /entrypoint.sh /server.py /log-user.sh /network-monitor.sh /ip-manager.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
EOF

    cat > "$d/entrypoint.sh" <<'EOF'
#!/bin/bash
set -euo pipefail
sed -i "s/8080/$PORT/g" /etc/xray/config.json
echo "[1] Port set to: $PORT"
python3 /server.py --host 127.0.0.1 --port 8081 &
sleep 1
/ip-manager.sh start &
sleep 1
echo "[2] Starting Xray Core..."
/usr/bin/xray run -c /etc/xray/config.json &
echo "[3] Waiting for port $PORT to open..."
until nc -z 127.0.0.1 $PORT; do
  sleep 0.2
done
echo "[OK] SUCCESS: Listening on $PORT — Ready!"
wait
EOF

    cat > "$d/server.py" <<'EOF'
#!/usr/bin/env python3
import sqlite3, json, os, time, argparse
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse
from datetime import datetime
import threading

DB_FILE = "/tmp/vless_users.db"
IP_FILE = "/tmp/remote_ips.txt"
START_TIME = time.time()

def init_db():
    with sqlite3.connect(DB_FILE) as c:
        c.execute('''CREATE TABLE IF NOT EXISTS connections (
            id INTEGER PRIMARY KEY AUTOINCREMENT, source_ip TEXT UNIQUE,
            connected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            duration TEXT DEFAULT '00:00:00', status TEXT DEFAULT 'ACTIVE'
        )''')

def update_ip_file():
    while True:
        try:
            with sqlite3.connect(DB_FILE) as c:
                ips = [r[0] for r in c.execute("SELECT source_ip FROM connections WHERE status='ACTIVE' ORDER BY last_seen DESC").fetchall()]
            with open(IP_FILE, 'w') as f:
                f.write(f"# Updated: {datetime.now()}\n# Total: {len(ips)}\n\n" + "\n".join(ips))
        except: pass
        time.sleep(10)

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        p = urlparse(self.path)
        if p.path == '/health':
            self.send(200, 'text/plain', b'healthy')
        elif p.path == '/remote_ips.txt':
            self.serve_file()
        elif p.path == '/api/stats':
            self.serve_stats()
        elif p.path == '/api/connections':
            self.serve_conns()
        elif p.path == '/':
            self.serve_dash()
        else:
            self.send(404, 'text/plain', b'Not Found')

    def send(self, code, ctype, data):
        self.send_response(code)
        self.send_header('Content-Type', ctype)
        self.end_headers()
        self.wfile.write(data)

    def serve_file(self):
        if os.path.exists(IP_FILE):
            self.send(200, 'text/plain', open(IP_FILE,'rb').read())
        else: self.send(404,'text/plain',b'No file')

    def serve_stats(self):
        uptime = int(time.time()-START_TIME)
        with sqlite3.connect(DB_FILE) as c:
            active = c.execute("SELECT COUNT(*) FROM connections WHERE status='ACTIVE'").fetchone()[0]
        data = json.dumps({'active':active,'uptime':uptime})
        self.send(200,'application/json',data.encode())

    def serve_conns(self):
        with sqlite3.connect(DB_FILE) as c:
            res = c.execute("SELECT * FROM connections").fetchall()
        self.send(200,'application/json',json.dumps(res).encode())

    def serve_dash(self):
        html = f'''<!DOCTYPE html><html><head><meta charset=utf-8><title>VLESS+XHTTP</title>
<style>body{{background:#0a0e27;color:#e0e0e0;font-family:monospace;padding:20px}}
.box{{background:#111;border-left:3px solid #0f8;padding:15px;margin:10px 0}}</style></head>
<body><h1 style="color:#0f8">VLESS Manager</h1>
<div class=box><b>Status:</b> ONLINE<br><b>Protocol:</b> VLESS+XHTTP<br><b>Uptime:</b> {int(time.time()-START_TIME)}s<br>
<b>IP List:</b> <a href=/remote_ips.txt style="color:#0f8">/remote_ips.txt</a></div></body></html>'''
        self.send(200,'text/html',html.encode())

if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--host',default='127.0.0.1')
    ap.add_argument('--port',type=int,default=8081)
    a = ap.parse_args()
    init_db()
    threading.Thread(target=update_ip_file,daemon=True).start()
    HTTPServer((a.host,a.port),Handler).serve_forever()
EOF

    cat > "$d/ip-manager.sh" <<'EOF'
#!/bin/sh
DB="/tmp/vless_users.db"
IP_FILE="/tmp/remote_ips.txt"
case "$1" in
  start)
    while true; do
      sqlite3 "$DB" "SELECT source_ip FROM connections WHERE status='ACTIVE' ORDER BY last_seen DESC;" 2>/dev/null > "$IP_FILE.tmp"
      mv "$IP_FILE.tmp" "$IP_FILE"
      sleep 10
    done
    ;;
  list) echo "=== Active Remote IPs ==="; cat "$IP_FILE" ;;
  count) echo "Total Active: $(wc -l < "$IP_FILE")" ;;
  block)
    [ -z "$2" ] && echo "Usage: block <IP>" && exit 1
    sqlite3 "$DB" "UPDATE connections SET is_blocked=1, status='BLOCKED' WHERE source_ip='$2';"
    echo "Blocked: $2" ;;
  unblock)
    [ -z "$2" ] && echo "Usage: unblock <IP>" && exit 1
    sqlite3 "$DB" "UPDATE connections SET is_blocked=0, status='ACTIVE' WHERE source_ip='$2';"
    echo "Unblocked: $2" ;;
  blocked)
    echo "=== Blocked IPs ==="
    sqlite3 "$DB" "SELECT source_ip FROM connections WHERE status='BLOCKED';" ;;
  *) echo "VLESS+XHTTP IP Manager"; echo "Usage: $0 [list|count|block <IP>|unblock <IP>|blocked]" ;;
esac
EOF

    cat > "$d/log-user.sh" <<'EOF'
#!/bin/sh
DB="/tmp/vless_users.db"
[ ! -f "$DB" ] && sqlite3 "$DB" "CREATE TABLE IF NOT EXISTS connections (id INTEGER PRIMARY KEY AUTOINCREMENT,source_ip TEXT UNIQUE,connected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,is_blocked BOOLEAN DEFAULT 0);" 2>/dev/null
[ -n "$1" ] && sqlite3 "$DB" "INSERT OR REPLACE INTO connections (source_ip,last_seen) VALUES ('$1',CURRENT_TIMESTAMP);" 2>/dev/null
EOF

    cat > "$d/network-monitor.sh" <<'EOF'
#!/bin/bash
SERVICE_NAME="${1:-vless-xhttp}"
REGION="${2:-us-central1}"
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" --region="$REGION" --format='value(status.url)' 2>/dev/null)
[ -z "$SERVICE_URL" ] && echo "[!] Service not found" && exit 1
LOG_DIR="$HOME/vless-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/status-$(date +%Y%m%d).log"
INTERVAL=30
echo "[*] Monitor started: $SERVICE_URL"
trap 'exit 0' INT
while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    RESULT=$(curl -o /dev/null -s -w "%{time_total}|%{http_code}" --max-time 5 "${SERVICE_URL}/health" 2>/dev/null)
    if [ -n "$RESULT" ]; then
        CODE=$(echo "$RESULT" | cut -d'|' -f2)
        [ "$CODE" = "200" ] && STATUS="UP" || STATUS="WARN"
        LOG_ENTRY="$TIMESTAMP | $STATUS | HTTP $CODE"
    else
        LOG_ENTRY="$TIMESTAMP | DOWN | Timeout"
    fi
    echo "$LOG_ENTRY" >> "$LOG_FILE"
    sleep "$INTERVAL"
done
EOF

    chmod +x "$d"/*.sh "$d/server.py" 2>/dev/null || true
    GCP_VLESS_LAST_UUID="$uuid"
}

# Confirm gcloud is present and the user is authenticated. The container image
# is built remotely by Cloud Build, so no local docker is required. Returns
# non-zero (with a printed explanation) if the environment can't deploy.
_gcp_vless_preflight() {
    if ! command -v gcloud &>/dev/null; then
        echo -e "${C_RED}❌ 'gcloud' CLI not found.${C_RESET}"
        echo -e "${C_DIM}   This deployer runs where the Google Cloud SDK is installed —${C_RESET}"
        echo -e "${C_DIM}   e.g. Google Cloud Shell, or any machine with gcloud (no docker needed).${C_RESET}"
        echo -e "${C_DIM}   Install: https://cloud.google.com/sdk/docs/install${C_RESET}"
        return 1
    fi
    if ! gcloud auth list --filter=status:ACTIVE --format='value(account)' 2>/dev/null | grep -q .; then
        echo -e "${C_YELLOW}⚠️ No active gcloud account. Run:${C_RESET} ${C_CYAN}gcloud auth login${C_RESET}"
        return 1
    fi
    return 0
}

# Shared build (Cloud Build) → deploy engine.
#   $1 project  $2 region  $3 service  $4 cpu  $5 memory
_gcp_vless_deploy_engine() {
    local project="$1" region="$2" service="$3" cpu="$4" memory="$5"
    local build_dir image uuid ws_path service_url clean_host vless_uri

    build_dir=$(mktemp -d 2>/dev/null || echo "/tmp/VPS_superScript-gcp-vless.$$")
    mkdir -p "$build_dir"
    echo -e "${C_CYAN}[*]${C_RESET} Staging container assets in ${C_DIM}${build_dir}${C_RESET}"
    _gcp_vless_write_assets "$build_dir"

    echo -e "${C_CYAN}[*]${C_RESET} Enabling required APIs (run, containerregistry, cloudbuild)..."
    gcloud services enable run.googleapis.com containerregistry.googleapis.com cloudbuild.googleapis.com --quiet 2>/dev/null || true

    uuid=$(grep -o '"id": *"[^"]*"' "$build_dir/config.json" | cut -d'"' -f4 | head -n1)
    ws_path=$(grep -o '"path": *"[^"]*"' "$build_dir/config.json" | cut -d'"' -f4 | head -n1)
    image="gcr.io/${project}/${service}:latest"

    echo -e "${C_CYAN}[*]${C_RESET} Building image ${C_DIM}${image}${C_RESET} remotely with Cloud Build..."
    echo -e "${C_DIM}    (no local docker needed — Google builds the image for you)${C_RESET}"
    if ! ( cd "$build_dir" && gcloud builds submit --tag "$image" --quiet . ); then
        echo -e "${C_RED}❌ Cloud Build failed (see error above).${C_RESET}"
        echo -e "${C_DIM}   Common causes: billing not enabled, or Cloud Build API blocked.${C_RESET}"
        rm -rf "$build_dir"; return 1
    fi

    echo -e "${C_CYAN}[*]${C_RESET} Deploying to Cloud Run in ${C_WHITE}${region}${C_RESET} ..."
    if ! gcloud run deploy "$service" \
        --image "$image" \
        --platform managed \
        --region "$region" \
        --allow-unauthenticated \
        --port 8080 \
        --cpu "$cpu" \
        --memory "$memory" \
        --cpu-boost \
        --concurrency 1000 \
        --timeout 3600 \
        --min-instances 1 \
        --max-instances 1 \
        --no-cpu-throttling \
        --session-affinity \
        --quiet; then
        echo -e "${C_RED}❌ Deployment failed (see error above).${C_RESET}"
        rm -rf "$build_dir"; return 1
    fi

    service_url=$(gcloud run services describe "$service" --region "$region" --format='value(status.url)' 2>/dev/null)
    clean_host=$(echo "$service_url" | sed 's|https://||')
    vless_uri="vless://${uuid}@${clean_host}:443?encryption=none&security=tls&type=ws&path=%2F${ws_path#/}&host=${clean_host}&sni=${clean_host}&fp=chrome#${service}"

    mkdir -p "$DB_DIR" 2>/dev/null
    echo "$vless_uri" > "$GCP_VLESS_URI_FILE"

    echo
    echo -e "${C_GREEN}════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_GREEN}✅ DEPLOYMENT SUCCESSFUL${C_RESET}"
    echo -e "${C_GREEN}════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_ACCENT}Service:${C_RESET}   ${C_WHITE}${service}${C_RESET}"
    echo -e "  ${C_ACCENT}Address:${C_RESET}   ${C_WHITE}www.gstatic.com${C_RESET}"
    echo -e "  ${C_ACCENT}SNI:${C_RESET}       ${C_WHITE}firebase-settings.crashlytics.com${C_RESET}"
    echo -e "  ${C_ACCENT}Host:${C_RESET}      ${C_WHITE}${clean_host}${C_RESET}"
    echo -e "  ${C_ACCENT}Port:${C_RESET}      ${C_WHITE}443${C_RESET}"
    echo -e "  ${C_ACCENT}UUID:${C_RESET}      ${C_WHITE}${uuid}${C_RESET}"
    echo -e "  ${C_ACCENT}WS Path:${C_RESET}   ${C_WHITE}${ws_path}${C_RESET}"
    echo -e "  ${C_ACCENT}Transport:${C_RESET} ${C_WHITE}WebSocket (ws) over TLS${C_RESET}"
    echo -e "  ${C_ACCENT}Region:${C_RESET}    ${C_WHITE}${region}${C_RESET}"
    echo -e "  ${C_ACCENT}CPU/RAM:${C_RESET}   ${C_WHITE}${cpu} vCPU / ${memory}${C_RESET}"
    echo -e "${C_GREEN}════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_PLAIN:-}${C_WHITE}Import URI:${C_RESET}"
    echo -e "  ${C_CYAN}${vless_uri}${C_RESET}"
    echo -e "${C_GREEN}════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_DIM}URI saved to: ${GCP_VLESS_URI_FILE}${C_RESET}"

    rm -rf "$build_dir"
    return 0
}

# Prompt for a Cloud Run service name (lowercase, RFC1035-safe) with a default.
_gcp_vless_prompt_service() {
    local default="$1" input name
    read -r -p "$(echo -e ${C_PROMPT}"👉 Service name [default: ${default}]: "${C_RESET})" input
    name="${input:-$default}"
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g; s/--*/-/g; s/^-//; s/-$//')
    [[ -n "$name" ]] || name="$default"
    printf '%s' "$name"
}

# Prompt for CPU/RAM. Echoes "CPU|MEMORY".
_gcp_vless_prompt_cpu_ram() {
    local choice cpu memory
    echo -e "  ${C_ACCENT}[1]${C_RESET} 1 vCPU, 1 GiB RAM" >&2
    echo -e "  ${C_ACCENT}[2]${C_RESET} 1 vCPU, 2 GiB RAM" >&2
    echo -e "  ${C_ACCENT}[3]${C_RESET} 2 vCPU, 2 GiB RAM" >&2
    echo -e "  ${C_ACCENT}[4]${C_RESET} 2 vCPU, 4 GiB RAM ${C_GREEN}(RECOMMENDED)${C_RESET}" >&2
    echo -e "  ${C_ACCENT}[5]${C_RESET} 4 vCPU, 8 GiB RAM" >&2
    echo -e "  ${C_ACCENT}[6]${C_RESET} 4 vCPU, 16 GiB RAM" >&2
    read -r -p "$(echo -e ${C_PROMPT}"👉 Select [1-6] [default: 4]: "${C_RESET})" choice
    choice="${choice:-4}"
    case $choice in
        1) cpu="1"; memory="1Gi" ;;
        2) cpu="1"; memory="2Gi" ;;
        3) cpu="2"; memory="2Gi" ;;
        4) cpu="2"; memory="4Gi" ;;
        5) cpu="4"; memory="8Gi" ;;
        6) cpu="4"; memory="16Gi" ;;
        *) cpu="2"; memory="4Gi" ;;
    esac
    printf '%s|%s' "$cpu" "$memory"
}

# [01] Own project — any region, unlimited/always-on, billed to the user.
deploy_gcp_vless_ownproject() {
    clear; show_banner
    echo -e "  ${C_TITLE}   🚀 GCP CLOUD RUN VLESS — DEPLOY TO YOUR OWN PROJECT${C_RESET}"
    echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_DIM}Always-on (min-instances=1). Billed to your GCP project.${C_RESET}"
    echo -e "  ${C_DIM}Rough cost of a warm instance: ~\$25–45/mo. Cloud Run ToS${C_RESET}"
    echo -e "  ${C_DIM}restricts proxy/VPN use — deploy only on a project you own.${C_RESET}"
    echo
    _gcp_vless_preflight || { return 1; }

    local cur_project project region svc cpuram cpu memory
    cur_project=$(gcloud config get-value project 2>/dev/null)
    read -r -p "$(echo -e ${C_PROMPT}"👉 GCP Project ID [default: ${cur_project:-none}]: "${C_RESET})" project
    project="${project:-$cur_project}"
    if [[ -z "$project" ]]; then
        echo -e "${C_RED}❌ A project ID is required.${C_RESET}"; return 1
    fi
    gcloud config set project "$project" --quiet 2>/dev/null

    # Billing must be enabled or Cloud Run / build will fail.
    if command -v gcloud &>/dev/null; then
        local billing
        billing=$(gcloud beta billing projects describe "$project" --format='value(billingEnabled)' 2>/dev/null)
        if [[ "$billing" != "True" && "$billing" != "true" ]]; then
            echo -e "${C_YELLOW}⚠️ Billing does not appear to be enabled on '${project}'.${C_RESET}"
            echo -e "${C_DIM}   Cloud Run always-on requires an active billing account.${C_RESET}"
            read -r -p "$(echo -e ${C_PROMPT}"Continue anyway? [y/N]: "${C_RESET})" go
            [[ "$go" =~ ^[Yy]$ ]] || return 1
        fi
    fi

    read -r -p "$(echo -e ${C_PROMPT}"👉 Region [default: us-central1]: "${C_RESET})" region
    region="${region:-us-central1}"
    svc=$(_gcp_vless_prompt_service "vless-xhttp")
    echo
    cpuram=$(_gcp_vless_prompt_cpu_ram)
    cpu="${cpuram%%|*}"; memory="${cpuram##*|}"
    echo
    _gcp_vless_deploy_engine "$project" "$region" "$svc" "$cpu" "$memory"
}

# [02] Qwiklabs lab — locked to us-central1 (lab org policy), throwaway.
deploy_gcp_vless_lab() {
    clear; show_banner
    echo -e "  ${C_TITLE}   🧪 GCP CLOUD RUN VLESS — QWIKLABS LAB${C_RESET}"
    echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_DIM}For the temporary Qwiklabs / Cloud Skills Boost sandbox.${C_RESET}"
    echo -e "  ${C_DIM}Region is locked to us-central1 by lab org policy. The lab${C_RESET}"
    echo -e "  ${C_DIM}project is torn down at the end of its timed session.${C_RESET}"
    echo
    _gcp_vless_preflight || { return 1; }

    local project region="us-central1" svc cpuram cpu memory
    project=$(gcloud config get-value project 2>/dev/null)
    if [[ -z "$project" ]]; then
        echo -e "${C_RED}❌ No active project. Open this inside the Qwiklabs Cloud Shell.${C_RESET}"
        return 1
    fi
    echo -e "  ${C_ACCENT}Project:${C_RESET} ${C_WHITE}${project}${C_RESET}   ${C_ACCENT}Region:${C_RESET} ${C_WHITE}${region}${C_RESET} ${C_DIM}(locked)${C_RESET}"
    echo
    svc=$(_gcp_vless_prompt_service "prvtspyyy404")
    echo
    cpuram=$(_gcp_vless_prompt_cpu_ram)
    cpu="${cpuram%%|*}"; memory="${cpuram##*|}"
    echo
    _gcp_vless_deploy_engine "$project" "$region" "$svc" "$cpu" "$memory"
}

# [03] Show the most recently deployed VLESS URI.
gcp_vless_show_uri() {
    clear; show_banner
    echo -e "  ${C_TITLE}   📋 LAST VLESS URI${C_RESET}"
    echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
    if [[ -s "$GCP_VLESS_URI_FILE" ]]; then
        echo -e "  ${C_CYAN}$(cat "$GCP_VLESS_URI_FILE")${C_RESET}"
    else
        echo -e "  ${C_DIM}No deployment recorded yet. Deploy first (option 01/02).${C_RESET}"
    fi
    echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
}

# [04] Delete a deployed Cloud Run service.
gcp_vless_delete_service() {
    clear; show_banner
    echo -e "  ${C_DANGER}   🗑️ DELETE A CLOUD RUN SERVICE${C_RESET}"
    echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
    if ! _gcp_vless_preflight; then return 1; fi
    local region svc
    read -r -p "$(echo -e ${C_PROMPT}"👉 Region [default: us-central1]: "${C_RESET})" region
    region="${region:-us-central1}"
    echo -e "  ${C_DIM}Existing services in ${region}:${C_RESET}"
    gcloud run services list --platform managed --region "$region" --format='value(metadata.name)' 2>/dev/null | sed 's/^/    /'
    read -r -p "$(echo -e ${C_PROMPT}"👉 Service name to delete: "${C_RESET})" svc
    [[ -n "$svc" ]] || { echo -e "${C_YELLOW}Cancelled.${C_RESET}"; return 1; }
    read -r -p "$(echo -e ${C_DANGER}"Type the service name again to confirm: "${C_RESET})" confirm
    if [[ "$confirm" == "$svc" ]]; then
        gcloud run services delete "$svc" --platform managed --region "$region" --quiet
        echo -e "${C_GREEN}✅ Deleted ${svc}.${C_RESET}"
    else
        echo -e "${C_YELLOW}Names did not match. Nothing deleted.${C_RESET}"
    fi
}

gcp_vless_menu() {
    while true; do
        show_banner
        echo -e "  ${C_TITLE}       ☁️ GCP CLOUD RUN — VLESS DEPLOYER${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        _mi "01" "🚀 DEPLOY TO MY OWN PROJECT" "(unlimited)"
        _mi "02" "🧪 DEPLOY TO QWIKLABS LAB" "(5-hour)"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        _mi "03" "📋 SHOW LAST VLESS URI"
        _mi "04" "🗑️ DELETE A DEPLOYED SERVICE"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ BACK ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" gc; then
            echo; return
        fi
        case $gc in
            01|1) deploy_gcp_vless_ownproject; press_enter ;;
            02|2) deploy_gcp_vless_lab; press_enter ;;
            03|3) gcp_vless_show_uri; press_enter ;;
            04|4) gcp_vless_delete_service; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

integrations_hub() {
    while true; do
        show_banner
        _hub_header "🤖 INTEGRATIONS"
        _hub_item "1" "🤖 Telegram Bot"       "Manage the Telegram bot"
        _hub_item "2" "🔗 Rest API (9000)"    "Manage the REST API service"
        _hub_item "3" "🦆 DuckDNS"            "Free dynamic DNS for your server"
        _hub_item "4" "☁️  GCP Cloud Run VLESS" "Deploy VLESS proxy to Google Cloud"
        _hub_footer
        read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice || return
        case $choice in
            1) telegram_bot_menu; press_enter ;;
            2) rest_api_menu; press_enter ;;
            3) duckdns_menu ;;
            4) gcp_vless_menu ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

# ADMcgh-style menu item: magenta brackets, green number, yellow arrow,
# white label. $3 is an optional trailing marker (e.g. "▸" for submenus).
_mi() {
    echo -e "  ${C_PURPLE}[${C_GREEN}${1}${C_PURPLE}]${C_RESET} ${C_WARN}⇨${C_RESET} ${C_WHITE}${2}${C_RESET}${3:+ ${C_WARN}${3}${C_RESET}}"
}

# Two-column variant for dense submenus. Uses absolute cursor columns
# (\033[Ng) rather than %-Ns padding because several labels start with
# variation-selector emoji (🗑️ ⚙️ 👁️) that render 1 or 2 cells depending on
# the terminal — printf padding would drift, absolute columns cannot.
_mi2() {
    printf "\033[3G${C_PURPLE}[${C_GREEN}%s${C_PURPLE}]${C_RESET}\033[9G${C_WARN}⇨${C_RESET} ${C_WHITE}%s${C_RESET}\033[34G${C_PURPLE}[${C_GREEN}%s${C_PURPLE}]${C_RESET}\033[40G${C_WARN}⇨${C_RESET} ${C_WHITE}%s${C_RESET}\033[K\n" \
        "$1" "$2" "$3" "$4"
}

# The ten user-management actions, moved off the main menu into their own hub
# so the top level stays at seven entries (ADMcgh shape).
user_control_hub() {
    while true; do
        show_banner
        echo -e "  ${C_TITLE}                  👤 USER CONTROL${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        _mi2 "01" "🌟 CREATE USER"  "06" "📝 EDIT USER"
        _mi2 "02" "🗑️ DELETE USER"  "07" "📋 LIST USERS"
        _mi2 "03" "🔄 RENEW USER"   "08" "👁️ USER DETAILS"
        _mi2 "04" "🔒 LOCK USER"    "09" "⏱️ TRIAL USER"
        _mi2 "05" "🔓 UNLOCK USER"  "10" "➕ MORE USERS ▸"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ BACK ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" uchoice; then
            echo; return
        fi
        case $uchoice in
            01|1) create_user; press_enter ;;
            02|2) delete_user; press_enter ;;
            03|3) renew_user; press_enter ;;
            04|4) lock_user; press_enter ;;
            05|5) unlock_user; press_enter ;;
            06|6) edit_user; press_enter ;;
            07|7) list_users; press_enter ;;
            08|8) view_user_details ;;
            09|9) create_trial_account; press_enter ;;
            10) more_users_hub ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

update_script() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- ⬇️ Update Script ---${C_RESET}"

    # Resolve the live menu binary (follow symlinks) so we update the real file.
    local dest; dest="$(command -v menu 2>/dev/null)"
    [[ -z "$dest" ]] && dest="/usr/local/bin/menu"
    dest="$(readlink -f "$dest" 2>/dev/null || printf '%s' "$dest")"

    local url="$FF_RAW_BASE/menu.sh"
    echo -e "\n${C_CYAN}Source:${C_RESET} $url"
    echo -e "\n${C_YELLOW}⬇️  Downloading latest menu.sh…${C_RESET}"

    local tmp
    tmp=$(mktemp /tmp/skylar_menu.XXXXXX 2>/dev/null) || { echo -e "${C_RED}❌ Could not create temp file.${C_RESET}"; press_enter; return; }
    if ! curl -fsSL --max-time 60 -o "$tmp" "$url"; then
        echo -e "${C_RED}❌ Download failed. Check network / repo URL.${C_RESET}"
        rm -f "$tmp"; press_enter; return
    fi
    # Sanity checks: never clobber a good menu with an empty/HTML/JSON body.
    if [[ ! -s "$tmp" ]]; then
        echo -e "${C_RED}❌ Downloaded file is empty. Update aborted (menu untouched).${C_RESET}"
        rm -f "$tmp"; press_enter; return
    fi
    if ! head -n1 "$tmp" | grep -q '^#!'; then
        echo -e "${C_RED}❌ File is not a valid script (no shebang). Update aborted.${C_RESET}"
        rm -f "$tmp"; press_enter; return
    fi

    local lines; lines=$(wc -l < "$tmp")
    local ts; ts=$(date +%Y%m%d-%H%M%S)
    if [[ -f "$dest" ]]; then
        cp -a "$dest" "${dest}.bak.${ts}" 2>/dev/null && echo -e "${C_DIM}📦 Backup saved: ${dest}.bak.${ts}${C_RESET}"
    fi
    if ! install -m 0755 "$tmp" "$dest" 2>/dev/null; then
        cp -f "$tmp" "$dest" && chmod +x "$dest"
    fi
    rm -f "$tmp"

    echo -e "\n${C_GREEN}✅ Update complete! menu.sh updated (${lines} lines).${C_RESET}"
    echo -e "${C_DIM}Re-run 'menu' (or type menu) to load the new version.${C_RESET}"
    press_enter
}

main_menu() {
    while true; do
        export UNINSTALL_MODE="interactive"
        show_banner

        # Tight ADMcgh-style item list: no blank spacers, one hub per line.
        _mi "01" "👤 USERS CONTROL" "▸"
        _mi "02" "🔌 PROTOCOLS & SERVICES" "▸"
        _mi "03" "📊 MONITORING & TRAFFIC" "▸"
        _mi "04" "🎨 ACCESS & CONTENT" "▸"
        _mi "05" "🌐 NETWORK & PORTS" "▸"
        _mi "06" "⚙️ SYSTEM & SERVER" "▸"
        _mi "07" "🤖 INTEGRATIONS" "▸"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_PURPLE}[${C_GREEN}99${C_PURPLE}]${C_RESET} ${C_WARN}⇨${C_RESET} ${C_WARN}[!]${C_RESET} ${C_DANGER}🔥 UNINSTALL SCRIPT${C_RESET}   ${C_GRAY}|${C_RESET}   ${C_PURPLE}[${C_GREEN}0${C_PURPLE}]${C_RESET} ${C_WARN}⇦${C_RESET} ${C_DIM}${C_WARN}[ EXIT ]${C_RESET}"
        echo -e "${C_BLUE} ═══════════════════════════════════════════════════════════${C_RESET}"
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
            echo
            exit 0
        fi
        case $choice in
            01|1) user_control_hub ;;
            02|2) protocols_hub ;;
            03|3) monitoring_hub ;;
            04|4) access_hub ;;
            05|5) network_hub ;;
            06|6) system_hub ;;
            07|7) integrations_hub ;;

            99) uninstall_script ;;
            0) exit 0 ;;
            *) invalid_option ;;
        esac
    done
}

# ═══════════════════════════════════════════════════════════
# NEW PROTOCOL INSTALLERS
# ═══════════════════════════════════════════════════════════

# ── Dropbear ──────────────────────────────────────────────
install_dropbear() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🦘 Install Dropbear (Lightweight SSH) ---${C_RESET}"
    if command -v dropbear &>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ Dropbear is already installed.${C_RESET}"
        ff_service_kick dropbear "Dropbear"
        return
    fi
    echo -e "\n${C_BLUE}📦 Installing Dropbear...${C_RESET}"
    ff_pkg_install dropbear >/dev/null 2>&1 || { echo -e "${C_RED}❌ Failed to install Dropbear.${C_RESET}"; return; }

    echo -e "\n${C_BLUE}🔧 Configuring Dropbear on ports ${DROPBEAR_PORTS}...${C_RESET}"
    local db_args=""
    IFS=',' read -ra _db_ports <<< "$DROPBEAR_PORTS"
    for _p in "${_db_ports[@]}"; do
        _p="${_p// /}"
        db_args+=" -p ${_p}"
        check_and_open_firewall_port "$_p" tcp
    done

    if [[ -f /etc/default/dropbear ]]; then
        sed -i 's/^#\?\s*NO_START=.*/NO_START=0/' /etc/default/dropbear
        if grep -q '^#\?\s*DROPBEAR_EXTRA_ARGS=' /etc/default/dropbear; then
            sed -i "s|^#\?\s*DROPBEAR_EXTRA_ARGS=.*|DROPBEAR_EXTRA_ARGS=\"${db_args}\"|" /etc/default/dropbear
        else
            echo "DROPBEAR_EXTRA_ARGS=\"${db_args}\"" >> /etc/default/dropbear
        fi
        sed -i 's/^#\?\s*DROPBEAR_PORT=.*/DROPBEAR_PORT=22/' /etc/default/dropbear
    fi

    # On Debian/Ubuntu the dropbear package ships `dropbear.socket` alongside
    # `dropbear.service`. Enabling the service starts a listener immediately;
    # starting the socket instead leaves `is-active dropbear` reporting inactive
    # while Dropbear is in fact reachable — which the status grid reads as red.
    # Disable the socket so the unit the grid checks is the one that runs.
    systemctl disable --now dropbear.socket >/dev/null 2>&1
    if ff_service_up dropbear "Dropbear" 2; then
        echo -e "${C_GREEN}✅ Dropbear installed on ports ${DROPBEAR_PORTS}.${C_RESET}"
    fi
}
uninstall_dropbear() {
    echo -e "\n${C_BLUE}🗑️ Removing Dropbear...${C_RESET}"
    systemctl stop dropbear 2>/dev/null; systemctl disable dropbear 2>/dev/null
    ff_pkg_purge dropbear >/dev/null 2>&1
    rm -f /etc/dropbear_banner 2>/dev/null
    rm -f /etc/default/dropbear 2>/dev/null
    echo -e "${C_GREEN}✅ Dropbear removed.${C_RESET}"
}

# ── WS-SSH (WebSocket SSH Proxy) ──────────────────────────
install_ws_ssh() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🌐 Install WS-SSH (WebSocket SSH Proxy) ---${C_RESET}"
    if systemctl is-active --quiet ws-ssh 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ WS-SSH is already installed and running.${C_RESET}"
        return
    fi
    if ! command -v python3 &>/dev/null; then
        echo -e "${C_RED}❌ Python3 is required but not found.${C_RESET}"
        return
    fi

    local ws_response
    echo -e "\n${C_CYAN}Choose the HTTP response status for the tunnel handshake:${C_RESET}"
    echo -e "  ${C_GREEN}[1]${C_RESET} HTTP/1.1 101 Switching Protocols  ${C_DIM}(WebSocket standard)${C_RESET}"
    echo -e "  ${C_GREEN}[2]${C_RESET} HTTP/1.1 200 OK  ${C_DIM}(works on most carriers)${C_RESET}"
    echo -e "  ${C_GREEN}[3]${C_RESET} HTTP/1.1 200 Connection Established  ${C_DIM}(CONNECT style)${C_RESET}"
    echo -e "  ${C_GREEN}[4]${C_RESET} Custom"
    local resp_choice
    read -p "👉 Select response [1]: " resp_choice
    resp_choice=${resp_choice:-1}
    case "$resp_choice" in
        1) ws_response="HTTP/1.1 101 Switching Protocols" ;;
        2) ws_response="HTTP/1.1 200 OK" ;;
        3) ws_response="HTTP/1.1 200 Connection Established" ;;
        4) read -p "👉 Enter custom response (e.g. HTTP/1.1 200 Bienvenido): " ws_response
           [[ -z "$ws_response" ]] && ws_response="HTTP/1.1 101 Switching Protocols" ;;
        *) ws_response="HTTP/1.1 101 Switching Protocols" ;;
    esac
    echo -e "   ${C_GREEN}Response:${C_RESET} $ws_response"

    echo -e "\n${C_BLUE}📦 Creating WebSocket SSH bridge...${C_RESET}"

    cat > "$WS_SSH_SCRIPT" <<'WSEOF'
#!/usr/bin/env python3
import socket, select, threading, sys, hashlib, base64, os, signal

SSH_HOST, SSH_PORT = "127.0.0.1", 22
BUF = 65536
CONF = "/etc/VPS_superScript/ws_ssh_config.conf"

def load_response():
    resp = "HTTP/1.1 101 Switching Protocols"
    try:
        with open(CONF) as f:
            for line in f:
                if line.startswith("RESPONSE="):
                    resp = line.strip().split("=", 1)[1].strip('"').strip("'")
                    break
    except FileNotFoundError:
        pass
    return resp

CUSTOM_RESPONSE = load_response()

def relay(a, b):
    try:
        while True:
            r, _, _ = select.select([a, b], [], [], 60)
            if not r:
                break
            for s in r:
                d = s.recv(BUF)
                if not d:
                    return
                (b if s is a else a).sendall(d)
    except Exception:
        pass
    finally:
        a.close()
        b.close()

def handle(client):
    try:
        data = b""
        while b"\r\n\r\n" not in data:
            chunk = client.recv(4096)
            if not chunk:
                client.close()
                return
            data += chunk

        header_block = data.split(b"\r\n\r\n", 1)[0].decode("utf-8", errors="ignore")
        headers = {}
        lines = header_block.split("\r\n")
        for line in lines[1:]:
            if ":" in line:
                k, v = line.split(":", 1)
                headers[k.strip().lower()] = v.strip()

        ssh = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ssh.connect((SSH_HOST, SSH_PORT))

        if "upgrade" in headers and "websocket" in headers.get("upgrade", "").lower():
            key = headers.get("sec-websocket-key", "")
            magic = "258EAFA5-E914-47DA-95CA-5AB5FE8286DD"
            accept = base64.b64encode(hashlib.sha1((key + magic).encode()).digest()).decode()
            if "101" in CUSTOM_RESPONSE:
                resp = (
                    f"{CUSTOM_RESPONSE}\r\n"
                    "Upgrade: websocket\r\n"
                    "Connection: Upgrade\r\n"
                    f"Sec-WebSocket-Accept: {accept}\r\n\r\n"
                )
            else:
                resp = f"{CUSTOM_RESPONSE}\r\n\r\n"
            client.sendall(resp.encode())
        elif lines[0].upper().startswith("CONNECT"):
            client.sendall(f"{CUSTOM_RESPONSE}\r\n\r\n".encode())
        else:
            client.sendall(f"{CUSTOM_RESPONSE}\r\n\r\n".encode())
            leftover = data.split(b"\r\n\r\n", 1)[1]
            if leftover:
                ssh.sendall(leftover)

        relay(client, ssh)
    except Exception:
        client.close()

def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 2082
    signal.signal(signal.SIGTERM, lambda *_: os._exit(0))
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(("0.0.0.0", port))
    srv.listen(128)
    sys.stderr.write(f"[WS-SSH] Listening on :{port} | Response: {CUSTOM_RESPONSE}\n")
    while True:
        c, _ = srv.accept()
        threading.Thread(target=handle, args=(c,), daemon=True).start()

if __name__ == "__main__":
    main()
WSEOF
    chmod +x "$WS_SSH_SCRIPT"

    cat > "$WS_SSH_SERVICE" <<WSSVC
[Unit]
Description=WebSocket SSH Proxy
After=network.target
[Service]
Type=simple
User=root
ExecStart=/usr/bin/python3 ${WS_SSH_SCRIPT} ${WS_SSH_INTERNAL_PORT}
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
WSSVC

    cat > "$WS_SSH_CONFIG_FILE" <<WSCFG
PORTS="${WS_SSH_INTERNAL_PORT}"
RESPONSE="${ws_response}"
WSCFG

    check_and_open_firewall_port "$WS_SSH_INTERNAL_PORT" tcp
    if ! ff_service_up ws-ssh "WS-SSH" 2; then
        echo -e "${C_YELLOW}ℹ️ WS-SSH bridge did not come up. Check that port ${WS_SSH_INTERNAL_PORT} is free and python3 is installed.${C_RESET}"
        return 1
    fi

    echo -e "\n${C_GREEN}✅ WS-SSH installed and active.${C_RESET}"
    echo -e "${C_CYAN}   Internal bridge port: ${WS_SSH_INTERNAL_PORT}${C_RESET}"
    echo -e "${C_CYAN}   HTTP Response: ${ws_response}${C_RESET}"
    echo -e "${C_CYAN}   Access via the Nginx proxy: ports 80, 443 (path /${WS_SSH_INTERNAL_PORT}/)${C_RESET}"
    echo -e "${C_CYAN}   Or direct: port ${WS_SSH_INTERNAL_PORT}${C_RESET}"
    echo -e "${C_DIM}   Works with HTTP Injector, HA Tunnel, KPN Tunnel, etc.${C_RESET}"

    if systemctl is-active --quiet nginx 2>/dev/null; then
        _ws_ssh_update_nginx_backend
    fi
}
uninstall_ws_ssh() {
    echo -e "\n${C_BLUE}🗑️ Removing WS-SSH...${C_RESET}"
    systemctl stop ws-ssh 2>/dev/null; systemctl disable ws-ssh 2>/dev/null
    rm -f "$WS_SSH_SCRIPT" "$WS_SSH_SERVICE" "$WS_SSH_CONFIG_FILE"
    systemctl daemon-reload
    if systemctl is-active --quiet nginx 2>/dev/null; then
        _ws_ssh_update_nginx_backend
    fi
    echo -e "${C_GREEN}✅ WS-SSH removed.${C_RESET}"
}

# Update Nginx location / backend: prefer FalconProxy if running, else WS-SSH, else 8080 default
_ws_ssh_update_nginx_backend() {
    [[ -f "$NGINX_CONFIG_FILE" ]] || return 0
    local backend_port="8080"
    if systemctl is-active --quiet falconproxy 2>/dev/null; then
        backend_port=$(grep -oP '^PORTS="\K[^"]*' "$FALCONPROXY_CONFIG_FILE" 2>/dev/null | cut -d',' -f1)
        [[ -z "$backend_port" ]] && backend_port="8080"
    elif systemctl is-active --quiet ws-ssh 2>/dev/null; then
        backend_port="$WS_SSH_INTERNAL_PORT"
    fi
    sed -i "s|proxy_pass http://127.0.0.1:[0-9]*;|proxy_pass http://127.0.0.1:${backend_port};|" "$NGINX_CONFIG_FILE" 2>/dev/null
    nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null
}

# ── OpenVPN ───────────────────────────────────────────────
install_openvpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🛡️ Install OpenVPN ---${C_RESET}"
    if systemctl is-active --quiet openvpn@server-tcp 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ OpenVPN is already installed.${C_RESET}"
        return
    fi
    echo -e "\n${C_BLUE}📦 Installing OpenVPN packages...${C_RESET}"
    ff_pkg_install openvpn easy-rsa >/dev/null 2>&1 || { echo -e "${C_RED}❌ Failed to install packages.${C_RESET}"; return; }

    echo -e "${C_BLUE}🔧 Enabling IP forwarding...${C_RESET}"
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
    mkdir -p /etc/sysctl.d 2>/dev/null
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-vpn-forward.conf

    check_and_open_firewall_port "$OPENVPN_TCP_PORT" tcp
    check_and_open_firewall_port "$OPENVPN_UDP_PORT" udp
    check_and_open_firewall_port "$OPENVPN_SDNS_PORT" udp
    mkdir -p "$EXPORTS_DIR" 2>/dev/null

    echo -e "\n${C_BLUE}🔐 Generating PKI (CA, server cert, DH params)...${C_RESET}"
    local EASYRSA_SRC
    for d in /usr/share/easy-rsa /usr/share/doc/easy-rsa; do
        [[ -d "$d" ]] && { EASYRSA_SRC="$d"; break; }
    done
    if [[ -z "$EASYRSA_SRC" ]]; then
        echo -e "${C_RED}❌ easy-rsa templates not found.${C_RESET}"
        return
    fi
    rm -rf /etc/openvpn/easy-rsa 2>/dev/null
    mkdir -p /etc/openvpn/easy-rsa
    if [[ -f "$EASYRSA_SRC/easyrsa" ]]; then
        cp -r "$EASYRSA_SRC"/* /etc/openvpn/easy-rsa/ || \
            echo -e "${C_YELLOW}⚠️ Some easy-rsa files may not have copied.${C_RESET}"
    elif [[ -d "$EASYRSA_SRC" ]]; then
        rsync -a "$EASYRSA_SRC"/ /etc/openvpn/easy-rsa/ 2>/dev/null || cp -rn "$EASYRSA_SRC"/* /etc/openvpn/easy-rsa/ 2>/dev/null
    fi
    # Run easyrsa in a subshell. A bare cd here would leave the menu parked in
    # /etc/openvpn/easy-rsa, which the rm -rf above deletes on a second install
    # — stranding the shell in a non-existent directory and breaking git and
    # other tools for the rest of the session.
    [[ -x /etc/openvpn/easy-rsa/easyrsa ]] || { echo -e "${C_RED}❌ easyrsa not found after copy.${C_RESET}"; return; }
    (
        cd /etc/openvpn/easy-rsa || exit 1
        ./easyrsa init-pki 2>/dev/null
        EASYRSA_BATCH=1 ./easyrsa build-ca nopass 2>/dev/null
        EASYRSA_BATCH=1 ./easyrsa build-server-full server nopass 2>/dev/null
        ./easyrsa gen-dh 2>/dev/null
    ) || { echo -e "${C_RED}❌ Failed to enter the easy-rsa directory.${C_RESET}"; return; }
    openvpn --genkey --secret /etc/openvpn/ta.key 2>/dev/null

    # Server TCP config
    cat > /etc/openvpn/server-tcp.conf <<OVPNA
port ${OPENVPN_TCP_PORT}
proto tcp
dev tun
ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem
tls-auth /etc/openvpn/ta.key 0
auth SHA256
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 1.1.1.1"
keepalive 10 120
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn-status.log
log-append /var/log/openvpn-tcp.log
verb 3
explicit-exit-notify 0
plugin /usr/lib/openvpn/openvpn-auth-pam.so login
username-as-common-name
duplicate-cn
OVPNA

    # Server UDP config
    cat > /etc/openvpn/server-udp.conf <<OVPNB
port ${OPENVPN_UDP_PORT}
proto udp
dev tun
ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem
tls-auth /etc/openvpn/ta.key 0
auth SHA256
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
topology subnet
server 10.9.0.0 255.255.255.0
ifconfig-pool-persist ipp-udp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 1.1.1.1"
keepalive 10 120
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn-status-udp.log
log-append /var/log/openvpn-udp.log
verb 3
explicit-exit-notify 1
plugin /usr/lib/openvpn/openvpn-auth-pam.so login
username-as-common-name
duplicate-cn
OVPNB

    # Server SlowDNS config (no redirect-gateway; DNSTT handles routing)
    cat > /etc/openvpn/server-sdns.conf <<OVPNC
port ${OPENVPN_SDNS_PORT}
proto udp
dev tun
ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem
tls-auth /etc/openvpn/ta.key 0
auth SHA256
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
topology subnet
server 10.10.0.0 255.255.255.0
ifconfig-pool-persist ipp-sdns.txt
keepalive 10 120
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn-status-sdns.log
log-append /var/log/openvpn-sdns.log
verb 3
explicit-exit-notify 1
plugin /usr/lib/openvpn/openvpn-auth-pam.so login
username-as-common-name
duplicate-cn
OVPNC

    # Enable and start TCP + UDP instances. Both are verified: /etc/openvpn is
    # scanned for *.conf and each match becomes openvpn@<basename>, so a missing
    # cert, DH file or PAM plugin used to announce success and leave red dots.
    local _ovpn_ok=true
    ff_service_up openvpn@server-tcp "OpenVPN (TCP)" 3 || _ovpn_ok=false
    ff_service_up openvpn@server-udp "OpenVPN (UDP)" 3 || _ovpn_ok=false
    # SlowDNS server is started only when DNSTT is active

    if $_ovpn_ok; then
        echo -e "\n${C_GREEN}✅ OpenVPN installed with auto-generated PKI.${C_RESET}"
        echo -e "${C_CYAN}   TCP mode:     ${OPENVPN_TCP_PORT} (active)${C_RESET}"
        echo -e "${C_CYAN}   UDP mode:     ${OPENVPN_UDP_PORT} (active)${C_RESET}"
        echo -e "${C_DIM}   Client configs will be auto-generated on account creation.${C_RESET}"
    fi
    echo -e "${C_CYAN}   SlowDNS mode: ${OPENVPN_SDNS_PORT} (start with DNSTT)${C_RESET}"
}
uninstall_openvpn() {
    echo -e "\n${C_BLUE}🗑️ Removing OpenVPN...${C_RESET}"
    systemctl stop openvpn@server-tcp 2>/dev/null; systemctl disable openvpn@server-tcp 2>/dev/null
    systemctl stop openvpn@server-udp 2>/dev/null; systemctl disable openvpn@server-udp 2>/dev/null
    systemctl stop openvpn@server-sdns 2>/dev/null; systemctl disable openvpn@server-sdns 2>/dev/null
    ff_pkg_purge openvpn >/dev/null 2>&1
    rm -rf /etc/openvpn/easy-rsa /etc/openvpn/server-tcp.conf /etc/openvpn/server-udp.conf /etc/openvpn/server-sdns.conf /etc/openvpn/ta.key 2>/dev/null
    echo -e "${C_GREEN}✅ OpenVPN removed.${C_RESET}"
}

# ── WireGuard ─────────────────────────────────────────────
install_wireguard() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔗 Install WireGuard ---${C_RESET}"
    if systemctl is-active --quiet wg-quick@wg0 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ WireGuard is already installed.${C_RESET}"
        return
    fi
    # Present but stopped (reboot, failed start): wg0.conf exists, so fall
    # through to the enable/start block rather than reinstalling from scratch.
    echo -e "\n${C_BLUE}📦 Installing WireGuard...${C_RESET}"
    ff_pkg_install wireguard wireguard-tools >/dev/null 2>&1 || { echo -e "${C_RED}❌ Failed to install WireGuard.${C_RESET}"; return; }

    echo -e "${C_BLUE}🔧 Enabling IP forwarding...${C_RESET}"
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
    mkdir -p /etc/sysctl.d 2>/dev/null
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-vpn-forward.conf

    check_and_open_firewall_port "$WIREGUARD_PORT" udp
    mkdir -p "$EXPORTS_DIR" 2>/dev/null

    echo -e "\n${C_BLUE}🔐 Generating server keys...${C_RESET}"
    mkdir -p /etc/wireguard 2>/dev/null
    wg genkey | tee /etc/wireguard/server.key | wg pubkey > /etc/wireguard/server.pub 2>/dev/null
    chmod 600 /etc/wireguard/server.key

    local WG_SERVER_PRIV; WG_SERVER_PRIV=$(</etc/wireguard/server.key)

    cat > /etc/wireguard/wg0.conf <<WGE
[Interface]
PrivateKey = ${WG_SERVER_PRIV}
Address = 10.66.66.1/24
ListenPort = ${WIREGUARD_PORT}
SaveConfig = false
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1) -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1) -j MASQUERADE
WGE

    if ff_service_up wg-quick@wg0 "WireGuard" 3; then
        echo -e "\n${C_GREEN}✅ WireGuard installed with auto-generated keys.${C_RESET}"
        echo -e "${C_CYAN}   Listen port: ${WIREGUARD_PORT} (udp)${C_RESET}"
        echo -e "${C_CYAN}   Server pubkey: $(</etc/wireguard/server.pub)${C_RESET}"
        echo -e "${C_DIM}   Client configs will be auto-generated on account creation.${C_RESET}"
    fi
}
uninstall_wireguard() {
    echo -e "\n${C_BLUE}🗑️ Removing WireGuard...${C_RESET}"
    wg-quick down wg0 2>/dev/null
    systemctl disable wg-quick@wg0 2>/dev/null
    ff_pkg_purge wireguard wireguard-tools >/dev/null 2>&1
    rm -f /etc/wireguard/server.key /etc/wireguard/server.pub /etc/wireguard/wg0.conf 2>/dev/null
    echo -e "${C_GREEN}✅ WireGuard removed.${C_RESET}"
}

# ── Hysteria ──────────────────────────────────────────────
install_hysteria() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🌪️ Install Hysteria 2 ---${C_RESET}"
    if systemctl is-active --quiet hysteria-server 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ Hysteria is already installed.${C_RESET}"
        return
    fi
    # Installed but down (reboot or failed start) still has its unit + config, so
    # jump straight to the enable/start block instead of redownloading.
    if [[ -f /etc/systemd/system/hysteria-server.service && -f /etc/hysteria/config.json ]]; then
        if ff_service_up hysteria-server "Hysteria 2" 2; then
            echo -e "\n${C_GREEN}✅ Hysteria 2 is active on port ${HYSTERIA2_PORT} (udp/quic).${C_RESET}"
        fi
        return
    fi
    echo -e "\n${C_BLUE}📦 Installing Hysteria 2 binary...${C_RESET}"
    local arch; arch=$(uname -m)
    local url
    case "$arch" in
        x86_64)  url="https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64" ;;
        aarch64) url="https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-arm64" ;;
        *) echo -e "${C_RED}❌ Unsupported arch.${C_RESET}"; return ;;
    esac
    ff_fetch_binary /usr/local/bin/hysteria "$url" || { echo -e "${C_RED}❌ Download failed.${C_RESET}"; return; }
    chmod +x /usr/local/bin/hysteria
    check_and_open_firewall_port "$HYSTERIA2_PORT" udp
    mkdir -p /etc/hysteria "$EXPORTS_DIR" 2>/dev/null

    echo -e "\n${C_BLUE}🔐 Generating self-signed cert and config...${C_RESET}"
    openssl req -x509 -nodes -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
        -days 3650 -keyout /etc/hysteria/key.pem -out /etc/hysteria/cert.pem \
        -subj "/CN=VPS_superScript-hysteria" 2>/dev/null

    cat > /etc/hysteria/config.json <<HYE
{
  "listen": ":${HYSTERIA2_PORT}",
  "tls": {
    "cert": "/etc/hysteria/cert.pem",
    "key": "/etc/hysteria/key.pem"
  },
  "auth": {
    "type": "userpass",
    "config": []
  },
  "quic": {
    "initStreamReceiveWindow": 8388608,
    "maxIdleTimeout": "30s",
    "keepAliveInterval": "10s"
  }
}
HYE

    cat > /etc/systemd/system/hysteria-server.service <<HYSRV
[Unit]
Description=Hysteria 2 VPN Server
After=network.target
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/hysteria server -c /etc/hysteria/config.json
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
HYSRV

    if ff_service_up hysteria-server "Hysteria 2" 2; then
        echo -e "\n${C_GREEN}✅ Hysteria 2 installed with auto-generated config.${C_RESET}"
        echo -e "${C_CYAN}   Listen port: ${HYSTERIA2_PORT} (udp/quic)${C_RESET}"
        echo -e "${C_DIM}   Client configs will be auto-generated on account creation.${C_RESET}"
    fi
}
uninstall_hysteria() {
    echo -e "\n${C_BLUE}🗑️ Removing Hysteria...${C_RESET}"
    systemctl stop hysteria-server 2>/dev/null; systemctl disable hysteria-server 2>/dev/null
    rm -f /usr/local/bin/hysteria /etc/systemd/system/hysteria-server.service
    rm -rf /etc/hysteria 2>/dev/null
    systemctl daemon-reload
    echo -e "${C_GREEN}✅ Hysteria removed.${C_RESET}"
}

# ── ShadowSocks ───────────────────────────────────────────
install_shadowsocks() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📡 Install ShadowSocks (Standalone) ---${C_RESET}"
    if systemctl is-active --quiet shadowsocks-libev 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ ShadowSocks is already installed.${C_RESET}"
        return
    fi
    echo -e "\n${C_BLUE}📦 Installing ShadowSocks-libev...${C_RESET}"
    ff_pkg_install shadowsocks-libev >/dev/null 2>&1 || { echo -e "${C_RED}❌ Failed.${C_RESET}"; return; }
    cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server":["0.0.0.0"],
    "server_port":${SHADOWSOCKS_PORT},
    "password":"VPS_superScript-ss",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "fast_open":true
}
EOF
    check_and_open_firewall_port "$SHADOWSOCKS_PORT" tcp
    # The packaged unit runs `ss-server -c /etc/shadowsocks-libev/config.json`.
    # It was enabled and restarted without ever being checked, so a rejected
    # config (bad cipher, port in use, fast_open without kernel support) still
    # printed "✅ installed".
    if ff_service_up shadowsocks-libev "ShadowSocks" 2; then
        echo -e "${C_GREEN}✅ ShadowSocks installed on port ${SHADOWSOCKS_PORT}.${C_RESET}"
    fi
}
uninstall_shadowsocks() {
    echo -e "\n${C_BLUE}🗑️ Removing ShadowSocks...${C_RESET}"
    systemctl stop shadowsocks-libev 2>/dev/null; systemctl disable shadowsocks-libev 2>/dev/null
    ff_pkg_purge shadowsocks-libev >/dev/null 2>&1
    echo -e "${C_GREEN}✅ ShadowSocks removed.${C_RESET}"
}

# ── Socks5 Proxy ──────────────────────────────────────────
install_socks5() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🧦 Install Socks5 Proxy ---${C_RESET}"
    if systemctl is-active --quiet danted 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ Socks5 proxy is already installed.${C_RESET}"
        return
    fi
    echo -e "\n${C_BLUE}📦 Installing Dante Socks5...${C_RESET}"
    ff_pkg_install dante-server >/dev/null 2>&1 || { echo -e "${C_RED}❌ Failed.${C_RESET}"; return; }
    cat > /etc/danted.conf <<EOF
logoutput: /var/log/danted.log
internal: 0.0.0.0 port = ${SOCKS5_PORT}
external: $(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
method: username
user.privileged: root
user.unprivileged: nobody
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error connect
}
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error connect disconnect
}
EOF
    check_and_open_firewall_port "$SOCKS5_PORT" tcp
    # Debian's dante-server unit starts danted only after `systemctl enable`;
    # a config it cannot parse (missing default interface, bad rule syntax)
    # exits immediately, which is why the install used to look successful and
    # the grid stayed red.
    if ff_service_up danted "Socks5 proxy" 2; then
        echo -e "${C_GREEN}✅ Socks5 proxy installed on port ${SOCKS5_PORT}.${C_RESET}"
    fi
}
uninstall_socks5() {
    echo -e "\n${C_BLUE}🗑️ Removing Socks5 proxy...${C_RESET}"
    systemctl stop danted 2>/dev/null; systemctl disable danted 2>/dev/null
    ff_pkg_purge dante-server >/dev/null 2>&1
    echo -e "${C_GREEN}✅ Socks5 proxy removed.${C_RESET}"
}

# ── Stunnel ───────────────────────────────────────────────
install_stunnel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔒 Install Stunnel (SSL Wrapper) ---${C_RESET}"
    if systemctl is-active --quiet stunnel4 2>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ Stunnel is already installed.${C_RESET}"
        return
    fi
    ff_pkg_install stunnel4 >/dev/null 2>&1 || { echo -e "${C_RED}❌ Failed.${C_RESET}"; return; }
    check_and_open_firewall_port "$STUNNEL_PORT" tcp
    mkdir -p /etc/stunnel
    # The packaged unit writes its pid to /var/run/stunnel4/, and a missing
    # runtime dir is the usual reason stunnel exits right after start.
    mkdir -p /var/run/stunnel4 && chown stunnel4:stunnel4 /var/run/stunnel4 2>/dev/null

    if [[ -f "$SSL_CERT_FILE" ]]; then
        local _st_cert="$SSL_CERT_FILE"
    else
        echo -e "${C_BLUE}🔐 Generating self-signed cert for Stunnel...${C_RESET}"
        openssl req -x509 -nodes -newkey rsa:2048 -days 3650 \
            -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem \
            -subj "/CN=VPS_superScript-stunnel" 2>/dev/null
        local _st_cert="/etc/stunnel/stunnel.pem"
    fi

    cat > /etc/stunnel/stunnel.conf <<STCFG
pid = /var/run/stunnel4/stunnel4.pid
[ssh]
accept = ${STUNNEL_PORT}
connect = 127.0.0.1:22
cert = ${_st_cert}
STCFG

    sed -i 's/^ENABLED=0/ENABLED=1/' /etc/default/stunnel4 2>/dev/null
    if ff_service_up stunnel4 "Stunnel" 2; then
        echo -e "${C_GREEN}✅ Stunnel installed and started on port ${STUNNEL_PORT} (wrapping SSH).${C_RESET}"
    fi
}
uninstall_stunnel() {
    echo -e "\n${C_BLUE}🗑️ Removing Stunnel...${C_RESET}"
    systemctl stop stunnel4 2>/dev/null; systemctl disable stunnel4 2>/dev/null
    ff_pkg_purge stunnel4 >/dev/null 2>&1
    echo -e "${C_GREEN}✅ Stunnel removed.${C_RESET}"
}

# ═══════════════════════════════════════════════════════════
# NEW FEATURE MENUS
# ═══════════════════════════════════════════════════════════

# ── Telegram Bot ──────────────────────────────────────────
telegram_bot_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🤖 Telegram Bot Notification ---${C_RESET}"
    local bot_conf="$DB_DIR/telegram.conf"
    local bot_status="${C_STATUS_I}Not configured${C_RESET}"
    if [[ -f "$bot_conf" ]]; then
        source "$bot_conf"
        bot_status="${C_STATUS_A}Configured${C_RESET}"
    fi
    echo -e "\n${C_WHITE}Status: ${bot_status}${C_RESET}"
    echo -e "\n${C_BOLD}Options:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🤖 Set Bot Token & Chat ID"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔧 Toggle Notifications (on/off)"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "📋 Test Notification"
    [[ -f "$bot_conf" ]] && printf "  ${C_DANGER}[ 4]${C_RESET} %-40s\n" "🗑️ Remove Bot Configuration"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Select an option: " t_choice
    case $t_choice in
        1)
            read -p "👉 Bot Token: " token
            read -p "👉 Chat ID: " chat_id
            echo "TELEGRAM_BOT_TOKEN=\"$token\"" > "$bot_conf"
            echo "TELEGRAM_CHAT_ID=\"$chat_id\"" >> "$bot_conf"
            echo "TELEGRAM_ENABLED=\"yes\"" >> "$bot_conf"
            echo -e "${C_GREEN}✅ Telegram bot configured.${C_RESET}"
            press_enter ;;
        2)
            if [[ ! -f "$bot_conf" ]]; then echo -e "\n${C_RED}❌ Configure bot first.${C_RESET}"; press_enter; return; fi
            source "$bot_conf"
            if [[ "$TELEGRAM_ENABLED" == "yes" ]]; then
                sed -i 's/TELEGRAM_ENABLED="yes"/TELEGRAM_ENABLED="no"/' "$bot_conf"
                echo -e "${C_YELLOW}⏸️ Notifications disabled.${C_RESET}"
            else
                sed -i 's/TELEGRAM_ENABLED="no"/TELEGRAM_ENABLED="yes"/' "$bot_conf"
                echo -e "${C_GREEN}✅ Notifications enabled.${C_RESET}"
            fi
            press_enter ;;
        3)
            if [[ ! -f "$bot_conf" ]]; then echo -e "\n${C_RED}❌ Configure bot first.${C_RESET}"; press_enter; return; fi
            source "$bot_conf"
            curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
                -d "chat_id=${TELEGRAM_CHAT_ID}&text=🔔 Test notification from VPS_superScript" >/dev/null 2>&1 \
                && echo -e "${C_GREEN}✅ Test sent.${C_RESET}" || echo -e "${C_RED}❌ Failed.${C_RESET}"
            press_enter ;;
        4) rm -f "$bot_conf"; echo -e "${C_GREEN}✅ Bot config removed.${C_RESET}"; press_enter ;;
        0) return ;;
        *) invalid_option ;;
    esac
}

_send_telegram() {
    local message="$1"
    local bot_conf="$DB_DIR/telegram.conf"
    [[ -f "$bot_conf" ]] || return 0
    source "$bot_conf"
    [[ "$TELEGRAM_ENABLED" == "yes" && -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]] || return 0
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}&text=${message}&parse_mode=HTML" >/dev/null 2>&1 || true
}

# ── Rest API ──────────────────────────────────────────────
rest_api_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔗 Rest API (Port ${REST_API_PORT}) ---${C_RESET}"
    local api_status="${C_STATUS_I}Not installed${C_RESET}"
    if [[ -f /etc/systemd/system/rest-api.service ]] && systemctl is-active --quiet rest-api; then
        api_status="${C_STATUS_A}Running${C_RESET}"
    elif [[ -f /etc/systemd/system/rest-api.service ]]; then
        api_status="${C_STATUS_I}Stopped${C_RESET}"
    fi
    echo -e "\n${C_WHITE}Status: ${api_status}${C_RESET}"
    echo -e "\n${C_BOLD}Options:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🚀 Install/Start Rest API"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "⏹️ Stop Rest API"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "🔁 Restart Rest API"
    printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "📋 View API Info"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Select an option: " api_choice
    case $api_choice in
        1)
            if [[ ! -f /etc/systemd/system/rest-api.service ]]; then
                local api_script="/usr/local/bin/VPS_superScript-api.py"
                cat > "$api_script" <<'APIPYTHON'
#!/usr/bin/env python3
import json, os, subprocess, sys, http.server, socketserver, urllib.parse, time
DB_FILE = "/etc/VPS_superScript/users.db"
EXPORTS_DIR = "/etc/VPS_superScript/exports"
HOST = "0.0.0.0"
PORT = 9000

class H(http.server.BaseHTTPRequestHandler):
    def _j(self, d, s=200):
        self.send_response(s); self.send_header("Content-Type","application/json")
        self.send_header("Access-Control-Allow-Origin","*"); self.end_headers()
        self.wfile.write(json.dumps(d).encode())
    def _e(self, m, s=400): self._j({"error":m}, s)
    def _b(self):
        l = int(self.headers.get("Content-Length",0))
        return json.loads(self.rfile.read(l).decode()) if l else {}
    def _p(self):
        p = urllib.parse.urlparse(self.path)
        return [x for x in p.path.split("/") if x], p.query
    def _users(self):
        u = []
        if os.path.exists(DB_FILE):
            with open(DB_FILE) as f:
                for l in f:
                    l = l.strip()
                    if not l or l.startswith("#"): continue
                    p = l.split(":")
                    if len(p) >= 5:
                        u.append({"username":p[0],"password":p[1],"expires":p[2],
                            "limit":int(p[3]) if p[3].isdigit() else 1,
                            "bandwidth_gb":p[4],"marker":p[5] if len(p)>5 else "",
                            "hwid":p[6] if len(p)>6 else "","strict":p[7] if len(p)>7 else "0",
                            "app":p[8] if len(p)>8 else "http"})
        return u
    def _run(self, *a):
        try: return subprocess.check_output(a, stderr=subprocess.STDOUT, timeout=30).decode()
        except: return ""
    def _setpw(self, u, pw):
        # Set the account password and VERIFY it landed as a real hash. A bare
        # chpasswd can silently no-op (PAM password-quality gate rejecting a weak
        # password, custom host config), leaving the account locked with nothing
        # to restore. If it doesn't take, hash it ourselves and write it directly.
        # Mirrors the menu's _ff_set_password. Returns True only once a hash is set.
        def f2():
            try:
                with open("/etc/shadow") as sh:
                    for ln in sh:
                        pr = ln.split(":")
                        if pr and pr[0] == u:
                            return pr[1] if len(pr) > 1 else ""
            except: pass
            return ""
        try:
            pipe = subprocess.Popen(["chpasswd"], stdin=subprocess.PIPE)
            pipe.communicate((u + ":" + pw + "\n").encode(), timeout=30)
        except: pass
        if f2().startswith("$"): return True
        try:
            import crypt
            h = crypt.crypt(pw, crypt.mksalt(crypt.METHOD_SHA512))
        except Exception:
            h = ""
        if h.startswith("$"):
            self._run("usermod", "-p", h, u)
            if f2().startswith("$"): return True
        return False
    def do_GET(self):
        p, q = self._p()
        if not p or p[0] == "":
            return self._j({"status":"ok","service":"VPS_superScript API","version":"1.0"})
        if p[0] == "users":
            us = self._users()
            if len(p) == 1: return self._j(us)
            for u in us:
                if u["username"] == p[1]:
                    cf = []
                    if u["app"]=="openvpn" and os.path.exists(f"{EXPORTS_DIR}/{p[1]}.ovpn"):
                        cf.append({"type":"openvpn","path":f"{EXPORTS_DIR}/{p[1]}.ovpn"})
                    if u["app"]=="wireguard" and os.path.exists(f"{EXPORTS_DIR}/{p[1]}.conf"):
                        cf.append({"type":"wireguard","path":f"{EXPORTS_DIR}/{p[1]}.conf"})
                    if u["app"]=="hysteria2" and os.path.exists(f"{EXPORTS_DIR}/{p[1]}-hysteria.json"):
                        cf.append({"type":"hysteria2","path":f"{EXPORTS_DIR}/{p[1]}-hysteria.json"})
                    u["configs"] = cf; return self._j(u)
            return self._j({"error":"User not found"}, 404)
        if p[0] == "status":
            up = self._run("uptime","-p").strip()
            m = self._run("free","-m")
            lu = sum(1 for u in self._users() if u["expires"] and u["expires"] >= time.strftime("%Y-%m-%d"))
            return self._j({"uptime":up,"mem":m.strip(),"users_total":len(self._users()),"users_active":lu})
        return self._e("Not found", 404)
    def do_POST(self):
        p, _ = self._p()
        if p and p[0] == "users":
            d = self._b()
            u = d.get("username",""); pw = d.get("password","")
            dy = str(d.get("days",30)); lm = str(d.get("limit",1)); bw = str(d.get("bandwidth_gb",0))
            ap = d.get("app","http")
            if not u: return self._e("username required")
            if not pw: pw = subprocess.check_output(["tr","-dc","A-Za-z0-9"], stdin=open("/dev/urandom","rb"), timeout=5).decode()[:8]
            ex = subprocess.check_output(["date","-d",f"+{dy} days","+%Y-%m-%d"], timeout=5).decode().strip()
            self._run("useradd","-m","-s","/usr/sbin/nologin",u)
            self._run("usermod","-aG","ffusers",u)
            if not self._setpw(u, pw):
                self._run("userdel","-r",u)
                return self._e("could not set password on this host; user not created", 500)
            self._run("chage","-E",ex,u)
            with open(DB_FILE,"a") as f: f.write(f"{u}:{pw}:{ex}:{lm}:{bw}::::0:{ap}\n")
            al = self._run("bash","-c",f"cd {os.path.dirname(DB_FILE)} && hwid_sync_allowed_db")
            return self._j({"status":"created","username":u,"password":pw,"expires":ex}, 201)
        return self._e("Not found", 404)
    def do_DELETE(self):
        p, _ = self._p()
        if p and p[0] == "users" and len(p) == 2:
            u = p[1]
            self._run("bash","-c",f"userdel -r {u}")
            import re
            with open(DB_FILE) as f: c = f.read()
            with open(DB_FILE,"w") as f: f.write(re.sub(f"^{u}:.*\n?","",c))
            self._run("bash","-c","hwid_sync_allowed_db")
            self._run("rm","-f",f"{EXPORTS_DIR}/{u}.ovpn",f"{EXPORTS_DIR}/{u}.conf",f"{EXPORTS_DIR}/{u}-hysteria.json")
            return self._j({"status":"deleted","username":u})
        return self._e("Not found", 404)
    def do_OPTIONS(self):
        self.send_response(200); self.send_header("Access-Control-Allow-Origin","*")
        self.send_header("Access-Control-Allow-Methods","GET,POST,DELETE,OPTIONS")
        self.send_header("Access-Control-Allow-Headers","Content-Type"); self.end_headers()
    def log_message(self, f, *a): sys.stderr.write("[API] %s\n" % (a[0] if a else f))
if __name__ == "__main__":
    socketserver.TCPServer.allow_reuse_address = True
    s = socketserver.TCPServer((HOST, PORT), H)
    sys.stderr.write(f"[API] Listening on {HOST}:{PORT}\n"); s.serve_forever()
APIPYTHON
                chmod +x "$api_script"
                cat > /etc/systemd/system/rest-api.service <<EOF
[Unit]
Description=VPS_superScript Rest API
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/env python3 /usr/local/bin/VPS_superScript-api.py
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
                systemctl daemon-reload
                check_and_open_firewall_port "$REST_API_PORT" tcp
            fi
            if ff_service_up rest-api "Rest API" 2; then
                echo -e "${C_GREEN}✅ Rest API started on port ${REST_API_PORT}.${C_RESET}"
            fi
            press_enter ;;
        2) systemctl stop rest-api 2>/dev/null; echo -e "${C_YELLOW}⏹️ Stopped.${C_RESET}"; press_enter ;;
        3) systemctl restart rest-api 2>/dev/null; echo -e "${C_GREEN}✅ Restarted.${C_RESET}"; press_enter ;;
        4) echo -e "\n${C_CYAN}API Endpoint: http://$(curl -s -4 icanhazip.com 2>/dev/null || echo "your-vps-ip"):${REST_API_PORT}${C_RESET}"; press_enter ;;
        0) return ;;
        *) invalid_option ;;
    esac
}

# ── ON/OFF Service ────────────────────────────────────────
on_off_service_menu() {
    while true; do
        clear; show_banner
        echo -e "\n   ${C_TITLE}══════════════[ ${C_BOLD}🔛 ON/OFF SERVICE CONTROL ${C_RESET}${C_TITLE}]══════════════${C_RESET}"
        echo -e "     ${C_DIM}Select a service to toggle ON or OFF${C_RESET}\n"
        local services=(
            "dropbear:Dropbear"
            "openvpn@server-tcp:OpenVPN"
            "wg-quick@wg0:WireGuard"
            "hysteria-server:Hysteria"
            "shadowsocks-libev:ShadowSocks"
            "danted:Socks5"
            "stunnel4:Stunnel"
            "badvpn:BadVPN"
            "udp-custom:UDP-Custom"
            "zivpn.service:ZiVPN"
            "dnstt.service:DNSTT"
            "falconproxy:FalconProxy"
            "nginx:Nginx"
            "rest-api:Rest API"
            "ws-ssh:WS-SSH"
        )
        local idx=1
        local -a svc_names=()
        for entry in "${services[@]}"; do
            local svc="${entry%%:*}"
            local label="${entry##*:}"
            svc_names+=("$svc")
            local status="${C_STATUS_I}○ OFF${C_RESET}"
            systemctl is-active --quiet "$svc" 2>/dev/null && status="${C_STATUS_A}● ON${C_RESET}"
            printf "     ${C_CHOICE}[%2d]${C_RESET} %-20s %s\n" "$idx" "$label" "$status"
            ((idx++))
        done
        echo -e "\n   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -p "👉 Select service to toggle: " togg
        [[ "$togg" == "0" ]] && return
        if [[ "$togg" =~ ^[0-9]+$ ]] && (( togg >= 1 && togg <= ${#svc_names[@]} )); then
            local target="${svc_names[$((togg-1))]}"
            if systemctl is-active --quiet "$target" 2>/dev/null; then
                systemctl stop "$target" 2>/dev/null
                if [[ "$target" == "openvpn@server-tcp" ]]; then
                    systemctl stop openvpn@server-udp 2>/dev/null
                    systemctl stop openvpn@server-sdns 2>/dev/null
                fi
                echo -e "\n${C_YELLOW}⏹️ Stopped $target${C_RESET}"
            else
                # Verified start: a unit whose config is broken used to print
                # "Started" and stay red on the banner.
                if ff_service_up "$target" "$target" 2; then
                    if [[ "$target" == "openvpn@server-tcp" ]]; then
                        ff_service_up openvpn@server-udp "openvpn@server-udp" 2 || true
                    fi
                    echo -e "\n${C_GREEN}▶️ Started $target${C_RESET}"
                fi
            fi
            press_enter
        else
            invalid_option
        fi
    done
}

# ── Recover Expired Xray ─────────────────────────────────
recover_expired_xray() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- ♻️ Recover Expired Xray/V2ray Account ---${C_RESET}"
    if ! command -v x-ui &>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ X-UI panel not installed. Use Protocol Manager [16] to install.${C_RESET}"
        press_enter; return
    fi
    echo -e "\n${C_YELLOW}Use the X-UI panel or 3X-UI panel to recover expired accounts:${C_RESET}"
    echo -e "   ${C_CYAN}x-ui${C_RESET} or ${C_CYAN}3x-ui${C_RESET} command → Panel Menu → User List → Edit → Reset Expiry"
    press_enter
}

# ── Dropbear Config Menu ─────────────────────────────────
dropbear_config_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🦘 Dropbear Configuration ---${C_RESET}"
    if ! command -v dropbear &>/dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ Dropbear is not installed. Install it via Protocol Manager [20].${C_RESET}"
        press_enter; return
    fi
    local banner_file="/etc/dropbear_banner"
    echo -e "\n${C_WHITE}Current Status:${C_RESET}"
    echo -e "   Ports: ${DROPBEAR_PORTS}"
    echo -e "   Version: $(dropbear -V 2>&1 || echo "unknown")"
    [[ -f "$banner_file" ]] && echo -e "   Banner: ${C_GREEN}Custom${C_RESET}" || echo -e "   Banner: ${C_DIM}Default${C_RESET}"
    echo -e "\n${C_BOLD}Options:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "📝 Set Custom Dropbear Banner"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "👁️ View Current Banner"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "🗑️ Remove Custom Banner"
    printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "🔄 Restart Dropbear"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Select an option: " db_choice
    case $db_choice in
        1) 
            echo -e "\n${C_DIM}Paste your banner text (CTRL+D to finish):${C_RESET}"
            cat > "$banner_file"
            sed -i "s|^DROPBEAR_BANNER=.*|DROPBEAR_BANNER=\"$banner_file\"|" /etc/default/dropbear 2>/dev/null
            systemctl restart dropbear 2>/dev/null
            echo -e "${C_GREEN}✅ Banner set.${C_RESET}"
            press_enter ;;
        2) 
            if [[ -f "$banner_file" ]]; then cat "$banner_file"; else echo -e "${C_YELLOW}No custom banner.${C_RESET}"; fi
            press_enter ;;
        3) 
            rm -f "$banner_file"
            sed -i 's|^DROPBEAR_BANNER=.*|#DROPBEAR_BANNER=""|' /etc/default/dropbear 2>/dev/null
            systemctl restart dropbear 2>/dev/null
            echo -e "${C_GREEN}✅ Banner removed.${C_RESET}"
            press_enter ;;
        4) systemctl restart dropbear 2>/dev/null; echo -e "${C_GREEN}✅ Restarted.${C_RESET}"; press_enter ;;
        0) return ;;
        *) invalid_option ;;
    esac
}

# ── Timezone ──────────────────────────────────────────────
timezone_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🕐 Change Server Timezone ---${C_RESET}"
    echo -e "\n${C_CYAN}Current timezone: $(timedatectl show --property=Timezone --value 2>/dev/null || echo "unknown")${C_RESET}"
    echo -e "\n${C_BOLD}Common timezones:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-30s\n" "🌍 UTC"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-30s\n" "🇺🇸 America/New_York"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-30s\n" "🇬🇧 Europe/London"
    printf "  ${C_CHOICE}[ 4]${C_RESET} %-30s\n" "🇮🇳 Asia/Kolkata"
    printf "  ${C_CHOICE}[ 5]${C_RESET} %-30s\n" "🇸🇬 Asia/Singapore"
    printf "  ${C_CHOICE}[ 6]${C_RESET} %-30s\n" "🇯🇵 Asia/Tokyo"
    printf "  ${C_CHOICE}[ 7]${C_RESET} %-30s\n" "🇮🇩 Asia/Jakarta"
    printf "  ${C_CHOICE}[ 8]${C_RESET} %-30s\n" "🇬🇭 Africa/Accra (Ghana, GMT)"
    printf "  ${C_CHOICE}[ 9]${C_RESET} %-30s\n" "🇳🇬 Africa/Lagos (WAT, GMT+1)"
    printf "  ${C_CHOICE}[10]${C_RESET} %-30s\n" "🇰🇪 Africa/Nairobi (EAT, GMT+3)"
    printf "  ${C_CHOICE}[11]${C_RESET} %-30s\n" "🇿🇦 Africa/Johannesburg (SAST)"
    printf "  ${C_CHOICE}[12]${C_RESET} %-30s\n" "🇪🇬 Africa/Cairo (EET)"
    printf "  ${C_CHOICE}[13]${C_RESET} %-30s\n" "✏️ Enter Custom Timezone"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Select timezone: " tz_choice
    case $tz_choice in
        1) timedatectl set-timezone UTC ;;
        2) timedatectl set-timezone America/New_York ;;
        3) timedatectl set-timezone Europe/London ;;
        4) timedatectl set-timezone Asia/Kolkata ;;
        5) timedatectl set-timezone Asia/Singapore ;;
        6) timedatectl set-timezone Asia/Tokyo ;;
        7) timedatectl set-timezone Asia/Jakarta ;;
        8) timedatectl set-timezone Africa/Accra ;;
        9) timedatectl set-timezone Africa/Lagos ;;
        10) timedatectl set-timezone Africa/Nairobi ;;
        11) timedatectl set-timezone Africa/Johannesburg ;;
        12) timedatectl set-timezone Africa/Cairo ;;
        13) read -p "👉 Enter timezone (e.g., Africa/Accra): " custom_tz; timedatectl set-timezone "$custom_tz" 2>/dev/null || echo -e "${C_RED}❌ Invalid.${C_RESET}" ;;
        0) return ;;
        *) invalid_option ;;
    esac
    echo -e "${C_GREEN}✅ Timezone updated.${C_RESET}"
    invalidate_banner_cache
    press_enter
}

# ── Bypass Proxy Detection ───────────────────────────────
bypass_proxy_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚫 Bypass Proxy & Anonymous Traffic ---${C_RESET}"
    local bp_status="${C_STATUS_I}Disabled${C_RESET}"
    iptables -C FORWARD -m string --string "anonymous" --algo bm -j DROP 2>/dev/null && bp_status="${C_STATUS_A}Enabled${C_RESET}"
    echo -e "\n${C_WHITE}Current Status: ${bp_status}${C_RESET}"
    echo -e "\n${C_BOLD}Options:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🛡️ Enable Proxy/VPN Detection"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔓 Disable Proxy/VPN Detection"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "📋 View Block Log"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Select an option: " bp_choice
    case $bp_choice in
        1)
            iptables -A FORWARD -m string --string "anonymous" --algo bm -j DROP 2>/dev/null
            iptables -A FORWARD -m string --string "proxy" --algo bm -j DROP 2>/dev/null
            echo -e "${C_GREEN}✅ Detection enabled.${C_RESET}"
            press_enter ;;
        2)
            iptables -D FORWARD -m string --string "anonymous" --algo bm -j DROP 2>/dev/null
            iptables -D FORWARD -m string --string "proxy" --algo bm -j DROP 2>/dev/null
            echo -e "${C_YELLOW}🔓 Disabled.${C_RESET}"
            press_enter ;;
        3) echo -e "\n${C_DIM}Check /var/log/syslog for blocked connections.${C_RESET}"; press_enter ;;
        0) return ;;
        *) invalid_option ;;
    esac
}

# ── Grant/Revoke Access ─────────────────────────────────────
# Two independent models exist on this server:
#   • FULL ROOT:    shell (bash) + membership in sudo/wheel → unrestricted root.
#   • DELEGATION:   restricted user console via /usr/local/bin/vss-subadmin.
#                   Delegates can create/edit/renew/lock/unlock/delete ONLY
#                   accounts they created themselves; admin-created accounts are
#                   hidden from them. They never get a bash shell or sudo -i.
_gr_sudo_group() {
    local g
    for g in sudo wheel; do
        getent group "$g" >/dev/null 2>&1 && { printf '%s' "$g"; return 0; }
    done
    return 1
}
_gr_user_shell() {
    getent passwd "$1" 2>/dev/null | cut -d: -f7
}
_gr_in_group() {
    id -nG "$1" 2>/dev/null | tr ' ' '\n' | grep -Fxq "$2"
}
_gr_nopasswd_file() {
    local safe; safe=$(printf '%s' "$1" | tr -c 'A-Za-z0-9_-' '_')
    printf '/etc/sudoers.d/90-vss-%s' "$safe"
}
_gr_nologin_shell() {
    local s
    for s in /usr/sbin/nologin /sbin/nologin; do
        [[ -x "$s" ]] && { printf '%s' "$s"; return 0; }
    done
    command -v nologin 2>/dev/null
}
_gr_deleg_safe() { printf '%s' "$1" | tr -c 'A-Za-z0-9_-' '_'; }
_gr_deleg_dropin() { printf '/etc/sudoers.d/90-vss-deleg-%s' "$(_gr_deleg_safe "$1")"; }
_gr_deleg_has_dropin() { [[ -f "$(_gr_deleg_dropin "$1")" ]]; }
_gr_deleg_wrapper_installed() { [[ -x /usr/local/bin/vss-subadmin ]]; }

# Installs the delegated console binary once. It ignores every argument (ssh -c
# / sftp subsystem) and always launches menu.sh in --delegate mode as root,
# deriving the actor from SUDO_USER so it cannot be spoofed.
_gr_install_deleg_wrapper() {
    _gr_deleg_wrapper_installed && return 0
    local self _cand
    for _cand in "${BASH_SOURCE[0]}" "$0" "/usr/local/bin/menu"; do
        self=$(readlink -f "$_cand" 2>/dev/null || true)
        [[ -n "$self" && -f "$self" ]] && break
        self=""
    done
    [[ -n "$self" && -f "$self" ]] || return 1
    mkdir -p /usr/local/bin 2>/dev/null || return 1
    cat > /usr/local/bin/vss-subadmin <<EOF
#!/bin/bash
# VPS_superScript delegated user console. Ignores all arguments (ssh -c / sftp).
if [[ \$EUID -ne 0 ]]; then
    exec sudo -n /usr/local/bin/vss-subadmin
fi
actor="\${SUDO_USER:-}"
[[ -z "\$actor" || "\$actor" == "root" ]] && exit 1
exec /bin/bash "$self" --delegate "\$actor"
EOF
    chmod 0755 /usr/local/bin/vss-subadmin
}

delegate_menu() {
    local actor="${1:-${VSS_ACTOR:-}}"
    [[ -n "$actor" ]] || return 1
    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 👤 Delegated User Manager — ${C_YELLOW}${actor}${C_PURPLE} ---${C_RESET}"
        echo -e "${C_DIM}This console manages accounts you create.${C_RESET}\n"
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-44s\n" "📋 List my users"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-44s\n" "✨ Create user"
        printf "  ${C_CHOICE}[ 3]${C_RESET} %-44s\n" "✏️ Edit user"
        printf "  ${C_CHOICE}[ 4]${C_RESET} %-44s\n" "🗑️ Delete user"
        printf "  ${C_CHOICE}[ 5]${C_RESET} %-44s\n" "🔄 Renew user"
        printf "  ${C_CHOICE}[ 6]${C_RESET} %-44s\n" "🔒 Lock user"
        printf "  ${C_CHOICE}[ 7]${C_RESET} %-44s\n" "🔓 Unlock user"
        printf "  ${C_CHOICE}[ 8]${C_RESET} %-44s\n" "👁️ User details"
        printf "  ${C_CHOICE}[ 9]${C_RESET} %-44s\n" "⏱️ Trial user"
        printf "  ${C_WARN}[ 0]${C_RESET} ↩️ Exit console (closes SSH session)"
        echo
        read -r -p "👉 Select an option: " dc || return
        case $dc in
            1) list_users; press_enter ;;
            2) create_user; press_enter ;;
            3) edit_user; press_enter ;;
            4) delete_user; press_enter ;;
            5) renew_user; press_enter ;;
            6) lock_user; press_enter ;;
            7) unlock_user; press_enter ;;
            8) view_user_details; press_enter ;;
            9) create_trial_account; press_enter ;;
            10) cleanup_expired; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

# Lists every managed user grouped by the admin/delegated owner who created it.
# Only meaningful for the server owner (VSS_ACTOR unset); delegated consoles
# already see only their own accounts via list_users().
list_users_by_owner() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 👥 Users by owner ---${C_RESET}\n"
    if [[ ! -s "$DB_FILE" ]]; then
        echo -e "${C_YELLOW}ℹ️ No users are currently being managed.${C_RESET}"
        press_enter; return
    fi

    # Collect the distinct owners (defaulting missing rows to "admin").
    local -A _owners=()
    local _u _o
    while IFS=: read -r _u _; do
        [[ -z "$_u" ]] && continue
        _o=$(_own_get "$_u")
        _owners["$_o"]=1
    done < "$DB_FILE"
    [[ -z "${_owners[admin]:-}" ]] && _owners["admin"]=1

    local _owner _any_owner _shown
    for _owner in $(printf '%s\n' "${!_owners[@]}" | LC_ALL=C sort); do
        _any_owner=false
        echo -e "${C_BOLD}${C_CYAN}👤 ${_owner}${C_RESET}"
        while IFS=: read -r _u _ _ _ _ _marker _; do
            [[ -z "$_u" ]] && continue
            [[ "$(_own_get "$_u")" == "$_owner" ]] || continue
            local _tag=""
            [[ "$_marker" == "trial" ]] && _tag=" ${C_YELLOW}(trial)${C_RESET}"
            echo -e "   ${C_GREEN}●${C_RESET} ${_u}${_tag}"
            _any_owner=true
        done < "$DB_FILE"
        [[ "$_any_owner" == "false" ]] && echo -e "   ${C_DIM}none${C_RESET}"
        echo
    done
}

grant_root_menu() {
    local grp; grp=$(_gr_sudo_group)
    local _login_shell=/bin/bash
    [[ -x "$_login_shell" ]] || _login_shell=$(command -v bash 2>/dev/null)
    local _nologin_shell; _nologin_shell=$(_gr_nologin_shell)
    [[ -n "$_nologin_shell" ]] || _nologin_shell=/usr/sbin/nologin
    local _delshell=/usr/local/bin/vss-subadmin

    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 👑 Grant/Revoke Access ---${C_RESET}"
        if [[ -z "$grp" ]]; then
            echo -e "\n${C_RED}❌ Neither a 'sudo' nor 'wheel' group exists on this host.${C_RESET}"
            press_enter; return
        fi
        echo -e "${C_DIM}Sudo group: ${C_YELLOW}${grp}${C_RESET}   Delegated console: ${C_YELLOW}${_delshell}${C_RESET}"

        echo -e "\n${C_BOLD}FULL ROOT users (bash shell + ${grp}):${C_RESET}"
        local _any=false _au _ashell
        while IFS=: read -r _au _ _ _uid _; do
            [[ "$_uid" == "0" ]] && echo -e "   ${C_GREEN}●${C_RESET} ${_au} ${C_DIM}(uid 0)${C_RESET}" && _any=true
        done < /etc/passwd
        while IFS= read -r _au; do
            [[ -z "$_au" || "$_au" == "root" ]] && continue
            _ashell=$(_gr_user_shell "$_au")
            echo -e "   ${C_GREEN}●${C_RESET} ${_au} ${C_DIM}(${grp}, shell: ${_ashell:-?})${C_RESET}"
            _any=true
        done < <(getent group "$grp" 2>/dev/null | cut -d: -f4 | tr ',' '\n')
        [[ "$_any" == "false" ]] && echo -e "   ${C_DIM}none${C_RESET}"

        echo -e "\n${C_BOLD}Delegated user-managers (own accounts only):${C_RESET}"
        _any=false
        while IFS=: read -r _au _ _ _ _ _ _ _shell; do
            [[ "$_shell" == "$_delshell" ]] || continue
            [[ -n "$_au" ]] && echo -e "   ${C_YELLOW}●${C_RESET} ${_au} ${C_DIM}(delegated console)${C_RESET}" && _any=true
        done < /etc/passwd
        [[ "$_any" == "false" ]] && echo -e "   ${C_DIM}none${C_RESET}"

        echo -e "\n${C_BOLD}Options:${C_RESET}\n"
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-46s\n" "👤 Delegate user management (own accounts only)"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-46s\n" "❌ Remove delegation from a user"
        printf "  ${C_CHOICE}[ 3]${C_RESET} %-46s\n" "➕ Grant FULL root (shell + sudo)"
        printf "  ${C_CHOICE}[ 4]${C_RESET} %-46s\n" "➖ Revoke FULL root"
        printf "  ${C_CHOICE}[ 5]${C_RESET} %-46s\n" "📋 List admins & delegated users"
        printf "  ${C_CHOICE}[ 6]${C_RESET} %-46s\n" "👥 List users by owner"
        printf "  ${C_CHOICE}[ 7]${C_RESET} %-46s\n" "🔓 Toggle NOPASSWD sudo (full root)"
        echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -r -p "👉 Select an option: " gr_choice || return
        case $gr_choice in
            1)
                local du _ok
                read -r -p "👉 Username to delegate: " du
                du=$(printf '%s' "$du" | tr -d '[:space:]')
                if [[ -z "$du" ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No username entered.${C_RESET}"
                elif ! id "$du" &>/dev/null; then
                    echo -e "\n${C_RED}❌ User '$du' does not exist on this server.${C_RESET}"
                elif [[ "$du" == "root" ]]; then
                    echo -e "\n${C_YELLOW}ℹ️ 'root' cannot be delegated.${C_RESET}"
                elif ! _gr_install_deleg_wrapper; then
                    echo -e "\n${C_RED}❌ Could not install the delegated console.${C_RESET}"
                else
                    echo -e "\n${C_DIM}This strips '${du}' of full root (sudo group + shell) and gives them${C_RESET}"
                    echo -e "${C_DIM}a restricted console where they can only manage accounts they create.${C_RESET}"
                    read -r -p "👉 Proceed? (y/N): " _ok
                    if [[ "${_ok,,}" != "y" ]]; then
                        echo -e "\n${C_YELLOW}❌ Cancelled.${C_RESET}"
                    else
                        local _fail=false
                        if _gr_in_group "$du" "$grp"; then
                            if gpasswd -d "$du" "$grp" >/dev/null 2>&1; then
                                echo -e " ${C_GREEN}✅${C_RESET} Removed '${du}' from '${grp}'."
                            else
                                echo -e " ${C_RED}❌ Could not remove '${du}' from '${grp}'.${C_RESET}"; _fail=true
                            fi
                        fi
                        local _np; _np=$(_gr_nopasswd_file "$du")
                        if [[ -f "$_np" ]]; then
                            rm -f "$_np" 2>/dev/null && echo -e " ${C_GREEN}✅${C_RESET} Removed full-root NOPASSWD rule."
                        fi
                        if _gr_install_deleg_wrapper && \
                           printf '%s ALL=(root) NOPASSWD: /usr/local/bin/vss-subadmin\n' "$du" > "$(_gr_deleg_dropin "$du")" && \
                           { command -v visudo >/dev/null 2>&1 && visudo -cf "$(_gr_deleg_dropin "$du")" >/dev/null 2>&1 || true; } && \
                           chmod 0440 "$(_gr_deleg_dropin "$du")" && \
                           usermod -s "$_delshell" "$du" 2>/dev/null && \
                           [[ "$(_gr_user_shell "$du")" == "$_delshell" ]]; then
                            echo -e "\n${C_GREEN}✅ '${du}' is now a delegated user-manager.${C_RESET}"
                            echo -e "${C_DIM}   They log in with: ssh ${du}@<server-ip>  (their assigned password)${C_RESET}"
                            echo -e "${C_DIM}   The console opens automatically; they can only manage accounts they create.${C_RESET}"
                            if _ff_is_shadow_locked "$du"; then
                                echo -e "${C_YELLOW}⚠️ This account is LOCKED — unlock it first or they cannot log in.${C_RESET}"
                            fi
                            local _expd _today
                            _expd=$(awk -F: -v u="$du" '$1==u{print $8; exit}' /etc/shadow 2>/dev/null)
                            _today=$(( $(date +%s) / 86400 ))
                            if [[ "$_expd" =~ ^[0-9]+$ ]] && (( _expd < _today )); then
                                echo -e "${C_YELLOW}⚠️ This account EXPIRED — renew it before they can log in.${C_RESET}"
                            fi
                        else
                            echo -e "\n${C_RED}❌ Delegation setup incomplete — check errors above.${C_RESET}"
                            echo -e "${C_DIM}   Try revoking delegation and granting again.${C_RESET}"
                        fi
                    fi
                fi
                ;;
            2)
                local dv _ok
                read -r -p "👉 Username to undelegate: " dv
                dv=$(printf '%s' "$dv" | tr -d '[:space:]')
                if [[ -z "$dv" ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No username entered.${C_RESET}"
                elif ! id "$dv" &>/dev/null; then
                    echo -e "\n${C_RED}❌ User '$dv' does not exist on this server.${C_RESET}"
                elif [[ "$dv" == "root" ]]; then
                    echo -e "\n${C_YELLOW}ℹ️ 'root' is not delegated.${C_RESET}"
                elif [[ "$(_gr_user_shell "$dv")" != "$_delshell" ]] && ! _gr_deleg_has_dropin "$dv"; then
                    echo -e "\n${C_YELLOW}ℹ️ '${dv}' is not a delegated user-manager.${C_RESET}"
                else
                    echo -e "\n${C_DIM}This removes '${dv}'s delegated console and restores nologin shell.${C_RESET}"
                    read -r -p "👉 Proceed? (y/N): " _ok
                    if [[ "${_ok,,}" != "y" ]]; then
                        echo -e "\n${C_YELLOW}❌ Cancelled.${C_RESET}"
                    else
                        local _dp; _dp=$(_gr_deleg_dropin "$dv")
                        [[ -f "$_dp" ]] && rm -f "$_dp" 2>/dev/null && echo -e " ${C_GREEN}✅${C_RESET} Removed delegated sudo rule."
                        if usermod -s "$_nologin_shell" "$dv" 2>/dev/null && [[ "$(_gr_user_shell "$dv")" == "$_nologin_shell" ]]; then
                            echo -e " ${C_GREEN}✅${C_RESET} Login shell reset to ${_nologin_shell} — no SSH shell."
                        else
                            echo -e " ${C_RED}❌ Could not reset the login shell.${C_RESET}"
                        fi
                        echo -e "\n${C_GREEN}✅ '${dv}' is no longer a delegated user-manager.${C_RESET}"
                    fi
                fi
                ;;
            3)
                local gr_user _cur_shell _ok _fail
                read -r -p "👉 Username to grant FULL root: " gr_user
                gr_user=$(printf '%s' "$gr_user" | tr -d '[:space:]')
                if [[ -z "$gr_user" ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No username entered.${C_RESET}"
                elif ! id "$gr_user" &>/dev/null; then
                    echo -e "\n${C_RED}❌ User '$gr_user' does not exist on this server.${C_RESET}"
                elif [[ "$gr_user" == "root" ]]; then
                    echo -e "\n${C_YELLOW}ℹ️ 'root' already has full access.${C_RESET}"
                elif [[ -z "$_login_shell" || ! -x "$_login_shell" ]]; then
                    echo -e "\n${C_RED}❌ bash is not installed — cannot enable an SSH shell.${C_RESET}"
                else
                    _cur_shell=$(_gr_user_shell "$gr_user")
                    echo -e "\n${C_DIM}This adds '${gr_user}' to '${grp}' AND sets the login shell to ${_login_shell}.${C_RESET}"
                    echo -e "${C_DIM}They can log in over SSH and run: sudo -i (full root).${C_RESET}"
                    read -r -p "👉 Proceed? (y/N): " _ok
                    if [[ "${_ok,,}" != "y" ]]; then
                        echo -e "\n${C_YELLOW}❌ Cancelled.${C_RESET}"
                    else
                        _fail=false
                        if usermod -aG "$grp" "$gr_user" 2>/dev/null && _gr_in_group "$gr_user" "$grp"; then
                            echo -e " ${C_GREEN}✅${C_RESET} Added '${gr_user}' to '${grp}'."
                        else
                            echo -e " ${C_RED}❌ Could not add '${gr_user}' to '${grp}'.${C_RESET}"; _fail=true
                        fi
                        if usermod -s "$_login_shell" "$gr_user" 2>/dev/null && [[ "$(_gr_user_shell "$gr_user")" == "$_login_shell" ]]; then
                            echo -e " ${C_GREEN}✅${C_RESET} Login shell set to ${_login_shell} ${C_DIM}(was: ${_cur_shell:-unknown})${C_RESET}"
                        else
                            echo -e " ${C_RED}❌ Could not change the login shell.${C_RESET}"; _fail=true
                        fi
                        if [[ "$_fail" == "false" ]]; then
                            echo -e "\n${C_GREEN}✅ '${gr_user}' now has FULL root access via SSH + sudo.${C_RESET}"
                            echo -e "${C_DIM}   Test: ssh ${gr_user}@<server-ip>  →  sudo -i${C_RESET}"
                            if _ff_is_shadow_locked "$gr_user"; then
                                echo -e "${C_YELLOW}⚠️ This account is currently LOCKED — unlock it first.${C_RESET}"
                            fi
                            local _expd _today
                            _expd=$(awk -F: -v u="$gr_user" '$1==u{print $8; exit}' /etc/shadow 2>/dev/null)
                            _today=$(( $(date +%s) / 86400 ))
                            if [[ "$_expd" =~ ^[0-9]+$ ]] && (( _expd < _today )); then
                                echo -e "${C_YELLOW}⚠️ This account EXPIRED — renew it before they can log in.${C_RESET}"
                            fi
                        fi
                    fi
                fi
                ;;
            4)
                local rv_user _rshell _rok _rfail
                read -r -p "👉 Username to revoke FULL root: " rv_user
                rv_user=$(printf '%s' "$rv_user" | tr -d '[:space:]')
                if [[ -z "$rv_user" ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No username entered.${C_RESET}"
                elif ! id "$rv_user" &>/dev/null; then
                    echo -e "\n${C_RED}❌ User '$rv_user' does not exist on this server.${C_RESET}"
                elif [[ "$rv_user" == "root" ]]; then
                    echo -e "\n${C_RED}❌ Refusing to modify 'root'.${C_RESET}"
                else
                    _rshell=$(_gr_user_shell "$rv_user")
                    echo -e "\n${C_DIM}This removes '${rv_user}' from '${grp}', deletes its NOPASSWD rule,${C_RESET}"
                    echo -e "${C_DIM}and sets the login shell back to ${_nologin_shell}.${C_RESET}"
                    read -r -p "👉 Proceed? (y/N): " _rok
                    if [[ "${_rok,,}" != "y" ]]; then
                        echo -e "\n${C_YELLOW}❌ Cancelled.${C_RESET}"
                    else
                        _rfail=false
                        if _gr_in_group "$rv_user" "$grp"; then
                            if gpasswd -d "$rv_user" "$grp" >/dev/null 2>&1; then
                                echo -e " ${C_GREEN}✅${C_RESET} Removed '${rv_user}' from '${grp}'."
                            else
                                echo -e " ${C_RED}❌ Could not remove '${rv_user}' from '${grp}'.${C_RESET}"; _rfail=true
                            fi
                        else
                            echo -e " ${C_DIM}ℹ️ '${rv_user}' is not in '${grp}'.${C_RESET}"
                        fi
                        local _np; _np=$(_gr_nopasswd_file "$rv_user")
                        if [[ -f "$_np" ]]; then
                            if rm -f "$_np" 2>/dev/null; then
                                echo -e " ${C_GREEN}✅${C_RESET} Removed NOPASSWD sudo rule (${_np})."
                            else
                                echo -e " ${C_RED}❌ Could not remove ${_np}.${C_RESET}"; _rfail=true
                            fi
                        fi
                        if usermod -s "$_nologin_shell" "$rv_user" 2>/dev/null && [[ "$(_gr_user_shell "$rv_user")" == "$_nologin_shell" ]]; then
                            echo -e " ${C_GREEN}✅${C_RESET} Login shell reset to ${_nologin_shell} ${C_DIM}(was: ${_rshell:-unknown})${C_RESET}"
                        else
                            echo -e " ${C_RED}❌ Could not reset the login shell.${C_RESET}"; _rfail=true
                        fi
                        if [[ "$_rfail" == "false" ]]; then
                            echo -e "\n${C_GREEN}✅ '${rv_user}' can no longer log in to a shell.${C_RESET}"
                        fi
                    fi
                fi
                ;;
            5)
                echo -e "\n${C_CYAN}FULL ROOT users (bash + ${grp}):${C_RESET}"
                local _lu _lsh _ls_any=false
                while IFS=: read -r _lu _ _ _luid _; do
                    [[ "$_luid" == "0" ]] && echo -e "   ${C_GREEN}●${C_RESET} ${_lu} ${C_DIM}(uid 0)${C_RESET}" && _ls_any=true
                done < /etc/passwd
                while IFS= read -r _lu; do
                    [[ -z "$_lu" ]] && continue
                    _lsh=$(_gr_user_shell "$_lu")
                    echo -e "   ${C_GREEN}●${C_RESET} ${_lu} ${C_DIM}(${grp}, shell: ${_lsh:-?})${C_RESET}"
                    _ls_any=true
                done < <(getent group "$grp" 2>/dev/null | cut -d: -f4 | tr ',' '\n')
                [[ "$_ls_any" == "false" ]] && echo -e "   ${C_DIM}none${C_RESET}"
                echo -e "\n${C_YELLOW}Delegated user-managers:${C_RESET}"
                _ls_any=false
                while IFS=: read -r _lu _ _ _ _ _ _ _shell; do
                    [[ "$_shell" == "$_delshell" ]] || continue
                    echo -e "   ${C_YELLOW}●${C_RESET} ${_lu} ${C_DIM}(restricted console, own accounts only)${C_RESET}"
                    _ls_any=true
                done < /etc/passwd
                [[ "$_ls_any" == "false" ]] && echo -e "   ${C_DIM}none${C_RESET}"
                ;;
            6)
                list_users_by_owner
                ;;
            7)
                local pw_user _pnp
                read -r -p "👉 Username for passwordless FULL sudo: " pw_user
                pw_user=$(printf '%s' "$pw_user" | tr -d '[:space:]')
                if [[ -z "$pw_user" ]]; then
                    echo -e "\n${C_YELLOW}⚠️ No username entered.${C_RESET}"
                elif ! id "$pw_user" &>/dev/null; then
                    echo -e "\n${C_RED}❌ User '$pw_user' does not exist on this server.${C_RESET}"
                elif ! _gr_in_group "$pw_user" "$grp"; then
                    echo -e "\n${C_YELLOW}⚠️ '${pw_user}' is not in '${grp}' — grant FULL root first ([3]).${C_RESET}"
                else
                    _pnp=$(_gr_nopasswd_file "$pw_user")
                    if [[ -f "$_pnp" ]]; then
                        rm -f "$_pnp" && echo -e "\n${C_GREEN}✅ NOPASSWD sudo DISABLED for '${pw_user}' (password required again).${C_RESET}"
                    else
                        local _ptmp; _ptmp=$(mktemp) || { echo -e "\n${C_RED}❌ Could not create a temp file.${C_RESET}"; _ptmp=""; }
                        if [[ -n "$_ptmp" ]]; then
                            printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$pw_user" > "$_ptmp"
                            if command -v visudo &>/dev/null && ! visudo -cf "$_ptmp" >/dev/null 2>&1; then
                                echo -e "\n${C_RED}❌ Generated rule failed visudo validation — nothing changed.${C_RESET}"
                            else
                                mkdir -p /etc/sudoers.d
                                if install -m 0440 -o root -g root "$_ptmp" "$_pnp" 2>/dev/null \
                                   || { cp -f "$_ptmp" "$_pnp" && chmod 0440 "$_pnp"; }; then
                                    echo -e "\n${C_GREEN}✅ NOPASSWD FULL sudo ENABLED for '${pw_user}' (${_pnp}).${C_RESET}"
                                    echo -e "${C_DIM}   They can now run: sudo -i   (no password prompt)${C_RESET}"
                                    if ! grep -Eq '^[[:space:]]*[#@]includedir[[:space:]]+/etc/sudoers\.d' /etc/sudoers 2>/dev/null; then
                                        echo -e "${C_YELLOW}⚠️ /etc/sudoers does not include /etc/sudoers.d — add: #includedir /etc/sudoers.d${C_RESET}"
                                    fi
                                else
                                    echo -e "\n${C_RED}❌ Could not write ${_pnp}.${C_RESET}"
                                fi
                            fi
                            rm -f "$_ptmp"
                        fi
                    fi
                fi
                ;;
            0) return ;;
            *) invalid_option ;;
        esac
        press_enter
    done
}

# ── Client Details ────────────────────────────────────────
client_details_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📊 Client & System Details ---${C_RESET}"
    refresh_banner_cache
    local total_users=0 online=0 expired_today=0 locked=0
    if [[ -s "$DB_FILE" ]]; then
        while IFS=: read -r u _ e _ _ _ _ _; do
            [[ -n "$u" && "$u" != \#* ]] && ((total_users++))
            [[ -n "$e" && "$e" < $(date +%Y-%m-%d) ]] && ((expired_today++))
        done < "$DB_FILE"
        online=$(count_managed_online_sessions 2>/dev/null || echo 0)
        locked=0
        while IFS=: read -r u _ _ _ _ _ _ _; do
            if [[ -n "$u" ]]; then
                local shadow=$(grep "^${u}:" /etc/shadow 2>/dev/null)
                [[ "$shadow" == *"!"* ]] && ((locked++))
            fi
        done < "$DB_FILE"
    fi
    local ram_total ram_used ram_pct disk_total disk_used disk_pct
    ram_total=$(free -m | awk '/^Mem:/{print $2}')
    ram_used=$(free -m | awk '/^Mem:/{print $3}')
    ram_pct=$(awk "BEGIN{printf \"%.0f\", ($ram_used/$ram_total)*100}")
    disk_used=$(df -B1 / | awk 'NR==2{print $3}')
    disk_total=$(df -B1 / | awk 'NR==2{print $2}')
    disk_pct=$(awk "BEGIN{printf \"%.0f\", ($disk_used/$disk_total)*100}")
    echo -e "\n   ${C_TITLE}--- SYSTEM INFO ---${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Hostname:    ${C_CYAN}${BANNER_CACHE_DOMAIN:-$(hostname)}${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Kernel:      ${C_CYAN}$(uname -r)${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Uptime:      ${C_CYAN}$(uptime -p | sed 's/up //')${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} CPU:         ${C_CYAN}${BANNER_CACHE_CPU_COUNT} cores (load: ${BANNER_CACHE_CPU_LOAD})${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} RAM:         ${C_CYAN}${ram_used}MB / ${ram_total}MB (${ram_pct}%)${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Disk:        ${C_CYAN}$(numfmt --to=iec $disk_used) / $(numfmt --to=iec $disk_total) (${disk_pct}%)${C_RESET}"
    echo -e "\n   ${C_TITLE}--- ACCOUNT SUMMARY ---${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Total Created:  ${C_CYAN}${total_users}${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Online Now:     ${C_GREEN}${online}${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Expired Today:  ${C_YELLOW}${expired_today}${C_RESET}"
    echo -e "   ${C_GRAY}•${C_RESET} Locked:         ${C_RED}${locked}${C_RESET}"
    echo
    press_enter
}

# ═══════════════════════════════════════════════════════════
# PORT MANAGER
# ═══════════════════════════════════════════════════════════
port_manager_menu() {
    while true; do
clear; show_banner
        echo -e "\n   ${C_TITLE}═════════════[ ${C_BOLD}🔌 PORT MANAGER ${C_RESET}${C_TITLE}]═════════════${C_RESET}"
        local ports_list=(
            "SSH:22"
            "ZiVPN:${ZIVPN_LISTEN_PORT:-5667}"
            "UDP-Custom:${UDP_CUSTOM_LISTEN_PORT:-36712}"
            "BadVPN:${BADVPN_LISTEN_PORT:-7300}"
            "DNSTT:53"
            "Nginx Int:${NGINX_INTERNAL_HTTP_PORT:-8880}, ${NGINX_INTERNAL_TLS_PORT:-8443}"
            "Dropbear:${DROPBEAR_PORTS}"
            "OpenVPN:${OPENVPN_TCP_PORT}, ${OPENVPN_UDP_PORT}, ${OPENVPN_SDNS_PORT}"
            "WireGuard:${WIREGUARD_PORT}"
            "Hysteria:${HYSTERIA1_PORT}/${HYSTERIA2_PORT}"
            "ShadowSocks:${SHADOWSOCKS_PORT:-2443}"
            "Socks5:${SOCKS5_PORT}"
            "Stunnel:${STUNNEL_PORT}"
            "WS-SSH:80, 443 (bridge:${WS_SSH_INTERNAL_PORT}) [$(grep -oP '^RESPONSE="\K[^"]*' "$WS_SSH_CONFIG_FILE" 2>/dev/null || echo 'HTTP/1.1 101 Switching Protocols')]"
        )
        local idx=1
        for entry in "${ports_list[@]}"; do
            local label="${entry%%:*}"
            local ports="${entry#*:}"
            printf "   ${C_CHOICE}[%2d]${C_RESET} %-15s ${C_GRAY}→${C_RESET} ${C_GREEN}%s${C_RESET}\n" "$idx" "$label" "$ports"
            ((idx++))
        done
        echo -e "\n   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -p "👉 Select a service to edit its port (press Enter for service config): " pm_choice
        [[ -z "$pm_choice" || "$pm_choice" == "0" ]] && return
        if [[ "$pm_choice" =~ ^[0-9]+$ ]] && (( pm_choice >= 1 && pm_choice <= ${#ports_list[@]} )); then
            local selected="${ports_list[$((pm_choice-1))]}"
            local svc_name="${selected%%:*}"
            local cur_ports="${selected#*:}"
            echo -e "\n${C_CYAN}Editing: ${svc_name}${C_RESET}"
            echo -e "${C_DIM}Current port(s): ${cur_ports}${C_RESET}"
            read -p "👉 Enter new port(s) (e.g. 1194 or 1194,2200): " new_port
            if [[ -n "$new_port" ]]; then
                echo -e "${C_GREEN}⚙️ Updating config and restarting ${svc_name}...${C_RESET}"
                case "$svc_name" in
                    SSH)
                        sed -i "s/^Port .*/Port $new_port/" /etc/ssh/sshd_config 2>/dev/null
                        systemctl try-restart sshd 2>/dev/null || systemctl try-restart ssh 2>/dev/null
                        echo -e "${C_GREEN}✅ SSH port changed to $new_port.${C_RESET}" ;;
                    ZiVPN)
                        sed -i "s/\"listen\":.*/\"listen\": \":$new_port\",/" /etc/zivpn/config.json 2>/dev/null
                        systemctl try-restart zivpn 2>/dev/null
                        ZIVPN_LISTEN_PORT="$new_port" ;;
                    Dropbear)
                        local _db_args=""
                        IFS=',' read -ra _db_pp <<< "$new_port"
                        for _dbp in "${_db_pp[@]}"; do _dbp="${_dbp// /}"; _db_args+=" -p ${_dbp}"; done
                        sed -i "s|^#\?\s*DROPBEAR_EXTRA_ARGS=.*|DROPBEAR_EXTRA_ARGS=\"${_db_args}\"|" /etc/default/dropbear 2>/dev/null
                        systemctl try-restart dropbear 2>/dev/null
                        DROPBEAR_PORTS="$new_port" ;;
                    OpenVPN)
                        IFS=',' read -ra p <<< "$new_port"
                        local _tcp="${p[0]:-1194}" _udp="${p[1]:-2200}" _sdns="${p[2]:-25000}"
                        sed -i "s/^port .*/port $_tcp/" /etc/openvpn/server-tcp.conf 2>/dev/null
                        sed -i "s/^port .*/port $_udp/" /etc/openvpn/server-udp.conf 2>/dev/null
                        sed -i "s/^port .*/port $_sdns/" /etc/openvpn/server-sdns.conf 2>/dev/null
                        systemctl try-restart openvpn@server-tcp 2>/dev/null
                        systemctl try-restart openvpn@server-udp 2>/dev/null
                        OPENVPN_TCP_PORT="$_tcp"; OPENVPN_UDP_PORT="$_udp"; OPENVPN_SDNS_PORT="$_sdns" ;;
                    WireGuard)
                        sed -i "s/^ListenPort = .*/ListenPort = $new_port/" /etc/wireguard/wg0.conf 2>/dev/null
                        wg-quick down wg0 2>/dev/null; wg-quick up wg0 2>/dev/null
                        WIREGUARD_PORT="$new_port" ;;
                    Hysteria)
                        IFS='/' read -ra p <<< "$new_port"
                        local _h1="${p[0]:-20000}" _h2="${p[1]:-20001}"
                        sed -i "s/\"listen\":.*/\"listen\": \":$_h2\",/" /etc/hysteria/config.json 2>/dev/null
                        systemctl try-restart hysteria-server 2>/dev/null
                        HYSTERIA1_PORT="$_h1"; HYSTERIA2_PORT="$_h2" ;;
                    ShadowSocks)
                        # Rewrite the field properly: the old sed appended a comma
                        # to the whole line, producing invalid JSON that made
                        # ss-server refuse to start.
                        if command -v jq &>/dev/null && [[ -f /etc/shadowsocks-libev/config.json ]]; then
                            local _ss_tmp; _ss_tmp=$(mktemp) || _ss_tmp=""
                            if [[ -n "$_ss_tmp" ]] && jq --argjson p "$new_port" '.server_port = $p' \
                                /etc/shadowsocks-libev/config.json > "$_ss_tmp" 2>/dev/null; then
                                mv "$_ss_tmp" /etc/shadowsocks-libev/config.json
                            else
                                rm -f "$_ss_tmp" 2>/dev/null
                                echo -e "${C_RED}❌ Could not update the ShadowSocks config.${C_RESET}"
                            fi
                        else
                            sed -i "s/\"server_port\":[0-9]*/\"server_port\":${new_port}/" /etc/shadowsocks-libev/config.json 2>/dev/null
                        fi
                        systemctl try-restart shadowsocks-libev 2>/dev/null
                        SHADOWSOCKS_PORT="$new_port" ;;
                    Socks5)
                        # danted needs BOTH the internal and external listener
                        # moved; rewriting only `internal:` left the socket on
                        # the old port and danted refused to bind the new one.
                        sed -i "s/^internal:.*port *= *[0-9]*/internal: 0.0.0.0 port = $new_port/" /etc/danted.conf 2>/dev/null
                        sed -i "s/^external:.*port *= *[0-9]*/external: $(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1) port = $new_port/" /etc/danted.conf 2>/dev/null
                        systemctl try-restart danted 2>/dev/null
                        SOCKS5_PORT="$new_port" ;;
                    Stunnel)
                        # The accept line is the only thing tied to the port; its
                        # comments and [ssh] section stay untouched.
                        sed -i "s/^accept *= *[0-9]*/accept = $new_port/" /etc/stunnel/stunnel.conf 2>/dev/null
                        systemctl try-restart stunnel4 2>/dev/null
                        STUNNEL_PORT="$new_port" ;;
                    Rest-API)
                        sed -i "s/PORT = .*/PORT = $new_port/" /usr/local/bin/VPS_superScript-api.py 2>/dev/null
                        systemctl try-restart rest-api 2>/dev/null
                        REST_API_PORT="$new_port" ;;
                    WS-SSH)
                        sed -i "s|${WS_SSH_SCRIPT} [0-9]*|${WS_SSH_SCRIPT} ${new_port}|" "$WS_SSH_SERVICE" 2>/dev/null
                        sed -i "s|^PORTS=.*|PORTS=\"${new_port}\"|" "$WS_SSH_CONFIG_FILE" 2>/dev/null
                        WS_SSH_INTERNAL_PORT="$new_port"
                        echo -e "\n${C_CYAN}Change HTTP response status too?${C_RESET}"
                        echo -e "  ${C_GREEN}[1]${C_RESET} HTTP/1.1 101 Switching Protocols"
                        echo -e "  ${C_GREEN}[2]${C_RESET} HTTP/1.1 200 OK"
                        echo -e "  ${C_GREEN}[3]${C_RESET} HTTP/1.1 200 Connection Established"
                        echo -e "  ${C_GREEN}[4]${C_RESET} Custom"
                        echo -e "  ${C_GREEN}[0]${C_RESET} Keep current"
                        local ws_resp_choice
                        read -p "👉 Select [0]: " ws_resp_choice
                        ws_resp_choice=${ws_resp_choice:-0}
                        if [[ "$ws_resp_choice" != "0" ]]; then
                            local new_resp=""
                            case "$ws_resp_choice" in
                                1) new_resp="HTTP/1.1 101 Switching Protocols" ;;
                                2) new_resp="HTTP/1.1 200 OK" ;;
                                3) new_resp="HTTP/1.1 200 Connection Established" ;;
                                4) read -p "👉 Enter custom response: " new_resp ;;
                            esac
                            if [[ -n "$new_resp" ]]; then
                                sed -i "s|^RESPONSE=.*|RESPONSE=\"${new_resp}\"|" "$WS_SSH_CONFIG_FILE" 2>/dev/null
                                echo -e "${C_GREEN}   Response set to: ${new_resp}${C_RESET}"
                            fi
                        fi
                        systemctl daemon-reload; systemctl try-restart ws-ssh 2>/dev/null
                        _ws_ssh_update_nginx_backend ;;
                    *) echo -e "${C_YELLOW}Manual config change required for this service.${C_RESET}" ;;
                esac
                echo -e "${C_GREEN}✅ Port updated and service restarted for ${svc_name}.${C_RESET}"
            fi
            press_enter
        else
            invalid_option
        fi
    done
}

# ═══════════════════════════════════════════════════════════
# SERVICE INFO
# ═══════════════════════════════════════════════════════════
service_info_menu() {
    while true; do
        clear; show_banner
        echo -e "\n   ${C_TITLE}══════════════[ ${C_BOLD}ℹ️ SERVICE INFORMATION ${C_RESET}${C_TITLE}]══════════════${C_RESET}"
        local idx=1
        local -a svc_keys=()
        for entry in "${SERVICE_INFO_DB[@]}"; do
            local name="${entry%%:*}"
            svc_keys+=("$name")
            printf "   ${C_CHOICE}[%2d]${C_RESET} %-20s\n" "$idx" "$name"
            ((idx++))
        done
        echo -e "\n   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        printf "   ${C_CHOICE}[N]${C_RESET} %-20s\n" "📂 Nano Paths & Exports"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -p "👉 Select a service to view info: " si_choice
        [[ "$si_choice" == "0" ]] && return
        if [[ "$si_choice" =~ ^[Nn]$ ]]; then
            clear; show_banner
            echo -e "\n   ${C_TITLE}══════════════[ ${C_BOLD}📂 CONFIG FILE PATHS ${C_RESET}${C_TITLE}]══════════════${C_RESET}"
            echo -e "\n   ${C_CYAN}── Copy any path and paste after 'nano ' in terminal ──${C_RESET}\n"
            echo -e "   ${C_WHITE}── SSH / Dropbear${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/ssh/sshd_config${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/default/dropbear${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── Nginx${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/nginx/nginx.conf${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── ZiVPN${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/zivpn/config.json${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── UDP-Custom${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/udp-custom/config.json${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── DNSTT (SlowDNS)${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/dnstt/server.conf${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── BadVPN / Falcon Proxy${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/systemd/system/badvpn.service${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/systemd/system/falcon-proxy.service${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── OpenVPN${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/openvpn/server-tcp.conf${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/openvpn/server-udp.conf${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/openvpn/server-sdns.conf${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/openvpn/easy-rsa/vars${C_RESET}"
            echo -e "      ${C_DIM}cat ${EXPORTS_DIR}/<username>.ovpn${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── WireGuard${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/wireguard/wg0.conf${C_RESET}"
            echo -e "      ${C_DIM}cat /etc/wireguard/server.pub${C_RESET}"
            echo -e "      ${C_DIM}cat ${EXPORTS_DIR}/<username>.conf${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── Hysteria2${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/hysteria/config.json${C_RESET}"
            echo -e "      ${C_DIM}cat ${EXPORTS_DIR}/<username>-hysteria.json${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── ShadowSocks${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/shadowsocks-libev/config.json${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── SOCKS5 (Dante)${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/danted.conf${C_RESET}"
            echo
            echo -e "   ${C_WHITE}── Stunnel${C_RESET}"
            echo -e "      ${C_DIM}nano /etc/stunnel/stunnel.conf${C_RESET}"
            echo
            echo -e "   ${C_CYAN}── Fetch User Configs (replace <username>)${C_RESET}"
            echo -e "      ${C_DIM}cat ${EXPORTS_DIR}/<username>.ovpn${C_RESET}"
            echo -e "      ${C_DIM}cat ${EXPORTS_DIR}/<username>.conf${C_RESET}"
            echo -e "      ${C_DIM}cat ${EXPORTS_DIR}/<username>-hysteria.json${C_RESET}"
            echo -e "      ${C_DIM}scp root@<server-ip>:${EXPORTS_DIR}/<username>.ovpn .${C_RESET}"
            echo
            echo -e "   ${C_YELLOW}💡 Tip: Replace <username> with the actual username from the user list.${C_RESET}"
            echo
            press_enter
        elif [[ "$si_choice" =~ ^[0-9]+$ ]] && (( si_choice >= 1 && si_choice <= ${#SERVICE_INFO_DB[@]} )); then
            local entry="${SERVICE_INFO_DB[$((si_choice-1))]}"
            local name="${entry%%:*}"
            local info="${entry#*:}"
            IFS='.' read -r desc default conflicts <<< "$info"
            echo -e "\n   ${C_TITLE}══════════════[ ${C_BOLD}${name} ${C_RESET}${C_TITLE}]══════════════${C_RESET}"
            echo -e "\n   ${C_CYAN}📝 Description:${C_RESET}"
            echo -e "   ${desc}"
            echo -e "\n   ${C_CYAN}⚙️  Default Port(s):${C_RESET}"
            echo -e "   ${default}"
            echo -e "\n   ${C_CYAN}⚠️  Conflict Warnings:${C_RESET}"
            echo -e "   ${conflicts}"
            echo
            press_enter
        else
            invalid_option
        fi
    done
}

# ═══════════════════════════════════════════════════════════
# DUCKDNS — FREE DYNAMIC DNS
# ═══════════════════════════════════════════════════════════

_duckdns_update() {
    local conf="$DUCKDNS_CONFIG_FILE"
    [[ -f "$conf" ]] || return 1
    source "$conf"
    [[ -n "$DUCKDNS_TOKEN" && -n "$DUCKDNS_DOMAIN" ]] || return 1
    local reply
    reply=$(curl -s "https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip=" 2>/dev/null)
    echo "$reply"
}

duckdns_menu() {
    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🦆 DuckDNS — Free Dynamic DNS ---${C_RESET}"

        local status="${C_STATUS_I}Not configured${C_RESET}"
        local domain_info=""
        if [[ -f "$DUCKDNS_CONFIG_FILE" ]]; then
            source "$DUCKDNS_CONFIG_FILE"
            if [[ -n "$DUCKDNS_DOMAIN" && -n "$DUCKDNS_TOKEN" ]]; then
                status="${C_STATUS_A}Configured${C_RESET}"
                domain_info="${C_GREEN}${DUCKDNS_DOMAIN}.duckdns.org${C_RESET}"
                local cron_on
                cron_on=$(crontab -l 2>/dev/null | grep -c "duckdns.org/update" || true)
                if (( cron_on > 0 )); then
                    domain_info+=" ${C_STATUS_A}(auto-update ON)${C_RESET}"
                else
                    domain_info+=" ${C_WARN}(no auto-update)${C_RESET}"
                fi
            fi
        fi

        echo -e "\n${C_WHITE}Status: ${status}${C_RESET}"
        [[ -n "$domain_info" ]] && echo -e "${C_WHITE}Domain: ${domain_info}${C_RESET}"

        echo -e "\n${C_BOLD}${C_YELLOW}── What is DuckDNS? ──${C_RESET}"
        echo -e "${C_DIM}DuckDNS is a FREE dynamic DNS service. It gives you a${C_RESET}"
        echo -e "${C_DIM}subdomain like ${C_CYAN}yourname.duckdns.org${C_RESET}${C_DIM} that always points to${C_RESET}"
        echo -e "${C_DIM}your server, even if your IP changes. Perfect for users${C_RESET}"
        echo -e "${C_DIM}who don't have a custom domain.${C_RESET}"

        echo -e "\n${C_BOLD}Options:${C_RESET}\n"
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🦆 Setup DuckDNS"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔄 Test Update Now"
        printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "👁️ View Config"
        [[ -f "$DUCKDNS_CONFIG_FILE" ]] && printf "  ${C_DANGER}[ 4]${C_RESET} %-40s\n" "🗑️ Remove DuckDNS"
        echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        read -p "👉 Select an option: " dd_choice
        case $dd_choice in
            1) duckdns_setup ;;
            2)
                echo -e "\n${C_BLUE}🔄 Testing DuckDNS update...${C_RESET}"
                local result
                result=$(_duckdns_update)
                if [[ "$result" == "OK" ]]; then
                    echo -e "${C_GREEN}✅ Success! ${DUCKDNS_DOMAIN}.duckdns.org now points to your server.${C_RESET}"
                else
                    echo -e "${C_RED}❌ Failed. Response: $result${C_RESET}"
                fi
                press_enter ;;
            3)
                if [[ -f "$DUCKDNS_CONFIG_FILE" ]]; then
                    source "$DUCKDNS_CONFIG_FILE"
                    echo -e "\n${C_CYAN}Domain: ${DUCKDNS_DOMAIN}.duckdns.org${C_RESET}"
                    echo -e "${C_CYAN}Token:  ${DUCKDNS_TOKEN:0:8}...${C_RESET}"
                    local cron_on
                    cron_on=$(crontab -l 2>/dev/null | grep -c "duckdns.org/update" || true)
                    if (( cron_on > 0 )); then
                        echo -e "${C_GREEN}Auto-update: Active (every 5 min)${C_RESET}"
                    else
                        echo -e "${C_YELLOW}Auto-update: Not active${C_RESET}"
                    fi
                else
                    echo -e "\n${C_YELLOW}Not configured.${C_RESET}"
                fi
                press_enter ;;
            4)
                if [[ -f "$DUCKDNS_CONFIG_FILE" ]]; then
                    echo -e "\n${C_YELLOW}⚠️  Remove DuckDNS? This will:${C_RESET}"
                    echo -e "   • Delete your DuckDNS config (domain + token)"
                    echo -e "   • Remove the auto-update cron job"
                    echo -e "   • Leave your banner domain as-is"
                    echo
                    read -p "👉 Type 'yes' to confirm: " confirm_rm
                    if [[ "$confirm_rm" != "yes" ]]; then
                        echo -e "\n${C_GREEN}✅ Cancelled.${C_RESET}"
                        press_enter; continue
                    fi
                    echo -e "\n${C_YELLOW}Removing DuckDNS config...${C_RESET}"
                    crontab -l 2>/dev/null | grep -v "duckdns.org/update" | crontab - 2>/dev/null || true
                    rm -f "$DUCKDNS_CONFIG_FILE"
                    echo -e "${C_GREEN}✅ DuckDNS removed.${C_RESET}"
                    press_enter
                fi ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

duckdns_setup() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🦆 DuckDNS Setup ---${C_RESET}"

    echo -e "\n${C_BOLD}${C_YELLOW}═══════════════════ GETTING YOUR DUCKDNS DOMAIN ═══════════════════${C_RESET}"
    echo -e "${C_DIM}"
    echo -e "  Follow these steps to get your free domain and token:"
    echo -e ""
    echo -e "  ${C_WHITE}Step 1:${C_DIM} Open https://duckdns.org in your browser"
    echo -e "  ${C_WHITE}Step 2:${C_DIM} Sign in using one of these methods:"
    echo -e "         • GitHub    • Google    • Twitter"
    echo -e "  ${C_WHITE}Step 3:${C_DIM} Under \"Domains\", enter a name you want and click"
    echo -e "         [add domain] — e.g. ${C_CYAN}myserver${C_DIM}"
    echo -e "  ${C_WHITE}Step 4:${C_DIM} Your domain will be: ${C_CYAN}myserver.duckdns.org${C_DIM}"
    echo -e "  ${C_WHITE}Step 5:${C_DIM} Copy the ${C_CYAN}token${C_DIM} shown on the dashboard — it's a"
    echo -e "         long string of letters and numbers. You'll need it below."
    echo -e "${C_RESET}"
    echo -e "${C_BOLD}${C_YELLOW}════════════════════════════════════════════════════════════════${C_RESET}"

    if [[ -f "$DUCKDNS_CONFIG_FILE" ]]; then
        source "$DUCKDNS_CONFIG_FILE"
        echo -e "\n${C_YELLOW}ℹ️ Already configured for ${DUCKDNS_DOMAIN}.duckdns.org${C_RESET}"
        read -p "👉 Overwrite? (y/n): " overwrite
        [[ "$overwrite" != "y" && "$overwrite" != "Y" ]] && return
    fi

    echo
    read -p "👉 Enter your DuckDNS domain name (without .duckdns.org): " dd_domain
    [[ -z "$dd_domain" ]] && { echo -e "${C_RED}❌ Domain required.${C_RESET}"; press_enter; return; }

    read -p "👉 Enter your DuckDNS token: " dd_token
    [[ -z "$dd_token" ]] && { echo -e "${C_RED}❌ Token required.${C_RESET}"; press_enter; return; }

    echo -e "\n${C_BLUE}🔄 Testing API with your domain and token...${C_RESET}"
    local reply
    reply=$(curl -s "https://www.duckdns.org/update?domains=${dd_domain}&token=${dd_token}&ip=" 2>/dev/null)
    if [[ "$reply" == "OK" ]]; then
        echo -e "${C_GREEN}✅ API test passed!${C_RESET}"
    else
        echo -e "${C_RED}❌ API test failed. Response: '${reply}'${C_RESET}"
        echo -e "${C_YELLOW}Double-check your domain name and token at https://duckdns.org${C_RESET}"
        press_enter; return
    fi

    mkdir -p "$DB_DIR" 2>/dev/null
    cat > "$DUCKDNS_CONFIG_FILE" <<EOF
DUCKDNS_DOMAIN="${dd_domain}"
DUCKDNS_TOKEN="${dd_token}"
EOF

    # Set up cron for auto-update every 5 minutes
    local cron_job="${DUCKDNS_CRON_SCHED} curl -s 'https://www.duckdns.org/update?domains=${dd_domain}&token=${dd_token}&ip=' >/dev/null 2>&1"
    (crontab -l 2>/dev/null | grep -v "duckdns.org/update"; echo "$cron_job") | crontab - 2>/dev/null
    echo -e "${C_GREEN}✅ Cron job installed (updates every 5 minutes).${C_RESET}"

    # Auto-set as display domain
    echo "${dd_domain}.duckdns.org" > "$DOMAIN_OVERRIDE_FILE"
    BANNER_CACHE_DOMAIN=""
    echo -e "${C_GREEN}✅ Domain set in banner: ${dd_domain}.duckdns.org${C_RESET}"

    echo -e "\n${C_GREEN}════════════════════════════════════════════════════════${C_RESET}"
    echo -e "${C_GREEN}  🦆 DuckDNS is live! Your domain:${C_RESET}"
    echo -e "${C_GREEN}  ${C_CYAN}${dd_domain}.duckdns.org${C_RESET}"
    echo -e "${C_GREEN}  It will auto-update every 5 minutes.${C_RESET}"
    echo -e "${C_GREEN}  Use this domain for your services and SSL.${C_RESET}"
    echo -e "${C_GREEN}════════════════════════════════════════════════════════${C_RESET}"
    press_enter
}

if [[ "$1" == "--install-setup" ]]; then
    initial_setup
    exit 0
fi

# Delegated console entry point (used by /usr/local/bin/vss-subadmin).
# Runs as root, restricted to the calling sudo user's own accounts.
if [[ "$1" == "--delegate" ]]; then
    [[ $EUID -eq 0 ]] || exit 1
    actor="${2:-}"
    [[ -n "$actor" && "$actor" != "root" ]] || exit 1
    id "$actor" &>/dev/null || exit 1
    VSS_ACTOR="$actor"; export VSS_ACTOR
    ensure_VPS_superScript_dirs
    delegate_menu
    exit 0
fi

require_interactive_terminal
vss_license_gate
sync_runtime_components_if_needed
main_menu

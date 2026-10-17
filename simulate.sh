#!/bin/bash
# Simulate the VPS_superScript-manager menu rendering - standalone

# Color palette (matches menu.sh)
C_RESET=$'\033[0m'
C_BOLD=$'\033[1m'
C_DIM=$'\033[2m'
C_RED=$'\033[38;5;196m'
C_GREEN=$'\033[38;5;46m'
C_YELLOW=$'\033[38;5;226m'
C_BLUE=$'\033[38;5;39m'
C_PURPLE=$'\033[38;5;135m'
C_CYAN=$'\033[38;5;51m'
C_WHITE=$'\033[38;5;255m'
C_GRAY=$'\033[38;5;245m'
C_ORANGE=$'\033[38;5;208m'
C_TITLE=$C_PURPLE
C_CHOICE=$C_CYAN
C_PROMPT=$C_BLUE
C_WARN=$C_YELLOW
C_DANGER=$C_RED
C_STATUS_A=$C_GREEN
C_STATUS_I=$C_GRAY
C_ACCENT=$C_ORANGE

# Simulated data
BANNER_CACHE_BASE="Ubuntu"
BANNER_CACHE_CPU_LOAD="0.15"
BANNER_CACHE_CPU_COUNT="2"
BANNER_CACHE_DOMAIN="VPS_superScript.space"
BANNER_CACHE_TOTAL_USERS="12"
BANNER_CACHE_UP_TIME="(2)wks (3)days"
BANNER_CACHE_IP="192.168.1.100"
BANNER_CACHE_OS_NAME="Ubuntu 22.04"

clear_screen() { printf '\033[2J\033[H'; }

show_banner_sim() {
    echo -e "${C_TITLE}          VPS_superScript ${C_RESET}${C_DIM}| Premium Edition V1.0.0         ${C_RESET}"
    echo -e "${C_BLUE}   ─────────────────────────────────────────────────────${C_RESET}"
    printf "   ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%-19s${C_RESET} ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%s${C_RESET}\n" "Base" "$BANNER_CACHE_BASE" "Load" "$BANNER_CACHE_CPU_LOAD"
    printf "   ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%-19s${C_RESET} ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%s${C_RESET}\n" "CPU'S" "$BANNER_CACHE_CPU_COUNT" "Domain" "$BANNER_CACHE_DOMAIN"
    printf "   ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%-19s${C_RESET} ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%s${C_RESET}\n" "Users" "$BANNER_CACHE_TOTAL_USERS Managed" "UpTime" "$BANNER_CACHE_UP_TIME"
    printf "   ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%-19s${C_RESET} ${C_GRAY}◦ %-6s${C_RESET} ${C_GREEN}%s${C_RESET}\n" "IP" "$BANNER_CACHE_IP" "OS" "$BANNER_CACHE_OS_NAME"
    echo -e "${C_BLUE}   ·····················································${C_RESET}"
    echo -e "   ${C_GRAY}·${C_RESET}${C_TITLE}              🔧 ACTIVE SERVICES               ${C_RESET}${C_GRAY}·${C_RESET}"
    echo -e "${C_BLUE}   ·····················································${C_RESET}"

    # Simulated active services
    local services=(
        "SSH:22" "Nginx Int.:80, 443"
        "ZiVPN:5667" "UDP-Custom:36712"
        "BadVPN:7300" "DNSTT:53"
        "Nginx Int.:8880, 8443" "Dropbear:109, 143"
        "OpenVPN:1194, 2200" "WireGuard:51820"
    )
    local i
    for ((i=0; i<${#services[@]}; i+=2)); do
        local s1="${services[i]}" s2="${services[i+1]}"
        local label1="${s1%%:*}" val1="${s1#*:}"
        local label2="${s2%%:*}" val2="${s2#*:}"
        printf "   ${C_GRAY}·  ◦ %-12s${C_RESET} ${C_ORANGE}%-7s${C_RESET}  ${C_GRAY}◦ %-12s${C_RESET} ${C_ORANGE}%s${C_RESET}  ${C_GRAY}·${C_RESET}\n" "$label1:" "$val1" "$label2:" "$val2"
    done
    echo -e "${C_BLUE}   ·····················································${C_RESET}"
}

main_menu_sim() {
    clear_screen
    show_banner_sim
    echo
    echo -e "   ${C_TITLE}─────────────────────────────────────────────────────${C_RESET}"
    echo -e "   ${C_TITLE}              👤 USER MANAGEMENT              ${C_RESET}"
    echo -e "   ${C_TITLE}─────────────────────────────────────────────────────${C_RESET}"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "1" "🌟 Create User" "6" "📝 Edit User"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "2" "🗑️ Delete User" "7" "📋 List Users"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "3" "🔄 Renew User" "8" "👁️ User Details"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "4" "🔒 Lock User" "9" "📱 User Config"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_ORANGE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "5" "🔓 Unlock User" "10" "➕ More Users ▸"
    echo
    echo -e "   ${C_TITLE}─────────────────────────────────────────────────────${C_RESET}"
    echo -e "   ${C_TITLE}              🧭 MANAGEMENT HUBS              ${C_RESET}"
    echo -e "   ${C_TITLE}─────────────────────────────────────────────────────${C_RESET}"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "11" "🔌 Protocols & Services ▸" "14" "🌐 Network & Ports ▸"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "12" "📊 Monitoring & Traffic ▸" "15" "⚙️ System & Server ▸"
    printf "\033[6G${C_CHOICE}[%2s]${C_RESET}\033[11G%-28s\033[40G${C_CHOICE}[%2s]${C_RESET}\033[45G%-28s\033[K\n" "13" "🎨 Access & Content ▸" "16" "🤖 Integrations ▸"
    echo
    echo -e "   ${C_DANGER}─────────────────────────────────────────────────────${C_RESET}"
    echo -e "   ${C_DANGER}                🔥 DANGER ZONE                 ${C_RESET}"
    echo -e "   ${C_DANGER}─────────────────────────────────────────────────────${C_RESET}"
    echo -e "     ${C_DANGER}[99]${C_RESET} Uninstall Script             ${C_WARN}[ 0]${C_RESET} Exit"
    echo
    read -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice
    case $choice in
        1) protocols_hub_sim ;;
        13) access_hub_sim ;;
        10) more_users_hub_sim ;;
        0) exit 0 ;;
        *) main_menu_sim ;;
    esac
}

more_users_hub_sim() {
    while true; do
        clear_screen; show_banner_sim
        echo -e "\n   ${C_TITLE}═══════════════[ ${C_BOLD}➕ MORE USER TOOLS${C_RESET}${C_TITLE} ]═══════════════${C_RESET}\n"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "1" "⏱️  Trial Account"  "Create a time-limited trial user"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "2" "👥 Bulk Users"       "Create many users at once"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "3" "💾 Backup Users"     "Export the user database"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "4" "📥 Restore Users"    "Import users from a backup"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "5" "🧹 Cleanup Expired"  "Remove expired accounts"
        echo -e "\n   ${C_DIM}───────────────────────────────────────────────────${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️  Back to Main Menu\n"
        read -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice
        case $choice in
            1) clear_screen; show_banner_sim; echo -e "${C_BOLD}${C_PURPLE}--- ⏱️ Create Trial Account ---${C_RESET}"; echo; echo -ne "${C_CYAN}👉 Username: ${C_RESET}"; read; echo -ne "${C_CYAN}👉 Duration (days): ${C_RESET}"; read; echo -e "\n${C_GREEN}✅ Trial user created.${C_RESET}"; read -p "Press [Enter] to continue...";;
            5) clear_screen; show_banner_sim; echo -e "${C_BOLD}${C_PURPLE}--- 🧹 Cleanup Expired Users ---${C_RESET}"; echo; echo -e "The following users have expired: ${C_RED}user1 user2 user3${C_RESET}"; echo -n "👉 Do you want to delete all of them? (y/n): "; read ans; echo -e "\n${C_GREEN}✅ Expired users cleaned up.${C_RESET}"; read -p "Press [Enter] to continue...";;
            0) break ;;
        esac
    done
    main_menu_sim
}

access_hub_sim() {
    while true; do
        clear_screen; show_banner_sim
        echo -e "\n   ${C_TITLE}═══════════════[ ${C_BOLD}🎨 ACCESS & CONTENT${C_RESET}${C_TITLE} ]═══════════════${C_RESET}\n"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "1" "🎨 SSH Banner"         "Set the login banner"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "2" "🔞 Content Filter"     "Block/allow content categories"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "3" "🚫 Bypass Proxy"       "Manage proxy bypass rules"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "4" "👑 Grant Root"         "Grant root to a user"
        echo -e "\n   ${C_DIM}───────────────────────────────────────────────────${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️  Back to Main Menu\n"
        read -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice
        case $choice in
            1) 
                while true; do
                    clear_screen; show_banner_sim
                    banner_status="${C_STATUS_I}Disabled${C_RESET}"
                    echo -e "\n   ${C_TITLE}═════════════════[ ${C_BOLD}🎨 SSH BANNER MODE: ${banner_status} ${C_RESET}${C_TITLE}]═════════════════${C_RESET}"
                    echo -e "${C_DIM}Static mode uses 'Banner /etc/ssh/banner'. Dynamic mode shows per-user account info.${C_RESET}"
                    printf "     ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "✨ Enable Dynamic Account Banner"
                    printf "     ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "📋 Paste or Replace Static Banner"
                    printf "     ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "👁️ View Current Static Banner"
                    printf "     ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "📝 Preview Dynamic Banner"
                    printf "     ${C_DANGER}[ 5]${C_RESET} %-40s\n" "🗑️ Disable All SSH Banners"
                    echo -e "   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
                    echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
                    echo
                    read -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" sub
                    [[ "$sub" == "0" ]] && break
                    echo -e "\n${C_GREEN}✅ Done.${C_RESET}"; read -p "Press [Enter] to continue..."
                done
                ;;
            0) break ;;
        esac
    done
    main_menu_sim
}

protocols_hub_sim() {
    while true; do
        clear_screen; show_banner_sim
        echo -e "\n   ${C_TITLE}═══════════════[ ${C_BOLD}🔌 PROTOCOLS & SERVICES${C_RESET}${C_TITLE} ]═══════════════${C_RESET}\n"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "1" "🔌 Protocol Manager"  "Install/manage VPN protocols & panels"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "2" "🔛 ON/OFF Service"     "Start or stop running services"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "3" "🦘 Dropbear Menu"      "Configure Dropbear SSH"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-24s ${C_DIM}%s${C_RESET}\n" "4" "♻️  Recover Xray"       "Recover expired Xray accounts"
        echo -e "\n   ${C_DIM}───────────────────────────────────────────────────${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️  Back to Main Menu\n"
        read -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice
        case $choice in
            0) break ;;
        esac
    done
    main_menu_sim
}

# Start
main_menu_sim

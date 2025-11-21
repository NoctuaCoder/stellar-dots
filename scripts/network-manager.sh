#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                       📶 NETWORK MANAGER 📶                               ║
# ║                        Stellar Dots Utility                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Check if NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    notify-send "Network Manager" "NetworkManager não está rodando!" -u critical
    exit 1
fi

# Get current connection
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)

# Options
wifi_toggle="📶 WiFi Toggle"
scan_wifi="🔍 Escanear Redes"
disconnect="❌ Desconectar"
separator="──────────────"

# Get WiFi status
wifi_status=$(nmcli radio wifi)

# Build menu
if [ "$wifi_status" = "enabled" ]; then
    menu="$wifi_toggle (Ligado)\n$scan_wifi\n"
    
    if [ -n "$current_ssid" ]; then
        menu+="$disconnect ($current_ssid)\n"
    fi
    
    menu+="$separator\n"
    
    # List available networks
    networks=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2 | \
        awk '{signal=$2; security=$3; ssid=$1; for(i=4;i<=NF;i++) ssid=ssid" "$i; printf "%-30s %3s%% %s\n", ssid, signal, security}')
    
    menu+="$networks"
else
    menu="$wifi_toggle (Desligado)"
fi

# Show menu
chosen=$(echo -e "$menu" | rofi -dmenu -p "Network Manager" -theme ~/.config/rofi/network.rasi)

# Handle selection
case "$chosen" in
    "$wifi_toggle"*)
        if [ "$wifi_status" = "enabled" ]; then
            nmcli radio wifi off
            notify-send "Network" "WiFi desligado" -i network-wireless-disabled
        else
            nmcli radio wifi on
            notify-send "Network" "WiFi ligado" -i network-wireless
        fi
        ;;
    "$scan_wifi")
        nmcli device wifi rescan
        notify-send "Network" "Escaneando redes..." -i network-wireless
        sleep 2
        $0  # Rerun script
        ;;
    "$disconnect"*)
        nmcli connection down "$current_ssid"
        notify-send "Network" "Desconectado de $current_ssid" -i network-wireless-disconnected
        ;;
    "$separator")
        exit 0
        ;;
    "")
        exit 0
        ;;
    *)
        # Extract SSID from chosen line
        ssid=$(echo "$chosen" | awk '{print $1}')
        
        # Check if network requires password
        security=$(nmcli -f SSID,SECURITY device wifi list | grep "^$ssid" | awk '{print $2}')
        
        if [ "$security" != "--" ]; then
            # Prompt for password
            password=$(rofi -dmenu -p "Senha para $ssid" -password -theme ~/.config/rofi/network.rasi)
            
            if [ -n "$password" ]; then
                nmcli device wifi connect "$ssid" password "$password"
                if [ $? -eq 0 ]; then
                    notify-send "Network" "Conectado a $ssid" -i network-wireless
                else
                    notify-send "Network" "Falha ao conectar" -u critical -i network-wireless-error
                fi
            fi
        else
            # Open network
            nmcli device wifi connect "$ssid"
            if [ $? -eq 0 ]; then
                notify-send "Network" "Conectado a $ssid" -i network-wireless
            else
                notify-send "Network" "Falha ao conectar" -u critical -i network-wireless-error
            fi
        fi
        ;;
esac

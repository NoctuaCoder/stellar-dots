#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      🔵 BLUETOOTH MANAGER 🔵                              ║
# ║                        Stellar Dots Utility                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Check if bluetooth is available
if ! command -v bluetoothctl &> /dev/null; then
    notify-send "Bluetooth" "bluetoothctl não está instalado!" -u critical
    exit 1
fi

# Options
power_toggle="🔵 Bluetooth Toggle"
scan="🔍 Escanear Dispositivos"
separator="──────────────"

# Get bluetooth status
power_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

# Build menu
if [ "$power_status" = "yes" ]; then
    menu="$power_toggle (Ligado)\n$scan\n$separator\n"
    
    # Get paired devices
    devices=$(bluetoothctl devices | cut -d' ' -f2-)
    
    while IFS= read -r device; do
        mac=$(echo "$device" | awk '{print $1}')
        name=$(echo "$device" | cut -d' ' -f2-)
        
        # Check if connected
        connected=$(bluetoothctl info "$mac" | grep "Connected" | awk '{print $2}')
        
        if [ "$connected" = "yes" ]; then
            menu+="✓ $name (Conectado)\n"
        else
            menu+="  $name\n"
        fi
    done <<< "$devices"
else
    menu="$power_toggle (Desligado)"
fi

# Show menu
chosen=$(echo -e "$menu" | rofi -dmenu -p "Bluetooth Manager" -theme ~/.config/rofi/bluetooth.rasi)

# Handle selection
case "$chosen" in
    "$power_toggle"*)
        if [ "$power_status" = "yes" ]; then
            bluetoothctl power off
            notify-send "Bluetooth" "Bluetooth desligado" -i bluetooth-disabled
        else
            bluetoothctl power on
            notify-send "Bluetooth" "Bluetooth ligado" -i bluetooth
        fi
        ;;
    "$scan")
        bluetoothctl power on
        bluetoothctl scan on &
        SCAN_PID=$!
        notify-send "Bluetooth" "Escaneando dispositivos..." -i bluetooth
        sleep 5
        kill $SCAN_PID
        $0  # Rerun script
        ;;
    "$separator"|"")
        exit 0
        ;;
    *)
        # Extract device name
        device_name=$(echo "$chosen" | sed 's/^[✓ ]*//')
        device_name=$(echo "$device_name" | sed 's/ (Conectado)//')
        
        # Get MAC address
        mac=$(bluetoothctl devices | grep "$device_name" | awk '{print $2}')
        
        if [ -n "$mac" ]; then
            # Check if connected
            connected=$(bluetoothctl info "$mac" | grep "Connected" | awk '{print $2}')
            
            if [ "$connected" = "yes" ]; then
                # Disconnect
                bluetoothctl disconnect "$mac"
                notify-send "Bluetooth" "Desconectado de $device_name" -i bluetooth-disabled
            else
                # Connect
                bluetoothctl connect "$mac"
                if [ $? -eq 0 ]; then
                    notify-send "Bluetooth" "Conectado a $device_name" -i bluetooth
                else
                    notify-send "Bluetooth" "Falha ao conectar" -u critical -i bluetooth-disabled
                fi
            fi
        fi
        ;;
esac

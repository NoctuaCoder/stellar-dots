#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         🔌 POWER MENU 🔌                                  ║
# ║                        Stellar Dots Utility                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Options
shutdown="⏻  Desligar"
reboot="  Reiniciar"
lock="  Bloquear"
suspend="⏾  Suspender"
logout="  Logout"
cancel="  Cancelar"

# Rofi command
rofi_cmd() {
    rofi -dmenu \
        -p "Power Menu" \
        -theme ~/.config/rofi/power-menu.rasi
}

# Confirmation dialog
confirm_exit() {
    rofi -dmenu \
        -p "Tem certeza? [S/n]" \
        -theme ~/.config/rofi/power-menu.rasi
}

# Show menu
chosen="$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown\n$cancel" | rofi_cmd)"

# Execute action
case $chosen in
    $shutdown)
        ans=$(confirm_exit &)
        if [[ $ans == "S" ]] || [[ $ans == "s" ]] || [[ $ans == "" ]]; then
            systemctl poweroff
        fi
        ;;
    $reboot)
        ans=$(confirm_exit &)
        if [[ $ans == "S" ]] || [[ $ans == "s" ]] || [[ $ans == "" ]]; then
            systemctl reboot
        fi
        ;;
    $lock)
        hyprlock
        ;;
    $suspend)
        ans=$(confirm_exit &)
        if [[ $ans == "S" ]] || [[ $ans == "s" ]] || [[ $ans == "" ]]; then
            systemctl suspend
        fi
        ;;
    $logout)
        ans=$(confirm_exit &)
        if [[ $ans == "S" ]] || [[ $ans == "s" ]] || [[ $ans == "" ]]; then
            hyprctl dispatch exit
        fi
        ;;
    $cancel)
        exit 0
        ;;
esac

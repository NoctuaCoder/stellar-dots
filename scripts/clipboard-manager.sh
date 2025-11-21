#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      📋 CLIPBOARD MANAGER 📋                              ║
# ║                        Stellar Dots Utility                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Check if cliphist is installed
if ! command -v cliphist &> /dev/null; then
    notify-send "Clipboard Manager" "cliphist não está instalado!" -u critical
    exit 1
fi

# Show clipboard history with Rofi
selected=$(cliphist list | rofi -dmenu \
    -p "Clipboard History" \
    -theme ~/.config/rofi/clipboard.rasi \
    -display-columns 1)

# Copy selected item to clipboard
if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
    notify-send "Clipboard" "Item copiado!" -i edit-paste
fi

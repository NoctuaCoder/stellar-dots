#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        ✨ SCREENSHOT SCRIPT ✨                             ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

SCREENSHOT_DIR="$HOME/Pictures/screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

# Notification function
notify() {
    notify-send -i "$FILENAME" "Screenshot" "$1"
}

case "$1" in
    --full)
        # Full screen
        grim "$FILENAME"
        notify "Screenshot completo salvo!"
        ;;
    --area)
        # Select area
        grim -g "$(slurp)" "$FILENAME"
        notify "Screenshot da área salvo!"
        ;;
    --window)
        # Active window
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILENAME"
        notify "Screenshot da janela salvo!"
        ;;
    *)
        echo "Uso: screenshot.sh [--full|--area|--window]"
        exit 1
        ;;
esac

# Copy to clipboard
wl-copy < "$FILENAME"
echo "✓ Screenshot salvo: $FILENAME"

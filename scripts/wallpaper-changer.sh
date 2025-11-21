#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      ✨ WALLPAPER CHANGER SCRIPT ✨                        ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALLPAPER="$WALLPAPER_DIR/current.jpg"

# Check if swww is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww init
    sleep 1
fi

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    # Set wallpaper with swww
    swww img "$wallpaper" \
        --transition-type wipe \
        --transition-duration 2 \
        --transition-fps 60 \
        --transition-angle 30
    
    # Create symlink to current wallpaper
    ln -sf "$wallpaper" "$CURRENT_WALLPAPER"
    
    # Generate colorscheme with pywal16
    if command -v wal &> /dev/null; then
        wal -i "$wallpaper" -n -q
    fi
    
    echo "✓ Wallpaper alterado: $(basename "$wallpaper")"
}

# Random wallpaper
if [[ "$1" == "--random" ]]; then
    wallpapers=("$WALLPAPER_DIR"/*)
    random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
    set_wallpaper "$random_wallpaper"
    exit 0
fi

# Select wallpaper with rofi
if [[ -z "$1" ]]; then
    # Get all wallpapers
    wallpapers=()
    while IFS= read -r -d '' file; do
        wallpapers+=("$(basename "$file")")
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print0)
    
    # Show selection menu
    selected=$(printf '%s\n' "${wallpapers[@]}" | rofi -dmenu -i -p "Escolha um wallpaper" -config ~/.config/rofi/launcher.rasi)
    
    if [[ -n "$selected" ]]; then
        set_wallpaper "$WALLPAPER_DIR/$selected"
    fi
else
    # Set specific wallpaper
    if [[ -f "$1" ]]; then
        set_wallpaper "$1"
    else
        echo "Erro: Arquivo não encontrado: $1"
        exit 1
    fi
fi

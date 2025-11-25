#!/bin/bash
# Auto-Theme Generator for Stellar Dots
# Automatically generates and applies theme when wallpaper changes
# Integrates with pywal for enhanced color generation

# Check if pywal is installed
USE_PYWAL=false
if command -v wal &> /dev/null; then
    USE_PYWAL=true
    echo "✓ Pywal detected - using enhanced color generation"
else
    echo "ℹ Pywal not found - using built-in color extraction"
    echo "  Install pywal for better results: pip install pywal"
fi

# Generate theme with pywal
generate_with_pywal() {
    local wallpaper="$1"
    
    echo "Generating theme with pywal..."
    
    # Run pywal
    wal -i "$wallpaper" -n -q
    
    # Extract colors from pywal cache
    local colors_json="$HOME/.cache/wal/colors.json"
    
    if [[ ! -f "$colors_json" ]]; then
        echo "Error: Pywal colors not generated"
        return 1
    fi
    
    # Parse JSON and extract colors
    python3 << EOF
import json

with open("$colors_json") as f:
    colors = json.load(f)

# Map pywal colors to our scheme
palette = {
    'primary': colors['colors']['color1'],
    'primary-light': colors['colors']['color9'],
    'primary-dark': colors['colors']['color0'],
    'secondary': colors['colors']['color2'],
    'accent': colors['colors']['color4'],
    'background': colors['special']['background'],
    'surface': colors['colors']['color8'],
    'text': colors['special']['foreground'],
    'text-secondary': colors['colors']['color7']
}

for name, color in palette.items():
    print(f"{name}={color}")
EOF
}

# Apply theme to all configs
apply_theme() {
    local palette="$1"
    
    echo "Applying theme to configs..."
    
    # Update Hyprland
    echo "$palette" | while IFS='=' read -r name color; do
        case "$name" in
            primary)
                echo "\$primary = rgb(${color#\#})"
                ;;
            accent)
                echo "\$accent = rgb(${color#\#})"
                ;;
        esac
    done > "$HOME/.config/hypr/colors.conf"
    
    # Reload Hyprland
    hyprctl reload &> /dev/null
    
    # Update Waybar
    pkill -SIGUSR2 waybar 2>/dev/null
    
    echo "✓ Theme applied successfully!"
}

# Watch for wallpaper changes
watch_wallpaper() {
    echo "Watching for wallpaper changes..."
    echo "Press Ctrl+C to stop"
    echo ""
    
    local last_wallpaper=""
    
    while true; do
        if command -v swww &> /dev/null; then
            current_wallpaper=$(swww query 2>/dev/null | grep -oP 'image: \K.*' | head -1)
            
            if [[ -n "$current_wallpaper" ]] && [[ "$current_wallpaper" != "$last_wallpaper" ]]; then
                echo "Wallpaper changed: $(basename "$current_wallpaper")"
                
                # Generate new theme
                if [[ "$USE_PYWAL" == true ]]; then
                    palette=$(generate_with_pywal "$current_wallpaper")
                else
                    palette=$(wallpaper-colors.sh "$current_wallpaper" 2>/dev/null | grep '=' || echo "")
                fi
                
                if [[ -n "$palette" ]]; then
                    apply_theme "$palette"
                    notify-send "Theme Updated" "Colors extracted from wallpaper" -i preferences-desktop-theme
                fi
                
                last_wallpaper="$current_wallpaper"
            fi
        fi
        
        sleep 2
    done
}

# Main function
main() {
    case "${1:-}" in
        --watch|-w)
            watch_wallpaper
            ;;
        --install-pywal)
            echo "Installing pywal..."
            pip install --user pywal
            echo "✓ Pywal installed!"
            ;;
        *)
            echo "Auto-Theme Generator for Stellar Dots"
            echo ""
            echo "Usage:"
            echo "  $0 --watch          Watch for wallpaper changes and auto-update theme"
            echo "  $0 --install-pywal  Install pywal for enhanced color generation"
            echo ""
            echo "To enable auto-theme on startup, add to hyprland.conf:"
            echo "  exec-once = auto-theme.sh --watch"
            ;;
    esac
}

main "$@"

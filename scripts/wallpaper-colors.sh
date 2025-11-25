#!/bin/bash
# Wallpaper Color Generation for Stellar Dots
# Extracts Material Design 3 colors from wallpaper and updates all configs
# Inspired by end-4/dots-hyprland auto-generated colors

# Dependencies check
check_dependencies() {
    local missing=()
    
    # Check for imagemagick (for color extraction)
    if ! command -v convert &> /dev/null; then
        missing+=("imagemagick")
    fi
    
    # Check for Python (for Material You color generation)
    if ! command -v python3 &> /dev/null; then
        missing+=("python3")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Missing dependencies: ${missing[*]}"
        echo "Install with: sudo pacman -S imagemagick python python-pip"
        exit 1
    fi
}

# Extract dominant colors from wallpaper
extract_colors() {
    local wallpaper="$1"
    local num_colors="${2:-6}"
    
    echo "Extracting colors from: $(basename "$wallpaper")"
    
    # Use imagemagick to get dominant colors
    convert "$wallpaper" -resize 100x100 -colors "$num_colors" -unique-colors txt:- | \
        grep -oE '#[0-9A-Fa-f]{6}' | head -n "$num_colors"
}

# Generate Material Design 3 color scheme
generate_material_colors() {
    local primary_color="$1"
    
    # Create Python script for Material You color generation
    python3 << EOF
import colorsys

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(rgb):
    return '#{:02x}{:02x}{:02x}'.format(int(rgb[0]), int(rgb[1]), int(rgb[2]))

def adjust_lightness(hex_color, factor):
    rgb = hex_to_rgb(hex_color)
    h, l, s = colorsys.rgb_to_hls(rgb[0]/255, rgb[1]/255, rgb[2]/255)
    l = max(0, min(1, l * factor))
    r, g, b = colorsys.hls_to_rgb(h, l, s)
    return rgb_to_hex((r*255, g*255, b*255))

def generate_palette(primary):
    colors = {
        'primary': primary,
        'primary-light': adjust_lightness(primary, 1.3),
        'primary-dark': adjust_lightness(primary, 0.7),
        'secondary': adjust_lightness(primary, 1.1),
        'accent': adjust_lightness(primary, 0.9),
        'background': '#191724',
        'surface': '#1f1d2e',
        'text': '#e0def4',
        'text-secondary': '#908caa'
    }
    
    for name, color in colors.items():
        print(f"{name}={color}")

generate_palette("$primary_color")
EOF
}

# Update Hyprland colors
update_hyprland_colors() {
    local colors_file="$HOME/.config/hypr/colors.conf"
    
    echo "# Auto-generated colors from wallpaper" > "$colors_file"
    echo "# Generated: $(date)" >> "$colors_file"
    echo "" >> "$colors_file"
    
    while IFS='=' read -r name color; do
        # Convert to Hyprland format
        case "$name" in
            primary)
                echo "\$primary = rgb(${color#\#})" >> "$colors_file"
                ;;
            primary-light)
                echo "\$primaryLight = rgb(${color#\#})" >> "$colors_file"
                ;;
            primary-dark)
                echo "\$primaryDark = rgb(${color#\#})" >> "$colors_file"
                ;;
            secondary)
                echo "\$secondary = rgb(${color#\#})" >> "$colors_file"
                ;;
            accent)
                echo "\$accent = rgb(${color#\#})" >> "$colors_file"
                ;;
            background)
                echo "\$background = rgb(${color#\#})" >> "$colors_file"
                ;;
            surface)
                echo "\$surface = rgb(${color#\#})" >> "$colors_file"
                ;;
            text)
                echo "\$text = rgb(${color#\#})" >> "$colors_file"
                ;;
        esac
    done
    
    echo "" >> "$colors_file"
    echo "# Window colors" >> "$colors_file"
    echo "general {" >> "$colors_file"
    echo "    col.active_border = \$primary \$accent 45deg" >> "$colors_file"
    echo "    col.inactive_border = \$surface" >> "$colors_file"
    echo "}" >> "$colors_file"
}

# Update Waybar colors
update_waybar_colors() {
    local waybar_css="$HOME/.config/waybar/style.css"
    local temp_file=$(mktemp)
    
    # Backup original
    cp "$waybar_css" "${waybar_css}.backup"
    
    # Update CSS variables
    sed -n '1,/\/\* Auto-generated colors \*\//p' "$waybar_css" > "$temp_file"
    
    echo "/* Auto-generated colors from wallpaper */" >> "$temp_file"
    echo "/* Generated: $(date) */" >> "$temp_file"
    
    while IFS='=' read -r name color; do
        echo "    --color-$name: $color;" >> "$temp_file"
    done
    
    # Append rest of file
    sed -n '/\/\* End auto-generated \*\//,$p' "$waybar_css" >> "$temp_file"
    
    mv "$temp_file" "$waybar_css"
}

# Update Rofi colors
update_rofi_colors() {
    local rofi_colors="$HOME/.config/rofi/colors.rasi"
    
    echo "/* Auto-generated colors from wallpaper */" > "$rofi_colors"
    echo "/* Generated: $(date) */" >> "$rofi_colors"
    echo "" >> "$rofi_colors"
    echo "* {" >> "$rofi_colors"
    
    while IFS='=' read -r name color; do
        echo "    $name: $color;" >> "$rofi_colors"
    done
    
    echo "}" >> "$rofi_colors"
}

# Update Kitty colors
update_kitty_colors() {
    local kitty_conf="$HOME/.config/kitty/colors.conf"
    
    echo "# Auto-generated colors from wallpaper" > "$kitty_conf"
    echo "# Generated: $(date)" >> "$kitty_conf"
    echo "" >> "$kitty_conf"
    
    while IFS='=' read -r name color; do
        case "$name" in
            background)
                echo "background $color" >> "$kitty_conf"
                ;;
            text)
                echo "foreground $color" >> "$kitty_conf"
                ;;
            primary)
                echo "cursor $color" >> "$kitty_conf"
                echo "selection_background $color" >> "$kitty_conf"
                ;;
        esac
    done
}

# Main function
main() {
    local wallpaper="$1"
    
    # Use current wallpaper if not specified
    if [[ -z "$wallpaper" ]]; then
        # Try to get current wallpaper from swww
        if command -v swww &> /dev/null; then
            wallpaper=$(swww query | grep -oP 'image: \K.*')
        else
            echo "No wallpaper specified and swww not found"
            echo "Usage: $0 <path-to-wallpaper>"
            exit 1
        fi
    fi
    
    if [[ ! -f "$wallpaper" ]]; then
        echo "Wallpaper not found: $wallpaper"
        exit 1
    fi
    
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║     Wallpaper Color Generation - Stellar Dots          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    check_dependencies
    
    echo "Step 1: Extracting dominant colors..."
    colors=($(extract_colors "$wallpaper" 6))
    
    echo "Found colors:"
    for i in "${!colors[@]}"; do
        echo "  $((i+1)). ${colors[$i]}"
    done
    echo ""
    
    # Use most dominant color as primary
    primary="${colors[0]}"
    echo "Step 2: Generating Material Design 3 palette..."
    echo "Primary color: $primary"
    echo ""
    
    # Generate full color scheme
    palette=$(generate_material_colors "$primary")
    
    echo "Generated palette:"
    echo "$palette" | while IFS='=' read -r name color; do
        echo "  $name: $color"
    done
    echo ""
    
    echo "Step 3: Updating configurations..."
    
    # Update all configs
    echo "$palette" | update_hyprland_colors
    echo "  ✓ Hyprland colors updated"
    
    echo "$palette" | update_waybar_colors
    echo "  ✓ Waybar colors updated"
    
    echo "$palette" | update_rofi_colors
    echo "  ✓ Rofi colors updated"
    
    echo "$palette" | update_kitty_colors
    echo "  ✓ Kitty colors updated"
    
    echo ""
    echo "Step 4: Reloading Hyprland..."
    hyprctl reload
    
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║              Color Generation Complete!                ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "Your theme has been updated to match your wallpaper!"
    echo "Colors saved to:"
    echo "  • ~/.config/hypr/colors.conf"
    echo "  • ~/.config/waybar/style.css"
    echo "  • ~/.config/rofi/colors.rasi"
    echo "  • ~/.config/kitty/colors.conf"
    echo ""
    echo "Tip: Run this script whenever you change wallpapers!"
}

# Run main function
main "$@"

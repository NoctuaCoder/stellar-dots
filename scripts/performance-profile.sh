#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                    ⚡ PERFORMANCE PROFILE SWITCHER ⚡                      ║
# ║                        Stellar Dots Gaming Utility                         ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

PROFILE_FILE="$HOME/.config/hypr/performance-profile"

# Get current profile
get_current_profile() {
    if [ -f "$PROFILE_FILE" ]; then
        cat "$PROFILE_FILE"
    else
        echo "balanced"
    fi
}

# Apply performance profile
apply_performance() {
    echo "performance" > "$PROFILE_FILE"
    
    # Set CPU governor
    if command -v cpupower &> /dev/null; then
        sudo cpupower frequency-set -g performance 2>/dev/null
    fi
    
    # Disable animations
    hyprctl keyword animations:enabled false
    
    # Disable blur
    hyprctl keyword decoration:blur:enabled false
    
    notify-send "Performance Profile" "Modo Performance ativado\nAnimações e efeitos desabilitados" -i cpu
}

# Apply balanced profile
apply_balanced() {
    echo "balanced" > "$PROFILE_FILE"
    
    # Set CPU governor
    if command -v cpupower &> /dev/null; then
        sudo cpupower frequency-set -g schedutil 2>/dev/null
    fi
    
    # Enable animations
    hyprctl keyword animations:enabled true
    
    # Enable blur
    hyprctl keyword decoration:blur:enabled true
    
    notify-send "Performance Profile" "Modo Balanceado ativado\nConfigurações padrão restauradas" -i preferences-system
}

# Apply power save profile
apply_powersave() {
    echo "powersave" > "$PROFILE_FILE"
    
    # Set CPU governor
    if command -v cpupower &> /dev/null; then
        sudo cpupower frequency-set -g powersave 2>/dev/null
    fi
    
    # Disable animations
    hyprctl keyword animations:enabled false
    
    # Disable blur
    hyprctl keyword decoration:blur:enabled false
    
    # Reduce brightness
    if command -v brightnessctl &> /dev/null; then
        brightnessctl set 50%
    fi
    
    notify-send "Performance Profile" "Modo Economia ativado\nEfeitos desabilitados, brilho reduzido" -i battery
}

# Show menu
current=$(get_current_profile)

menu="⚡ Performance (Máximo desempenho)
⚖️ Balanced (Padrão)
🔋 Power Save (Economia de energia)
──────────────
✓ Atual: $current"

chosen=$(echo -e "$menu" | rofi -dmenu -p "Performance Profile" -theme ~/.config/rofi/power-menu.rasi)

case "$chosen" in
    "⚡ Performance"*)
        apply_performance
        ;;
    "⚖️ Balanced"*)
        apply_balanced
        ;;
    "🔋 Power Save"*)
        apply_powersave
        ;;
esac

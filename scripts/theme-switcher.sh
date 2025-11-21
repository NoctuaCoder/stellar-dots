#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                       ✨ THEME SWITCHER SCRIPT ✨                          ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

THEMES_DIR="$HOME/.config/stellar-dots/themes"
HYPR_DIR="$HOME/.config/hypr"

# Theme previews
show_theme_preview() {
    clear
    echo -e "\n╔═══════════════════════════════════════════════════════════════╗"
    echo -e "║              ✨ STELLAR DOTS - THEME SWITCHER ✨              ║"
    echo -e "╚═══════════════════════════════════════════════════════════════╝\n"
    
    echo -e "Selecione um tema:\n"
    
    echo -e "1) Rosé Pine"
    echo -e "   ████ Suave e aconchegante"
    echo -e "   Cores: Rosa, Roxo, Azul\n"
    
    echo -e "2) Catppuccin Mocha"
    echo -e "   ████ Pastel moderno"
    echo -e "   Cores: Rosa, Azul, Verde\n"
    
    echo -e "3) Nord"
    echo -e "   ████ Ártico e gelado"
    echo -e "   Cores: Azul, Cinza\n"
}

# Apply theme
apply_theme() {
    local theme="$1"
    local theme_dir=""
    
    case "$theme" in
        1)
            theme_dir="rose-pine"
            theme_name="Rosé Pine"
            ;;
        2)
            theme_dir="catppuccin"
            theme_name="Catppuccin Mocha"
            ;;
        3)
            theme_dir="nord"
            theme_name="Nord"
            ;;
        *)
            echo "Opção inválida!"
            exit 1
            ;;
    esac
    
    # Copy theme colors
    cp "$THEMES_DIR/$theme_dir/colors.conf" "$HYPR_DIR/colors.conf"
    
    # Reload Hyprland
    hyprctl reload
    
    # Reload Waybar
    killall waybar
    waybar &
    
    echo -e "\n✓ Tema $theme_name aplicado com sucesso!"
    echo "Algumas mudanças podem requerer reiniciar aplicações."
    
    sleep 2
}

# Main
show_theme_preview

read -p "Escolha [1-3]: " choice
apply_theme "$choice"

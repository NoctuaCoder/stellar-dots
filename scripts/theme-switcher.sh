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
    
    echo -e "4) Tokyo Night"
    echo -e "   ████ Cyberpunk vibrante"
    echo -e "   Cores: Azul Neon, Roxo\n"
    
    echo -e "5) Dracula"
    echo -e "   ████ Escuro e misterioso"
    echo -e "   Cores: Roxo, Rosa, Cyan\n"
    
    echo -e "6) Gruvbox"
    echo -e "   ████ Retro e aconchegante"
    echo -e "   Cores: Laranja, Verde, Azul\n"
    
    echo -e "7) Everforest"
    echo -e "   ████ Floresta tranquila"
    echo -e "   Cores: Verde, Teal, Bege\n"
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
        4)
            theme_dir="tokyo-night"
            theme_name="Tokyo Night"
            ;;
        5)
            theme_dir="dracula"
            theme_name="Dracula"
            ;;
        6)
            theme_dir="gruvbox"
            theme_name="Gruvbox"
            ;;
        7)
            theme_dir="everforest"
            theme_name="Everforest"
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

read -p "Escolha [1-7]: " choice
apply_theme "$choice"

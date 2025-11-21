#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                       📦 UPDATE MANAGER 📦                                ║
# ║                      Stellar Dots System Utility                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Detect distro
if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

# Update system packages
update_system() {
    echo "🔄 Atualizando pacotes do sistema..."
    
    case "$DISTRO" in
        arch|manjaro|endeavouros)
            sudo pacman -Syu --noconfirm
            
            # Update AUR packages if helper is available
            if command -v paru &> /dev/null; then
                paru -Syu --noconfirm
            elif command -v yay &> /dev/null; then
                yay -Syu --noconfirm
            fi
            ;;
        fedora)
            sudo dnf upgrade -y
            ;;
        ubuntu|debian|pop)
            sudo apt update
            sudo apt upgrade -y
            sudo apt autoremove -y
            ;;
        *)
            echo "Distro não suportada para atualização automática"
            return 1
            ;;
    esac
    
    echo "✓ Sistema atualizado!"
}

# Update Flatpak
update_flatpak() {
    if command -v flatpak &> /dev/null; then
        echo "🔄 Atualizando Flatpak..."
        flatpak update -y
        echo "✓ Flatpak atualizado!"
    fi
}

# Update dotfiles
update_dotfiles() {
    echo "🔄 Atualizando dotfiles..."
    
    DOTFILES_DIR="$HOME/.config/stellar-dots"
    
    if [ -d "$DOTFILES_DIR/.git" ]; then
        cd "$DOTFILES_DIR"
        git pull origin main
        echo "✓ Dotfiles atualizados!"
    else
        echo "⚠ Dotfiles não são um repositório git"
    fi
}

# Cleanup
cleanup_system() {
    echo "🧹 Limpando sistema..."
    
    case "$DISTRO" in
        arch|manjaro|endeavouros)
            sudo pacman -Sc --noconfirm
            if command -v paru &> /dev/null; then
                paru -Sc --noconfirm
            fi
            ;;
        fedora)
            sudo dnf clean all
            ;;
        ubuntu|debian|pop)
            sudo apt autoremove -y
            sudo apt autoclean
            ;;
    esac
    
    # Clean cache
    rm -rf ~/.cache/thumbnails/*
    
    echo "✓ Sistema limpo!"
}

# Main menu
menu="📦 Atualizar Sistema
📱 Atualizar Flatpak
✨ Atualizar Dotfiles
🧹 Limpar Sistema
🔄 Fazer Tudo"

chosen=$(echo -e "$menu" | rofi -dmenu -p "Update Manager" -theme ~/.config/rofi/power-menu.rasi)

case "$chosen" in
    "📦 Atualizar Sistema")
        kitty -e bash -c "update_system; read -p 'Pressione Enter para fechar...'"
        ;;
    "📱 Atualizar Flatpak")
        kitty -e bash -c "update_flatpak; read -p 'Pressione Enter para fechar...'"
        ;;
    "✨ Atualizar Dotfiles")
        kitty -e bash -c "update_dotfiles; read -p 'Pressione Enter para fechar...'"
        ;;
    "🧹 Limpar Sistema")
        kitty -e bash -c "cleanup_system; read -p 'Pressione Enter para fechar...'"
        ;;
    "🔄 Fazer Tudo")
        kitty -e bash -c "
            update_system
            update_flatpak
            update_dotfiles
            cleanup_system
            echo ''
            echo '✓ Todas as atualizações concluídas!'
            read -p 'Pressione Enter para fechar...'
        "
        ;;
esac

#!/bin/bash

# Dependency installation script for different distros

DISTRO="$1"

install_arch() {
    echo "Instalando dependências para Arch Linux..."
    
    # Check if yay or paru is installed
    if command -v paru &> /dev/null; then
        AUR_HELPER="paru"
    elif command -v yay &> /dev/null; then
        AUR_HELPER="yay"
    else
        echo "Instalando paru (AUR helper)..."
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru
        makepkg -si --noconfirm
        cd -
        AUR_HELPER="paru"
    fi
    
    # Core packages
    sudo pacman -S --needed --noconfirm \
        hyprland \
        waybar \
        kitty \
        rofi-wayland \
        dunst \
        swww \
        hyprlock \
        hypridle \
        wlogout \
        grim \
        slurp \
        wl-clipboard \
        brightnessctl \
        playerctl \
        pavucontrol \
        network-manager-applet \
        bluez \
        bluez-utils \
        blueman \
        fastfetch \
        starship \
        lsd \
        zoxide \
        fzf \
        bat \
        ripgrep \
        fd \
        ttf-jetbrains-mono-nerd \
        ttf-nerd-fonts-symbols \
        noto-fonts-emoji \
        polkit-gnome \
        xdg-desktop-portal-hyprland \
        qt5-wayland \
        qt6-wayland
    
    # AUR packages
    $AUR_HELPER -S --needed --noconfirm \
        pywal16-git \
        wf-recorder \
        hyprpicker \
        nwg-look
    
    echo "✓ Dependências instaladas com sucesso!"
}

install_fedora() {
    echo "Instalando dependências para Fedora..."
    
    # Enable COPR repos
    sudo dnf copr enable -y solopasha/hyprland
    
    sudo dnf install -y \
        hyprland \
        waybar \
        kitty \
        rofi-wayland \
        dunst \
        grim \
        slurp \
        wl-clipboard \
        brightnessctl \
        playerctl \
        pavucontrol \
        NetworkManager-tui \
        bluez \
        blueman \
        fastfetch \
        starship \
        lsd \
        zoxide \
        fzf \
        bat \
        ripgrep \
        fd-find \
        jetbrains-mono-fonts-all \
        google-noto-emoji-fonts \
        polkit-gnome \
        xdg-desktop-portal-hyprland \
        qt5-qtwayland \
        qt6-qtwayland
    
    # Install pywal16 via pip
    pip install --user pywal16
    
    echo "✓ Dependências instaladas com sucesso!"
}

install_debian() {
    echo "Instalando dependências para Debian/Ubuntu..."
    
    sudo apt update
    sudo apt install -y \
        kitty \
        rofi \
        dunst \
        grim \
        slurp \
        wl-clipboard \
        brightnessctl \
        playerctl \
        pavucontrol \
        network-manager-gnome \
        bluez \
        blueman \
        fastfetch \
        starship \
        fzf \
        bat \
        ripgrep \
        fd-find \
        fonts-jetbrains-mono \
        fonts-noto-color-emoji \
        policykit-1-gnome \
        qt5-wayland \
        qt6-wayland \
        python3-pip
    
    # Install pywal16 via pip
    pip3 install --user pywal16
    
    echo "⚠ NOTA: Hyprland e Waybar precisam ser compilados manualmente no Debian/Ubuntu"
    echo "Visite: https://wiki.hyprland.org/Getting-Started/Installation/"
    
    echo "✓ Dependências básicas instaladas!"
}

case "$DISTRO" in
    arch)
        install_arch
        ;;
    fedora)
        install_fedora
        ;;
    debian)
        install_debian
        ;;
    *)
        echo "Distro não suportada: $DISTRO"
        exit 1
        ;;
esac

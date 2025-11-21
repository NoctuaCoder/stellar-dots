#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        ✨ STELLAR DOTS INSTALLER ✨                        ║
# ║                   Automated Dotfiles Installation System                  ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

set -e

# Colors
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# Banner
show_banner() {
    clear
    echo -e "${MAGENTA}${BOLD}"
    cat << "EOF"
    ███████╗████████╗███████╗██╗     ██╗      █████╗ ██████╗ 
    ██╔════╝╚══██╔══╝██╔════╝██║     ██║     ██╔══██╗██╔══██╗
    ███████╗   ██║   █████╗  ██║     ██║     ███████║██████╔╝
    ╚════██║   ██║   ██╔══╝  ██║     ██║     ██╔══██║██╔══██╗
    ███████║   ██║   ███████╗███████╗███████╗██║  ██║██║  ██║
    ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
    
    ██████╗  ██████╗ ████████╗███████╗
    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
    ██║  ██║██║   ██║   ██║   ███████╗
    ██║  ██║██║   ██║   ██║   ╚════██║
    ██████╔╝╚██████╔╝   ██║   ███████║
    ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
EOF
    echo -e "${RESET}"
    echo -e "${CYAN}    Automated Dotfiles Installation System${RESET}"
    echo -e "${BLUE}    Inspired by hyprstellar aesthetics${RESET}"
    echo ""
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

log_error() {
    echo -e "${RED}[✗]${RESET} $1"
}

# Check if running on supported system
check_system() {
    log_info "Verificando sistema..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "Sistema não suportado. Este instalador funciona apenas em Linux."
        exit 1
    fi
    
    source /etc/os-release
    
    case "$ID" in
        arch|manjaro|endeavouros)
            DISTRO="arch"
            PKG_MANAGER="pacman"
            ;;
        fedora)
            DISTRO="fedora"
            PKG_MANAGER="dnf"
            ;;
        ubuntu|debian|pop)
            DISTRO="debian"
            PKG_MANAGER="apt"
            ;;
        *)
            log_warning "Distribuição '$ID' pode não ser totalmente suportada."
            log_warning "Tentando continuar mesmo assim..."
            DISTRO="unknown"
            ;;
    esac
    
    log_success "Sistema detectado: $ID ($DISTRO)"
}

# Check dependencies
check_dependencies() {
    log_info "Verificando dependências do instalador..."
    
    local deps=("git" "curl")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Dependências faltando: ${missing[*]}"
        log_info "Por favor, instale-as antes de continuar."
        exit 1
    fi
    
    log_success "Todas as dependências do instalador estão presentes"
}

# Create backup
create_backup() {
    log_info "Criando backup dos configs existentes..."
    
    local configs_to_backup=(
        "hypr"
        "waybar"
        "kitty"
        "rofi"
        "dunst"
        "fastfetch"
        "starship.toml"
    )
    
    local backed_up=0
    
    for config in "${configs_to_backup[@]}"; do
        if [[ -e "$CONFIG_DIR/$config" ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -r "$CONFIG_DIR/$config" "$BACKUP_DIR/"
            backed_up=$((backed_up + 1))
        fi
    done
    
    if [[ $backed_up -gt 0 ]]; then
        log_success "Backup criado em: $BACKUP_DIR"
        log_info "Arquivos salvos: $backed_up"
    else
        log_info "Nenhum config existente encontrado, pulando backup"
    fi
}

# Install system dependencies
install_dependencies() {
    log_info "Instalando dependências do sistema..."
    
    case "$DISTRO" in
        arch)
            source "$SCRIPT_DIR/scripts/install-deps.sh" arch
            ;;
        fedora)
            source "$SCRIPT_DIR/scripts/install-deps.sh" fedora
            ;;
        debian)
            source "$SCRIPT_DIR/scripts/install-deps.sh" debian
            ;;
        *)
            log_warning "Instalação automática de dependências não disponível para esta distro"
            log_info "Por favor, instale manualmente: hyprland waybar kitty rofi dunst"
            read -p "Pressione Enter para continuar..."
            ;;
    esac
}

# Theme selection
select_theme() {
    echo ""
    echo -e "${BOLD}${MAGENTA}Selecione um tema:${RESET}"
    echo ""
    echo -e "${MAGENTA}1)${RESET} Rosé Pine ${BLUE}(Padrão - Inspirado no hyprstellar)${RESET}"
    echo -e "   ${CYAN}Cores suaves e aconchegantes com tons de rosa e roxo${RESET}"
    echo ""
    echo -e "${MAGENTA}2)${RESET} Catppuccin Mocha"
    echo -e "   ${CYAN}Paleta pastel moderna com tons de café e chocolate${RESET}"
    echo ""
    echo -e "${MAGENTA}3)${RESET} Nord"
    echo -e "   ${CYAN}Tema ártico com azuis e cinzas gelados${RESET}"
    echo ""
    
    while true; do
        read -p "$(echo -e ${YELLOW}Escolha [1-3]:${RESET} )" choice
        case $choice in
            1)
                SELECTED_THEME="rose-pine"
                break
                ;;
            2)
                SELECTED_THEME="catppuccin"
                break
                ;;
            3)
                SELECTED_THEME="nord"
                break
                ;;
            *)
                log_error "Opção inválida. Escolha 1, 2 ou 3."
                ;;
        esac
    done
    
    log_success "Tema selecionado: $SELECTED_THEME"
}

# Install dotfiles
install_dotfiles() {
    log_info "Instalando dotfiles..."
    
    # Copy config files
    cp -r "$SCRIPT_DIR/.config/"* "$CONFIG_DIR/"
    
    # Apply selected theme
    cp "$SCRIPT_DIR/themes/$SELECTED_THEME/colors.conf" "$CONFIG_DIR/hypr/colors.conf"
    
    # Copy scripts
    mkdir -p "$HOME/.local/bin"
    cp -r "$SCRIPT_DIR/scripts/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/"*.sh
    
    # Copy wallpapers
    mkdir -p "$HOME/Pictures/wallpapers"
    cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/Pictures/wallpapers/"
    
    log_success "Dotfiles instalados com sucesso!"
}

# Post-install setup
post_install() {
    log_info "Configuração pós-instalação..."
    
    # Add scripts to PATH if not already there
    if ! grep -q "$HOME/.local/bin" "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    
    if [[ -f "$HOME/.zshrc" ]] && ! grep -q "$HOME/.local/bin" "$HOME/.zshrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    
    log_success "Configuração concluída!"
}

# Show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}${BOLD}║                  ✨ INSTALAÇÃO CONCLUÍDA! ✨                  ║${RESET}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    log_success "Stellar Dots foi instalado com sucesso!"
    echo ""
    echo -e "${CYAN}Próximos passos:${RESET}"
    echo -e "  ${BLUE}1.${RESET} Faça logout e login novamente (ou reinicie)"
    echo -e "  ${BLUE}2.${RESET} Selecione Hyprland no seu display manager"
    echo -e "  ${BLUE}3.${RESET} Aproveite seu novo setup! 🚀"
    echo ""
    echo -e "${CYAN}Comandos úteis:${RESET}"
    echo -e "  ${BLUE}•${RESET} theme-switcher.sh - Trocar tema"
    echo -e "  ${BLUE}•${RESET} wallpaper-changer.sh - Trocar wallpaper"
    echo -e "  ${BLUE}•${RESET} Super + Q - Fechar janela"
    echo -e "  ${BLUE}•${RESET} Super + Return - Abrir terminal"
    echo -e "  ${BLUE}•${RESET} Super + D - Launcher"
    echo ""
    echo -e "${CYAN}Documentação completa:${RESET} ${BLUE}docs/INSTALACAO.md${RESET}"
    echo ""
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo -e "${YELLOW}Backup dos seus configs antigos:${RESET} $BACKUP_DIR"
        echo ""
    fi
}

# Main installation flow
main() {
    show_banner
    
    echo -e "${YELLOW}Este script irá:${RESET}"
    echo "  • Fazer backup dos seus configs atuais"
    echo "  • Instalar dependências necessárias"
    echo "  • Configurar Hyprland, Waybar, Kitty, Rofi e mais"
    echo "  • Aplicar o tema escolhido"
    echo ""
    
    read -p "$(echo -e ${GREEN}Deseja continuar? [S/n]:${RESET} )" confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        log_info "Instalação cancelada."
        exit 0
    fi
    
    echo ""
    
    check_system
    check_dependencies
    create_backup
    
    echo ""
    read -p "$(echo -e ${YELLOW}Deseja instalar as dependências do sistema? [S/n]:${RESET} )" install_deps
    if [[ ! "$install_deps" =~ ^[Nn] ]]; then
        install_dependencies
    fi
    
    echo ""
    select_theme
    
    echo ""
    install_dotfiles
    post_install
    
    echo ""
    show_completion
}

# Run main function
main "$@"

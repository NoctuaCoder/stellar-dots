#!/bin/bash
# Enhanced Installer Module for Stellar Dots
# Adds dry-run mode and progress indicators

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local task=$3
    local width=50
    
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%% - %s" "$percentage" "$task"
}

# Dry-run mode
DRY_RUN=false
if [[ "$1" == "--dry-run" ]] || [[ "$1" == "-n" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}[DRY-RUN MODE]${RESET} Nenhuma mudança será feita no sistema"
    echo ""
fi

# Execute command with dry-run support
execute_cmd() {
    local cmd="$1"
    local description="$2"
    
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${CYAN}[WOULD RUN]${RESET} $description"
        echo -e "${BLUE}  Command:${RESET} $cmd"
    else
        echo -e "${BLUE}[RUNNING]${RESET} $description"
        eval "$cmd"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}[✓]${RESET} $description - Concluído"
        else
            echo -e "${RED}[✗]${RESET} $description - Falhou"
            return 1
        fi
    fi
}

# Installation steps with progress tracking
TOTAL_STEPS=10
CURRENT_STEP=0

installation_steps() {
    # Step 1: System check
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Verificando sistema"
    echo ""
    execute_cmd "check_system" "Detectar distribuição Linux"
    
    # Step 2: Dependencies check
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Verificando dependências"
    echo ""
    execute_cmd "check_dependencies" "Verificar git e curl"
    
    # Step 3: Backup
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Criando backup"
    echo ""
    execute_cmd "create_backup" "Backup de configs existentes"
    
    # Step 4: Install system dependencies
    if [[ "$INSTALL_DEPS" != "no" ]]; then
        CURRENT_STEP=$((CURRENT_STEP + 1))
        show_progress $CURRENT_STEP $TOTAL_STEPS "Instalando dependências"
        echo ""
        execute_cmd "install_dependencies" "Instalar pacotes do sistema"
    fi
    
    # Step 5: Copy dotfiles
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Copiando dotfiles"
    echo ""
    execute_cmd "cp -r '$SCRIPT_DIR/.config/'* '$CONFIG_DIR/'" "Copiar arquivos de configuração"
    
    # Step 6: Apply theme
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Aplicando tema"
    echo ""
    execute_cmd "cp '$SCRIPT_DIR/themes/$SELECTED_THEME/colors.conf' '$CONFIG_DIR/hypr/colors.conf'" "Aplicar tema $SELECTED_THEME"
    
    # Step 7: Copy scripts
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Instalando scripts"
    echo ""
    execute_cmd "cp -r '$SCRIPT_DIR/scripts/'* '$HOME/.local/bin/'" "Copiar scripts utilitários"
    execute_cmd "chmod +x '$HOME/.local/bin/'*.sh" "Tornar scripts executáveis"
    
    # Step 8: Copy wallpapers
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Copiando wallpapers"
    echo ""
    execute_cmd "cp -r '$SCRIPT_DIR/wallpapers/'* '$HOME/Pictures/wallpapers/'" "Copiar wallpapers"
    
    # Step 9: Gaming setup
    if [[ "$SETUP_GAMING" == "yes" ]]; then
        CURRENT_STEP=$((CURRENT_STEP + 1))
        show_progress $CURRENT_STEP $TOTAL_STEPS "Configurando gaming"
        echo ""
        execute_cmd "install_gaming_setup" "Instalar ferramentas de gaming"
    fi
    
    # Step 10: Post-install
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS "Finalizando"
    echo ""
    execute_cmd "post_install" "Configuração pós-instalação"
    
    echo ""
    echo -e "${GREEN}[✓]${RESET} Instalação completa!"
}

# Rollback function
rollback_installation() {
    log_warning "Iniciando rollback..."
    
    if [[ -d "$BACKUP_DIR" ]]; then
        log_info "Restaurando configs do backup: $BACKUP_DIR"
        
        # Restore backed up configs
        for config in "$BACKUP_DIR"/*; do
            config_name=$(basename "$config")
            if [[ -e "$CONFIG_DIR/$config_name" ]]; then
                rm -rf "$CONFIG_DIR/$config_name"
            fi
            cp -r "$config" "$CONFIG_DIR/"
        done
        
        log_success "Rollback concluído. Configs restaurados."
    else
        log_warning "Nenhum backup encontrado para restaurar."
    fi
}

# Verification after install
verify_installation() {
    log_info "Verificando instalação..."
    
    local errors=0
    local warnings=0
    
    # Check if Hyprland config exists
    if [[ ! -f "$CONFIG_DIR/hypr/hyprland.conf" ]]; then
        log_error "Hyprland config não encontrado"
        errors=$((errors + 1))
    else
        log_success "Hyprland config OK"
    fi
    
    # Check if selected bar is installed
    if [[ "$SELECTED_BAR" == "waybar" ]]; then
        if [[ ! -f "$CONFIG_DIR/waybar/config.jsonc" ]]; then
            log_error "Waybar config não encontrado"
            errors=$((errors + 1))
        else
            log_success "Waybar config OK"
        fi
    fi
    
    # Check scripts
    if [[ ! -d "$HOME/.local/bin" ]] || [[ -z "$(ls -A $HOME/.local/bin/*.sh 2>/dev/null)" ]]; then
        log_warning "Scripts não encontrados em ~/.local/bin"
        warnings=$((warnings + 1))
    else
        local script_count=$(ls -1 "$HOME/.local/bin"/*.sh 2>/dev/null | wc -l)
        log_success "Scripts OK ($script_count encontrados)"
    fi
    
    # Check wallpapers
    if [[ ! -d "$HOME/Pictures/wallpapers" ]] || [[ -z "$(ls -A $HOME/Pictures/wallpapers 2>/dev/null)" ]]; then
        log_warning "Wallpapers não encontrados"
        warnings=$((warnings + 1))
    else
        log_success "Wallpapers OK"
    fi
    
    echo ""
    if [[ $errors -eq 0 ]]; then
        log_success "Verificação completa! Nenhum erro encontrado."
        if [[ $warnings -gt 0 ]]; then
            log_warning "$warnings avisos encontrados (não críticos)"
        fi
        return 0
    else
        log_error "Verificação falhou com $errors erros"
        return 1
    fi
}

# Export functions for use in main installer
export -f show_progress
export -f execute_cmd
export -f installation_steps
export -f rollback_installation
export -f verify_installation

#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                       💾 BACKUP MANAGER 💾                                ║
# ║                      Stellar Dots System Utility                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

BACKUP_DIR="$HOME/Backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Create backup
create_backup() {
    echo "💾 Criando backup..."
    
    mkdir -p "$BACKUP_DIR"
    
    BACKUP_FILE="$BACKUP_DIR/stellar-dots-backup-$TIMESTAMP.tar.gz"
    
    # Backup configs
    tar -czf "$BACKUP_FILE" \
        -C "$HOME" \
        .config/hypr \
        .config/waybar \
        .config/kitty \
        .config/rofi \
        .config/dunst \
        .config/starship.toml \
        .local/bin \
        2>/dev/null
    
    if [ $? -eq 0 ]; then
        size=$(du -h "$BACKUP_FILE" | cut -f1)
        notify-send "Backup Manager" "Backup criado com sucesso!\nTamanho: $size\nLocal: $BACKUP_FILE" -i document-save
        echo "✓ Backup salvo em: $BACKUP_FILE"
    else
        notify-send "Backup Manager" "Erro ao criar backup!" -u critical -i dialog-error
        echo "✗ Erro ao criar backup"
    fi
}

# List backups
list_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Nenhum backup encontrado"
        return
    fi
    
    backups=$(ls -1t "$BACKUP_DIR"/stellar-dots-backup-*.tar.gz 2>/dev/null)
    
    if [ -z "$backups" ]; then
        echo "Nenhum backup encontrado"
        return
    fi
    
    echo "Backups disponíveis:"
    echo ""
    
    while IFS= read -r backup; do
        filename=$(basename "$backup")
        size=$(du -h "$backup" | cut -f1)
        date=$(echo "$filename" | sed 's/stellar-dots-backup-\(.*\)\.tar\.gz/\1/')
        echo "📦 $date ($size)"
    done <<< "$backups"
}

# Restore backup
restore_backup() {
    backups=$(ls -1t "$BACKUP_DIR"/stellar-dots-backup-*.tar.gz 2>/dev/null)
    
    if [ -z "$backups" ]; then
        notify-send "Backup Manager" "Nenhum backup encontrado!" -u critical -i dialog-error
        return
    fi
    
    # Build menu
    menu=""
    while IFS= read -r backup; do
        filename=$(basename "$backup")
        date=$(echo "$filename" | sed 's/stellar-dots-backup-\(.*\)\.tar\.gz/\1/')
        size=$(du -h "$backup" | cut -f1)
        menu+="$date ($size)\n"
    done <<< "$backups"
    
    chosen=$(echo -e "$menu" | rofi -dmenu -p "Selecione backup para restaurar" -theme ~/.config/rofi/power-menu.rasi)
    
    if [ -n "$chosen" ]; then
        date=$(echo "$chosen" | cut -d'(' -f1 | xargs)
        backup_file="$BACKUP_DIR/stellar-dots-backup-$date.tar.gz"
        
        # Confirm
        confirm=$(echo -e "Sim\nNão" | rofi -dmenu -p "Restaurar backup de $date?" -theme ~/.config/rofi/power-menu.rasi)
        
        if [ "$confirm" = "Sim" ]; then
            tar -xzf "$backup_file" -C "$HOME"
            notify-send "Backup Manager" "Backup restaurado com sucesso!\nReinicie o Hyprland para aplicar." -i document-revert
        fi
    fi
}

# Delete old backups
cleanup_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        return
    fi
    
    # Keep only last 5 backups
    backups=$(ls -1t "$BACKUP_DIR"/stellar-dots-backup-*.tar.gz 2>/dev/null)
    count=$(echo "$backups" | wc -l)
    
    if [ "$count" -gt 5 ]; then
        echo "$backups" | tail -n +6 | while read -r backup; do
            rm "$backup"
            echo "Removido: $(basename $backup)"
        done
        
        notify-send "Backup Manager" "Backups antigos removidos\nMantidos os 5 mais recentes" -i user-trash
    else
        notify-send "Backup Manager" "Nenhum backup para remover" -i dialog-information
    fi
}

# Main menu
menu="💾 Criar Backup
📋 Listar Backups
♻️ Restaurar Backup
🗑️ Limpar Backups Antigos"

chosen=$(echo -e "$menu" | rofi -dmenu -p "Backup Manager" -theme ~/.config/rofi/power-menu.rasi)

case "$chosen" in
    "💾 Criar Backup")
        kitty -e bash -c "$(declare -f create_backup); create_backup; read -p 'Pressione Enter para fechar...'"
        ;;
    "📋 Listar Backups")
        kitty -e bash -c "$(declare -f list_backups); list_backups; read -p 'Pressione Enter para fechar...'"
        ;;
    "♻️ Restaurar Backup")
        restore_backup
        ;;
    "🗑️ Limpar Backups Antigos")
        kitty -e bash -c "$(declare -f cleanup_backups); cleanup_backups; read -p 'Pressione Enter para fechar...'"
        ;;
esac

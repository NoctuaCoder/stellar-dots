#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════════════════
#                    GLASSMORPHISM APP MENU LAUNCHER
#                         Multiple Style Options
# ═══════════════════════════════════════════════════════════════════════════

# Configuration
ROFI_CONFIG_DIR="$HOME/.config/rofi"

# Default to sidebar menu
STYLE="${1:-sidebar}"

# Show help
show_help() {
    echo "Glassmorphism App Menu Launcher"
    echo ""
    echo "Usage: $(basename "$0") [STYLE]"
    echo ""
    echo "Available styles:"
    echo "  sidebar   - Compact vertical sidebar (default)"
    echo "  full      - Full menu with search bar"
    echo "  ultimate  - Icon-only sidebar (YouTube style)"
    echo "  youtube   - Full YouTube-style menu with controls"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") sidebar"
    echo "  $(basename "$0") youtube"
    echo "  $(basename "$0") --help"
}

# Parse arguments and launch
case "$STYLE" in
    -h|--help)
        show_help
        exit 0
        ;;
    sidebar)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-sidebar.rasi"
        ;;
    full)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-full.rasi"
        ;;
    ultimate)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-ultimate.rasi"
        ;;
    youtube)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-youtube.rasi"
        ;;
    *)
        echo "Error: Unknown style '$STYLE'"
        echo ""
        show_help
        exit 1
        ;;
esac

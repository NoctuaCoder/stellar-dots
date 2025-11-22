#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════════════════
#                    GLASSMORPHISM APP MENU LAUNCHER
#                         7 Different Styles Available
# ═══════════════════════════════════════════════════════════════════════════

# Configuration
ROFI_CONFIG_DIR="$HOME/.config/rofi"

# Default to sidebar menu
STYLE="${1:-sidebar}"

# Show help
show_help() {
    cat << EOF
✨ Glassmorphism App Menu Launcher

Usage: $(basename "$0") [STYLE]

Available styles:
  sidebar   - Compact vertical sidebar (default)
  full      - Full menu with search bar
  ultimate  - Icon-only vertical sidebar (YouTube style)
  youtube   - Full YouTube-style menu with controls
  dock      - Horizontal bottom dock (macOS style)
  control   - Control center with widgets (iOS style)
  spotify   - Music player layout (Spotify style)

Examples:
  $(basename "$0") sidebar   # Vertical sidebar
  $(basename "$0") dock      # Horizontal dock
  $(basename "$0") spotify   # Spotify-style layout
  $(basename "$0") --help    # Show this help

Keyboard shortcuts (in Hyprland):
  Super + Space  - Full menu
  Super + A      - Sidebar menu
  Super + D      - Dock menu (add to hyprland.conf)

EOF
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
    dock)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-dock.rasi"
        ;;
    control)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-control.rasi"
        ;;
    spotify)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-spotify.rasi"
        ;;
    *)
        echo "❌ Error: Unknown style '$STYLE'"
        echo ""
        show_help
        exit 1
        ;;
esac

#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════════════════
#                    GLASSMORPHISM APP MENU LAUNCHER
#                         10 Different Styles Available!
# ═══════════════════════════════════════════════════════════════════════════

# Configuration
ROFI_CONFIG_DIR="$HOME/.config/rofi"

# Default to sidebar menu
STYLE="${1:-sidebar}"

# Show help
show_help() {
    cat << EOF
✨ Glassmorphism App Menu Launcher - 10 Styles!

Usage: $(basename "$0") [STYLE]

📱 Vertical Layouts:
  sidebar   - Compact vertical sidebar (default)
  ultimate  - Icon-only vertical sidebar (YouTube style)

🔍 Full Screen:
  full      - Full menu with search bar
  youtube   - YouTube-style menu with window controls

🚀 Horizontal:
  dock      - Bottom horizontal dock (macOS style)

🎛️ Widget Styles:
  control   - iOS/Android control center
  cards     - Card-based widget grid
  dashboard - Smart home dashboard layout
  widgets   - 3-column widget center (NEW!)

🎵 Complex Layouts:
  spotify   - Music player with sidebar + grid

Examples:
  $(basename "$0") sidebar    # Vertical sidebar
  $(basename "$0") dock       # Horizontal dock
  $(basename "$0") widgets    # Full widget center
  $(basename "$0") --help     # Show this help

Keyboard shortcuts (add to hyprland.conf):
  Super + Space     - Full menu
  Super + A         - Sidebar
  Super + D         - Dock
  Super + W         - Widgets (NEW!)

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
    dashboard)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-dashboard.rasi"
        ;;
    cards)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-cards.rasi"
        ;;
    widgets)
        rofi -show drun -theme "$ROFI_CONFIG_DIR/glassmorphism-widgets.rasi"
        ;;
    *)
        echo "❌ Error: Unknown style '$STYLE'"
        echo ""
        show_help
        exit 1
        ;;
esac

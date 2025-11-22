#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════════════════
#                    ✅ STELLAR DOTS - VERIFICATION SCRIPT
#                         Post-Installation Checker
# ═══════════════════════════════════════════════════════════════════════════

set -e

# Colors
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Logging
log_pass() {
    echo -e "${GREEN}[✓]${RESET} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[✗]${RESET} $1"
    ((FAILED++))
}

log_warn() {
    echo -e "${YELLOW}[!]${RESET} $1"
    ((WARNINGS++))
}

log_info() {
    echo -e "${BLUE}[i]${RESET} $1"
}

# Banner
echo -e "${MAGENTA}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║          ✅ STELLAR DOTS - VERIFICATION SCRIPT           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo ""

# 1. Check Hyprland
echo -e "${BOLD}${BLUE}1. Checking Hyprland...${RESET}"
if command -v Hyprland &> /dev/null; then
    VERSION=$(Hyprland --version 2>&1 | head -n1 || echo "unknown")
    log_pass "Hyprland installed: $VERSION"
else
    log_fail "Hyprland not found"
fi

# 2. Check Configuration Files
echo ""
echo -e "${BOLD}${BLUE}2. Checking Configuration Files...${RESET}"

CONFIG_FILES=(
    "$HOME/.config/hypr/hyprland.conf"
    "$HOME/.config/hypr/colors.conf"
    "$HOME/.config/waybar/config.jsonc"
    "$HOME/.config/waybar/style.css"
    "$HOME/.config/kitty/kitty.conf"
    "$HOME/.config/rofi/launcher.rasi"
    "$HOME/.config/dunst/dunstrc"
)

for file in "${CONFIG_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        log_pass "Found: $(basename "$file")"
    else
        log_warn "Missing: $file"
    fi
done

# 3. Check Scripts
echo ""
echo -e "${BOLD}${BLUE}3. Checking Scripts...${RESET}"

SCRIPTS=(
    "$HOME/.local/bin/app-menu.sh"
    "$HOME/.local/bin/theme-switcher.sh"
    "$HOME/.local/bin/wallpaper-changer.sh"
    "$HOME/.local/bin/screenshot.sh"
    "$HOME/.local/bin/power-menu.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [[ -f "$script" ]] && [[ -x "$script" ]]; then
        log_pass "Executable: $(basename "$script")"
    elif [[ -f "$script" ]]; then
        log_warn "Not executable: $(basename "$script")"
        chmod +x "$script" 2>/dev/null && log_info "  → Fixed permissions"
    else
        log_warn "Missing: $(basename "$script")"
    fi
done

# 4. Check Dependencies
echo ""
echo -e "${BOLD}${BLUE}4. Checking Dependencies...${RESET}"

DEPS=(
    "waybar"
    "kitty"
    "rofi"
    "dunst"
    "swww"
    "hyprlock"
    "hypridle"
)

for dep in "${DEPS[@]}"; do
    if command -v "$dep" &> /dev/null; then
        log_pass "$dep installed"
    else
        log_fail "$dep not found"
    fi
done

# 5. Check Fonts
echo ""
echo -e "${BOLD}${BLUE}5. Checking Fonts...${RESET}"

if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    log_pass "JetBrainsMono Nerd Font installed"
else
    log_warn "JetBrainsMono Nerd Font not found"
fi

if fc-list | grep -qi "Noto.*Emoji"; then
    log_pass "Noto Emoji installed"
else
    log_warn "Noto Emoji not found"
fi

# 6. Check Theme
echo ""
echo -e "${BOLD}${BLUE}6. Checking Theme...${RESET}"

if [[ -f "$HOME/.config/hypr/colors.conf" ]]; then
    THEME=$(grep -m1 "# Theme:" "$HOME/.config/hypr/colors.conf" 2>/dev/null | cut -d: -f2 | xargs || echo "unknown")
    log_pass "Theme configured: $THEME"
else
    log_warn "Theme file not found"
fi

# 7. Check Wallpapers
echo ""
echo -e "${BOLD}${BLUE}7. Checking Wallpapers...${RESET}"

if [[ -d "$HOME/Pictures/wallpapers" ]]; then
    COUNT=$(find "$HOME/Pictures/wallpapers" -type f \( -name "*.png" -o -name "*.jpg" \) 2>/dev/null | wc -l)
    if [[ $COUNT -gt 0 ]]; then
        log_pass "Wallpapers found: $COUNT"
    else
        log_warn "No wallpapers in ~/Pictures/wallpapers"
    fi
else
    log_warn "Wallpapers directory not found"
fi

# 8. Check PATH
echo ""
echo -e "${BOLD}${BLUE}8. Checking PATH...${RESET}"

if echo "$PATH" | grep -q "$HOME/.local/bin"; then
    log_pass "~/.local/bin in PATH"
else
    log_warn "~/.local/bin not in PATH"
    log_info "  → Add to ~/.bashrc or ~/.zshrc:"
    log_info "     export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# 9. Check Backup
echo ""
echo -e "${BOLD}${BLUE}9. Checking Backup...${RESET}"

BACKUPS=$(find "$HOME" -maxdepth 1 -type d -name ".config-backup-*" 2>/dev/null | wc -l)
if [[ $BACKUPS -gt 0 ]]; then
    LATEST=$(find "$HOME" -maxdepth 1 -type d -name ".config-backup-*" 2>/dev/null | sort -r | head -n1)
    log_pass "Backup found: $(basename "$LATEST")"
else
    log_info "No backup found (fresh install)"
fi

# 10. Performance Check
echo ""
echo -e "${BOLD}${BLUE}10. Performance Check...${RESET}"

if command -v hyprctl &> /dev/null; then
    if pgrep -x Hyprland > /dev/null; then
        log_pass "Hyprland is running"
        
        # Check FPS
        if command -v hyprctl &> /dev/null; then
            log_info "Run 'hyprctl monitors' to check refresh rate"
        fi
    else
        log_info "Hyprland not currently running (normal if not logged in)"
    fi
fi

# Summary
echo ""
echo -e "${BOLD}${MAGENTA}═══════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${MAGENTA}                      SUMMARY${RESET}"
echo -e "${BOLD}${MAGENTA}═══════════════════════════════════════════════════════════${RESET}"
echo ""
echo -e "${GREEN}Passed:   ${BOLD}$PASSED${RESET}"
echo -e "${YELLOW}Warnings: ${BOLD}$WARNINGS${RESET}"
echo -e "${RED}Failed:   ${BOLD}$FAILED${RESET}"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}✓ Installation looks good!${RESET}"
    echo ""
    echo -e "${CYAN}Next steps:${RESET}"
    echo -e "  1. Logout and login to Hyprland"
    echo -e "  2. Test with: ${BLUE}Super + Return${RESET} (terminal)"
    echo -e "  3. Test with: ${BLUE}Super + Space${RESET} (glassmorphism menu)"
    exit 0
else
    echo -e "${RED}${BOLD}✗ Some issues found${RESET}"
    echo ""
    echo -e "${YELLOW}Suggestions:${RESET}"
    echo -e "  • Check docs/TROUBLESHOOTING.md"
    echo -e "  • Re-run install.sh if needed"
    echo -e "  • Open an issue: https://github.com/alanascanferla/stellar-dots/issues"
    exit 1
fi

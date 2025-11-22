# 🔒 Security & Safety - Stellar Dots

## What This Installer Does

### Files Modified
- `~/.config/hypr/` - Hyprland configuration
- `~/.config/waybar/` - Waybar configuration  
- `~/.config/kitty/` - Kitty terminal configuration
- `~/.config/rofi/` - Rofi launcher themes
- `~/.config/dunst/` - Notification daemon config
- `~/.local/bin/` - Utility scripts
- `~/Pictures/wallpapers/` - Wallpaper collection

### System Changes
- **Package Installation**: Only if you confirm (uses your distro's package manager)
- **No Root Access**: Scripts run as your user, no `sudo` in main installer
- **Automatic Backup**: Creates `~/.config-backup-TIMESTAMP` before any changes
- **PATH Addition**: Adds `~/.local/bin` to your shell RC file

### External Scripts
- `scripts/install-deps.sh` - Installs system packages (requires sudo)
- `scripts/detect-gpu.sh` - Detects GPU vendor (read-only)
- `scripts/install-gaming.sh` - Installs gaming tools (requires sudo)
- `https://ii.clsty.link/get` - illogical-impulse installer (if selected)

## Safety Features

### 1. Automatic Backup
Before any changes, the installer creates a timestamped backup:
```bash
~/.config-backup-20250122-020000/
```

### 2. Confirmation Prompts
The installer asks before:
- Installing system dependencies
- Selecting bar (Waybar vs illogical-impulse)
- Installing gaming setup
- Running external scripts

### 3. No Destructive sudo
The main `install.sh` does NOT use `sudo`. Only dependency installation scripts use it, and only after confirmation.

### 4. Rollback Instructions
If something goes wrong:
```bash
# Remove new configs
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/rofi

# Restore backup
mv ~/.config-backup-TIMESTAMP/* ~/.config/

# Or restore specific configs
cp -r ~/.config-backup-TIMESTAMP/hypr ~/.config/
```

## Verification

### Post-Install Check
After installation, run:
```bash
./scripts/verify-installation.sh
```

This checks:
- ✓ Hyprland installed
- ✓ All config files present
- ✓ Scripts executable
- ✓ Dependencies installed
- ✓ Fonts available
- ✓ Theme configured
- ✓ Wallpapers copied
- ✓ PATH configured
- ✓ Backup created

### Manual Verification
```bash
# Check Hyprland
Hyprland --version

# Check configs
ls -la ~/.config/hypr/
ls -la ~/.config/waybar/

# Check scripts
ls -la ~/.local/bin/*.sh

# Test script
~/.local/bin/theme-switcher.sh --help
```

## Dry Run Mode

To see what would be installed WITHOUT making changes:

```bash
# View the installer code
less install.sh

# Check what packages would be installed
cat scripts/install-deps.sh

# See what configs would be copied
ls -R .config/
```

> **Note**: Full dry-run mode coming in next update!

## Audit Mode

### What Gets Installed (Arch)
```bash
# Essential
hyprland waybar kitty rofi dunst swww hyprlock hypridle

# Utilities
grim slurp wl-clipboard brightnessctl playerctl pavucontrol

# Fonts
ttf-jetbrains-mono-nerd noto-fonts-emoji

# Gaming (optional)
steam lutris wine-staging gamemode mangohud
```

### What Gets Installed (Fedora)
```bash
# Essential
hyprland waybar kitty rofi dunst

# Utilities
grim slurp wl-clipboard brightnessctl playerctl pavucontrol

# Gaming (optional)
steam lutris wine gamemode mangohud
```

### What Gets Installed (Debian/Ubuntu)
```bash
# Essential
kitty rofi dunst

# Note: Hyprland and Waybar need manual installation or PPA
# See: docs/TROUBLESHOOTING.md

# Utilities
grim slurp wl-clipboard brightnessctl playerctl pavucontrol

# Gaming (optional)
steam lutris wine gamemode mangohud
```

## Risk Assessment

### Low Risk ✅
- **Arch/Manjaro/EndeavourOS**: All packages in official repos
- **Fresh Install**: No existing configs to conflict
- **Waybar Option**: Simpler, more stable

### Medium Risk ⚠️
- **Fedora**: Most packages available, some need RPM Fusion
- **Existing Configs**: Backup is automatic but test restore
- **illogical-impulse**: External installer, more dependencies

### Higher Risk 🔴
- **Debian/Ubuntu**: Hyprland not in official repos
- **Hybrid GPU**: Driver detection may need manual tweaking
- **Custom Kernel**: May need additional configuration

## Best Practices

### Before Installing

1. **Read the Code**
   ```bash
   cat install.sh
   cat scripts/install-deps.sh
   ```

2. **Manual Backup**
   ```bash
   tar czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz ~/.config
   ```

3. **Check Distro**
   ```bash
   cat /etc/os-release
   ```

4. **Free Space**
   ```bash
   df -h ~
   # Need at least 2GB free
   ```

### During Installation

1. **Read Prompts**: Don't blindly press Enter
2. **Choose Wisely**: Waybar is safer than illogical-impulse
3. **Skip Gaming**: If you don't game, skip it
4. **Watch Output**: Look for errors

### After Installation

1. **Verify**
   ```bash
   ./scripts/verify-installation.sh
   ```

2. **Test Gradually**
   - Login to Hyprland
   - Test terminal (Super + Return)
   - Test launcher (Super + Space)
   - Test scripts one by one

3. **Keep Backup**
   - Don't delete backup for at least a week
   - Test everything before removing

## Troubleshooting

If something breaks:

1. **Check Logs**
   ```bash
   journalctl -xe
   cat /tmp/hypr/*/hyprland.log
   ```

2. **Restore Backup**
   ```bash
   mv ~/.config-backup-TIMESTAMP/* ~/.config/
   ```

3. **Reinstall**
   ```bash
   ./install.sh
   ```

4. **Get Help**
   - Read: `docs/TROUBLESHOOTING.md`
   - Issue: https://github.com/alanascanferla/stellar-dots/issues

## Security Considerations

### What We DON'T Do
- ❌ Modify system files outside your home
- ❌ Run as root
- ❌ Download executables without confirmation
- ❌ Send data anywhere
- ❌ Modify bootloader or kernel

### What We DO
- ✅ Create backups automatically
- ✅ Ask before installing packages
- ✅ Use official package managers
- ✅ Keep everything in your home directory
- ✅ Provide rollback instructions

## Trust but Verify

This is open source. You can (and should):
- Read every line of code
- Check what packages are installed
- Verify checksums (coming soon)
- Report security issues

**Security Issue?** Email: security@stellar-dots.dev (coming soon)  
**Or open issue**: https://github.com/alanascanferla/stellar-dots/issues

---

<div align="center">

**Your safety is our priority** 🔒

Made with care and transparency 💜

</div>

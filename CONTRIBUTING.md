# Contributing to Stellar Dots ✨

First off, thank you for considering contributing to Stellar Dots! 🎉 It's people like you that make Stellar Dots such a great tool.

## 🌟 Ways to Contribute

### 🐛 Reporting Bugs
- Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md)
- Include your system information (OS, GPU, Hyprland version)
- Provide clear steps to reproduce
- Include error logs if applicable

### ✨ Suggesting Features
- Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md)
- Explain the problem it solves
- Describe your proposed solution
- Consider alternatives

### 🎨 Submitting Themes
- Use the [Theme Submission template](.github/ISSUE_TEMPLATE/theme_submission.md)
- Follow the theme structure in `themes/`
- Include screenshots
- Test on multiple setups

### 📝 Improving Documentation
- Fix typos and grammar
- Add examples and tutorials
- Translate to other languages
- Clarify confusing sections

### 💻 Contributing Code
- Fix bugs
- Implement features
- Optimize performance
- Add new scripts

## 🚀 Getting Started

### 1. Fork the Repository
Click the "Fork" button at the top right of the repository page.

### 2. Clone Your Fork
```bash
git clone https://github.com/YOUR-USERNAME/stellar-dots.git
cd stellar-dots
```

### 3. Create a Branch
```bash
git checkout -b feature/amazing-feature
# or
git checkout -b fix/bug-description
# or
git checkout -b docs/improvement
```

### 4. Make Your Changes
- Follow the existing code style
- Test your changes thoroughly
- Update documentation if needed

### 5. Commit Your Changes
Use descriptive commit messages following this format:
```bash
git commit -m "✨ Add amazing feature"
git commit -m "🐛 Fix bug in wallpaper script"
git commit -m "📝 Update installation docs"
git commit -m "🎨 Add new Tokyo Night theme"
```

**Commit Emoji Guide:**
- ✨ `:sparkles:` - New feature
- 🐛 `:bug:` - Bug fix
- 📝 `:memo:` - Documentation
- 🎨 `:art:` - Theme/styling
- ⚡ `:zap:` - Performance
- 🔧 `:wrench:` - Configuration
- 🚀 `:rocket:` - Deployment
- ♻️ `:recycle:` - Refactoring

### 6. Push to Your Fork
```bash
git push origin feature/amazing-feature
```

### 7. Open a Pull Request
- Go to the original repository
- Click "New Pull Request"
- Select your fork and branch
- Fill out the PR template
- Wait for review!

## 📋 Pull Request Guidelines

### Before Submitting
- [ ] Code follows the project style
- [ ] Self-reviewed your code
- [ ] Added comments for complex logic
- [ ] Updated documentation
- [ ] Tested on at least one distro
- [ ] No new warnings or errors

### PR Title Format
- `✨ Add: Description` - New features
- `🐛 Fix: Description` - Bug fixes
- `📝 Docs: Description` - Documentation
- `🎨 Theme: Description` - Themes
- `⚡ Perf: Description` - Performance

### PR Description
- Explain what and why
- Link related issues
- Include screenshots for visual changes
- List testing done

## 🎨 Theme Contribution Guidelines

### Theme Structure
```
themes/your-theme-name/
├── theme.conf           # Main theme configuration
├── waybar/
│   └── style.css       # Waybar styling
├── rofi/
│   └── theme.rasi      # Rofi theme
├── hyprlock/
│   └── hyprlock.conf   # Lock screen theme
└── README.md           # Theme documentation
```

### Theme Requirements
1. **Color Palette** - Define all colors clearly
2. **Screenshots** - Show desktop, menus, and lock screen
3. **Documentation** - Installation and customization guide
4. **Testing** - Test with all menu styles
5. **Compatibility** - Works with Waybar and illogical-impulse

### Color Variables
Your `theme.conf` should define:
```conf
# Background colors
$bg_primary=#XXXXXX
$bg_secondary=#XXXXXX

# Foreground colors
$fg_primary=#XXXXXX
$fg_secondary=#XXXXXX

# Accent colors
$accent_1=#XXXXXX
$accent_2=#XXXXXX
$accent_3=#XXXXXX

# Special colors
$urgent=#XXXXXX
$warning=#XXXXXX
$success=#XXXXXX
```

## 🧪 Testing Guidelines

### Test Your Changes
1. **Fresh Install** - Test on clean system
2. **Multiple Distros** - If possible, test on Arch, Fedora, Debian
3. **Different GPUs** - NVIDIA, AMD, Intel
4. **All Features** - Test affected features thoroughly

### Report Test Results
Include in your PR:
- Distro and version
- GPU type
- Hyprland version
- What you tested
- Any issues found

## 📝 Code Style

### Shell Scripts
- Use `#!/usr/bin/env bash`
- Add comments for complex logic
- Use meaningful variable names
- Handle errors gracefully
- Follow existing formatting

### Example:
```bash
#!/usr/bin/env bash

# Description of what this script does
# Usage: script-name.sh [options]

set -e  # Exit on error

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="$HOME/.config"

# Functions
show_error() {
    echo "Error: $1" >&2
    exit 1
}

# Main logic
main() {
    # Your code here
}

main "$@"
```

## 🌍 Translation Guidelines

### Adding a New Language
1. Copy `README.md` to `README.xx-XX.md` (e.g., `README.es-ES.md`)
2. Translate all content
3. Keep formatting and links
4. Update language selector in main README
5. Test all links

### Translation Checklist
- [ ] All text translated
- [ ] Code blocks unchanged
- [ ] Links working
- [ ] Formatting preserved
- [ ] Native speaker reviewed

## 🤝 Community Guidelines

### Be Respectful
- Be kind and welcoming
- Respect different viewpoints
- Accept constructive criticism
- Focus on what's best for the community

### Be Helpful
- Help others in issues and discussions
- Share your knowledge
- Provide constructive feedback
- Encourage new contributors

### Be Professional
- Use clear, professional language
- Stay on topic
- Avoid spam and self-promotion
- Follow the Code of Conduct

## 🎯 Priority Areas

We especially need help with:

### High Priority
- 🐛 Bug fixes for reported issues
- 📸 Screenshots and GIFs
- 🧪 Testing on different distros
- 🌍 Translations (Spanish, French)

### Medium Priority
- ✨ New utility scripts
- 🎨 Community themes
- 📝 Documentation improvements
- 🎬 Video tutorials

### Nice to Have
- ⚡ Performance optimizations
- 🔧 Advanced features
- 🎮 Gaming improvements
- 📊 Analytics and monitoring

## 📞 Getting Help

### Questions?
- 💬 [Start a Discussion](https://github.com/NoctuaCoder/stellar-dots/discussions)
- 📖 Check the [Documentation](docs/)
- 🐛 [Open an Issue](https://github.com/NoctuaCoder/stellar-dots/issues)

### Need Guidance?
- Comment on an existing issue
- Ask in discussions
- Tag maintainers in your PR

## 🎉 Recognition

Contributors will be:
- Listed in README credits
- Mentioned in release notes
- Featured in community showcase
- Given contributor badge

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

<div align="center">

**Thank you for contributing to Stellar Dots!** ⭐

Made with 💜 by the community

</div>

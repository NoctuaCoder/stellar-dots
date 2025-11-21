#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         🎮 GAME LAUNCHER 🎮                               ║
# ║                        Stellar Dots Gaming Utility                         ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Build game list
games=""

# Steam games (if installed)
if command -v steam &> /dev/null; then
    games+="🎮 Steam\n"
fi

# Lutris games
if command -v lutris &> /dev/null; then
    games+="🎯 Lutris\n"
    
    # Get installed Lutris games
    lutris_games=$(lutris --list-games 2>/dev/null | tail -n +2)
    if [ -n "$lutris_games" ]; then
        while IFS= read -r game; do
            games+="  $game\n"
        done <<< "$lutris_games"
    fi
fi

# Minecraft (common installation)
if [ -f "$HOME/.minecraft/launcher" ] || command -v minecraft-launcher &> /dev/null; then
    games+="⛏️ Minecraft\n"
fi

# Heroic Games Launcher
if command -v heroic &> /dev/null; then
    games+="🦸 Heroic Games Launcher\n"
fi

# Custom games section
games+="\n──────────────\n"
games+="⚙️ Configurações de Gaming\n"
games+="📊 Performance Profile\n"

# Show menu
chosen=$(echo -e "$games" | rofi -dmenu -p "Game Launcher" -theme ~/.config/rofi/launcher.rasi -i)

# Launch selected game/app
case "$chosen" in
    "🎮 Steam")
        steam &
        ;;
    "🎯 Lutris")
        lutris &
        ;;
    "⛏️ Minecraft")
        if command -v minecraft-launcher &> /dev/null; then
            minecraft-launcher &
        else
            "$HOME/.minecraft/launcher" &
        fi
        ;;
    "🦸 Heroic Games Launcher")
        heroic &
        ;;
    "⚙️ Configurações de Gaming")
        kitty -e sh -c "echo 'Gaming Settings'; echo ''; echo 'GameMode: gamemoderun %command%'; echo 'MangoHud: mangohud %command%'; echo ''; read -p 'Pressione Enter para fechar...'"
        ;;
    "📊 Performance Profile")
        ~/.local/bin/performance-profile.sh
        ;;
    "")
        exit 0
        ;;
    *)
        # Try to launch as Lutris game
        if command -v lutris &> /dev/null; then
            game_slug=$(echo "$chosen" | sed 's/^  //' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
            lutris lutris:rungame/"$game_slug" &
        fi
        ;;
esac

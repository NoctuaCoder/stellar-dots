# 🎨 Guia de Customização - Stellar Dots

Este guia te ajudará a personalizar seu setup Stellar Dots do seu jeito!

## Cores e Temas

### Trocar Tema

Use o theme switcher para trocar entre os temas disponíveis:

```bash
theme-switcher.sh
```

### Criar Seu Próprio Tema

1. Crie um novo diretório em `~/.config/stellar-dots/themes/`:

```bash
mkdir -p ~/.config/stellar-dots/themes/meu-tema
```

2. Crie o arquivo `colors.conf`:

```bash
nano ~/.config/stellar-dots/themes/meu-tema/colors.conf
```

3. Defina suas cores (exemplo):

```conf
# Base colors
base=#1a1b26
surface=#24283b
text=#c0caf5
accent=#7aa2f7

# Terminal colors
color0=#15161e
color1=#f7768e
color2=#9ece6a
color3=#e0af68
color4=#7aa2f7
color5=#bb9af7
color6=#7dcfff
color7=#a9b1d6
color8=#414868
color9=#f7768e
color10=#9ece6a
color11=#e0af68
color12=#7aa2f7
color13=#bb9af7
color14=#7dcfff
color15=#c0caf5

# Hyprland specific
active_border=rgba(7aa2f7ee)
inactive_border=rgba(41486855)
background=rgba(1a1b26ff)
foreground=rgba(c0caf5ff)
```

4. Aplique seu tema:

```bash
cp ~/.config/stellar-dots/themes/meu-tema/colors.conf ~/.config/hypr/colors.conf
hyprctl reload
```

## Wallpapers

### Adicionar Novos Wallpapers

1. Copie suas imagens para a pasta de wallpapers:

```bash
cp /caminho/para/imagem.jpg ~/Pictures/wallpapers/
```

2. Use o wallpaper changer:

```bash
wallpaper-changer.sh
```

### Wallpaper Automático ao Iniciar

Edite `~/.config/hypr/hyprland.conf` e modifique a linha:

```conf
exec-once = ~/.local/bin/wallpaper-changer.sh /caminho/para/wallpaper.jpg
```

## Waybar

### Modificar Módulos

Edite `~/.config/waybar/config.jsonc`:

```jsonc
{
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery", "tray"]
}
```

### Adicionar Módulo de CPU

```jsonc
"cpu": {
    "format": " {usage}%",
    "tooltip": false
}
```

E adicione `"cpu"` em `modules-right`.

### Modificar Cores

Edite `~/.config/waybar/style.css`:

```css
#cpu {
    background: rgba(25, 23, 36, 0.8);
    color: #f6c177;
    border-radius: 12px;
    padding: 0 14px;
}
```

## Hyprland

### Modificar Animações

Edite `~/.config/hypr/hyprland.conf`:

```conf
animations {
    enabled = true
    
    # Animações mais rápidas
    animation = windows, 1, 4, wind, slide
    animation = windowsIn, 1, 4, winIn, slide
    
    # Animações mais lentas
    animation = windows, 1, 8, wind, slide
    animation = windowsIn, 1, 8, winIn, slide
}
```

### Modificar Gaps e Bordas

```conf
general {
    gaps_in = 8        # Espaço interno entre janelas
    gaps_out = 16      # Espaço externo das bordas
    border_size = 3    # Espessura da borda
}
```

### Modificar Blur

```conf
decoration {
    blur {
        enabled = true
        size = 8           # Intensidade do blur
        passes = 4         # Qualidade (mais = melhor)
    }
}
```

### Adicionar Regras de Janela

```conf
# Fazer app específico sempre flutuante
windowrulev2 = float, class:^(meu-app)$

# Definir opacidade para app específico
windowrulev2 = opacity 0.85 0.85, class:^(firefox)$

# Iniciar app em workspace específico
windowrulev2 = workspace 2, class:^(firefox)$
```

## Kitty Terminal

### Modificar Opacidade

Edite `~/.config/kitty/kitty.conf`:

```conf
background_opacity 0.85  # 0.0 = transparente, 1.0 = opaco
background_blur 30       # Intensidade do blur
```

### Modificar Fonte

```conf
font_family      JetBrainsMono Nerd Font
font_size        12.0
```

### Adicionar Atalhos Customizados

```conf
map ctrl+shift+z scroll_to_prompt -1
map ctrl+shift+x scroll_to_prompt 1
```

## Rofi

### Modificar Tamanho

Edite `~/.config/rofi/launcher.rasi`:

```css
window {
    width: 800px;  /* Largura */
}

listview {
    lines: 10;     /* Número de itens visíveis */
}
```

### Modificar Cores

```css
* {
    bg: #191724ee;
    accent: #c4a7e7;  /* Cor de destaque */
}
```

## Atalhos de Teclado

### Adicionar Novos Atalhos

Edite `~/.config/hypr/hyprland.conf`:

```conf
# Abrir navegador
bind = $mainMod, B, exec, firefox

# Abrir editor de código
bind = $mainMod, C, exec, code

# Volume com scroll do mouse
bind = $mainMod, mouse_down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = $mainMod, mouse_up, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
```

### Modificar Atalhos Existentes

Encontre o atalho que quer modificar e altere:

```conf
# Original
bind = $mainMod, Return, exec, kitty

# Modificado para usar Alacritty
bind = $mainMod, Return, exec, alacritty
```

## Starship Prompt

### Modificar Estilo

Edite `~/.config/starship.toml`:

```toml
# Prompt de uma linha
format = """$all"""

# Modificar cores
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

# Adicionar mais informações
[battery]
disabled = false
```

## Autostart

### Adicionar Apps ao Autostart

Edite `~/.config/hypr/hyprland.conf`:

```conf
exec-once = discord
exec-once = spotify
exec-once = firefox
```

### Executar Script ao Iniciar

```conf
exec-once = ~/.local/bin/meu-script.sh
```

## Monitores Múltiplos

### Configurar Múltiplos Monitores

```conf
# Monitor principal
monitor=DP-1,1920x1080@144,0x0,1

# Monitor secundário à direita
monitor=HDMI-A-1,1920x1080@60,1920x0,1

# Monitor secundário acima
monitor=HDMI-A-1,1920x1080@60,0x-1080,1
```

### Waybar em Múltiplos Monitores

Edite `~/.config/waybar/config.jsonc`:

```jsonc
{
    "output": ["DP-1", "HDMI-A-1"]  // Mostrar em ambos
}
```

## Dicas Avançadas

### Pywal16 Integration

Para colorschemes dinâmicos baseados no wallpaper:

```bash
# Instalar pywal16
pip install --user pywal16

# Gerar colorscheme do wallpaper
wal -i ~/Pictures/wallpapers/meu-wallpaper.jpg

# Aplicar cores ao Hyprland
cat ~/.cache/wal/colors-hyprland.conf > ~/.config/hypr/colors.conf
hyprctl reload
```

### Backup de Configurações

Crie um script de backup:

```bash
#!/bin/bash
tar -czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz \
    ~/.config/hypr \
    ~/.config/waybar \
    ~/.config/kitty \
    ~/.config/rofi \
    ~/.local/bin/*.sh
```

### Sincronizar com Git

```bash
cd ~/.config
git init
git add hypr/ waybar/ kitty/ rofi/
git commit -m "Initial dotfiles"
git remote add origin https://github.com/seu-usuario/meus-dotfiles.git
git push -u origin main
```

## Recursos Úteis

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Rofi Themes](https://github.com/davatorium/rofi-themes)
- [Starship Config](https://starship.rs/config/)

---

**Divirta-se customizando!** 🎨✨

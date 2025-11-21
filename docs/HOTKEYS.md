# ⌨️ Referência de Atalhos - Stellar Dots

## Aplicações

| Atalho | Ação |
|--------|------|
| `Super + Return` | Abrir terminal (Kitty) |
| `Super + D` | Launcher de aplicações (Rofi) |
| `Super + E` | Gerenciador de arquivos (Thunar) |
| `Super + Q` | Fechar janela ativa |
| `Super + M` | Sair do Hyprland |

## Gerenciamento de Janelas

| Atalho | Ação |
|--------|------|
| `Super + V` | Alternar modo flutuante |
| `Super + F` | Tela cheia |
| `Super + J` | Alternar split |
| `Super + P` | Pseudo-tile |
| `Super + ←/→/↑/↓` | Mover foco entre janelas |
| `Super + Shift + ←/→/↑/↓` | Mover janela |
| `Super + Ctrl + ←/→/↑/↓` | Redimensionar janela |
| `Super + Mouse Esquerdo` | Mover janela (arrastar) |
| `Super + Mouse Direito` | Redimensionar janela (arrastar) |

## Workspaces

| Atalho | Ação |
|--------|------|
| `Super + 1-9` | Ir para workspace 1-9 |
| `Super + 0` | Ir para workspace 10 |
| `Super + Shift + 1-9` | Mover janela para workspace 1-9 |
| `Super + Shift + 0` | Mover janela para workspace 10 |
| `Super + Scroll Mouse` | Navegar entre workspaces |

## Screenshots

| Atalho | Ação |
|--------|------|
| `Print` | Screenshot da tela completa |
| `Super + Print` | Screenshot de área selecionada |
| `Super + Shift + Print` | Screenshot da janela ativa |

> Screenshots são salvos em `~/Pictures/screenshots/` e copiados para a área de transferência.

## Gravação de Tela

| Atalho | Ação |
|--------|------|
| `Super + R` | Iniciar/Parar gravação de tela |

> Gravações são salvas em `~/Videos/recordings/`

## Wallpaper e Temas

| Atalho | Ação |
|--------|------|
| `Super + W` | Selecionar wallpaper |
| `Super + Shift + W` | Wallpaper aleatório |
| `Super + T` | Trocar tema |

## Sistema

| Atalho | Ação |
|--------|------|
| `Super + L` | Bloquear tela |
| `Super + Shift + E` | Menu de energia (power menu) |

## Mídia

| Atalho | Ação |
|--------|------|
| `XF86AudioRaiseVolume` | Aumentar volume (+5%) |
| `XF86AudioLowerVolume` | Diminuir volume (-5%) |
| `XF86AudioMute` | Mutar/Desmutar áudio |
| `XF86AudioPlay` | Play/Pause |
| `XF86AudioNext` | Próxima faixa |
| `XF86AudioPrev` | Faixa anterior |

## Brilho (Laptops)

| Atalho | Ação |
|--------|------|
| `XF86MonBrightnessUp` | Aumentar brilho (+5%) |
| `XF86MonBrightnessDown` | Diminuir brilho (-5%) |

## Terminal (Kitty)

| Atalho | Ação |
|--------|------|
| `Ctrl + Shift + C` | Copiar |
| `Ctrl + Shift + V` | Colar |
| `Ctrl + Shift + Enter` | Nova janela |
| `Ctrl + Shift + T` | Nova aba |
| `Ctrl + Shift + Q` | Fechar aba |
| `Ctrl + Shift + →` | Próxima aba |
| `Ctrl + Shift + ←` | Aba anterior |
| `Ctrl + Shift + +` | Aumentar fonte |
| `Ctrl + Shift + -` | Diminuir fonte |
| `Ctrl + Shift + F11` | Tela cheia |

## Rofi (Launcher)

| Atalho | Ação |
|--------|------|
| `Esc` | Fechar |
| `Enter` | Executar aplicação selecionada |
| `↑/↓` | Navegar |
| `Tab` | Alternar entre modos (drun/run/window) |

## Scripts Utilitários

### Wallpaper Changer

```bash
# Selecionar wallpaper interativamente
wallpaper-changer.sh

# Wallpaper aleatório
wallpaper-changer.sh --random

# Definir wallpaper específico
wallpaper-changer.sh /caminho/para/imagem.jpg
```

### Screenshot

```bash
# Tela completa
screenshot.sh --full

# Área selecionada
screenshot.sh --area

# Janela ativa
screenshot.sh --window
```

### Theme Switcher

```bash
# Abrir menu de seleção de tema
theme-switcher.sh
```

### Screen Recorder

```bash
# Iniciar/parar gravação
record-screen.sh

# Gravar área específica
record-screen.sh --area
```

## Waybar (Barra Superior)

| Módulo | Ação ao Clicar |
|--------|----------------|
| Workspaces | Ir para workspace |
| Volume | Abrir Pavucontrol |
| Network | Abrir Network Manager |
| Bluetooth | Abrir Blueman |
| Clock | Mostrar calendário |

## Dicas

### Redimensionamento Rápido

Para redimensionar janelas rapidamente:
1. Pressione `Super + Ctrl`
2. Use as setas direcionais
3. Cada pressão redimensiona 20px

### Navegação entre Workspaces

- Use `Super + 1-9` para acesso direto
- Use `Super + Scroll` para navegação sequencial
- Workspaces vazios são ocultados automaticamente

### Modo Flutuante

Algumas janelas (como diálogos) flutuam automaticamente. Para alternar manualmente:
- `Super + V` - Alternar flutuante/tiled

### Tela Cheia

- `Super + F` - Tela cheia (mantém a barra)
- Para tela cheia real, use `Super + F` duas vezes

## Customização

Para customizar os atalhos, edite:

```bash
~/.config/hypr/hyprland.conf
```

Procure pela seção `# KEYBINDINGS` e modifique conforme necessário.

### Exemplo de Customização

```conf
# Adicionar novo atalho
bind = $mainMod, B, exec, firefox

# Modificar atalho existente
bind = $mainMod, Return, exec, alacritty  # Trocar terminal
```

Após modificar, recarregue a configuração:
```bash
hyprctl reload
```

---

**Dica:** Imprima esta página ou mantenha aberta para referência rápida enquanto se acostuma com os atalhos!

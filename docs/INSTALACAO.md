# 📖 Guia de Instalação - Stellar Dots

## Pré-requisitos

- Sistema Linux (Arch, Fedora, ou Debian/Ubuntu)
- Git instalado
- Conexão com a internet
- Pelo menos 2GB de espaço livre

## Instalação Automática

### 1. Clone o Repositório

```bash
git clone https://github.com/SEU_USUARIO/stellar-dots.git
cd stellar-dots
```

### 2. Execute o Instalador

```bash
./install.sh
```

### 3. Siga o Assistente Interativo

O instalador irá:

1. **Detectar seu sistema** - Identifica automaticamente sua distribuição Linux
2. **Criar backup** - Salva seus configs existentes em `~/.config-backup-TIMESTAMP/`
3. **Perguntar sobre dependências** - Você pode escolher instalar ou pular
4. **Selecionar tema** - Escolha entre Rosé Pine, Catppuccin ou Nord
5. **Instalar dotfiles** - Copia todos os arquivos de configuração
6. **Configurar scripts** - Adiciona utilitários ao PATH

### 4. Finalize a Instalação

Após a instalação:

1. Faça logout da sua sessão atual
2. No display manager, selecione **Hyprland**
3. Faça login
4. Aproveite seu novo setup! 🎉

## Instalação Manual

Se preferir instalar manualmente:

### 1. Instale as Dependências

#### Arch Linux

```bash
sudo pacman -S hyprland waybar kitty rofi-wayland dunst swww hyprlock hypridle \
  grim slurp wl-clipboard brightnessctl playerctl pavucontrol \
  network-manager-applet bluez blueman fastfetch starship lsd zoxide \
  ttf-jetbrains-mono-nerd polkit-gnome xdg-desktop-portal-hyprland

# AUR packages (com paru ou yay)
paru -S pywal16-git wf-recorder hyprpicker
```

#### Fedora

```bash
sudo dnf copr enable solopasha/hyprland
sudo dnf install hyprland waybar kitty rofi-wayland dunst grim slurp \
  wl-clipboard brightnessctl playerctl pavucontrol NetworkManager-tui \
  bluez blueman fastfetch starship lsd zoxide jetbrains-mono-fonts-all \
  polkit-gnome xdg-desktop-portal-hyprland

pip install --user pywal16
```

#### Debian/Ubuntu

```bash
sudo apt update
sudo apt install kitty rofi dunst grim slurp wl-clipboard brightnessctl \
  playerctl pavucontrol network-manager-gnome bluez blueman fastfetch \
  starship fonts-jetbrains-mono policykit-1-gnome python3-pip

pip3 install --user pywal16
```

> **Nota:** Hyprland precisa ser compilado manualmente no Debian/Ubuntu.  
> Veja: https://wiki.hyprland.org/Getting-Started/Installation/

### 2. Copie os Arquivos de Configuração

```bash
# Backup dos configs existentes
mkdir -p ~/.config-backup-$(date +%Y%m%d)
cp -r ~/.config/hypr ~/.config-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp -r ~/.config/kitty ~/.config-backup-$(date +%Y%m%d)/ 2>/dev/null || true

# Copie os novos configs
cp -r .config/* ~/.config/

# Escolha e aplique um tema
cp themes/rose-pine/colors.conf ~/.config/hypr/colors.conf
```

### 3. Instale os Scripts

```bash
mkdir -p ~/.local/bin
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*.sh

# Adicione ao PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
# ou para zsh:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

### 4. Copie os Wallpapers

```bash
mkdir -p ~/Pictures/wallpapers
cp wallpapers/* ~/Pictures/wallpapers/
```

## Pós-Instalação

### Configurar Teclado

Edite `~/.config/hypr/hyprland.conf` e ajuste o layout do teclado:

```conf
input {
    kb_layout = br  # ou us, pt, etc.
}
```

### Configurar Monitor

Se você tem múltiplos monitores, edite a linha `monitor=` em `hyprland.conf`:

```conf
# Exemplo para monitor específico
monitor=DP-1,1920x1080@144,0x0,1

# Ou deixe automático
monitor=,preferred,auto,1
```

### Trocar Tema

Execute o theme switcher:

```bash
theme-switcher.sh
```

### Configurar Wallpaper Inicial

```bash
wallpaper-changer.sh --random
```

## Solução de Problemas

### Waybar não inicia

```bash
killall waybar
waybar &
```

### Hyprland não inicia

Verifique os logs:

```bash
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log
```

### Fontes não aparecem corretamente

Atualize o cache de fontes:

```bash
fc-cache -fv
```

### Scripts não funcionam

Verifique se estão executáveis:

```bash
chmod +x ~/.local/bin/*.sh
```

## Desinstalação

Para remover o Stellar Dots:

1. Restaure seus configs antigos:
   ```bash
   rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/rofi
   cp -r ~/.config-backup-TIMESTAMP/* ~/.config/
   ```

2. Remova os scripts:
   ```bash
   rm ~/.local/bin/wallpaper-changer.sh
   rm ~/.local/bin/screenshot.sh
   rm ~/.local/bin/theme-switcher.sh
   rm ~/.local/bin/record-screen.sh
   ```

## Próximos Passos

- [Ver todos os atalhos de teclado](HOTKEYS.md)
- [Customizar seu setup](CUSTOMIZACAO.md)
- Explorar e personalizar!

---

**Precisa de ajuda?** Abra uma issue no GitHub!

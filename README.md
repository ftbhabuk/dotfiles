# Hyprland Dotfiles

My  Hyprland configuration files I'm using.

## Contents

**Window Manager**
- hypr/ - Hyprland configuration
- waybar/ - Status bar
- rofi/ - Application launcher
- wlogout/ - Logout menu
- dunst/ - Notifications
- uwsm/ - Session manager

**Terminal & Shell**
- kitty/ - Terminal emulator
- zsh/ - Shell configuration
- starship/ - Prompt
- fastfetch/ - System info
- btop/ - System monitor
- vim/ - Editor

**Theming**
- gtk-3.0/, gtk-4.0/ - GTK themes
- qt5ct/, qt6ct/ - Qt configuration
- Kvantum/ - Qt theme engine
- nwg-look/ - GTK settings

**Scripts**
- create-claude.sh
- create-grok.sh
- fix_thermal.sh

## Installation

Backup your existing configs first:
```bash
mkdir -p ~/.config-backup
cp -r ~/.config/{hypr,waybar,rofi,kitty,zsh} ~/.config-backup/
```

Copy configurations:
```bash
cp -r ./* ~/.config/
chmod +x create-*.sh fix_thermal.sh
```

## Dependencies

Core packages needed:
```bash
hyprland waybar rofi dunst kitty zsh starship fastfetch btop vim
qt5ct qt6ct kvantum nwg-gtk-settings wlogout uwsm
```

Install on Arch:
```bash
sudo pacman -S hyprland waybar rofi dunst kitty zsh starship fastfetch btop vim qt5ct qt6ct kvantum wlogout uwsm
yay -S nwg-look
```


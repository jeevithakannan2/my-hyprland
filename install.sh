#!/bin/bash -e

DOT_LOCATION="$HOME/hyprland-dots"

install_deps() {
  if ! command -v paru &>/dev/null; then
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si --noconfirm
  fi
  paru
  paru -S hyprland xdg-desktop-portal-hyprland waybar hyprpaper hyprlock hyprshot hypridle wlogout wttrbar waybar-module-pacman-updates-git foot mate-polkit wofi --needed --noconfirm
}

git_clone() {
  if [ -d "$DOT_LOCATION" ]; then
    read -n -p "To proceed with installation remove all contents in $DOT_LOCATION ?? [Y/N] [DEFAULT Y]: " confirm
    echo
    confirm=${confirm:-Y}
    if [[ "$confirm" =~ [Yy] ]]; then
      rm "$DOT_LOCATION"
    else
      exit 1
    fi
  else
    git clone https://github.com/jeevithakannan2/hyprland-dots.git --depth 1 "$DOT_LOCATION"
  fi
}

copy_configs() {
  mkdir -p "$HOME/.config"
  cp -rf "$DOT_LOCATION/config/"* "$HOME/.config"
}

if command -v pacman &>/dev/null; then
  echo "Using pacman !!"
  install_deps
  if [$? -ne 0]; then
    echo "Error installing dependencies !!"
    exit 1
  fi

  git_clone
  copy_configs

  echo "Finished installation !!"
else
  echo "Pacman not found !! Not arch linux ??"
  exit 1
fi

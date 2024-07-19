DOT_LOCATION=~/hypr-jeeva

install_deps() {
  if command -v paru &>/dev/null; then
    paru
    paru -S hyprland waybar hyprlock hypridle wlogout wttrbar waybar-module-pacman-updates-git --needed
  else
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    install_deps
  fi
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
    git clone https://github.com/jeevithakannan2/hyprland.git --depth 1 "$DOT_LOCATION"
  fi
}

copy_configs() {
  cd "$DOT_LOCATION"
  cp -rf config/* ~/.config/
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
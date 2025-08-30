#!/bin/bash

cd "$(dirname "$0")" || exit 1

to_install=(
  # oh-my-posh
  atuin
  coreutils
  eza
  ffmpeg
  fileicon
  git-delta
  mise
  starship
)

echo -e "GREETINGS!\n\nThis install has two steps: \033[35m1.) Install Homebrew packages\033[0m, and \033[36m2.) Link dotfiles\033[0m.\n"
echo -e "Step 1: Install Homebrew packages\n"
echo -e "The following packages will be installed:\n"
for package in "${to_install[@]}"; do
  echo -e "\t - 📦 $package"
done

echo -e "\nProceed with installation? If you do not, you will need to install on your own. (y/n)"
read -n 1 -r
echo
case $REPLY in
y | Y)
  echo "🍻 Installing Homebrew packages..."
  for package in "${to_install[@]}"; do
    if ! brew list --formula | grep -q "^$package\$"; then
      echo "Installing $package..."
      brew install "$package"
    else
      echo "$package is already installed. Skipping."
    fi
  done
  ;;
*)
  echo "No dependencies will be installed. You can do later if you want."
  ;;
esac

files_to_link=(
  .tool-versions
  .gitconfig
  .gitignore_global
  .zshrc
)
echo -e "\nStep 2: Link dotfiles\n"
echo -e "The following files will be linked to your home directory:\n"
for file in "${files_to_link[@]}"; do
  echo -e "\t - 🔗 $file"
done

echo -e "\nProceed with linking? (y/n)"
read -n 1 -r
case $REPLY in
y | Y)
  echo "🔗 Linking dotfiles..."
  for file in "${files_to_link[@]}"; do
    source="$(pwd)/$file"
    dest="$HOME/$file"
    echo -e "🔗 Linking \033[33m$file\033[0m to \033[32m$dest\033[0m"
    ln -fs "$source" "$dest"
  done
  ;;
*)
  echo "No files will be linked. You can do later if you want."
  exit 1
  ;;
esac

echo "✨ All done!"

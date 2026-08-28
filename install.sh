#!/bin/bash

cd "$(dirname "$0")" || exit 1

UNDERLINE="\033[4m"
RESET="\033[0m"

to_install=(
  atuin
  coreutils
  eza
  fileicon
  git-delta
  mise
  starship
  zsh-autosuggestions
  zsh-syntax-highlighting
  # oh-my-posh
)

optional_to_install=(
  ffmpeg
)

echo -e "GREETINGS!\n\nThis install has two steps: \033[35m1.) Install Homebrew packages\033[0m, and \033[36m2.) Link dotfiles\033[0m.\n"
echo -e "Step 1: Install Homebrew packages\n"
echo -e "The following packages are \"required\" will be installed:\n"
for package in "${to_install[@]}"; do
  echo -e "\t - 📦 $package"
done

echo -e "\nThese packages are optional:\n"
for package in "${optional_to_install[@]}"; do
  echo -e "\t - 📦 $package"
done

install="n"
echo -e "\nHow do you want to proceed? Install ${UNDERLINE}a${RESET}ll, only ${UNDERLINE}r${RESET}equired, or ${UNDERLINE}n${RESET}one? (a/r/n)"
read -n 1 -r
echo
case $REPLY in
a | A)
  echo "🍻 Installing all Homebrew packages..."
  install="a"
  ;;
r | R)
  echo "🍻 Installing required Homebrew packages..."
  install="r"
  ;;
*)
  echo "No dependencies will be installed. You can do later if you want."
  ;;
esac

if [ "$install" = "a" ]; then
  to_install+=("${optional_to_install[@]}")
elif [ "$install" = "n" ]; then
  to_install=()
fi

for package in "${to_install[@]}"; do
  if ! brew list --formula | grep -q "^$package\$"; then
    echo "Installing $package..."
    brew install "$package"
  else
    echo "$package is already installed. Skipping."
  fi
done

files_to_link=(
  .tool-versions
  .gitconfig
  .gitignore_global
  .vimrc
  .zshrc
  .netrc
  # .p10k.zsh
)
echo -e "\nStep 3: Link dotfiles\n"
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

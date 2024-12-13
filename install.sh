#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

files_to_link=(
  .asdfrc
  .gitconfig
  .gitignore_global
  .p10k.zsh
  .vimrc
  .zshrc
)

for file in "${files_to_link[@]}"; do
  source="$(pwd)/$file"
  dest="$HOME/$file"
  echo -e "🔗 Linking \033[33m$file\033[0m to \033[32m$dest\033[0m"
  ln -fs "$source" "$dest"
done

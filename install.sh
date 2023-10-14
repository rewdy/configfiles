#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

ln -fs {~/.configfiles/,~/}.zshrc
ln -fs {~/.configfiles/,~/}.gitconfig
ln -fs {~/.configfiles/,~/}.gitignore_global

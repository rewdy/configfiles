#!/bin/bash

#########################################################################
### ALIASES
#########################################################################

# Basic aliases
alias ..='cd ../'           # Go up one directory
alias ~='cd ~'              # Go to home directory
alias home='cd ~'           # Go to home directory
alias work='cd ~/Workspace' # Go to work directory
alias cp='cp -Rv'           # Preferred 'cp' implementation: recusive, interactive, verbose
alias untar="tar -zxvf"     # Shortcut for untarring
cd() {
  builtin cd "$@" || exit 1
  eza -hl --git
} # List directory contents upon 'cd'

# Better file listings
alias ls='eza'                 # replace ls with eza b/c it kicks ass
alias ll='ls --git -hl --git'  # list files
alias la='ls --git -hla --git' # list all

# Git Shorties
alias gs='git status' # Git Shorties
alias gaac="git add --all && git commit"
alias grc="git rebase --continue"

# Short version of other commands
alias docc="docker compose"
alias tf="terraform"
alias p="pnpm"
alias y="yarn"
alias gui="gitui"

# App aliases
alias edit="code"

# Clear DNS cache
alias cleardnscache="sudo killall -HUP mDNSResponder"

# GH Copilot
alias ghs="gh copilot suggest"
alias ghe="gh copilot explain"

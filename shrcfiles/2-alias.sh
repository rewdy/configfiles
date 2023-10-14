#!/bin/bash

#########################################################################
### ALIASES
#########################################################################

# Basic aliases
alias ..='cd ../'               # Go up one directory
alias ~='cd ~'                  # Go to home directory
alias home='cd ~'               # Go to home directory
alias cp='cp -Riv'              # Preferred 'cp' implementation: recusive, interactive, verbose
alias untar="tar -zxvf"         # Shortcut for untarring
cd() { builtin cd "$@" || exit 1; exa -hl --git; }   # List directory contents upon 'cd'

# Better file listings
alias ls='exa'                  # replace ls with exa b/c it kicks ass
alias ll='ls --git -hl --git'          # list files
alias la='ls --git -hla --git'         # list all

# Git Shorties
alias gs='git status'                     # Git Shorties
alias gaac="git add --all && git commit"

# Short version of other commands
alias docc="docker-compose"
alias tf="terraform"

# App aliases
alias edit="code"
alias lkl="lokalise2 --config ~/.config/lokalise/config.yml"

# Clear DNS cache
alias cleardnscache="sudo killall -HUP mDNSResponder"

# unlock keychain
# alias unlock-keychain='security -i unlock-keychain'

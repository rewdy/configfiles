############################################################
# ALIASES
############################################################

# Prefer eza (modern ls replacement) if available
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -hl --git'
  alias la='eza -hla --git'
  alias lm='eza -las=modified --git'
else
  alias ls='ls --color=auto'
  alias ll='ls -al'
  alias la='ls -a'
  alias lm='ls -lahrt'
fi

# Basic aliases
alias ..='cd ../'           # Go up one directory
alias ~='cd ~'              # Go to home directory
alias home='cd ~'           # Go to home directory
alias work='cd ~/Workspace' # Go to work directory
alias cp='cp -Rv'           # Preferred 'cp' implementation: recursive, interactive, verbose
alias untar="tar -zxvf"     # Shortcut for untarring

cd() {
  builtin cd "$@" || return 1;
  eza -hl --git
} # List directory contents upon 'cd'

# Git Shorties
alias gs='git status' # Git Shorties
alias gaac="git add --all && git commit"
alias grc="git rebase --continue"

# Short version of other commands
alias docc="docker compose"
alias tf="terraform"
alias p="pnpm"
alias p-id="pnpm install && pnpm dev"
alias y="yarn"
alias gui="gitui"

# App aliases
alias edit="zed"
alias code="zed"

# Clear DNS cache
alias cleardnscache="sudo killall -HUP mDNSResponder"

# GH Copilot
alias ghs="gh copilot suggest"
alias ghe="gh copilot explain"

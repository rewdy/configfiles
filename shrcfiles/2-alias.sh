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

# List directory contents whenever the working directory changes
autoload -Uz add-zsh-hook
chpwd_list_files() {
  if (( $+commands[eza] )); then
    eza -hl --git
  else
    ls -lah
  fi
}
add-zsh-hook chpwd chpwd_list_files

# Git Shorties
alias gs='git status' # Git Shorties
alias gaac="git add --all && git commit"
alias grc="git rebase --continue"
alias gg="ziggity"

# Short version of other commands
alias docc="docker compose"
alias tf="terraform"
alias p="pnpm"
alias p-id="pnpm install && pnpm dev"
alias gui="ziggity"

# Edit stuff
alias code="$EDITOR_TOOL"
alias edit="$EDITOR_TOOL"
alias wt="worktree"

alias pwdcp="pwd | pbcopy"

# Clear DNS cache
alias cleardnscache="sudo killall -HUP mDNSResponder"

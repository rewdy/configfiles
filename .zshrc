#
# Super lite .zshrc file I created after reading:
# https://rushter.com/blog/zsh-shell/
#

echo "⏳ Loading..."
# source files in the shrcfiles folder alphabetically
config_start=$(($(gdate +%s%N) / 1000000))

export HISTSIZE=500000
export SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY
setopt autocd

typeset -U path PATH

# Sauce go binaries
export PATH="$HOME/go/bin:$PATH"

############################################################
# USER CONFIG
############################################################

# 🚀✨ Starship
export STARSHIP_CONFIG=~/.configfiles/starship.toml
eval "$(starship init zsh)"

# Spin up atuin
eval "$(atuin init zsh)"

# Sets up the z command https://github.com/agkozak/zsh-z
source "$HOME/.configfiles/zsh-z/zsh-z.plugin.zsh"

# Syntax highlighting
# shellcheck disable=SC2046
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Auto suggestions (we're going to use async)
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history)
# shellcheck disable=SC2046
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable mise!
eval "$(mise activate zsh)"

# Enable worktree
eval "$(worktree-bin shell-init)"

############################################################
# Load additional config files
############################################################

# A Place to put your credentials that is not source controlled. This is
# for things like GITLAB_TOKEN, GITLAB_USERNAME, other TOKENs, etc
if [ -f "$HOME/.private-config.sh" ]; then
  source "$HOME/.private-config.sh"
fi

for f in ~/.configfiles/shrcfiles/*.sh; do
  # shellcheck disable=SC1090
  source "$f"
done

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/andrew.meyer/.docker/completions $fpath)
# End of Docker CLI completions

# Completion settings (must be before compinit)
zstyle ':completion:*' menu select

# Run once at the end
autoload -Uz compinit; compinit

############################################################
# This is the last thing that runs. This Replaces any output that happens during
# start up with the ready indicator.
config_end=$(($(gdate +%s%N) / 1000000))
config_elapsed=$(($config_end - $config_start))
elapsed=$(colorize-time $config_elapsed)

echo -e "\033c$(emoji) Let's go! $elapsed"

# remind-cli hook - This takes about 500ms and isn't configuring the
# shell at all, so putting here after we echo out we're ready.
if [[ $SHLVL -eq 1 && $- == *i* ]]; then
  remind check
fi

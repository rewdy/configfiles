# NOTE: I've removed most of the comments here. To see the original default .zshrc take a
# peek here: https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template
# zmodload zsh/zprof

echo "⏳ Loading..."
# source files in the shrcfiles folder alphabetically
config_start=$(($(gdate +%s%N) / 1000000))

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
  macos
  git
  mise
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  dotenv
)

source $ZSH/oh-my-zsh.sh

############################################################
# USER CONFIG
############################################################

# 💅 Oh my posh
# posh_config="~/.configfiles/oh-my-posh-config.yml"
# eval "$(oh-my-posh init zsh --config $posh_config)"

# 🚀✨ Starship
export STARSHIP_CONFIG=~/.configfiles/starship.toml
eval "$(starship init zsh)"

# Spin up atuin
eval "$(atuin init zsh)"

############################################################
# Configure bash style completions
############################################################

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

############################################################
# Load additional config files
############################################################

# A Place to put your credentials that is not source controlled. This is
# for things like GITLAB_TOKEN, GITLAB_USERNAME, other TOKENs, etc
if [ -f "$HOME/.private-config.sh" ]; then
  source "$HOME/.private-config.sh"
fi

for f in $(ls -v ~/.configfiles/shrcfiles/*.sh); do
  # timer=$(($(gdate +%s%N)/1000000))
  source $f
  # now=$(($(gdate +%s%N)/1000000))
  # elapsed=$(($now-$timer))
  # echo $elapsed":" $f
done

config_end=$(($(gdate +%s%N) / 1000000))
config_elapsed=$(($config_end - $config_start))

elapsed=$(colorize-time $config_elapsed)

# This is the last thing that runs. This Replaces any output that happens during
# start up with the ready indicator.
echo -e "\033c$(emoji) Let's go! $elapsed"

# zprof
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/andrew.meyer/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Added by Antigravity
export PATH="/Users/andrew.meyer/.antigravity/antigravity/bin:$PATH"

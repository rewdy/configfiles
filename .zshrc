# NOTE: I've removed most of the comments here. To see the original default .zshrc take a
# peek here: https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template
# zmodload zsh/zprof

echo "⏳ Loading..."
# source files in the shrcfiles folder alphabetically
config_start=$(($(gdate +%s%N)/1000000))

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
  macos
  git
  # asdf
  mise
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  dotenv
)

source $ZSH/oh-my-zsh.sh

##########################################
### USER CONFIG
##########################################

# 💅 Oh my posh
# posh_config="~/.configfiles/oh-my-posh-config.yml"
# eval "$(oh-my-posh init zsh --config $posh_config)"

# 🚀✨ Starship
export STARSHIP_CONFIG="$HOME/.configfiles/starship.toml"
eval "$(starship init zsh)"

# Spin up atuin
eval "$(atuin init zsh)"

#########################################################################
### ALLOW BASH STYLE COMPLETIONS
#########################################################################

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

#########################################################################
### LOAD COMMON FILES
#########################################################################

# A Place to put your credentials that is not source controlled
#   things like GITLAB_TOKEN, GITLAB_USERNAME
if [ -f "$HOME/.private-config.sh" ]; then
  source "$HOME/.private-config.sh"
fi

for f in $(ls -v ~/.configfiles/shrcfiles/*.sh); do
  # timer=$(($(gdate +%s%N)/1000000))
  source $f;
  # now=$(($(gdate +%s%N)/1000000))
  # elapsed=$(($now-$timer))
  # echo $elapsed":" $f
done

config_end=$(($(gdate +%s%N)/1000000))
config_elapsed=$(($config_end-$config_start))

elapsed=$(colorize_time $config_elapsed)

# This is the last thing that runs. This Replaces any output that happens during
# start up with the ready indicator.
echo -e "\033c$(emoji) Let's go! $elapsed"
# zprof

# NOTE: I've removed most of the comments here. To see the original default .zshrc take a
# peek here: https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template

echo "⏳ Loading..."

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Setup brew env variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
  macos
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  dotenv
)

source $ZSH/oh-my-zsh.sh

##########################################
### USER CONFIG
##########################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# TODO: Do I need all this?? 
# export PATH="$PATH:/Users/$USER/.local/bin"
# export PATH="/usr/local/sbin:$PATH"
# export PATH="$HOME/.poetry/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/bzip2/lib -L/opt/homebrew/opt/zlib/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/bzip2/include -I/opt/homebrew/opt/zlib/include"
# export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/openssl@3/lib"
# export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/openssl@3/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"


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

# source files in the shrcfiles folder alphabetically
for f in $(ls -v ~/.configfiles/shrcfiles/*.sh); do source $f; done

# This is the last thing that runs. This Replaces any output that happens during 
# start up with the ready indicator.
echo -e "\033c👍 Ready"
#!/bin/bash

# NVM takes a long time to load. We're doing some special stuff here to speed it up.
# - Default node version is at this 👇 path. If default version needs to be updated, do it here.
export PATH="$HOME/.nvm/versions/node/v16.20.0/bin/node:$PATH"
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
if [[ "$HOME" != "$(pwd)" ]]; then
  # We only run nvm use when not in home dir. I don't work out of that
  # directory so this speeds up the shell start time a bit. It will still
  # check on cd
  load-nvmrc
fi

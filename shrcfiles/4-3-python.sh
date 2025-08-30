#!/bin/bash

#########################################################################
### PYENV INIT
#########################################################################

# TODO: Sort out what I actually want here. Use uv?
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - $SHELL)"
#   # TODO: Do I need any of this stuff? I usually just let poetry handle all this...
#   # eval "$(pyenv virtualenv-init - $SHELL)"
#   # eval "$(pyenv init --path)"
#   # eval "$(pyenv init - $SHELL)"
fi

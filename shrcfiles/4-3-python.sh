#!/bin/bash

#########################################################################
### PYENV INIT
#########################################################################

# TODO: Figure out ideal python setup. This stuff is slow AF and I don't want to have it normally enabled.
# I use poetry most of the time and it doesn't seem to need any of this.
# PYENV SETUP
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - $SHELL --no-rehash)"
  # TODO: Do I need any of this stuff? I usually just let poetry handle all this...
  # eval "$(pyenv virtualenv-init - $SHELL)"
  # eval "$(pyenv init --path)"
  # eval "$(pyenv init - $SHELL)"
fi

# uncomment for autocomplete with register-python-argcomplete installed
#if command -v pipx &> /dev/null; then
#    eval "$(register-python-argcomplete pipx)"
#fi

# user brew open SSL for python builds
# Note: This is the result of calling $(brew --prefix openssl). This call takes longer than I want,
# so hardcoding to a var. If it fails ever, i can adjust.
openssl_path="$HOMEBREW_PREFIX/opt/openssl@3"
export CPATH=$openssl_path/include:$CPATH
export LIBRARY_PATH=$openssl_path/lib:$LIBRARY_PATH

# add open "star" pins to poetry
poetry-add-star() {
  poetry add $1'=*'
}

poetry-add-dev-star() {
  poetry add -D $1'=*'
}

poetry() {
  if [ -e "uv.lock" ]; then
    notify "📦 uv.lock found. Are ya sure about that??"
  else
    "$HOME/.local/bin/poetry" "$@"
  fi
}

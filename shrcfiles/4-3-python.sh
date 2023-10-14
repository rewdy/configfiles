#!/bin/bash

#########################################################################
### DIRENV/PYENV INIT
#########################################################################
# DIRENV
if command -v direnv &> /dev/null; then
    eval "$(direnv hook $SHELL)"
fi

# PYENV SETUP
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# PIPX
export PATH=/Users/$USER/.local/bin:$PATH # pipx
# uncomment for autocomplete with register-python-argcomplete installed
#if command -v pipx &> /dev/null; then
#    eval "$(register-python-argcomplete pipx)"
#fi

_init-python-dir() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(pyenv versions --bare --skip-aliases)

	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0 
}
init-python-dir() {
    local dirname
    dirname=${PWD##*/}
    pyenv virtualenv $1 ${dirname}
    pyenv local ${dirname}
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    fi
}
complete -F _init-python-dir init-python-dir

# user brew open SSL for python builds
export CPATH=$(brew --prefix openssl)/include:$CPATH
export LIBRARY_PATH=$(brew --prefix openssl)/lib:$LIBRARY_PATH

# add open "star" pins to poetry
poetry-add-star() {
    poetry add $1'=*'
}

poetry-add-dev-star() {
    poetry add -D $1'=*'
}
#!/bin/bash

yarn() {
  if [ -e "pnpm-lock.yaml" ]; then
    notify "📦 pnpm-lock.yaml found. Are ya sure about that??"
  else
    "$HOME/.asdf/shims/yarn" "$@"
  fi
}

# NOTE: asdf installed via these directions: git clone https://github.com/asdf-vm/asdf.git ~/.asdf

############################################################
# NODE SETUP
############################################################

yarn() {
  if [ -e "pnpm-lock.yaml" ]; then
    notify "📦 pnpm-lock.yaml found. Are ya sure about that??"
  else
    "$HOME/.local/share/mise/installs/yarn/1.22.22/bin/yarn" "$@"
  fi
}

# TODO: Disable once I am done fartin' around with ng
# Load Angular CLI autocompletion.
# shellcheck disable=SC1090
source <(ng completion script)

# NOTE: mise installed via these instructions: https://mise.jdx.dev/getting-started.html

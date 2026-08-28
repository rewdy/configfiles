############################################################
# BASE CONFIGURATION
############################################################

# for referencing other files in the config dir
export CONFIG_ROOT="/Users/$USER/.configfiles"

# Hush pipenv verbosity
export PIPENV_VERBOSITY=-1

# hide brew cleanup hints
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1

# Set editors
export EDITOR_TOOL="zed"
export VISUAL="$EDITOR_TOOL --wait"
export EDITOR="$EDITOR_TOOL --wait"
export GIT_EDITOR=vim

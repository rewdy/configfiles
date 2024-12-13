#!/bin/bash

# for referencing other files in the config dir
export CONFIG_ROOT="/Users/$USER/.configfiles"

# This pulls in the color functions, bc 🌈😊
# shellcheck source="../bash_colors/bash_colors.sh"
source "$CONFIG_ROOT/bash_colors/bash_colors.sh"

export PIPENV_VERBOSITY=-1

# Composer memory limit
export COMPOSER_MEMORY_LIMIT=-1

# hide brew cleanup hints
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1

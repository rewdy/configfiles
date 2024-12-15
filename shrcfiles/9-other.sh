#!/bin/bash

#########################################################################
### OTHER RANDOM
#########################################################################

# This makes it so alt-left and alt-right will move the cursor by word in the terminal.
bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word

# DIRENV
if command -v direnv &>/dev/null; then
  eval "$(direnv hook $SHELL)"
fi

# Random emoji generator!!
emoji_list=(🚀 🌟 ⛵️ 👻 👖 🌈 🔥 🍕 🌮 🍭 🍬 🍩 ⛳️ 🎯 🛵 🛫 🪭 💙 🤍 ❤️‍🔥 📣 🫦 🧠 💁‍♀️ 👓 🦑)
function emoji() {
  echo "${emoji_list[ $RANDOM % ${#emoji_list[@]} ]}"
}

CUSTOM_ICON_PATH="$CONFIG_ROOT/custom-app-icons/"

# Set custom app icons
# NOTE: This is not run automatically. It's just here to run manually after the app(s)
# are updated and icons reset.
function set_app_icons() {
  if command -v fileicon &>/dev/null; then
    fileicon set /Applications/iTerm.app "$CUSTOM_ICON_PATH/iTerm2-white-chevron.icns"
    # fileicon set /Applications/iTerm.app "$CUSTOM_ICON_PATH/iTerm2-nord-chevron.icns"
    # Other applications could be set here...
    killall Dock
  else
    notify-fail "fileicon is not installed. Run 'brew install fileicon' to install."
  fi
}

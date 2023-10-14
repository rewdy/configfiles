#!/bin/bash

usage=("")
usage+=("👋 Helper Functions:")
usage+=("-------\n\n")

define() {
  usage+=("    \033[33m$1\033[0m~$2")
}

define "date-string" "Generates a datestring; can be used to generate timestamps"
date-string() {
  date "+%Y%m%d-%H%M%S"
}

# Output helpers
define "notify" "Echos a notify message with styling"
notify() {
  clr_blue "  $1"
}

define "notify-start" "Notifies a process is starting"
notify-start() {
  echo ""
  clr_blueb "   $1 "
  echo ""
}

define "notify-success" "Notifies a process has succeeded"
notify-success() {
  clr_green "  $1"
}

define "notify-fail" "Notifies a process has failed"
notify-fail() {
  clr_red "  $1"
}

define "newtab" "Tells iTerm to create a new tab"
newtab() {
  osascript -e 'tell application "iTerm" to activate' -e 'tell application "System Events" to tell process "iTerm" to keystroke "t" using command down'
}

define "py-path" "Sets the PYTHONPATH env var to the current path"
py-path() {
  current=$(pwd)
  export PYTHONPATH=$current
  notify "PYTHONPATH is now ${PYTHONPATH}"
}

define "bonvoyage" "Create a new bon voyage static website project" "https://github.com/rewdy/bonvoyage"
bonvoyage() {
  notify-start "Bon voyage 🛳️"
  git clone https://github.com/rewdy/bonvoyage.git $1
  if [ -z ${1+x} ]; then
    cd bonvoyage || exit 1
  else
    cd "$1" || exit 1
  fi
  notify 'Installing node modules...'
  npm install
  rm -rf .git
  notify-success 'Removed git reference.'
  rm readme.md
  notify-success 'Removed readme file.'
  notify-success 'Done.'
  notify "🎗 Reminder: Before running browsersync, be sure to update the proxy setting in Gruntfile.js."
}

define "toggle-stage-manager" "Turns on or off MacOS Stage Manager"
toggle-stage-manager() {
  enabled=$(defaults read com.apple.WindowManager GloballyEnabled)
  newValue=1
  case "$enabled" in
  "0")
    notify "Stage manager is currently disabled. Enabling..."
    ;;
  *)
    notify "Stage manager is enabled. Disabling..."
    newValue=0
    ;;
  esac
  defaults write com.apple.WindowManager GloballyEnabled -int $newValue
  notify-success "Done."
}

# Make a mp4 from a mov
define "movtomp4" "Creates an .mp4 file from a .mov file"
movtomp4() {
  ending='.mp4'
  if [ -z ${2+x} ]; then
    output=${1:0:-4}
    output=$output$ending
  else
    output=$2
  fi
  notify-start "🎬 Starting to make $output"
  ffmpeg -i "$1" -vcodec h264 -acodec aac -strict -2 "$output"
}

define "node-project-copy" "Copies a node project, excluding node_module, dist, build, .cache, and .yarn dirs"
node-project-copy() {
  # Function to copy a node-based project. Excludes node_modules.
  rsync -rav --exclude=node_modules --exclude=dist --exclude=build --exclude=.cache --exclude=.yarn --exclude=qmk "$1" "$2"
}
define "ncp" "alias of node-project-copy"
alias ncp="node-project-copy"

define "vs-code-colors" "Creates a .vscode settings file and sets the window bar to a random color (or you can pass a hex color code of your choice)"
vs-code-colors() {
  if [ -z "$1" ]; then
    color="#$(openssl rand -hex 3)"
  else
    color="$1"
  fi
  mkdir -p .vscode
  cat <<EOT >>./.vscode/settings.json
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "$color",
    "titleBar.activeForeground": "#f2f2f2"
  }
}
EOT
  notify-success "VSCode Settings Created."
}

define "portcheck" "Checks what is running on a specified port"
function portcheck() {
  lsof -n -i :$@
}

# This kills everything on a port
define "smackdown" "Kills everything on the specified port"
function smackdown() {
  lsof -n -i:$@ |
    grep LISTEN |
    awk '{ print $2 }' |
    uniq |
    xargs -r kill -9
}

# Helper function to check how long it takes shell to load
define "timezsh" "Helper function to see how long it takes z shell to load"
function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 2); do /usr/bin/time $shell -i -c exit; done
}

# this function plus completions is available in the configfiles repo
define "init-python-dir" "Sets up a new python virutalenv in the current directory"
init-python-dir() {
  notify "Setting up python dir..."
  local dirname
  dirname=${PWD##*/}
  pyenv virtualenv $1 ${dirname}
  pyenv local ${dirname}
  notify-success "✨ New virtual configured at $dirname!"
  if [ -f requirements.txt ]; then
    notify "requirements.txt found. installing dependencies..."
    pip install -r requirements.txt
  fi
}

define "config" "Opens up shell config in vs code"
config() {
  code ~/.configfiles
}

define "source-config" "Reloads the zsh config"
source-config() {
  exec zsh
}

alias refresh=source-config

define "config-help" "Shows these help docs"
config-help() {
  for line in "${usage[@]}"; do echo -e "$line"; done | column -t -s'~'
}

alias help=config-help
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
  echo -e "\033[34m  $1\033[0m"
}

define "notify-start" "Notifies a process is starting"
notify-start() {
  echo ""
  echo -e "\033[44m   $1 \033[0m"
  echo ""
}

define "notify-success" "Notifies a process has succeeded"
notify-success() {
  echo -e "\033[32m  $1\033[0m"
}

define "notify-fail" "Notifies a process has failed"
notify-fail() {
  echo -e "\033[31m  $1\033[0m"
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

define "toggle-dark" "Toggles on or off MacOS dark mode"
toggle-dark() {
  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
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

# Make a mp4 from a mov
define "movtogif" "Creates an .gif file from a .mov file"
movtogif() {
  ending='.gif'
  scale=640
  if [ -z ${2+x} ]; then
    output=${1:0:-4}
    output=$output$ending
  else
    output=$2
  fi
  notify-start "🎬 Starting to make $output"
  ffmpeg -i "$1" -vf "fps=10,scale=$scale:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$output"
}

define "data-encode-img" "Encodes an image to base64 and adds to clipboard"
data-encode-img() {
  if [ -z ${1+x} ]; then
    notify-fail "Please provide a path to an image file!"
    return 1
  fi
  case "${1##*.}" in
  jpg | jpeg)
    mime_type="image/jpeg"
    ;;
  png)
    mime_type="image/png"
    ;;
  gif)
    mime_type="image/gif"
    ;;
  svg)
    mime_type="image/svg+xml"
    ;;
  *)
    notify-fail "Unsupported file type!"
    return 1
    ;;
  esac
  encoded=$(base64 -i "$1")
  datauri="data:$mime_type;base64,$encoded"
  size=$(echo "$encoded" | wc -c | awk '{print int($1/1024)}')
  echo -e "\033[34mℹ️ Encoded image size: ${size}kb\033[0m"
  echo "$datauri" | pbcopy
  notify-success "Image encoded and copied to clipboard!"
}

define "node-project-copy" "Copies a node project, excluding node_module, dist, build, .cache, and .yarn dirs"
node-project-copy() {
  # Function to copy a node-based project. Excludes node_modules.
  rsync -rav --exclude=node_modules --exclude=dist --exclude=build --exclude=.cache --exclude=.yarn --exclude=qmk "$1" "$2"
}
define "ncp" "alias of node-project-copy"
alias ncp="node-project-copy"

define "yarn-clean-reinstall" "Removes node_modules and yarn.lock then reinstalls dependencies"
yarn-clean-reinstall() {
  notify-start "🧹 Removing node_modules and yarn.lock, reinstalling"
  rm -rf node_modules yarn.lock
  yarn install
  notify-success "🎉 Done."
}
define "ycri" "alias of yarn-clean-reinstall"
alias ycri=yarn-clean-reinstall

define "make-nerd-font" "Patches a ttf file to create a nerd font"
make-nerd-font() {
  if [ -s "$1" ]; then
    patched_dir="$PWD/$1 Patched"
    docker_patcher_img="nerdfonts/patcher"
    mkdir "$patched_dir"
    docker run --rm -v "$PWD/$1":/in:Z -v "$patched_dir":/out:Z $docker_patcher_img
  else
    notify-fail "Please provide a path to a directory containing .ttf files!"
    return 1
  fi
}

define "yarn-add-resolution" "Adds a resolution to package.json, yarn style."
yarn-add-resolution() {
  if [ "$#" -eq 0 ]; then
    notify-fail "Please provide at least one package name and version in the format package@version"
    return 1
  fi

  notify-start "🔏 Adding resolutions to package.json"

  for pkg in "$@"; do
    if [[ "$pkg" != *@* ]]; then
      notify-fail "Invalid format for $pkg. Please provide in the format package@version"
      return 1
    fi

    package_name="${pkg%@*}"
    version="${pkg#*@}"
    jq --arg pkg "$package_name" --arg ver "$version" '.resolutions[$pkg] = $ver' package.json >tmp.$$.json && mv tmp.$$.json package.json
  done

  notify-success "🎉 Done."
}

define "vscode-colors" "Creates a .vscode settings file and sets the window bar to a random color (or you can pass a hex color code of your choice)"
vscode-colors() {
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

define "cdo" "cds to the directory and opens it in vscode"
cdo() {
  z "$1" || cd "$1" || exit 1
  code .
}

define "print-colors" "Prints a table of ANSI color codes"
print-colors() {
    for i in {0..15}; do
        # Print the color number and the corresponding color
        printf "\e[48;5;${i}m %3d \e[0m " $i
        # Print a newline after every 8 colors for better readability
        if [ $(( (i + 1) % 8 )) -eq 0 ]; then
            echo
        fi
    done
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

define "trash" "Moves a file to the trash"
trash() { mv -fv "$@" ~/.Trash/; }

define "cert-issue" "Checks to see if a site has a valid SSL cert"
cert-issue() {
  echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -issuer
}

define "cert-info" "Checks to get info on a cert"
cert-info() {
  echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -text
}

define "config-help" "Shows these help docs"
config-help() {
  for line in "${usage[@]}"; do echo -e "$line"; done | column -t -s'~'
}

alias help=config-help

############################################################
# Helper functions
############################################################

usage=("")
usage+=("👋 Helper Functions:")
usage+=("-------\n\n")

define() {
  usage+=("    \033[33m$1\033[0m~$2")
}

#
# Output helpers
#

define "notify" "Echos a notify message with styling"
notify() {
  echo -e "\033[34m  $1\033[0m"
}

# Little var that can be set to make the notify start text dark. It is displayed on top of
# the blue color and sometimes white text is unreadable based on the theme.
NOTIFY_TEXT_DARK=1

define "notify-start" "Notifies a process is starting"
notify-start() {
  text_style="\033[44m"
  if [ "$NOTIFY_TEXT_DARK" -eq 1 ]; then
    text_style="\033[44;30m"
  fi
  echo ""
  echo -e "${text_style}   $1 \033[0m"
  echo ""
}

define "notify-success" "Notifies a process has succeeded"
notify-success() {
  echo -e "\033[32m  $1\033[0m"
}

define "notify-warning" "Notifies with a warning"
notify-warning() {
  echo -e "\033[33m  $1\033[0m"
}
alias notify-warn=notify-warning

define "notify-fail" "Notifies a process has failed"
notify-fail() {
  echo -e "\033[31m  $1\033[0m"
}

define "notify-calm" "Notifies with a calm message"
notify-calm() {
  echo -e "\033[1;30m$1\033[0m"
}

#
# String generation
#

define "date-string" "Generates a datestring; can be used to generate timestamps"
date-string() {
  date "+%Y%m%d-%H%M%S"
}

define "get-uuid" "Generates a UUID4 and copies it to clipboard"
get-uuid() {
  uuid=$(uuidgen)
  uuid=$(echo "$uuid" | tr '[:upper:]' '[:lower:]')
  echo -n "$uuid" | pbcopy
  notify "UUID copied to clipboard: $uuid"
}

#
# Utilities
#

define "toggle-dark" "Toggles on or off MacOS dark mode"
toggle-dark() {
  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
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

define "cd-repo" "Changes directory to the root of the current git repo"
cd-repo() {
  # Check if we're in a git repo
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1
  then
    # Get the root of the git repo
    repo_root=$(git rev-parse --show-toplevel)
    cd "$repo_root" || notify-fail "Could not cd to $repo_root"
  else
    notify-fail "Not inside a git repository"
  fi
}
alias cdr=cd-repo

define "code-repo" "Opens the root of the current git repo in VSCode"
code-repo() {
  # Check if we're in a git repo
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Get the root of the git repo
    repo_root=$(git rev-parse --show-toplevel)
    code "$repo_root"
  else
    notify-warn "Not inside a git repository; will open where you are."
    code .
  fi
}
define "coder" "alias for code-repo"
alias coder=code-repo

define "port-check" "Checks what is running on a specified port"
function port-check() {
  lsof -n -i :"$1"
}

# This kills everything on a port
define "smackdown" "Kills everything on the specified port"
function smackdown() {
  lsof -n -i:"$1" |
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

define "cert-issue" "Checks to see if a site has a valid SSL cert"
cert-issue() {
  echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -issuer
}

define "cert-info" "Checks to get info on a cert"
cert-info() {
  echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -text
}

#
# Scripts (basically)
#

define "mov-to-mp4" "Creates an .mp4 file from a .mov file"
mov-to-mp4() {
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
define "mov-to-gif" "Creates an .gif file from a .mov file"
mov-to-gif() {
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

define "cdo" "cds to the directory and opens it in vscode"
cdo() {
  z "$1" || cd "$1" || return 1
  "$EDITOR_TOOL" .
}

define "run-with-timer" "Runs a command and shows a ticking timer while it's running. Usage: run-with-timer <command>"
run-with-timer() {
  if [ -z "$1" ]; then
    notify-fail "Please provide a command to run."
    return 1
  fi

  notify-start "Running command: $*"
  start_time=$(date +%s)

  # Start the command in the background
  "$@" &
  cmd_pid=$!

  # Start a timer
  (
    while kill -0 $cmd_pid 2>/dev/null; do
      elapsed=$(( $(date +%s) - start_time ))
      printf "\r🕑 Elapsed time: %02d:%02d" $((elapsed / 60)) $((elapsed % 60))
      sleep 1
    done
  ) &
  timer_pid=$!
  # Wait for the command to finish
  wait $cmd_pid

  # Kill the timer
  kill $timer_pid 2>/dev/null

  end_time=$(date +%s)
  total_time=$((end_time - start_time))

  echo ""
  notify-success "Command completed in $total_time seconds."
}

define "scad-to-stl" "Converts a .scad file to .stl using OpenSCAD"
scad-to-stl() {
  if [ -z "$1" ]; then
    echo "Usage: scad-to-stl <file.scad> [output.stl]"
    return 1
  fi

  if [[ "$1" != *.scad ]]; then
    notify-fail "Input file must have .scad extension"
    return 1
  fi

  output="${2:-${1%.scad}.stl}"

  # Check if output has an extension
  if [[ "$output" == *.* ]]; then
    # Has extension, check if it's .stl
    if [[ "$output" != *.stl ]]; then
      echo "Error: Output file must have .stl extension"
      return 1
    fi
  else
    # No extension, add .stl
    output="${output}.stl"
  fi

  notify-start "Converting $1 to $output..."
  openscad --export-format binstl -o "$output" "$1"
  echo ""
  notify-success "Conversion complete: $output"
}

#
# Node utils
#

define "node-project-copy" "Copies a node project, excluding node_module, dist, build, .cache, and .yarn dirs"
node-project-copy() {
  # Function to copy a node-based project. Excludes node_modules.
  rsync -rav --exclude=node_modules --exclude=dist --exclude=build --exclude=.cache --exclude=.yarn --exclude=qmk "$1" "$2"
}
define "ncp" "alias of node-project-copy"
alias ncp="node-project-copy"

#
# Colors
#

define "print-colors" "Prints a table of 16 ANSI color codes"
print-colors() {
  for i in {0..15}; do
    # Print the color number and the corresponding color
    printf "\e[48;5;${i}m %3d \e[0m " $i
    # Print a newline after every 8 colors for better readability
    if [ $(((i + 1) % 8)) -eq 0 ]; then
      echo
    fi
  done
}

define "print-all-colors" "Prints a table of all 255 ANSI color codes"
print-all-colors() {
  echo -e "\n--- ANSI 16 colors\n"
  for i in {0..255}; do
    # Print the color number and the corresponding color
    printf "\e[48;5;${i}m %3d \e[0m \e[38;5;${i}m %3d \e[0m " $i $i
    # Print a newline after every 8 colors for better readability
    if [ $(((i + 1) % 8)) -eq 0 ]; then
      echo
    fi

    if ((i == 15)); then
      echo -e "\n--- Other colors\n"
    fi
  done
}

define "colorize-time" "Colorizes the time output; higher times are bolder"
colorize-time() {
  local time=$1
  if [ $time -lt 1000 ]; then
    # Use a dimmed default foreground so it adapts to light and dark themes.
    printf '\e[2;39m(%d ms)\e[0m\n' "$time"
  elif [ $time -le 3000 ]; then
    # show in yellow
    echo -e "\033[33m($time ms)\033[0m"
  elif [ $time -le 5000 ]; then
    # show in red
    echo -e "\033[31m($time ms)\033[0m"
  else
    # show in red background b/c it's BAD
    echo -e "\033[41;37m $time ms \033[0m"
  fi
}

#
# Config utils
#

define "config" "Opens up shell config in vs code"
config() {
  code ~/.configfiles
}

define "config-dir" "Changes directory to shell config files"
config-dir() {
  cd ~/.configfiles || notify-fail "Could not cd to ~/.configfiles"
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

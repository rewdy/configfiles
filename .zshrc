#
# Super lite .zshrc file I created after reading:
# https://rushter.com/blog/zsh-shell/
#

echo "⏳ Loading..."
config_start=$(($(gdate +%s%N) / 1000000))

export HISTSIZE=500000
export SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY  # save timestamp and duration with each history entry
setopt autocd            # type a directory name to cd into it

# Keep fpath and PATH arrays free of duplicate entries.
typeset -U fpath path

############################################################
# USER CONFIG
############################################################

# Cache eval-based tool initializations to speed up shell startup.
# Re-generates cache only when the binary is newer than the cached file.
_eval_cached() {
  local name=$1; shift
  local cache="$HOME/.cache/zsh-init-cache/${name}.zsh"
  local bin_path cache_tmp status
  bin_path=$(whence -p "$1" 2>/dev/null)
  [[ -z "$bin_path" ]] && return
  if [[ ! -f "$cache" ]] || [[ "$bin_path" -nt "$cache" ]]; then
    mkdir -p "${cache:h}"
    cache_tmp=$(mktemp "${cache}.tmp.XXXXXX") || return
    if "$@" >| "$cache_tmp"; then
      mv -f -- "$cache_tmp" "$cache"
    else
      status=$?
      rm -f -- "$cache_tmp"
      [[ -f "$cache" ]] || return $status
    fi
  fi
  source "$cache"
}

# 🚀✨ Starship prompt
export STARSHIP_CONFIG=~/.configfiles/starship.toml
_eval_cached starship starship init zsh

# Atuin: replaces shell history with a searchable, syncable SQLite database
_eval_cached atuin atuin init zsh

# zsh-defer: defers plugin loading until after the first prompt, keeping startup fast.
# Any plugin sourced via `zsh-defer` will load asynchronously in the background.
source "$HOME/.configfiles/zsh-defer/zsh-defer.plugin.zsh"

# Auto suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history)

# zsh-z: fast directory jumping with tab completion
source $HOME/.configfiles/zsh-z/zsh-z.plugin.zsh

# Enable mise!
_eval_cached mise mise activate zsh

# Add Go binaries after mise has updated PATH, then remove any duplicates.
path=("$HOME/go/bin" $path)

# Worktree integration
_eval_cached worktree-bin worktree-bin shell-init

############################################################
# Load additional config files
############################################################

# A place to put credentials that are not source controlled.
# For things like GITLAB_TOKEN, GITLAB_USERNAME, other tokens, etc.
if [ -f "$HOME/.private-config.sh" ]; then
  source "$HOME/.private-config.sh"
fi

for f in ~/.configfiles/shrcfiles/*.sh; do
  # shellcheck disable=SC1090
  source "$f"
done

# NOTE: All fpath additions must appear before compinit is called below.
# Docker Desktop CLI completions
fpath=($HOME/.docker/completions $fpath)
# zsh-z completions
fpath=($HOME/.configfiles/zsh-z $fpath)
# Added by zshellcheck installer
fpath=($HOME/.local/share/zsh/site-functions $fpath)

# Completion settings
zstyle ':completion:*' menu select

# Single compinit with daily cache — re-scans fpath at most once per day.
# Delete ~/.zcompdump to force an immediate rescan if completions feel stale.
# NOTE: the glob must be expanded via an array assignment. Inside [[ ... ]] zsh
# does not glob, so `[[ -n ~/.zcompdump(#qN.mh+24) ]]` is always true and would
# force a full compinit on every startup.
autoload -Uz compinit bashcompinit
_zcompdump_stale=( ~/.zcompdump(N.mh+24) )
if (( $#_zcompdump_stale )); then
  compinit
else
  compinit -C
fi
unset _zcompdump_stale

# Compile the dump file so future shells load it as bytecode (much faster than parsing text).
# Re-compile only when the dump is newer than the compiled version.
if [[ -s ~/.zcompdump && (! -s ~/.zcompdump.zwc || ~/.zcompdump -nt ~/.zcompdump.zwc) ]]; then
  zcompile ~/.zcompdump
fi

# Defer optional completion and line-editor integrations. Syntax highlighting must
# load last so it can wrap the final set of ZLE widgets.
zsh-defer bashcompinit
zsh-defer source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
zsh-defer source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

############################################################
# Post load
############################################################

# Clears startup noise and prints the ready indicator with elapsed time.

config_end=$(($(gdate +%s%N) / 1000000))
config_elapsed=$(($config_end - $config_start))
elapsed=$(colorize-time $config_elapsed)

# And we're done
clear
echo "$(emoji) Let's go! $elapsed"

# remind-cli hook - This takes about 500ms and isn't configuring the
# shell at all, so putting here after we echo out we're ready.
if [[ $SHLVL -eq 1 && $- == *i* ]]; then
  remind check
fi

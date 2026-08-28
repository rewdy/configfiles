############################################################
# TERMINAL INTEGRATION
############################################################

autoload -Uz add-zsh-hook

# Report cwd via OSC 7 so new tabs/splits open in the same directory. Works in
# Ghostty, cmux, iTerm2, Wezterm, kitty, and any terminal that follows the OSC 7
# convention. Using "localhost" sidesteps Ghostty's hostname validation
# (see ghostty-org/ghostty#9372).
_osc7_cwd() { printf '\e]7;file://localhost%s\a' "$PWD" }
add-zsh-hook chpwd _osc7_cwd
add-zsh-hook precmd _osc7_cwd
_osc7_cwd

# Terminal title via OSC 2: the git repo name when inside a repo, otherwise the
# cwd basename. Ghostty's built-in title feature is turned off via
# `shell-integration-features=no-title` in config.ghostty so it doesn't
# overwrite this. The git lookup costs ~20ms, so the result is memoized per $PWD.
typeset -g _osc2_pwd _osc2_title
_osc2_set_title() {
  if [[ "$PWD" != "$_osc2_pwd" ]]; then
    local -a info
    info=("${(@f)$(command git rev-parse --path-format=absolute \
      --show-toplevel --git-common-dir 2>/dev/null)}")
    if (( ${#info} >= 2 )) && [[ -n "${info[1]}" ]]; then
      # Identity comes from the *common* dir so every worktree of a repo agrees:
      # ".../acme/.git" -> acme, bare ".../acme.git" -> acme. The worktree's own
      # basename is appended only when it differs (i.e. a linked worktree).
      local common=${info[2]} repo wt
      if [[ ${common:t} == .git ]]; then repo=${common:h:t}; else repo=${common:t:r}; fi
      wt=${info[1]:t}
      _osc2_title=$repo
      [[ "$wt" != "$repo" ]] && _osc2_title="$repo:$wt"
    else
      _osc2_title=${(%):-%1~}
    fi
    _osc2_pwd=$PWD
  fi
  printf '\e]2;%s\a' "$_osc2_title"
}
add-zsh-hook chpwd _osc2_set_title
add-zsh-hook precmd _osc2_set_title
_osc2_set_title

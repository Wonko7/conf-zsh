# Key bindings
# ------------
if which sk > /dev/null; then

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  #local cmd="${SKIM_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
  #  -o -type f -print \
  #  -o -type d -print \
  #  -o -type l -print 2> /dev/null | cut -b3-"}"
  local cmd="git ls-tree -r --name-only HEAD || fd --type f || rg --files || find . " # cut?
  setopt localoptions pipefail 2> /dev/null
  eval "$cmd" | $(__skcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

__sk_use_tmux__ () {
  [ -n "$TMUX_PANE" ] && [ "${SKIM_TMUX:-0}" != 0 ]
}

__skcmd() {
  __sk_use_tmux__ &&
    echo "sk-tmux -d${SKIM_HEIGHT:-50} $@ " || echo "sk --height=${SKIM_HEIGHT:-50} $@ "
}

sk-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   sk-file-widget
bindkey '^T' sk-file-widget

# CTRL-R - Paste the selected command from history into the command line
sk-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  # IF you want to use whatever text was present on the prompt as initial query,
  # use what's in this: ${(qqq)LBUFFER} as __skcmd's --query
  # I always end up deleting it, so this is ignores it.

  selected=( $(fc -rl 1 | $(__skcmd --exact)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N   sk-history-widget
bindkey '^R' sk-history-widget

#alias sk="\$(__skcmd)"

else
  echo Could not find sk!
  # meh:
  source ~/.fzf.zsh
fi

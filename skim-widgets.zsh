# Key bindings
# ------------
if [[ $- == *i* ]]; then

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${SKIM_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail 2> /dev/null
  eval "$cmd" | SKIM_DEFAULT_OPTS="--height ${SKIM_TMUX_HEIGHT:-50%} --reverse $SKIM_DEFAULT_OPTS $SKIM_CTRL_T_OPTS" $(__skcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

() {
  # FIXME: add SKIM_TMUX=1 to conf
  [ -n "$TMUX_PANE" ] && [ "${SKIM_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__skcmd() {
  __sk_use_tmux__ &&
    echo "sk-tmux -d${SKIM_TMUX_HEIGHT:-50%}" || echo "sk"
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
  selected=( $(fc -rl 1 | $(__skcmd --query=${(qqq)LBUFFER}) ) )

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

fi

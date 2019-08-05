# Prompt file
# for code ({000..255}) { print -nP -- "$code: %F{$code}Test: %K{$code}Test%k%f " ; (( code % 8 && code < 255 )) || printf '\n'} # colors

autoload -Uz colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zmodload zsh/datetime
zmodload zsh/mathfunc

setopt PROMPT_SUBST
setopt PROMPT_PERCENT

PR_RESET="%{${reset_color}%}";
PR_RESET="%f%k";

COL_BLACK="${PR_RESET}%F{white}%K{black}"
COL_BLACK_TO_SHELL="${PR_RESET}%F{black}"
COL_BLACK_TO_MAG="${PR_RESET}%F{black}%K{magenta}"
COL_BL="${PR_RESET}%F{white}%K{blue}"
COL_BL_TO_MAG="${PR_RESET}%F{blue}%K{magenta}"
COL_BL_TO_SHELL="${PR_RESET}%F{blue}"
COL_MAG="${PR_RESET}%F{white}%K{magenta}"
COL_MAG_TO_BL="$PR_RESET%F{magenta}%K{blue}"
COL_MAG_TO_SHELL="$PR_RESET%F{magenta}"
COL_OR="${PR_RESET}%K{9}%F{white}"
COL_OR_TO_MAG="${PR_RESET}%F{9}%K{magenta}"
COL_OR_TO_SHELL="${PR_RESET}%F{9}"
if [ "$REMOTE_SESSION" = 1 ]; then
  COL_BL="${PR_RESET}%F{white}%K{240}"
  COL_BL_TO_MAG="${PR_RESET}%F{240}%K{52}"
  COL_BL_TO_SHELL="${PR_RESET}%F{240}"
  COL_MAG="${PR_RESET}%F{white}%K{52}"
  COL_MAG_TO_BL="${PR_RESET}%F{52}%K{240}"
  COL_MAG_TO_SHELL="${PR_RESET}%F{52}"
  COL_OR="${PR_RESET}%K{124}%F{white}"
  COL_OR_TO_SHELL="${PR_RESET}%F{124}"
fi

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
# %i - hash
# we parse it later:
FMT_PATH="%R
%b
%5.5i%c%u
%S"

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:*:*'      check-for-changes true
zstyle ':vcs_info:*:*:*'      unstagedstr       "%F{black}✘%f"
zstyle ':vcs_info:*:*:*'      stagedstr         "%F{black}✘%f"
zstyle ':vcs_info:*:prompt:*' actionformats     ""		"$FMT_PATH"
zstyle ':vcs_info:*:prompt:*' formats           ""		"$FMT_PATH"
zstyle ':vcs_info:*:prompt:*' nvcsformats       ""		"%~"
zstyle ':vcs_info:*:prompt:*' get-revision      true

if [ $TERM = screen-256color ]; then
  ZLE_RPROMPT_INDENT=0
fi

# FIXME whyyyyy:
typeset -Ag FG BG FX

_P9K_TIMER_START=0x7FFFFFFF
function powerlevel9k_preexec() {
  _P9K_TIMER_START=$EPOCHREALTIME
}

function powerlevel9k_precmd() {
  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))
  _P9K_TIMER_START=0x7FFFFFFF
}

function precmd()
{
  vcs_info 'prompt'
  local ref
  local vcs=("${(f)vcs_info_msg_1_}")
  #vcs: 1 basedir, 2 branch, 3 commit + action, 4 subdir
  gR=$vcs[1]
  gr=$(basename "$gR")
  b=$vcs[2]
  gs=$vcs[4]

  if [ "$gR" = "%~" ]; then
    # FIXME not sure if this is a good idea:
    gR=$PWD
  fi

  local bookmark=$(sed -nre "s|^export (.*)=\"$gR\"$|\1|p" "$BOOKMARK_SAVE_DIR/$BOOKMARK_SESSION/all" 2> /dev/null | head -n 1)

  #echo sed -nre \""s|^export (.*)=\"$gR\"$|\1|p"\" \""$BOOKMARK_SAVE_DIR/$BOOKMARK_SESSION/all"\"
  #echo $gr $gR $b $gs
  #echo $bookmark



  if [ ! -z "$bookmark" ]; then
    local root="${COL_MAG} ${COL_MAG_TO_BL}${COL_BL} $bookmark "
  else
    local root="${COL_BL} $gR "
  fi

  if [ -z $vcs[3] ]; then
    local vcs_prompt="${root} ${COL_BL_TO_SHELL}${PR_RESET}"
  elif [ "$vcs[4]" = "." ]; then
    local vcs_prompt="${root} ${COL_BL_TO_MAG}${COL_MAG} $b $vcs[3] ${COL_MAG_TO_SHELL}${PR_RESET}"
  else
    local vcs_prompt="${root} ${COL_BL_TO_MAG}${COL_MAG} $b $vcs[3] ${COL_MAG_TO_BL}${COL_BL} $gs ${COL_BL_TO_SHELL}${PR_RESET}"
  fi

  PROMPT="
${vcs_prompt}
${COL_OR} %n@%m ${COL_OR_TO_SHELL}${PR_RESET} "
}

prompt_command_execution_time() {
  local POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  local POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2
  #   $'\uF250' $'\uF251' $'\uF252' $'\uF253' $'\uF254' ⌛ ⏳
  local EXECUTION_TIME_ICON=""

  # Print time in human readable format
  # For that use `strftime` and convert
  # the duration (float) to an seconds
  # (integer).
  # See http://unix.stackexchange.com/a/89748
  local humanReadableDuration
  if (( _P9K_COMMAND_DURATION > 3600 )); then
    humanReadableDuration=$(TZ=GMT; strftime '%H:%M:%S' $(( int(rint(_P9K_COMMAND_DURATION)) )))
  elif (( _P9K_COMMAND_DURATION > 60 )); then
    humanReadableDuration=$(TZ=GMT; strftime '%M:%S' $(( int(rint(_P9K_COMMAND_DURATION)) )))
  elif (( _P9K_COMMAND_DURATION < 0 )); then
    humanReadableDuration="-"
  else
    # If the command executed in seconds, print as float.
    # Convert to float
    if [[ "${POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION}" == "0" ]]; then
      # If user does not want microseconds, then we need to convert
      # the duration to an integer.
      typeset -i humanReadableDuration
    else
      typeset -F ${POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION} humanReadableDuration
    fi
    humanReadableDuration=$_P9K_COMMAND_DURATION
  fi

  #if (( _P9K_COMMAND_DURATION >= POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD )); then
  #  echo "${humanReadableDuration} $EXECUTION_TIME_ICON"
  #fi
  echo "$EXECUTION_TIME_ICON ${humanReadableDuration}"
}

function rprompt
{
  local timestamp='${COL_BL_TO_SHELL}${COL_BL} %(?.%F{46}✔.%F{red}✘ %?) ${COL_MAG_TO_BL}${COL_MAG} $(prompt_command_execution_time) ${COL_BL_TO_MAG}${COL_BL} %T $PR_RESET'
  RPROMPT="$timestamp"
}

add-zsh-hook preexec powerlevel9k_preexec
add-zsh-hook precmd powerlevel9k_precmd
rprompt

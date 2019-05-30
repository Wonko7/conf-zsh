# Prompt file
# for code ({000..255}) { print -nP -- "$code: %F{$code}Test: %K{$code}Test%k%f " ; (( code % 8 && code < 255 )) || printf '\n'} # colors

autoload -Uz colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zmodload zsh/datetime
zmodload zsh/mathfunc

PR_RESET="%{${reset_color}%}";
PR_RESET="%f%k";

COL_BL="${PR_RESET}%F{white}%K{blue}"
COL_BL_TO_MAG="${PR_RESET}%F{blue}%K{magenta}"
COL_BL_TO_SHELL="${PR_RESET}%F{blue}"
COL_MAG="${PR_RESET}%F{white}%K{magenta}"
COL_MAG_TO_BL="$PR_RESET%F{magenta}%K{blue}"
COL_MAG_TO_SHELL="$PR_RESET%F{magenta}"
COL_OR="${PR_RESET}%K{9}%F{white}"
COL_OR_TO_SHELL="${PR_RESET}%F{9}"
if [ ! -z $REMOTE_SESSION ]; then
  COL_BL="${PR_RESET}%F{white}%K{240}"
  COL_BL_TO_MAG="${PR_RESET}%F{240}%K{52}"
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

function vcs () {
  local subdir="%S"
  if [ "$subdir" = "." ]; then
    local vcs="${COL_BL}%R ${COL_BL_TO_MAG}${COL_MAG} %b:%5.5i%c%u ${COL_MAG_TO_BL}${COL_BL} %S${PR_RESET}"
  else
    local vcs="${COL_BL}%R ${COL_BL_TO_MAG}${COL_MAG} %b:%5.5i%c%u ${COL_MAG_TO_SHELL}${PR_RESET}"
  fi

  echo ${vcs}
}

FMT_PATH="${COL_BL}%R ${COL_BL_TO_MAG}${COL_MAG} %b:%5.5i%c%u ${COL_MAG_TO_BL}${COL_BL} %S"

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr       "%F{black}✘%f"
zstyle ':vcs_info:*:prompt:*' stagedstr         "%F{black}✘%f"
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
  ref="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

  ref="${ref/\* /}"
  export b="$ref"
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

function lprompt
{
  local vcs_cwd="${COL_BL} \${vcs_info_msg_1_} ${COL_BL_TO_SHELL}${PR_RESET}"

  PROMPT="
${vcs_cwd}
${COL_OR} %n@%m ${COL_OR_TO_SHELL}$PR_RESET "
}

function rprompt
{
  local timestamp='$PR_RESET%F{blue}$PR_RESET%K{blue} %(?.%F{46}✔.%F{red}✘ %?) %F{magenta}%K{magenta}%F{white} $(prompt_command_execution_time) %F{blue}%K{blue}%F{white} %T $PR_RESET'

  RPROMPT="$timestamp"
}

add-zsh-hook preexec powerlevel9k_preexec
add-zsh-hook precmd powerlevel9k_precmd
rprompt
lprompt

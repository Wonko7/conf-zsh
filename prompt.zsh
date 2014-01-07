# Prompt file

ctime="white"
cvcs="red"
cpath="blue"
cuser="white"
chost="white"
csept="white"
csepb="blue"

autoload -Uz vcs_info

#zrcautoload vcs_info || vcs_info() {return 5}

for COLOR in RED GREEN YELLOW WHITE BLACK CYAN BLUE; do
  eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
  eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
# %i - hash

#FMT_VCS="${PR_BRIGHT_BLUE}(%s)${PR_RESET}"
FMT_HASH="%i"
FMT_BRANCH="[${PR_RED}%b${PR_WHITE}${PR_RESET}:${PR_CYAN}%5.5i${PR_BRIGHT_GREEN}%c%u${PR_RESET}]"				# e.g. master¹²
FMT_ACTION="(${PR_CYAN}%a${PR_RESET}%)"   				# e.g. (rebase-i)
FMT_PATH_PART1="${PR_BRIGHT_BLUE}%R${PR_RESET}"
FMT_PATH_PART2="${PR_BRIGHT_BLUE}%S${PR_RESET}"
FMT_PATH="${FMT_PATH_PART1}${FMT_BRANCH}${FMT_PATH_PART2}"	# e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '*'  				# display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '*'    				# display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats ""		"${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats       ""		"${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""		"%~"
zstyle ':vcs_info:*:prompt:*' get-revision true

setopt extended_glob
setopt prompt_subst

function precmd()
{
  vcs_info 'prompt'

  # Term title
  case $TERM in
    *xterm*|*rxvt*|(dt|k|E)term)
      print -Pn "\e]0;%n@%m:%~\a"
      #preexec () { print -Pn "\e]0;%n@%m:%~\a $1" }
    ;;
  esac

  #set b
  ref="$(git branch 2> /dev/null | egrep '^\*' || echo "")"
  ref="${ref/\* /}"
  export b="$ref"
}

function lprompt
{
  #if [ "$USER" != "root" -a "$USERNAME" != "root" ]; then
  #  local user_host="${PR_BRIGHT_WHITE}%n${at}${PR_BRIGHT_GREEN}%m${PR_RESET}"
  #else
  #  local user_host="${PR_BRIGHT_RED}%n${at}${PR_BRIGHT_GREEN}%m${PR_RESET}"
  #fi

  local vcs_cwd='${vcs_info_msg_1_%%.}'
  local cwd="${PR_BRIGHT_BLUE}${vcs_cwd}${PR_RESET}"
  local user="%B%{$fg[$cuser]%}%n"
  local host="%B%{$fg[$chost]%}%m"

  PROMPT="${PR_RESET}${cwd}
${PR_RESET}$user${PR_BRIGHT_BLUE}@${PR_BRIGHT_WHITE}$host${PR_BRIGHT_BLUE}> ${PR_RESET}"
}

function rprompt
{
  local prompt="%B>%{$fg[$ctime]%}"
  local time="%H:%M"
  local timestamp="%(?..%B%{$fg[$ctime]%}Err %?%b$clr )%{$fg[$cpath]%}%B| $clr%{$fg[$ctime]%}%B%D{$time}"

  RPROMPT="$timestamp$clr"
}

rprompt
lprompt

# vim:filetype=zsh

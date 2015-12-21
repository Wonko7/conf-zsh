# Prompt file

ctime="white"
cvcs="red"
cpath="blue"
cuser="white"
chost="white"
csept="white"
csepb="blue"

autoload -Uz colors
autoload -Uz vcs_info
colors

#zrcautoload vcs_info || vcs_info() {return 5}

#for COLOR in RED GREEN YELLOW WHITE BLACK CYAN BLUE; do
#  eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
#  eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
#done


PR_RESET="%{${reset_color}%}";
PR_RESET="%f%k";

#return
# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
# %i - hash

#FMT_VCS="${PR_BRIGHT_BLUE}(%s)${PR_RESET}"
#FMT_HASH="%i"
#FMT_BRANCH="${PR_RED}%b${PR_WHITE}${PR_RESET}:${PR_CYAN}%5.5i${PR_BRIGHT_GREEN}%c%u${PR_RESET}"
#FMT_ACTION="(${PR_CYAN}%a${PR_RESET}%)"   				# e.g. (rebase-i)
#FMT_PATH_PART1="${PR_BRIGHT_BLUE}%R${PR_RESET}"
#FMT_PATH_PART2="${PR_BRIGHT_BLUE}%S${PR_RESET}"
#FMT_PATH="${FMT_PATH_PART1}${FMT_BRANCH}${FMT_PATH_PART2}"	# e.g. ~/repo/subdir
FMT_PATH="$PR_RESET%F{white}%K{blue}%R $PR_RESET%F{blue}%K{magenta}"$'\ue0b0'$PR_RESET"%F{white}%K{magenta}"$' %b:%5.5i%c%u '"$PR_RESET%F{magenta}%K{blue}"$'\ue0b0'$PR_RESET"%F{white}%K{blue}"' %S'$PR_RESET
# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr "✘"
zstyle ':vcs_info:*:prompt:*' stagedstr "✘"
zstyle ':vcs_info:*:prompt:*' actionformats ""		"${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats       ""		"${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""		"%~"
zstyle ':vcs_info:*:prompt:*' get-revision true

setopt AUTO_LIST
setopt CDABLE_VARS
setopt MARK_DIRS
setopt NO_NULL_GLOB
setopt NO_NO_MATCH
setopt NO_MENU_COMPLETE
setopt NO_AUTO_MENU
setopt NO_CASE_GLOB
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
setopt SH_WORD_SPLIT

setopt NO_IGNORE_EOF

setopt AUTO_CD
setopt AUTO_PUSHD
#setopt PUSHD_TO_HOME
#setopt PUSHD_IGNORE_DUPS

#setopt REMATCH_PCRE
setopt INC_APPEND_HISTORY
setopt extended_glob
setopt prompt_subst
setopt prompt_percent
if [ $TERM = screen-256color ]; then
	ZLE_RPROMPT_INDENT=0
fi


typeset -Ag FG BG FX

function precmd()
{
  vcs_info 'prompt'

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

  local vcs_cwd="%F{white}%K{blue} "'${vcs_info_msg_1_%%.}'"%(2l..%~)%K{blue} $PR_RESET%F{blue}"$'\ue0b0'
  local cwd="${PR_BRIGHT_BLUE}${vcs_cwd}${PR_RESET}"
  #local user="%B%{$fg[$cuser]%}%n"
  #local host="%B%{$fg[$chost]%}%m"

#%K{9}%F{white} %n@%m $PR_RESET%F{9}"$'\ue0b0'" $PR_RESET"
  #PROMPT="%K{9}%F{white} %n@%m $PR_RESET%F{9}"$'\ue0b0'" $PR_RESET"
  PROMPT="
${PR_RESET}${cwd}$PR_RESET
%K{9}%F{white} %n@%m $PR_RESET%F{9}"$'\ue0b0'" $PR_RESET"
}
#$BG['009']
function rprompt
{
  local timestamp="$PR_RESET%F{blue}"$'\ue0b2'"$PR_RESET%K{blue} %(?.%F{46}✔.%F{red}✘ %?) %F{white} %T $PR_RESET"
  #local timestamp=coucou

  RPROMPT="$timestamp"
}

rprompt
lprompt

# vim:filetype=zsh

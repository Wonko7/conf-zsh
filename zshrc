##########################################
###  OPTIONS  ############################
##########################################

autoload -Uz add-zsh-hook

source ~/conf/zsh/env.zsh

setopt AUTO_LIST
setopt MARK_DIRS

setopt NO_NULL_GLOB

setopt NO_NOMATCH
setopt NO_MENU_COMPLETE
setopt NO_AUTO_MENU
setopt NO_CASE_GLOB
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD

setopt AUTO_LIST
setopt NO_GLOB_COMPLETE
setopt NO_GLOB_SUBST
setopt LIST_AMBIGUOUS
#setopt COMPLETE_ALIASES # FIXME check this

setopt SH_WORD_SPLIT # FIXME check this

setopt NO_IGNORE_EOF

setopt AUTO_CD
setopt AUTO_PUSHD
#setopt PUSHD_TO_HOME
#setopt PUSHD_IGNORE_DUPS

#setopt REMATCH_PCRE
# Expire duplicate entries first when trimming history.
setopt INC_APPEND_HISTORY
# Don't record an entry that was just recorded again.
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
# Delete old recorded entry if new entry is a duplicate.
#setopt HIST_IGNORE_ALL_DUPS
# Do not display a line previously found.
setopt HIST_FIND_NO_DUPS
# Don't record an entry starting with a space.
setopt HIST_IGNORE_SPACE
 # Don't write duplicate entries in the history file
setopt HIST_SAVE_NO_DUPS
setopt NO_PROMPT_BANG
setopt NO_BANGHIST

# from prompt.zsh, shouldn't have been there: FIXME check this against complete type
setopt EXTENDED_GLOB

# comp prompt
# remove slash if it's at then end of the line
setopt NO_AUTO_REMOVE_SLASH
setopt AUTO_PARAM_SLASH
# follow symlinks
setopt CHASE_LINKS
setopt ALWAYS_TO_END
# unusable with bookmarks
setopt NO_CDABLEVARS

#source ~/conf/zsh/alias.zsh

##########################################
###  MODIFIERS  ##########################
##########################################

autoload -U age


##########################################
###  COMPLETION  #########################
##########################################

# Comp init
autoload -Uz colors
colors
fpath=(~/conf/zsh/bundle/completions/src ~/conf/zsh/local-completions/src $fpath)
autoload -U compinit
compinit -u

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Automatically update PATH entries:
zstyle ':completion:*' rehash true
# Use ls dircolors:
#eval `dircolors ~/conf/zsh/dircolors-solarized/dircolors.256dark`
zstyle ':completion:*:default' list-colors ${(s.:.)_LS_COLORS}
unset LS_COLORS # FIXME. trying out exa's defaults.
# cd:
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# kill PID:
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# complete users:
zstyle ':completion:*:*:*:users' ''
# message style:
zstyle ':completion:*:descriptions' format "%b%{$fg[red]%}-%{$reset_color%} %{$fg[yellow]%}%d%{$reset_color%}:"
zstyle ':completion:*:warnings' format "%b%{$fg[red]%}-%{$reset_color%} %{$fg[yellow]%}Nothing to see here%{$reset_color%}"
zstyle ':completion:*' list-prompt %SAt %p: TAB or LOL%s
# group matches by tag name:
zstyle ':completion:*' group-name ''

# FIXME check out keep_prefix
# FIXME;   _all_matches _list _oldlist _menu _expand _complete _match _ignored _correct _approximate _prefix

zle -C complete-glob list-choices compglob
compglob () {
  setopt localoptions globsubst
  compset -P '*'
  f=(echo $IPREFIX)
  files=(${IPREFIX}*)
  #display=(${files/${IPREFIX}/${(q)IPREFIX}})
  #glob=(${files/${IPREFIX}/})
  compadd ${files}
}

zstyle ':completion:*' completer _complete _prefix _approximate
zstyle ':completion:*:match:*' original only
#zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:correct:*' insert-unambiguous true
# poor man's fuzzy completion:
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
# was:
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Correction
setopt DVORAK
setopt NO_CORRECTALL
setopt NO_CORRECT


##########################################
###  EDIT  ###############################
##########################################

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


##########################################
###  HISTORY  ############################
##########################################

setopt HIST_IGNORE_DUPS
#setopt HIST_IGNORE_ALL_DUPS seems to make things unavailable in some cases?
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
setopt APPEND_HISTORY

SAVEHIST=100000
HISTSIZE=$SAVEHIST

##########################################
###  HISTORY  ############################
##########################################

# fake-accept-line() {
#	if [[ -n "$BUFFER" ]];
#	then
#		print -S "$BUFFER"
#	fi
#	return 0
#}
#
#zle -N fake-accept-line
#
#down-or-fake-accept-line() {
#	if (( HISTNO == HISTCMD )) && [[ "$RBUFFER" != *$'\n'* ]];
#	then
#		zle fake-accept-line
#	fi
#	zle .down-line-or-history "$@"
#}
#
#zle -N down-line-or-history
#zle -N down-or-fake-accept-line
#bindkey -M vicmd j down-or-fake-accept-line


##########################################
###  SUB CONF  ###########################
##########################################

for i in ~/conf/zsh/*.zsh; do
  source $i
done

bindkey '^l' autosuggest-accept
bindkey '^b' autosuggest-execute

# plugins:
source ~/conf/zsh/bundle/autosuggestions/zsh-autosuggestions.zsh
source ~/conf/zsh/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias nvm_load='$NVM_DIR/nvm.sh && $NVM_DIR/bash_completion'
if [ ! -z $kube_for_life ]; then
  for i in kubectl kops kompose; do
    if [ -x "`which $i`" ]; then
      source <($i completion zsh)
    fi
  done

  if [ -r "/usr/bin/aws_zsh_completer.sh" ]; then
    source /usr/bin/aws_zsh_completer.sh
  fi
fi

# FIXME: why do I need this again?
#     Access to internal hash tables via special associative arrays.
zmodload zsh/parameter


##########################################
###  KEYS  ###############################
##########################################

setopt VI

_bindkey_xclip () {
  cmd=$(history | tail -n1 | sed -re 's/^\S+\s+//')
  $cmd | xclip
  zle reset-prompt
  echo "$cmd | xclip"
}
_bindkey_sudo () {
  cmd=$(history | tail -n1 | sed -re 's/^\S+\s+//')
  sudo $cmd
  zle reset-prompt
  echo "sudo $cmd"
}
zle -N _bindkey_xclip
zle -N _bindkey_sudo
zle -N tm_switch_window

#bindkey -M viins '^i' $fzf_default_completion
bindkey -M viins jj vi-cmd-mode
bindkey -M vicmd '^n' history-incremental-search-forward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^F' fzf-completion
bindkey -M viins '^I' complete-word
#bindkey -M viins '^g' expand-or-complete-prefix
#bindkey -M viins '^g' expand-or-complete
bindkey -M viins '^g' complete-glob
#bindkey -M viins '^I' expand-or-complete-prefix
bindkey -M viins '^x' _bindkey_xclip
#bindkey -M viins '^o' _bindkey_sudo
bindkey -M viins '^o' tm_switch_window # who has time for prefix keys anyway?

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=23
#source ~/conf/zsh/syntax-highlighting-dircolors/zsh-syntax-highlighting.zsh

#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)


#ZSH_HIGHLIGHT_STYLES[default]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold,bg=none
#ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow,bg=none
#ZSH_HIGHLIGHT_STYLES[alias]=fg=green,bg=none
#ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline,bg=none
#ZSH_HIGHLIGHT_STYLES[builtin]=fg=green,bg=none
#ZSH_HIGHLIGHT_STYLES[function]=fg=green,bg=none
#ZSH_HIGHLIGHT_STYLES[command]=fg=green,bg=none
#ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline,bg=none
#ZSH_HIGHLIGHT_STYLES[commandseparator]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green,bg=none
ZSH_HIGHLIGHT_STYLES[path]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[path]=underline,bg=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[path_prefix]=underline,bg=none
#ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=blue,bg=none
#ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan,bg=none
#ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan,bg=none
#ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=cyan,bg=none
#ZSH_HIGHLIGHT_STYLES[assign]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[redirection]=none,bg=none
#ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold,bg=none


##########################################
###  GREETING/TMUX  ######################
##########################################

print_greeting ()
{
	#screenfetch -L
	~/conf/zsh/bundle/neofetch/neofetch -L
	echo
	echo "[32m`uname -a`"
	echo $COLOR_PURPLE
	#curl -m 1 -s http://www.free-reseau.fr/outils/rss/67 | sed -nre "s/\s*.desc.*>(.*)<.*/\1/p" || echo $COLOR_RED free api down.
	fortune -a
	echo "[m"
}

print_separator ()
{
	print -nP "%F{9}"$(head -c $COLUMNS < /dev/zero | sed s/./─/g)${COLOR_RESET} # tr doesn't work on unicode
	#echo ${COLOR_CYAN}$(head -c $COLUMNS < /dev/zero | sed s/./─/g)${COLOR_RESET} # tr doesn't work on unicode
	#echo ${COLOR_RED}$(head -c $COLUMNS < /dev/zero | sed s/./─/g)${COLOR_RESET} # tr doesn't work on unicode
}


bload lol
if [ ! -z "$__tmux_session" ]; then
	print_greeting
	print_separator

	export __tmux_session_path="$__tmux_session_path"
	export __tmux_session="$__tmux_session"
	export __tmux_window="$__tmux_window"

	local l_pwd="$__tmux_session_path/pwd"
	local l_init="$__tmux_session_path/init.sh"
	local dir

	if [ -r "$l_pwd" ]; then
		dir=$(cat "$l_pwd")
		cd "$dir"
	fi

	if [ -r "$l_init" ]; then
		source "$l_init"
	fi

	# history is taken care of in line-init.
	zle -N zle-line-init _tm-exec-init

elif [ ! -z "$LOAD_TMUX_SESSION"  ]; then
	unset INIT_TMUX_SESSION # probably wasn't set, just playing it safe?
	local t="$LOAD_TMUX_SESSION"
	unset LOAD_TMUX_SESSION
	tm "$t"
else
	print_greeting
fi

# exec source init.sh without fucking history up:
function _tm-exec-init
{
	tm_load_history || reset_prompt=1
	# smoother than zle -D zle-line-init, works followed by enter and by ctrl-c:
	_tm-exec-init (){}
	if [ "$reset_prompt" = 1 ]; then
		zle send-break
	fi
}

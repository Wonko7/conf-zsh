##########################################
###  OPTIONS  ############################
##########################################

source ~/conf/zsh/env.zsh

setopt BASH_AUTO_LIST
setopt CDABLE_VARS
setopt MARK_DIRS
setopt NULL_GLOB
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
#setopt SHARE_HISTORY

source ~/conf/zsh/alias.zsh


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
fpath=(~/conf/zsh/completions/src $fpath)
autoload -U compinit
compinit -u

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# comp prompt
unsetopt list_ambiguous	  # mode
setopt auto_remove_slash  # remove slash if it's at then end of the line
setopt chase_links	  # follow symlinks
zstyle ':completion:*' group-name ''

eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

# fuzzy completion:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# kill/killall
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

zstyle ':completion:*:descriptions' format "%b%{$fg[red]%}-%{$reset_color%} %{$fg[yellow]%}%d%{$reset_color%}:"
zstyle ':completion:*:warnings' format "%b%{$fg[red]%}-%{$reset_color%} %{$fg[yellow]%}no match found%{$reset_color%}"

zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Correction
setopt dvorak
setopt correctall

##########################################
###  EDIT  ###############################
##########################################

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

##########################################
###  HISTORY  ############################
##########################################

setopt VI
bindkey -M viins jj vi-cmd-mode
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^n' history-incremental-search-forward
bindkey -M vicmd '^n' history-incremental-search-forward

##########################################
###  HISTORY  ############################
##########################################

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt APPEND_HISTORY

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

##########################################
###  HISTORY  ############################
##########################################

#fake-accept-line() {
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

cd
for i in ~/conf/zsh/*.zsh; do
  source $i
done
source ~/conf/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh


##########################################
###  GREETING  ###########################
##########################################

bload lol
if [ ! -z $INIT_TMUX_SESSION ]; then
	unset LOAD_TMUX_SESSION
	local t=$INIT_TMUX_SESSION
	unset INIT_TMUX_SESSION
	source $t
elif [ ! -z $LOAD_TMUX_SESSION  ]; then
	unset INIT_TMUX_SESSION
	local t=$LOAD_TMUX_SESSION
	unset LOAD_TMUX_SESSION
	tm $t
else
	echo "[32m`uname -a`"
	echo "[m"
	fortune -a
	echo "[31m"
	date "+%d/%m/%y	  %l:%M"
	echo -n "[m"
fi

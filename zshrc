##########################################
###  OPTIONS  ############################
##########################################

source ~/conf/zsh/env.zsh

setopt AUTO_LIST
setopt CDABLE_VARS
setopt MARK_DIRS
setopt NO_NULL_GLOB
setopt NO_NO_MATCH
setopt NO_MENU_COMPLETE
setopt NO_AUTO_MENU
setopt NO_CASE_GLOB
setopt ALWAYS_TO_END
setopt NO_COMPLETE_IN_WORD
setopt SH_WORD_SPLIT

setopt NO_IGNORE_EOF

setopt AUTO_CD
setopt AUTO_PUSHD
#setopt PUSHD_TO_HOME
#setopt PUSHD_IGNORE_DUPS

#setopt REMATCH_PCRE
setopt INC_APPEND_HISTORY

#setopt SHARE_HISTORY

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
fpath=(~/conf/zsh/completions/src ~/conf/zsh/gentoo-zsh-completions/src $fpath)
autoload -U compinit
compinit -u

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# comp prompt
unsetopt list_ambiguous	  # mode
setopt auto_remove_slash  # remove slash if it's at then end of the line
setopt chase_links	  # follow symlinks
zstyle ':completion:*' group-name ''

#eval "$(dircolors -b)"
eval `dircolors ~/conf/zsh/dircolors-solarized/dircolors.256dark`
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: TAB or LOL%s

zstyle ':completion:*' users ''

# fuzzy completion:
# zstyle ':completion:*' completer _expand _complete _correct _prefix _match _list _approximate
# #zstyle ':completion:*' completer _expand _prefix 
# zstyle ':completion:*:correct:*' insert-unambiguous true
# #bindkey '^i' complete-word
# zstyle ':completion:*:match:*' original only
# zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# kill/killall
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

zstyle ':completion:*:descriptions' format "%b%{$fg[red]%}-%{$reset_color%} %{$fg[yellow]%}%d%{$reset_color%}:"
zstyle ':completion:*:warnings' format "%b%{$fg[red]%}-%{$reset_color%} %{$fg[yellow]%}no match found%{$reset_color%}"

zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Correction
setopt dvorak
unsetopt correctall
setopt correct

# TODO: force rehash:
#_force_rehash() {
#  (( CURRENT == 1 )) && rehash
#  return 1	# Because we didn't really complete anything
#}
#
#zstyle ':completion:*' completer \
#  _oldlist _expand _force_rehash _complete ...
#       (where "…" is the rest of whatever you already have in that style).

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

bindkey -M viins '^g' expand-or-complete-prefix

##########################################
###  HISTORY  ############################
##########################################

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
setopt APPEND_HISTORY


HISTSIZE=100000
SAVEHIST=$HISTSIZE
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

for i in ~/conf/zsh/*.zsh ~/conf/payfit/aws/*.zsh; do
  source $i
done

if [ -r "/usr/bin/aws_zsh_completer.sh" ]; then
  source /usr/bin/aws_zsh_completer.sh
fi

for i in kubectl kops kompose; do
  if [ -x `which $i` ]; then
    source <($i completion zsh)
  fi
done
#source ~/conf/zsh/env.zsh

bindkey '^l' autosuggest-accept
bindkey '^b' autosuggest-execute

source ~/conf/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/conf/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh
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
https://github.com/bhilburn/powerlevel9k

##########################################
###  GREETING/TMUX  ######################
##########################################
#

print_greeting ()
{
	screenfetch -L
	echo
	echo "[32m`uname -a`"
	echo $COLOR_PURPLE
	curl -m 1 -s http://www.free-reseau.fr/outils/rss/67 | sed -nre "s/\s*.desc.*>(.*)<.*/\1/p" || echo $COLOR_RED free api down.
	echo "[m"
	fortune -a
}

bload lol
if [ ! -z $INIT_TMUX_SESSION ]; then
	unset LOAD_TMUX_SESSION
	local t=$INIT_TMUX_SESSION
	unset INIT_TMUX_SESSION
	source $t
	print_greeting
elif [ ! -z $LOAD_TMUX_SESSION  ]; then
	unset INIT_TMUX_SESSION
	local t=$LOAD_TMUX_SESSION
	unset LOAD_TMUX_SESSION
	tm $t
else
	print_greeting
fi

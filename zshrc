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
# Expire duplicate entries first when trimming history.
setopt INC_APPEND_HISTORY
# Don't record an entry that was just recorded again.
setopt HIST_IGNORE_DUPS
# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Do not display a line previously found.
setopt HIST_FIND_NO_DUPS
# Don't record an entry starting with a space.
setopt HIST_IGNORE_SPACE
 # Don't write duplicate entries in the history file
setopt HIST_SAVE_NO_DUPS

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
fpath=(~/conf/zsh/completions/src ~/conf/zsh/local-completions/src $fpath)
autoload -U compinit
compinit -u

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# comp prompt
unsetopt list_ambiguous
# remove slash if it's at then end of the line
setopt auto_remove_slash
# follow symlinks
setopt chase_links
#setopt complete_aliases
setopt complete_in_word
setopt always_to_end
# unusable with bookmarks
unsetopt cdablevars

# Automatically update PATH entries:
zstyle ':completion:*' rehash true
# Use ls dircolors:
eval `dircolors ~/conf/zsh/dircolors-solarized/dircolors.256dark`
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
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

# fuzzy completion:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:correct:*' insert-unambiguous false
# poor man's fuzzy completion:
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
# was:
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Correction
setopt dvorak
unsetopt correctall
setopt correct


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
#bindkey -M viins '^r' history-incremental-search-backward
#bindkey -M vicmd '^r' history-incremental-search-backward
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

if [ -r "/usr/bin/aws_zsh_completer.sh" ]; then
  source /usr/bin/aws_zsh_completer.sh
fi

for i in kubectl kops kompose; do

  if [ -x "`which $i`" ]; then
    source <($i completion zsh)
  fi
done
#source ~/conf/zsh/env.zsh

bindkey '^l' autosuggest-accept
bindkey '^b' autosuggest-execute

# plugins:
source ~/conf/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/conf/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias nvm_load='$NVM_DIR/nvm.sh && $NVM_DIR/bash_completion'

export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --exclude node_modules'
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

zmodload zsh/parameter

_bindkey_sudo () {
  cmd=`eval echo $history[$HISTCMD]`
  echo yyy $cmd
  echo yyy $cmd
  sudo $cmd
}
zle -N _bindkey_sudo

#bindkey -M viins '^i' $fzf_default_completion
bindkey -M viins '^F' fzf-completion
bindkey -M viins '^I' expand-or-complete
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^x' _bindkey_sudo

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

# FIXME testing stuff:
chpwd() {
  ls
}

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
	#curl -m 1 -s http://www.free-reseau.fr/outils/rss/67 | sed -nre "s/\s*.desc.*>(.*)<.*/\1/p" || echo $COLOR_RED free api down.
	fortune -a
	echo "[m"
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

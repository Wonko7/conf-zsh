#!/usr/bin/env zsh

COLOR_RED="\033[31;01m"
COLOR_GREEN="\033[32;01m"
COLOR_YELLOW="\033[33;01m"
COLOR_BLUE="\033[34;01m"
COLOR_PURPLE="\033[35;01m"
COLOR_CYAN="\033[36;01m"
COLOR_BLACK="\033[30;01m"
COLOR_NEUTRAL="\033[0m"

COLOR_DARK_RED="\033[0;31;11m"
COLOR_DARK_GREEN="\033[0;32;11m"
COLOR_DARK_YELLOW="\033[0;33;11m"
COLOR_DARK_BLUE="\033[0;34;11m"
COLOR_DARK_PURPLE="\033[0;35;11m"
COLOR_DARK_CYAN="\033[0;36;11m"
COLOR_DARK_BLACK="\033[0;30;11m" # hehe. dark black.

#umask 002
umask u=rwx,g=rwx,o=

#export CLICOLORS=1
#export LSCOLORS=exfxcxdxbxegedabagacad
#export DISPLAY=":0.0"

#if echo $TERM | grep -vq 256color; then
#	#export TERM=$TERM-256color
#fi
export BLOCK_SIZE=human-readable

#export LSCOLORS=CxfxexexbxegedexexCxCx
#export LSCOLORS=dxfxexexbxegedexexdxdx
export MANPATH=/opt/local/man/:$MANPATH
export MANPATH=/Users/$USER/junk/apps/man:$MANPATH

# for gentoo:
#export EPREFIX=/opt/gentoo


export NPM_PACKAGES="${HOME}/.npm-packages"


PATH="/sbin:$PATH"
PATH="/usr/sbin:$PATH"
PATH="/home/$USER/local/bin:$PATH" #perso
PATH="/home/$USER/local/sbin:$PATH" #perso
PATH="/home/$USER/work/local/bin:$PATH" #perso
PATH="/home/$USER/work/local/sbin:$PATH" #perso
PATH="/home/$USER/work/local/lib/node_modules/npm/bin/node-gyp-bin/:$PATH" #perso
PATH="$NPM_PACKAGES/bin:$PATH"
PATH="$PATH:/usr/local/bin" #mtools
export PATH="$PATH:/usr/local/sbin" #mtools
#export PATH="/home/$USER/.cabal/bin:$PATH" #perso

# NODE local first
#export PATH="$PATH:./node_modules/.bin:../node_modules/.bin:./node_modules/eslint-config-payfit/node_modules/.bin"
export PATH="./node_modules/.bin:../node_modules/.bin:./node_modules/eslint-config-payfit/node_modules/.bin:$PATH"

export GOPATH=$HOME/local/go
export PATH="$PATH:$GOPATH/bin"

export PAGER="w3m"
export EDITOR="nvim"

export USERWM=`which xmonad`
#export CLIENT=rxvtc

export CONCURRENCY_LEVEL=3
export FZF_DEFAULT_OPTS='--reverse --inline-info'

LANG=en_US.UTF8
LC_ALL="en_US.UTF8"
LC_CTYPE="en_US.UTF8"
LC_NUMERIC="en_US.UTF8"
LC_TIME="en_US.UTF8"
LC_COLLATE="en_US.UTF8"
LC_MONETARY="en_US.UTF8"
LC_MESSAGES="en_US.UTF8"
LC_PAPER="en_US.UTF8"
LC_NAME="en_US.UTF8"
LC_ADDRESS="en_US.UTF8"
LC_TELEPHONE="en_US.UTF8"
LC_MEASUREMENT="en_US.UTF8"
LC_IDENTIFICATION="en_US.UTF8"
## LANG=en_US.UTF-8
## LC_ALL="en_US.UTF-8"
## LC_CTYPE="en_US.UTF-8"
## LC_NUMERIC="en_US.UTF-8"
## LC_TIME="en_US.UTF-8"
## LC_COLLATE="en_US.UTF-8"
## LC_MONETARY="en_US.UTF-8"
## LC_MESSAGES="en_US.UTF-8"
## LC_PAPER="en_US.UTF-8"
## LC_NAME="en_US.UTF-8"
## LC_ADDRESS="en_US.UTF-8"
## LC_TELEPHONE="en_US.UTF-8"
## LC_MEASUREMENT="en_US.UTF-8"
## LC_IDENTIFICATION="en_US.UTF-8"


# export PATH="$EPREFIX/bin:$EPREFIX/usr/bin:$PATH"
# export PATH="$EPREFIX/sbin:$EPREFIX/usr/sbin:$PATH"
#export PATH="$PATH:/opt/local/bin"
# export PATH="$PATH:$EPREFIX/bin:$EPREFIX/usr/bin"
# export PATH="$PATH:$EPREFIX/sbin:$EPREFIX/usr/sbin"
# fink
#test -r /sw/bin/init.sh && . /sw/bin/init.sh
#export CDPATH="~"

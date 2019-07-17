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
export DISPLAY=":0"
export GDK_DPI_SCALE=1.5
export GPG_TTY=$(tty)


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

export CONCURRENCY_LEVEL=3
export FZF_DEFAULT_OPTS='--reverse --inline-info'

## because fuck you ansible.
export ANSIBLE_NOCOWS=1

## because fuck you android-studio vs tiling.
export _JAVA_AWT_WM_NONREPARENTING=1

# X stuff;
##  XDG:
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
##  KDE:
export QT_QPA_PLATFORMTHEME="lxqt"


# solarized dark colors:
_LS_COLORS='no=00;38;5;244:rs=0:di=00;38;5;33:ln=00;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:cd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:ca=30;41:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:ex=00;38;5;64:*.tar=00;38;5;61:*.tgz=00;38;5;61:*.arj=00;38;5;61:*.taz=00;38;5;61:*.lzh=00;38;5;61:*.lzma=00;38;5;61:*.tlz=00;38;5;61:*.txz=00;38;5;61:*.zip=00;38;5;61:*.z=00;38;5;61:*.Z=00;38;5;61:*.dz=00;38;5;61:*.gz=00;38;5;61:*.lz=00;38;5;61:*.xz=00;38;5;61:*.bz2=00;38;5;61:*.bz=00;38;5;61:*.tbz=00;38;5;61:*.tbz2=00;38;5;61:*.tz=00;38;5;61:*.deb=00;38;5;61:*.rpm=00;38;5;61:*.jar=00;38;5;61:*.rar=00;38;5;61:*.ace=00;38;5;61:*.zoo=00;38;5;61:*.cpio=00;38;5;61:*.7z=00;38;5;61:*.rz=00;38;5;61:*.apk=00;38;5;61:*.gem=00;38;5;61:*.jpg=00;38;5;136:*.JPG=00;38;5;136:*.jpeg=00;38;5;136:*.gif=00;38;5;136:*.bmp=00;38;5;136:*.pbm=00;38;5;136:*.pgm=00;38;5;136:*.ppm=00;38;5;136:*.tga=00;38;5;136:*.xbm=00;38;5;136:*.xpm=00;38;5;136:*.tif=00;38;5;136:*.tiff=00;38;5;136:*.png=00;38;5;136:*.PNG=00;38;5;136:*.svg=00;38;5;136:*.svgz=00;38;5;136:*.mng=00;38;5;136:*.pcx=00;38;5;136:*.dl=00;38;5;136:*.xcf=00;38;5;136:*.xwd=00;38;5;136:*.yuv=00;38;5;136:*.cgm=00;38;5;136:*.emf=00;38;5;136:*.eps=00;38;5;136:*.CR2=00;38;5;136:*.ico=00;38;5;136:*.tex=00;38;5;245:*.rdf=00;38;5;245:*.owl=00;38;5;245:*.n3=00;38;5;245:*.ttl=00;38;5;245:*.nt=00;38;5;245:*.torrent=00;38;5;245:*.xml=00;38;5;245:*Makefile=00;38;5;245:*Rakefile=00;38;5;245:*Dockerfile=00;38;5;245:*build.xml=00;38;5;245:*rc=00;38;5;245:*1=00;38;5;245:*.nfo=00;38;5;245:*README=00;38;5;245:*README.txt=00;38;5;245:*readme.txt=00;38;5;245:*.md=00;38;5;245:*README.markdown=00;38;5;245:*.ini=00;38;5;245:*.yml=00;38;5;245:*.cfg=00;38;5;245:*.conf=00;38;5;245:*.h=00;38;5;245:*.hpp=00;38;5;245:*.c=00;38;5;245:*.cpp=00;38;5;245:*.cxx=00;38;5;245:*.cc=00;38;5;245:*.objc=00;38;5;245:*.sqlite=00;38;5;245:*.go=00;38;5;245:*.sql=00;38;5;245:*.csv=00;38;5;245:*.log=00;38;5;240:*.bak=00;38;5;240:*.aux=00;38;5;240:*.lof=00;38;5;240:*.lol=00;38;5;240:*.lot=00;38;5;240:*.out=00;38;5;240:*.toc=00;38;5;240:*.bbl=00;38;5;240:*.blg=00;38;5;240:*~=00;38;5;240:*#=00;38;5;240:*.part=00;38;5;240:*.incomplete=00;38;5;240:*.swp=00;38;5;240:*.tmp=00;38;5;240:*.temp=00;38;5;240:*.o=00;38;5;240:*.pyc=00;38;5;240:*.class=00;38;5;240:*.cache=00;38;5;240:*.aac=00;38;5;166:*.au=00;38;5;166:*.flac=00;38;5;166:*.mid=00;38;5;166:*.midi=00;38;5;166:*.mka=00;38;5;166:*.mp3=00;38;5;166:*.mpc=00;38;5;166:*.ogg=00;38;5;166:*.opus=00;38;5;166:*.ra=00;38;5;166:*.wav=00;38;5;166:*.m4a=00;38;5;166:*.axa=00;38;5;166:*.oga=00;38;5;166:*.spx=00;38;5;166:*.xspf=00;38;5;166:*.mov=00;38;5;166:*.MOV=00;38;5;166:*.mpg=00;38;5;166:*.mpeg=00;38;5;166:*.m2v=00;38;5;166:*.mkv=00;38;5;166:*.ogm=00;38;5;166:*.mp4=00;38;5;166:*.m4v=00;38;5;166:*.mp4v=00;38;5;166:*.vob=00;38;5;166:*.qt=00;38;5;166:*.nuv=00;38;5;166:*.wmv=00;38;5;166:*.asf=00;38;5;166:*.rm=00;38;5;166:*.rmvb=00;38;5;166:*.flc=00;38;5;166:*.avi=00;38;5;166:*.fli=00;38;5;166:*.flv=00;38;5;166:*.gl=00;38;5;166:*.m2ts=00;38;5;166:*.divx=00;38;5;166:*.webm=00;38;5;166:*.axv=00;38;5;166:*.anx=00;38;5;166:*.ogv=00;38;5;166:*.ogx=00;38;5;166:';

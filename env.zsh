#!/usr/bin/env zsh

export BOOKMARK_SAVE_DIR=~/conf/private/bookmarks
if [ ! -d $BOOKMARK_SAVE_DIR ]; then
  export BOOKMARK_SAVE_DIR=~/conf/zsh/bookmarks
fi

export TMUX_SESSION_SAVE_DIR=~/conf/private/tmux-sessions
if [ ! -d $TMUX_SESSION_SAVE_DIR ]; then
  export TMUX_SESSION_SAVE_DIR=~/conf/zsh/tmux-sessions
fi

export PASSWORD_STORE_DIR=~/conf/private/pass
if [ ! -d $PASSWORD_STORE_DIR ]; then
  export PASSWORD_STORE_DIR=~/.password-store
fi
export PASSWORD_STORE_GENERATED_LENGTH=33

HISTFILE=~/conf/private/history/$(hostname).history
if [ ! -r $HISTFILE ]; then
  echo WARNING, had to create $HISTFILE
  mkdir -p $(dirname $HISTFILE)
  touch $HISTFILE
fi

#umask 002
umask u=rwx,g=rwx,o=

export PAGER="w3m"
export EDITOR="nvim"
export USERWM=`which xmonad`

export HOST=$(hostname)

export BLOCK_SIZE=human-readable
export CONCURRENCY_LEVEL=3

export FZF_DEFAULT_OPTS='--reverse --inline-info'
export SKIM_TMUX=0 # only use tmux if needed.
export SKIM_HEIGHT=30%
export SKIM_DEFAULT_OPTIONS="--tiebreak=index --layout=reverse --exact --case=ignore"

export PINENTRY_USER_DATA=0

case $HOST in
  yggdrasill)
    export CONCURRENCY_LEVEL=7
    ## X stuff;
    export GDK_SCALE=3
    export GDK_DPI_SCALE=0.4
    ;;
  daban-urnud)
    ## X stuff;
    export GDK_SCALE=1
    export GDK_DPI_SCALE=1
    ;;
  nostromo|undefined|underage)
    export REMOTE_SESSION=1
    export PINENTRY_USER_DATA=1
    ;;
esac



## dev lang dependant:
export GOPATH=$HOME/local/go
export NPM_PACKAGES="${HOME}/.npm-packages"

## path:
PATH="/sbin:$PATH"
PATH="/usr/sbin:$PATH"

# my local stuff:
PATH="$HOME/local/bin:$PATH"
PATH="$HOME/local/sbin:$PATH"
# dev:
PATH="$NPM_PACKAGES/bin:$PATH"
PATH="./node_modules/.bin:$PATH"
PATH="$GOPATH/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
# I don't like this:
PATH="$HOME/.skim/bin:$PATH"

export PATH="$PATH"

## XDG:
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
## X stuff;
export QT_QPA_PLATFORMTHEME="lxqt"
export GPG_TTY=$(tty)

# solarized dark colors:
_LS_COLORS='no=00;38;5;244:rs=0:di=00;38;5;33:ln=00;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:cd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:ca=30;41:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:ex=00;38;5;64:*.tar=00;38;5;61:*.tgz=00;38;5;61:*.arj=00;38;5;61:*.taz=00;38;5;61:*.lzh=00;38;5;61:*.lzma=00;38;5;61:*.tlz=00;38;5;61:*.txz=00;38;5;61:*.zip=00;38;5;61:*.z=00;38;5;61:*.Z=00;38;5;61:*.dz=00;38;5;61:*.gz=00;38;5;61:*.lz=00;38;5;61:*.xz=00;38;5;61:*.bz2=00;38;5;61:*.bz=00;38;5;61:*.tbz=00;38;5;61:*.tbz2=00;38;5;61:*.tz=00;38;5;61:*.deb=00;38;5;61:*.rpm=00;38;5;61:*.jar=00;38;5;61:*.rar=00;38;5;61:*.ace=00;38;5;61:*.zoo=00;38;5;61:*.cpio=00;38;5;61:*.7z=00;38;5;61:*.rz=00;38;5;61:*.apk=00;38;5;61:*.gem=00;38;5;61:*.jpg=00;38;5;136:*.JPG=00;38;5;136:*.jpeg=00;38;5;136:*.gif=00;38;5;136:*.bmp=00;38;5;136:*.pbm=00;38;5;136:*.pgm=00;38;5;136:*.ppm=00;38;5;136:*.tga=00;38;5;136:*.xbm=00;38;5;136:*.xpm=00;38;5;136:*.tif=00;38;5;136:*.tiff=00;38;5;136:*.png=00;38;5;136:*.PNG=00;38;5;136:*.svg=00;38;5;136:*.svgz=00;38;5;136:*.mng=00;38;5;136:*.pcx=00;38;5;136:*.dl=00;38;5;136:*.xcf=00;38;5;136:*.xwd=00;38;5;136:*.yuv=00;38;5;136:*.cgm=00;38;5;136:*.emf=00;38;5;136:*.eps=00;38;5;136:*.CR2=00;38;5;136:*.ico=00;38;5;136:*.tex=00;38;5;245:*.rdf=00;38;5;245:*.owl=00;38;5;245:*.n3=00;38;5;245:*.ttl=00;38;5;245:*.nt=00;38;5;245:*.torrent=00;38;5;245:*.xml=00;38;5;245:*Makefile=00;38;5;245:*Rakefile=00;38;5;245:*Dockerfile=00;38;5;245:*build.xml=00;38;5;245:*rc=00;38;5;245:*1=00;38;5;245:*.nfo=00;38;5;245:*README=00;38;5;245:*README.txt=00;38;5;245:*readme.txt=00;38;5;245:*.md=00;38;5;245:*README.markdown=00;38;5;245:*.ini=00;38;5;245:*.yml=00;38;5;245:*.cfg=00;38;5;245:*.conf=00;38;5;245:*.h=00;38;5;245:*.hpp=00;38;5;245:*.c=00;38;5;245:*.cpp=00;38;5;245:*.cxx=00;38;5;245:*.cc=00;38;5;245:*.objc=00;38;5;245:*.sqlite=00;38;5;245:*.go=00;38;5;245:*.sql=00;38;5;245:*.csv=00;38;5;245:*.log=00;38;5;240:*.bak=00;38;5;240:*.aux=00;38;5;240:*.lof=00;38;5;240:*.lol=00;38;5;240:*.lot=00;38;5;240:*.out=00;38;5;240:*.toc=00;38;5;240:*.bbl=00;38;5;240:*.blg=00;38;5;240:*~=00;38;5;240:*#=00;38;5;240:*.part=00;38;5;240:*.incomplete=00;38;5;240:*.swp=00;38;5;240:*.tmp=00;38;5;240:*.temp=00;38;5;240:*.o=00;38;5;240:*.pyc=00;38;5;240:*.class=00;38;5;240:*.cache=00;38;5;240:*.aac=00;38;5;166:*.au=00;38;5;166:*.flac=00;38;5;166:*.mid=00;38;5;166:*.midi=00;38;5;166:*.mka=00;38;5;166:*.mp3=00;38;5;166:*.mpc=00;38;5;166:*.ogg=00;38;5;166:*.opus=00;38;5;166:*.ra=00;38;5;166:*.wav=00;38;5;166:*.m4a=00;38;5;166:*.axa=00;38;5;166:*.oga=00;38;5;166:*.spx=00;38;5;166:*.xspf=00;38;5;166:*.mov=00;38;5;166:*.MOV=00;38;5;166:*.mpg=00;38;5;166:*.mpeg=00;38;5;166:*.m2v=00;38;5;166:*.mkv=00;38;5;166:*.ogm=00;38;5;166:*.mp4=00;38;5;166:*.m4v=00;38;5;166:*.mp4v=00;38;5;166:*.vob=00;38;5;166:*.qt=00;38;5;166:*.nuv=00;38;5;166:*.wmv=00;38;5;166:*.asf=00;38;5;166:*.rm=00;38;5;166:*.rmvb=00;38;5;166:*.flc=00;38;5;166:*.avi=00;38;5;166:*.fli=00;38;5;166:*.flv=00;38;5;166:*.gl=00;38;5;166:*.m2ts=00;38;5;166:*.divx=00;38;5;166:*.webm=00;38;5;166:*.axv=00;38;5;166:*.anx=00;38;5;166:*.ogv=00;38;5;166:*.ogx=00;38;5;166:';

COLOR_RED="\033[31;01m"
COLOR_GREEN="\033[32;01m"
COLOR_YELLOW="\033[33;01m"
COLOR_BLUE="\033[34;01m"
COLOR_PURPLE="\033[35;01m"
COLOR_CYAN="\033[36;01m"
COLOR_BLACK="\033[30;01m"
COLOR_NEUTRAL="\033[0m"
COLOR_RESET="\033[0m"

COLOR_DARK_RED="\033[0;31;11m"
COLOR_DARK_GREEN="\033[0;32;11m"
COLOR_DARK_YELLOW="\033[0;33;11m"
COLOR_DARK_BLUE="\033[0;34;11m"
COLOR_DARK_PURPLE="\033[0;35;11m"
COLOR_DARK_CYAN="\033[0;36;11m"
COLOR_DARK_BLACK="\033[0;30;11m"

## because fuck you:
## because fuck you ansible.
export ANSIBLE_NOCOWS=1
## because fuck you android-studio vs tiling.
export _JAVA_AWT_WM_NONREPARENTING=1

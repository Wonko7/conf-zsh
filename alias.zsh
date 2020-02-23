#!/usr/bin/env zsh

## heh... why the fuck not?
alias e="emacs -nw"
alias v="~/conf/misc/scripts/nvim.sh"
alias vv="VIM_SERVER=DANCE_COMMANDER ~/conf/misc/scripts/nvim.sh"
alias p="popd"
alias c="dirs -c"
alias g="git"
alias sc="systemctl"
alias z="xscreensaver-command --lock"
alias mute="pactl set-sink-volume 0 30%; pactl set-sink-volume 1 20%; pactl set-sink-mute 1 true; pactl set-sink-mute 0 true"
# might change this:
alias m=mute

#alias h="history 0 | rg "
function h ()
{
	# sorts by command number, non consistent. sync them? go extended and get date and sort? <- overkill, right?
	rg --no-heading -n "$@" $zhistory/ | sed -re 's|^.*/([^:]+)\.history:([^:]+):|\2:\1\t|g' | sort -n
}

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"

alias eu="emerge --with-bdeps=y --complete-graph=y --keep-going --verbose-conflicts -uDNaAv "
alias dmesg="dmesg -He"
alias cal="cal -m"

alias ip="ip -c -h"

alias rg="rg -S --type-add 'clj:*.{clj,cljc,cljs}'"
alias rgf="rg -S --type-add 'clj:*.{clj,cljc,cljs}' --files-with-matches"
alias rgu="rg -S --type-add 'clj:*.{clj,cljc,cljs}' --unrestricted"
alias rgr="rg -S --type-add 'clj:*.{clj,cljc,cljs}' --no-filename --no-line-number"

alias psack="ps aux | ack "
alias psrg="ps aux | rg "
alias psc='ps xawf -eo pid,user,cgroup,args'

alias ncdu="ncdu --confirm-quit"

if [ -x "$(which exa)" ]; then
  alias ls="exa --group-directories-first"
  alias ll="exa -l --group-directories-first"
  alias la="exa -la --group-directories-first"
  alias lla="exa -la --group-directories-first"
  alias lsd="exa -la --sort=date --group-directories-first"
  alias t="exa --group-directories-first --tree"
  alias ds="exa --group-directories-first -ld */"
  alias lds="exa --group-directories-first -ld */"
else
  alias ls="ls --color=auto"
  alias ll="ls -l --color=auto"
  alias la="ls -A --color=auto"
  alias lla="ls -lA --color=auto"
  alias lsd="ls -lAc --color=auto"
  alias t="tree -AC"
  function ds ()
  {
	  if [ -z "$@" ]; then
		  arg="."
	  else
		  arg="$@"
	  fi
	  find  "$arg" -maxdepth 1 -type d \! -name . -printf '%f/\n' | sort | column
  }

fi

alias rm='rm -i'
alias rmf='rm -rf'
alias rms='echo Stallman was right.'

alias cp="rsync -hrlpD --progress"

alias tarc='tar -cavf '
alias tarx='tar -xavf '
alias tart='tar -tavf '

#alias am="udisksctl mount --block-device "
#alias aum="udisksctl unmount --block-device "

function am () {
	udisksctl mount --block-device $@
}

function aum () {
	udisksctl unmount --block-device $@
}

function _lsblk_completion () {
	reply=($(lsblk -o PATH -l --noheading))
}

compctl -K _lsblk_completion aum
compctl -K _lsblk_completion am

alias sudo='command sudo '
alias sudop='command sudo -u portage '
alias sv="sudoedit"
alias svp="sudoedit -u portage"
alias lowcpu='systemd-run --gid=portage --setenv=HOME=/root -t --slice=lowCPU.slice '
compdef _precommand sudo
compdef _precommand lowcpu

alias yt="youtube-dl -x --no-playlist "

force_session ()
{
	if [ "$1" = "remote" ]; then
		export REMOTE_SESSION=1
	else
		export REMOTE_SESSION=0
	fi
	export PINENTRY_USER_DATA=$REMOTE_SESSION
	source ~/conf/zsh/prompt.zsh
}

"s6-svc-list" () # haha, didn't expect that to work.
{
  for s in "$1"/*/; do
    echo $(basename "$s") $(s6-svstat "$s")
  done | column -t -o ' '
}

catcert ()
{
	address=$1
	port=`[ -z "$2" ] && echo 443 || echo $2`
	echo "$address:$port"
	echo "Running: echo | openssl s_client -showcerts -servername $address -connect $address:$port 2>/dev/null | openssl x509 -inform pem -noout -text"
	echo | openssl s_client -showcerts -servername $address -connect $address:$port 2>/dev/null | openssl x509 -inform pem -noout -text
}

print_colors ()
{
	code=$1
	print -nP -- "$code: %F{$code}Test: %K{$code}Test%k%f " ; (( code % 8 && code < 255 )) || printf '\n'
}

lol ()
{
	i=1
	while true; do
		s="";
		for j in `seq $(( $i * $i % $COLUMNS ))`; do
			s="$s ";
		done;
		echo "$s $@";
		i=$(( $i + 1 ))
	done
}

wtf ()
{
	i=1
	strlen=`echo -n "$@" | wc -c`
	while true; do
		s="";
		d=$RANDOM
		for j in `seq $(( $RANDOM * $RANDOM % ( $COLUMNS - $strlen ) ))`; do
			s="$s ";
		done;
		echo "$s $@";
		i=$(( $i + 1 ))
	done
}

kkt ()
{
	i=1
	j=1
	while true; do
		s="";
		for k in `seq $(( $j * $j % $COLUMNS ))`; do
			s="$s ";
		done;
		echo "$s $@";
		i=$(( $i + 1 ))
		if [ $(( $i % 25 )) -eq 0 ]; then
			j=$(( $j + 1 ))
		fi
	done
}

rofl ()
{
	i=1
	k=1
	up=1
	op="+"
	while true; do
		s="";
		for j in `seq 1 $(( $k * $i % $COLUMNS ))`; do
			s="$s ";
		done;
		echo "$s $@";
		#echo $i $k
		i=$(( $i $op 1 ))
		if [ $(( $i % ( $LINES * 4 ) )) -eq 0 ]; then
			if [ $up -eq 1 ]; then
				i=1
				k=$(( $k + 1 ))
				if [ $k -eq 15 ]; then
					up=2
					op="-"
				fi
			else
				i=$(( $LINES * 4 - 1 ))
				k=$(( $k - 1 ))
				if [ $k -eq 0 ]; then
					up=1
					op="+"
				fi
			fi
		fi
	done
}

ta_mere ()
{
	lol="$@   "
	s=""
	while true; do
		for i in `seq $#lol`; do
			if [ $#s -ge $COLUMNS ]; then
				s=""
			fi
			echo "$s${lol[$i]}"
			s=$s" "
		done
		sleep 1
	done
}

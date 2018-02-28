#!/usr/bin/env zsh

alias v="~/conf/vim/nvim.sh"
alias p="popd"
alias c="dirs -c"
alias g="git"
alias sc="systemctl "
alias z="xscreensaver-command --lock"

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias t="tree -AC"

alias eu="emerge --with-bdeps=y --complete-graph=y --keep-going --verbose-conflicts -uDNaAv "
alias dmesg="dmesg -He"

alias ip="ip -c -h"

alias rg="rg -S --type-add 'clj:*.{clj,cljc,cljs}'"
alias psack="ps aux | ack "
alias psrg="ps aux | rg "

alias psc='ps xawf -eo pid,user,cgroup,args'

function ds {
	if [ -z "$@" ]; then
		arg="."
	else
		arg="$@"
	fi
	find  "$arg" -maxdepth 1 -type d \! -name . -printf '%f/\n' | sort | column
}

alias cp="rsync -ha --progress"

alias ll="ls -l --color=auto"
alias la="ls -a --color=auto"
alias lla="ls -la --color=auto"
alias ls="ls --color=auto"

alias rm='rm -i'
alias rf='rm -rf'

alias tarc='tar -cavf '
alias tarx='tar -xavf '
alias tart='tar -tavf '

alias sudo='command sudo '
alias lowCPU='systemd-run --setenv=HOME=/root -t --slice=lowCPU.slice '

compdef _precommand sudo
compdef _precommand lowCPU

rppush ()
{
	repo forall $@ -c 'echo $REPO_PROJECT: ; git push $REPO_REMOTE $REPO_RREV:$REPO_RREV; echo'
}

rpfetch ()
{
	nb=$#
	projects=""
	remote=""
	while [ $nb -gt 0 ]; do
		if [ "$1" = "--remote" -o "$1" = "-r" ]; then
			shift
			remote=$1
			nb=$(( $nb - 1 ))
		else
			projects="$projects $1"
		fi
		shift
		nb=$(( $nb - 1 ))
	done

	if [ ! -z "$remote" ]; then
		repo forall $projects -c 'echo $REPO_PROJECT: ; '"git fetch $remote; echo"
	else
		repo forall $projects -c 'echo $REPO_PROJECT: ; git fetch $REPO_REMOTE; echo'
	fi
}

rpmerge ()
{
	nb=$#
	projects=""
	remote=""
	while [ $nb -gt 0 ]; do
		if [ "$1" = "--remote" -o "$1" = "-r" ]; then
			shift
			remote=$1
			nb=$(( $nb - 1 ))
			echo r:$1
		else
			if [ -z $projects ]; then
				projects=$1
			else
				projects="$projects $1"
			fi
		fi
		shift
		nb=$(( $nb - 1 ))
	done

	if [ ! -z "$remote" ]; then
		echo repo forall $projects -c 'echo $REPO_PROJECT:; git merge '"$remote"'/$REPO_RREV; echo'
		#repo forall $projects -c 'echo $REPO_PROJECT: ; git merge '"$remote"'/$REPO_RREV; echo'
		repo forall $projects -c 'echo $REPO_PROJECT:'
	else
		#echo repo forall $@ -c 'echo $REPO_PROJECT: ; git merge $REPO_REMOTE/$REPO_RREV; echo'
		repo forall $@ -c 'echo $REPO_PROJECT: ; git merge $REPO_REMOTE/$REPO_RREV; echo'
	fi
}

rpinitbr ()
{
	repo forall $@ -c 'echo $REPO_PROJECT: ; git checkout -b $REPO_RREV $REPO_REMOTE/$REPO_RREV --track'
}

print_color ()
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

#!/usr/bin/env zsh
#
#alias gvim="~/src/mvim --remote-tab-silent"
#
if [ -z $VIM_SERVER ]; then
  #export VIM_SERVER=`openssl rand -base64 20`
  #export VIM_SERVER=`wmctrl -d | sed -nre "/\*/ s/^([0-9]+).*/\1/p"`
  export VIM_SERVER=1
fi

#alias v="gvim --servername $VIM_SERVER --remote"
alias v="~/conf/vim/gvim.sh"
#alias v="~/src/scripts/mvim --servername $VIM_SERVER --remote"

alias p="popd"
alias c="dirs -c"

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias t="tree -C"
alias ack="ack-grep"

alias pix="pquery --attr iuse --attr keywords  -vn"

#if [ ! -z `which vcp` ]; then
#	alias cp=vcp
#fi

alias cp="rsync -a --progress"

alias l="ls -1 --color=auto"
alias ll="ls -l --color=auto"
alias la="ls -a --color=auto"
alias lla="ls -la --color=auto"
alias ls="ls --color=auto"

alias rm='rm -i'
alias clean='rm -f *~ *\#* *.o *.so *.a 2> /dev/null'
alias clean-tex='rm -f *log *out *snm *toc *nav *aux'

alias tarc='tar -cavf '
alias tarx='tar -xavf '
alias tart='tar -tavf '

alias sudo='command sudo '

#alias msdb1="sudo mount /dev/sdb1 /media/sdb1"
#alias msdb2="sudo mount /dev/sdb2 /media/sdb2"
#alias msda1="sudo mount /dev/sda1 /media/sda1"
#alias msda2="sudo mount /dev/sda2 /media/sda2"
#alias umsdb1="sudo umount /dev/sdb1"
#alias umsdb2="sudo umount /dev/sdb2"
#alias umsda1="sudo umount /dev/sda1"
#alias umsda2="sudo umount /dev/sda2"
alias z="xscreensaver-command --lock"

wiki() { dig +short txt $1.wp.dg.cx; }

alias g="git"

alias psack="ps aux | ack "
alias psc='ps xawf -eo pid,user,cgroup,args'

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

gdist ()
{
  base_dir="."
  while [ ! -d "$base_dir/.git" ]; do base_dir="$base_dir/.."; [ $(readlink -f "${base_dir}") = "/" ] && return 1; done
  base_dir=$(readlink -f "$base_dir/")
  git-archive --format=tar HEAD | gzip -c > `basename $base_dir`.tgz
  echo $base_dir.tgz
}

o ()
{
  if [ $# -eq 0 ]
  then
    open .
  else
    open $@
  fi
}

alias q="/work/git/ktools/q.sh"
alias qg="/work/git/ktools/qg.sh"
alias ik="/work/git/ktools/install_kernel.sh"
alias kq="sudo killall qemu"

nc_send ()
{
	if [ "$#" -eq 2 ]; then
		my_path="$1"
		my_port="$2"
	elif [ "$#" -eq 1 ]; then
		my_path="$1"
		my_port=6666
	else
		echo "nc_send \$path [\$port]"
		return
	fi
	tar -czf - $my_path | pv | nc -l -p $my_port -q 5
}

nc_recv ()
{
	if [ "$#" -eq 2 ]; then
		my_ip="$1"
		my_port="$2"
	elif [ "$#" -eq 1 ]; then
		my_ip="$1"
		my_port=6666
	else
		echo "nc_recv $ip [$port]"
		return
	fi
	nc $my_ip $my_port | pv | tar -xzf -
}

lol ()
{
	i=1
	while true; do
		s="";
		for j in `seq $(( $i * $i % $COLUMNS ))`; do
			s="$s ";
		done;
		echo $s $@;
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
		echo $s $@;
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
		echo $s $@;
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
		echo $s $@;
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
	s=""
	for i in `seq $#1 `; do
		if [ $#s -ge $COLUMNS ]; then
			s=""
		fi
		echo $s${1[$i]}
		s=$s" "
	done
}


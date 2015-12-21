#!/usr/bin/env zsh

SESSION_SAVE_DIR=~/conf/zsh/tmux-sessions


tm ()
{
	local dir=
	local i=
	local w=
	local w_nb=1
	local I=
	local S=
	local first=
	local session=$1

	setopt local_options null_glob

	## select session
	if [ -z $session ]; then
		session=def
	fi

	local s="$SESSION_SAVE_DIR/$session"

	if [ ! -d "$s" ]; then
		echo $COLOR_DARK_RED No such session: $COLOR_NEUTRAL $session
		return 1
	fi

	## attach or create:
	if tmux has-session -t $session; then
		tmux attach -t $session
		return 0
	fi

	tmux new -d -s $session

	if [ -e "$s"/init.sh ]; then
		S=INIT_TMUX_SESSION_CONF="$s"/init.sh
	fi

	tm_new ()
	{
		dir=$1

		for i in  "$dir"/*/; do
			w=`basename $i`
			w=`echo $w | sed -re "s/^[0-9]*://g"`
			I=""
			if [ -e "$i/init.sh" ]; then
				I=INIT_TMUX_SESSION="$i/init.sh"
			fi

			tmux neww -t $session -n $w "$S $I zsh"

			if [ -z $first ]; then
				tmux kill-window -t $session:1
				tmux move-window -s $session:2 -t $session:1
				first=not
			fi

			for j in "$i"/*/; do
				I=""
				if [ -e "$j/init.sh" ]; then
					I=INIT_TMUX_SESSION="$j/init.sh"
				fi
				tmux split-window -t $session:$w_nb "$S $I zsh"
			done
			tmux select-layout -t $session:$w_nb even-horizontal
			w_nb=$(( $w_nb + 1 ))
		done
	}

	## make windows
	tm_new $s;

	## end
	tmux attach -t $session
}

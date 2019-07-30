#!/usr/bin/env zsh -x

SESSION_SAVE_DIR=~/conf/zsh/tmux-sessions


tm ()
{
	local dir
	local i
	local w
	local w_nb=1
	local I
	local first
	local session=$1

	setopt local_options null_glob

	## select session
	local session_dir="$SESSION_SAVE_DIR/$session"

	if [ ! -d "$session_dir" ]; then
		echo $COLOR_DARK_RED No such session: $COLOR_NEUTRAL $session
		return 1
	fi

	## attach or create:
	if tmux has-session -t=$session; then
		tmux attach -t $session
	fi

	## create session:
	tmux new -d -s $session

	## create windows:
	for window_dir in  "$session_dir"/*/; do
		w=$(basename "$window_dir")
		w=$(echo "$w" | cut -d: -f2)
		echo "creating $w"

		escaped_window_dir=echo $window_dir
		I=INIT_TMUX_SESSION=\""$window_dir"\"

		tmux neww -a -t "$session" -n "$w" "$I zsh"
		echo tmux neww -a -t "$session" -n "$w" "$I zsh"

		## FIXME I'm guessing this is because tmux creates a window, check
		if [ -z "$first" ]; then
			tmux kill-window -t "$session":1
			tmux move-window -s "$session":2 -t "$session":1
			first=not
		fi

		## FIXME: make panes save pwd hist:
		for j in "$window_dir"/*/; do
			I=INIT_TMUX_SESSION="$j"
			tmux split-window -t "$session:$w_nb" "$I zsh"
		done
		tmux select-layout -t "$session:$w_nb" even-horizontal
		w_nb=$(( $w_nb + 1 ))
	done

	tmux attach -t $session
}

tm_save ()
{
	local session=$(tmux display-message -p '#S')
	local session_dir="$SESSION_SAVE_DIR/$session"
	local save="$session_dir/.save/`date '+%F_%T'`"
	local w
	local i

	setopt local_options null_glob

	echo "session:	$session"
	echo "session data:	$session_dir"
	echo "backup:		$save"
	echo

	OIFS="$IFS"
	local IFS=$'\n'

	window_list=$(tmux list-windows -t $session -F "#{window_index}:#{window_name}")

	echo sending ctrl-c:
	for w in $window_list; do
		local id="$(echo $w | cut -d: -f1)"
		local name="$(echo $w | cut -d: -f2)"
		tmux send-keys -t "$session:$id".0 C-C
		echo GOT cc "$w" "$id" "$name"
	done

	if [ -d "$session_dir" ]; then
		mkdir -p "$save"
		mv "$session_dir"/* "$save"/
		echo "Saved previous version of $session in $save"
	else
		mkdir -p "$session_dir"
	fi

	i=0
	for w in $window_list; do
		i=$(( i + 1 ))
		local id="$(echo $w | cut -d: -f1)"
		local name="$(echo $w | cut -d: -f2)"
		local window_dir="$session_dir/$i:$name" # not using id because there can be gaps in tmux windows
		echo mkdir -p "$window_dir"
		mkdir -p "$window_dir"
		tmux send-keys -t "$session:$id".0 SPACE fc SPACE -ln \> \""$window_dir"\"/history ENTER
		tmux send-keys -t "$session:$id".0 SPACE pwd \> \""$window_dir"\"/pwd ENTER
		for init in "$save/"*":$name/init.sh"; do
			echo $session $name OVERWRITING init with $init
			echo $session $name OVERWRITING init with $init >> "$session_dir/log"
			cp "$init" "$window_dir"/init.sh
		done
		echo saved $name to $window_dir
	done

	IFS="$OIFS"
	local IFS=$'\n'
}

tm_history ()
{
	local line
	while read -r line
	do
		print -rS "$line"
	done < "$__local_zsh_history"
}

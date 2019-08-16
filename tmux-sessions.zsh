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
		w=$(basename "$window_dir" | cut -d: -f2)

		P=__tmux_session_path=\""$window_dir"\"
		S=__tmux_session=\""$session"\"
		W=__tmux_window=\""$w"\"

		tmux neww -a -t "$session" -n "$w" "$S $P $W zsh"

		## FIXME I'm guessing this is because tmux creates a window, check
		if [ -z "$first" ]; then
			tmux kill-window -t "$session":1
			tmux move-window -s "$session":2 -t "$session":1
			first=not
		fi

		## FIXME: make panes save pwd hist:
		for j in "$window_dir"/*/; do
			P=__tmux_session_path="$j"
			tmux split-window -t "$session:$w_nb" "$S $P $W zsh"
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

	for w in $window_list; do
		local id="$(echo $w | cut -d: -f1)"
		local name="$(echo $w | cut -d: -f2)"
		tmux send-keys -t "$session:$id".0 C-C
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

tm_load_pane_history ()
{
	local line
	while read -r line
	do
		print -rS "$line"
	done < "$__local_zsh_history"

	echo "loaded pane history"
}

tm_load_filter_history () {
	# fill history with 10 mru filtered commands:
	local filter_path="$__tmux_session_path/history_filter"
	local line
	echo $__tmux_session_path


	filter=$(cat "$filter_path" 2> /dev/null)
	if [ -z "$filter" ]; then
		filter="(vlc|mpv).*"$(echo "$__tmux_window" | sed -re 's/\s+/.{,5}/g')
	fi
	egrep -i "$filter" $HISTFILE | tail -n 10 | while read -r line; do
		print -rS "$line"
	done

	echo "loaded $filter history"
}

tm_load_history ()
{
	local filter_history_path="$__tmux_session_path/filter_history"
	local pane_history_path="$__tmux_session_path/pane_history"
	local session_dir="$SESSION_SAVE_DIR/$__tmux_session/global_history_settings"
	local needs_refresh=no

	if [ -r "$pane_history_path" ]; then
		tm_load_pane_history
		needs_refresh=yes
	fi
	if [ -r "$filter_history_path" ]; then
		tm_load_filter_history
		needs_refresh=yes
	fi
	#zle send-break # ugly but works
}

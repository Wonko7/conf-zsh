#!/usr/bin/env zsh -x

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
	local s="$SESSION_SAVE_DIR/$session"

	if [ ! -d "$s" ]; then
		echo $COLOR_DARK_RED No such session: $COLOR_NEUTRAL $session
		return 1
	fi

	## attach or create:
	if tmux has-session -t=$session; then
		tmux attach -t $session
	fi

	tmux new -d -s $session

	if [ -e "$s"/init.sh ]; then
		S=INIT_TMUX_SESSION_CONF="$s"/init.sh
	fi

	tm_new ()
	{
		dir="$1"

		for i in  "$dir"/*/; do
			w=$(basename $i)
			w=$(echo $w | sed -re "s/^[0-9]*://g")

			I=INIT_TMUX_SESSION="$i"

			tmux neww -a -t $session -n $w "$S $I zsh"

			## FIXME I'm guessing this is because tmux creates a window, check
			if [ -z $first ]; then
				tmux kill-window -t $session:1
				tmux move-window -s $session:2 -t $session:1
				first=not
			fi

			## FIXME: make this use pwd hist:
			for j in "$i"/*/; do
				I=INIT_TMUX_SESSION="$j"
				tmux split-window -t $session:$w_nb "$S $I zsh"
			done
			tmux select-layout -t $session:$w_nb even-horizontal
			w_nb=$(( $w_nb + 1 ))
		done

		window_list=$(tmux list-windows -t $session | sed -re 's/^([[:digit:]]+:) (\w+).*/\1\2/')
		echo window_list: $window_list

		## echo yup loading things:
		## for w in $window_list; do
		## 	local id=$(echo $w | cut -d: -f1)
		## 	local name=$(echo $w | cut -d: -f2)
		## 	tmux select-window -t "$session:$id"
		## 	tmux send-keys -t "$session:$id.0" SPACE tm_history ENTER
		## done
		}

	## make windows
	tm_new $s;

	## end
	tmux attach -t $session
}

tm_save ()
{
	local session=$(tmux display-message -p '#S')
	local s="$SESSION_SAVE_DIR/$session"
	local save="$s/.save/`date '+%F_%T'`"

	setopt local_options null_glob

	echo s: $s
	echo session: $session
	echo save: $save

	if [ -d "$s" ]; then
		mkdir -p "$save"
		mv "$s"/* "$save"/
		echo "Saved previous version of $session in $save"
	else
		mkdir -p "$s"
	fi

	echo saving $session

	window_list=$(tmux list-windows -t $session | sed -re 's/^([[:digit:]]+:) (\w+).*/\1\2/')

	#echo sending C-C:
	#for w in $window_list; do
	#	local id=$(echo $w | cut -d: -f1)
	#	local name=$(echo $w | cut -d: -f2)
	#	tmux select-window -t $session:$id
	#	tmux send-keys -t $session:$id.0 C-C
	#done

	for w in $window_list; do
		local id=$(echo $w | cut -d: -f1)
		local name=$(echo $w | cut -d: -f2)
		local s_dir="$s/$id:$name"
		echo $s_dir
		#tmux  $session:$id.0 C-c history \> ${s_dir}.history ENTER
		mkdir -p "${s_dir}"
		tmux select-window -t $session:$id
		tmux send-keys -t $session:$id.0 SPACE history \> ${s_dir}/history ENTER
		tmux send-keys -t $session:$id.0 SPACE pwd \> ${s_dir}/pwd ENTER
		# FIXME test this!
		echo checking "$save/$id:$name/init.sh"
		if [ -e "$save/$id:$name/init.sh" ]; then
			echo yes!
			cp "$save/$id:$name/init.sh" ${s_dir}/
		fi
	done
}

tm_history ()
{
	local l
	while read -r l
	do
		l=$(print -r "$l" | sed -re "s/\w+\s+(.*)/\1/")
		print -rS "$l"
	done < $__local_zsh_history
}

#!/usr/bin/env zsh

if [ -z "$bmlist" ]; then
	bmlist=""
fi

BOOKMARK_SAVE_DIR=~/conf/zsh/bookmarks
BOOKMARK_ERROR_COLOR=$COLOR_DARK_RED
BOOKMARK_BM_COLUMN_COLOR=$COLOR_RED
BOOKMARK_SYM_COLUMN_COLOR=$COLOR_BLUE
BOOKMARK_DIR_COLUMN_COLOR=$COLOR_DARK_CYAN
BOOKMARK_SEARCH_COLOR="01;32"

# add bookmark
bm ()
{
	local i=
	if [ -z "$1" ]; then
		1=`basename $PWD`
	fi
	export $1="`pwd`"
	bmlist=`for i in $bmlist $1; do echo $i; done | sort -u`
	export bmlist
}

# remove bookmark
brm ()
{
	local j=
	local i=
	for j in $@; do
		export $j=
		bmlist=`for i in $bmlist; do if [ $i != $j ]; then echo $i; fi; done | sort -u`
	done
	export bmlist
}

# list bookmarks
bl ()
{
	local i=
	for i in $bmlist; do
		local p="echo \$${i}"
		local dir="`eval $p`"
		if [ -d "$dir" -a -x "$dir" ]; then
			echo "	${BOOKMARK_BM_COLUMN_COLOR}$i#${BOOKMARK_SYM_COLUMN_COLOR}-->#${BOOKMARK_DIR_COLUMN_COLOR}$dir${COLOR_NEUTRAL}"
		else
			echo "	${BOOKMARK_BM_COLUMN_COLOR}$i#${BOOKMARK_SYM_COLUMN_COLOR}-->#${BOOKMARK_ERROR_COLOR}$dir${COLOR_NEUTRAL}"
		fi
	done | column -s \# -t
}

# find (grep) bookmarks
bf ()
{
	bl | GREP_COLORS="ms=$BOOKMARK_SEARCH_COLOR:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36" egrep "$@"
}

# remove all bookmarks
bclear ()
{
	#todo; unset all variables
	export bmlist=
}

# remove broken bookmarks
bclean ()
{
	local j=
	local i=
	for j in $bmlist; do
		local p="echo \$${j}"
		local dir="`eval $p`"
		if [ ! -d "$dir" -o ! -x "$dir" ]; then
			unset $j
			bmlist=`for i in $bmlist; do if [ $i != $j ]; then echo $i; fi; done | sort -u`
		fi
	done
	export bmlist
}

# jump to bookmark
b ()
{
	p="echo \$$1"
	if echo $bmlist | egrep -q "\b$1\b"; then
		cd "`eval $p`"
	else
		echo $BOOKMARK_ERROR_COLOR unknown bookmark: $1 $COLOR_NEUTRAL
	fi
}

# save bookmark session
bsave ()
{
	if [ -z "$1" ]; then
		echo $BOOKMARK_ERROR_COLOR Please give a session name. $COLOR_NEUTRAL
		return
	fi

	if [ -e "$BOOKMARK_SAVE_DIR/$1" ]; then
		local save="$BOOKMARK_SAVE_DIR/$1/.save/`date '+%Y.%m.%d-%H:%M:%S'`" 
		mkdir -p "$save"
		mv "$BOOKMARK_SAVE_DIR/$1"/* "$save"/
		echo "Saved previous version of $1 in $save"
	else
		mkdir -p "$BOOKMARK_SAVE_DIR/$1"
	fi

	echo "$bmlist" > "$BOOKMARK_SAVE_DIR/$1/bmlist"

	local i=
	for i in $bmlist; do
		local p="echo \$${i}"
		local dir="`eval $p`"
		echo "$dir" > "$BOOKMARK_SAVE_DIR/$1/$i"
	done
}

# load bookmark session
bload ()
{
	if [ -z "$1" ]; then
		echo $BOOKMARK_ERROR_COLOR Please give a session name. $COLOR_NEUTRAL
		return
	fi

	local i=
	for i in "$BOOKMARK_SAVE_DIR/$1"/*; do
		local n="`basename $i`"
		local d="`cat $i`"
		export $n="$d"
	done
}

# remove bookmark session
brm_session ()
{
	if [ -z "$1" ]; then
		echo $BOOKMARK_ERROR_COLOR Please give a session name. $COLOR_NEUTRAL
		return
	fi

	rm -rf "$BOOKMARK_SAVE_DIR/$1"
}

_bookmark_completion () {
	reply=(`echo ${bmlist// /}`)
	#reply=("${bmlist// /}")
}
_bookmark_session_completion () {
	reply=(`ls $BOOKMARK_SAVE_DIR`)
}

compctl -K _bookmark_completion b
compctl -K _bookmark_completion brm
compctl -K _bookmark_session_completion bsave
compctl -K _bookmark_session_completion bload
compctl -K _bookmark_session_completion brm_session


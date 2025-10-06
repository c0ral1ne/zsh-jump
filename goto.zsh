#!/bin/zsh

GOTO_FILE="$HOME/.goto_bookmarks"

function j() {
	local name=$1

	[[ -f $GOTO_FILE ]] || touch $GOTO_FILE

	if [[ -z $name ]]; then
		echo "Usage: j <name>"
		return 1
	fi

	local path=$(grep "$name=" $GOTO_FILE | cut -d "=" -f 2)
	if [[ -z $path ]]; then
		echo "Bookmark does not exist"
	else
		cd $path
	fi
}


function _zsh_jump_bookmark_exists() {
	echo hi
}


function js() {
	local name=$1
	local cpath=$2

	if [[ -z $name ]]; then
		echo "Usage: js <name> [path]"
		return 1
	fi

	local path=$(realpath "${cpath:-$PWD}")

	#grep -v "$name=" $GOTO_FILE > $GOTO_FILE.tmp 2> /dev/null
	#/bin/mv "$GOTO_FILE.tmp" $GOTO_FILE

	echo "$name=$path" >> $GOTO_FILE
	echo "Added bookmark: $name -> $path"
}

function jrm() {
	local name=$1

	if [[ -z $name ]]; then
		echo "Usage: jrm <name>"
		return 1
	fi

	grep -v "$name=" $GOTO_FILE > $GOTO_FILE.tmp

	diff $GOTO_FILE $GOTO_FILE.tmp > /dev/null
	if [ $? -eq 1 ]; then
		/bin/mv $GOTO_FILE.tmp $GOTO_FILE
		echo "Removed bookmark: $name"
	else
		rm $GOTO_FILE.tmp
		echo "Bookmark does not exist"
	fi
}

function jls() {
	[[ ! -f $GOTO_FILE ]] || cat $GOTO_FILE
}

alias b="cd -"

# Future features:
# - Tab completion
# - Better logging
# - Thorough scenarios

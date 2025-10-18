# zsh-jump - Directory bookmarking system for zsh
#
# This plugin provides a simple and efficient way to bookmark and jump between
# directories in your terminal. It stores bookmarks in ~/.goto_bookmarks file
# with tab completion support for quick navigation.
#
# Commands:
#   j <name>          - Jump to a bookmarked directory (supports fuzzy path navigation)
#   ja <name> [path]  - Add current directory (or specified path) as a bookmark
#   jrm <name>        - Remove a bookmark
#   jls               - List all bookmarks
#   b                 - Go back to previous directory (alias for 'cd -')
#
# Tab Completion:
#   j <TAB>          - Shows all available bookmarks
#   jrm <TAB>        - Shows all available bookmarks
#
# Examples:
#   ja work ~/Documents/work    # Bookmark work directory
#   j work                      # Jump to work directory
#   jls                         # List all bookmarks
#   jrm work                   # Remove work bookmark
#
# File Format:
#   Bookmarks are stored in ~/.goto_bookmarks with format: name=path
#   Each bookmark is on a new line
#
# Author: c0ral1ne
# License: MIT
# Repository: https://github.com/c0ral1ne/zsh-jump

GOTO_FILE="$HOME/.goto_bookmarks"

function j() {
	local name=${1%%/*}
	if [[ "$1" == */* ]]; then
		fuzz_path="/${1#*/}"
	else
		fuzz_path=""
	fi

	[[ -f $GOTO_FILE ]] || touch $GOTO_FILE

	if [[ -z $name ]]; then
		echo "Usage: j <name>"
		return 1
	fi

	local jpath=$(grep "^${name}=" $GOTO_FILE | cut -d "=" -f 2)
	if [[ -z $jpath ]]; then
		echo "Bookmark does not exist"
	else
		cd "${jpath}${fuzz_path}"
	fi
}


function ja() {
	local name=$1
	local cpath=$2

	if [[ -z $name ]]; then
		echo "Usage: ja <name> [path]"
		return 1
	fi

	local jpath=$(realpath "${cpath:-$PWD}")

	if grep -q "^${name}=" $GOTO_FILE; then
		grep -v "^${name}=" $GOTO_FILE > $GOTO_FILE.tmp && mv $GOTO_FILE.tmp $GOTO_FILE
	fi

	echo "$name=$jpath" >> $GOTO_FILE
	echo "Added bookmark: $name -> $jpath"
}

function jrm() {
	local name=$1

	if [[ -z $name ]]; then
		echo "Usage: jrm <name>"
		return 1
	fi

	if grep -q "^${name}=" $GOTO_FILE; then
		grep -v "^${name}=" $GOTO_FILE > $GOTO_FILE.tmp && mv $GOTO_FILE.tmp $GOTO_FILE
		echo "Removed bookmark: $name"
	else
		echo "Bookmark does not exist"
	fi
}

function jls() {
  [[ ! -f $GOTO_FILE ]] && echo "No bookmarks yet" && return

  while IFS='=' read -r name dir; do
    [[ -n "$name" && -n "$dir" ]] && printf "%-16s %s\n" "($name)" "$dir"
  done < "$GOTO_FILE"
}

function _zsh_jump_bookmarks() {
    local -a bookmarks
    while IFS='=' read -r name _; do
        [[ -n "$name" ]] && bookmarks+=("$name")
    done < "$GOTO_FILE"
    _describe 'bookmarks' bookmarks
}

function _zsh_jump_complete() {
    _arguments '1:bookmark:->bookmarks'
    case "$state" in
        bookmarks)
            _zsh_jump_bookmarks
            ;;
    esac
}

alias b="cd -"

compdef _zsh_jump_complete j
compdef _zsh_jump_complete jrm

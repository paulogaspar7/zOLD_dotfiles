#!/usr/bin/env bash
# Initialize the dotfiles profile extensions

# Reload Library
alias reload='source ~/.bash_profile'


############################################################
##### Script sourcing functions


function _try2source() {
	local f=$1
	if [ -e "${f}" ]; then
		if [ -s "${f}" ]; then
#			echo "sourcing ${f}..."
			source ${f}
#		else
#			echo "empty file: ${f}"
		fi
#	else
#		echo "file does not exist: ${f}"
	fi
}


function _try2source_dir() {
#	echo "trying to source bash files in directory $1..."
	if [ -d "$1" ]; then
		local FILES="$1/*.bash"
		for f in $FILES
		do
			_try2source $f
		done
#	else
#		echo "directory NOT found: $1"
	fi
}


function _source_dir() {
#	echo "source bash files in directory $1..."
	if [ -d "$1" ]; then
		local FILES="$1/*.bash"
		for f in $FILES
		do
#			echo "sourcing ${f}..."
			source ${f}
		done
	else
		echo "ERROR: directory NOT found: $1"
	fi
}


############################################################
##### Load local and private exports

_try2source_dir "$DOTFILES_PRIVATE_DIR/profile/exports"
_try2source_dir "$DOTFILES_LOCAL_DIR/profile/exports"


############################################################
##### Add decent defaults for missing values

# Only set $LC_ALL if it's not already set
if [ -z "$LC_ALL" ];
then
	export LC_ALL="en_US.UTF-8"
fi

# Only set $LANG if it's not already set
if [ -z "$LANG" ];
then
	export LANG="en_US"
fi

# Only set $DISPLAY if it's not already set
if [ -z "$DISPLAY" ];
then
	export DISPLAY=:0.0
fi

# Only set $CLICOLOR if it's not already set
if [ -z "$CLICOLOR" ];
then
	export CLICOLOR=1
fi

# Only set $TERM if it's not already set
if [ -z "$TERM" ];
then
	export TERM=xterm-color
fi

# Only set $DOTFILES_DIR if it's not already set
if [ -z "$DOTFILES_DIR" ];
then
	export DOTFILES_DIR="$HOME/dotfiles"
fi


# Only set $BASH_COMPLETION_DIR if it's not already set
# Should not be a problem if you do not install bash completion
if [ -z "$BASH_COMPLETION_DIR" ];
then
	export BASH_COMPLETION_DIR=~/.bash_completion.d
fi


# Only set $DOTFILES_LOCAL_DIR if it's not already set
if [ -z "$DOTFILES_LOCAL_DIR" ];
then
	export DOTFILES_LOCAL_DIR="$HOME/dotfiles_local"
fi

# Only set $DOTFILES_PRIVATE_DIR if it's not already set
if [ -z "$DOTFILES_PRIVATE_DIR" ];
then
	export DOTFILES_PRIVATE_DIR="$HOME/dotfiles_private"
fi

# Only set $DOTFILES_THEME if it's not already set
if [ -z "$DOTFILES_THEME" ];
then
	export DOTFILES_THEME="bobby"
fi


# If we have textmate...
if [ -e "/usr/bin/mate" ]; then
	# Set my editor and git editor if still unset
	if [ -z "$EDITOR" ];
	then
		export EDITOR='/usr/bin/mate -w'
	fi

	if [ -z "$GIT_EDITOR" ];
	then
		export GIT_EDITOR='/usr/bin/mate -w'
	fi
fi


# Only set $IRC_CLIENT if it's not already set
if [ -z "$IRC_CLIENT" ];
then
	export IRC_CLIENT='irssi'
fi

# Only set $TODO if it's not already set
if [ -z "$TODO" ];
then
	export TODO="t"
fi


############################################################
##### Source everything else...

export DOTFILES_PROFILE_DIR="$DOTFILES_DIR/profile"

# Only set $DOTFILES_THEMES_DIR if it's not already set
if [ -z "$DOTFILES_THEMES_DIR" ];
then
	export DOTFILES_THEMES_DIR="${DOTFILES_PROFILE_DIR}/themes"
fi



# Load composure first, so we support function metadata
# echo "source ${DOTFILES_PROFILE_DIR}/lib/composure.sh"
source ${DOTFILES_PROFILE_DIR}/lib/composure.sh

# Load colors first so they can be use in base theme
# echo "source ${DOTFILES_PROFILE_DIR}/themes/colors.theme.bash"
source ${DOTFILES_PROFILE_DIR}/themes/colors.theme.bash

# echo "source ${DOTFILES_PROFILE_DIR}/themes/base.theme.bash"
source ${DOTFILES_PROFILE_DIR}/themes/base.theme.bash


# echo "Loading libraries (core settings)..."

# libraries (core settings)
_source_dir ${DOTFILES_PROFILE_DIR}/lib
_try2source_dir "$DOTFILES_PRIVATE_DIR/profile/lib"
_try2source_dir "$DOTFILES_LOCAL_DIR/profile/lib"


# echo "Loading all enabled extensions..."
# Load all enabled extensions
df.load.all


# echo "Setting PS1 to PROMPT..."
if [[ $PROMPT ]]; then
    export PS1=$PROMPT
fi


# echo "Setting preview..."
# Adding Support for other OSes
PREVIEW="less"
[ -s /usr/bin/gloobus-preview ] && PREVIEW="gloobus-preview"
[ -s /Applications/Preview.app ] && PREVIEW="/Applications/Preview.app"

# echo "...done with dotfiles.load.bash!!!"

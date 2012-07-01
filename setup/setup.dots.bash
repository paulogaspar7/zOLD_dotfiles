#!/usr/bin/env bash

function setup_dots()
{
	local DOTFILES_DIR="$HOME/dotfiles"
	local DOTFILES_LOCAL_DIR="$HOME/dotfiles_local"
	local DOTFILES_PRIVATE_DIR="$HOME/dotfiles_private"

	local DOTFILES_BAK_DIR="$HOME/dotfiles_backup"

	local SOURCE="${BASH_SOURCE[0]}"
	local SOURCE_DIR="$( dirname "$SOURCE" )"

	echo "SOURCE     = $SOURCE"
	echo "SOURCE_DIR = $SOURCE_DIR"

	while [ -h "$SOURCE" ]
	do 
	  SOURCE="$(readlink "$SOURCE")"
	  [[ $SOURCE != /* ]] && SOURCE="$SOURCE_DIR/$SOURCE"
	  SOURCE_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
	done
	SOURCE_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

	echo "SOURCE     = $SOURCE"
	echo "SOURCE_DIR = $SOURCE_DIR"

	local DOTFILES_HOMEDOTS_DIR="$DOTFILES_DIR/homedots"
	local DOTFILES_LOCAL_HOMEDOTS_DIR="$DOTFILES_LOCAL_DIR/homedots"
	local DOTFILES_PRIVATE_HOMEDOTS_DIR="$DOTFILES_PRIVATE_DIR/homedots"


	local TS=$(date +%Y%m%d_%H%M%S)
	local BAK_DIR="$DOTFILES_BAK_DIR/$TS/OLD"

	## mkdir -p $DOTFILES_BAK_DIR/$TS/NEW
	mkdir -p $BAK_DIR


	local b
	local s
	local t
	echo
	echo
	echo "Processing source directory ${DOTFILES_HOMEDOTS_DIR}"
	echo
	local FILES="$DOTFILES_HOMEDOTS_DIR/.*"
	for s in $FILES
	do
		b=$(basename $s)
		if [ "$b" = "." ] || [ "$b" = ".." ] || [ "$b" = ".DS_Store" ]; then
			continue
		fi
		echo
		echo "Linking up ${s}"
		t="$HOME/$b"
		if [ -h $t ]; then
			echo "Removing previous symbolic link ${t}"
			rm $t
		else
			if [ -e $t ]; then
				echo "Backing up ${t}"
				mv $t $BAK_DIR/
			fi
		fi
		echo "Create link ${t} for ${s}"
		ln -s $s $t
	done


	local bk
	local SD
	for SD in $DOTFILES_PRIVATE_HOMEDOTS_DIR $DOTFILES_LOCAL_HOMEDOTS_DIR
	do
		echo
		echo
		if [ -e $SD ]; then
			echo "Processing source directory ${SD}"
			echo
			FILES="$SD/.*"
			for s in $FILES
			do
				b=$(basename $s)
				if [ "$b" = "." ] || [ "$b" = ".." ] || [ "$b" = ".DS_Store" ]; then
					continue
				fi

				echo "Linking up ${s}"
				t="$HOME/$b"
				if [ -h $t ]; then
					echo "Removing previous symbolic link ${t}"
					rm $t
				else
					if [ -e $bk ]; then
						echo "Skip backup. This is a duplicated copy and the original file is already at ${bk}"
						echo "Removing ${t}"
						rm $t
					else
						echo "Backing up ${t}"
						mv $t $BAK_DIR/
					fi
				fi

				echo "Create link ${t} for ${s}"
				ln -s $s $t
			done
		else
			echo "Optional source directory does not exist: ${SD}"
		fi
	done
}

setup_dots

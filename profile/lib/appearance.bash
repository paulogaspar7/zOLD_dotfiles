#!/usr/bin/env bash

# colored grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;33'

# colored ls
export LSCOLORS='Gxfxcxdxdxegedabagacad'

# Load the theme
function netf-load-theme ()
{
	if [[ $DOTFILES_THEME ]]; then
		local tf="$DOTFILES_LOCAL_DIR/profile/themes/$DOTFILES_THEME/$DOTFILES_THEME.theme.bash"
		if [ -e "$tf" ] && [ -s "$tf" ]; then
			source $tf
		else
			tf="$DOTFILES_PRIVATE_DIR/profile/themes/$DOTFILES_THEME/$DOTFILES_THEME.theme.bash"
			if [ -e "$tf" ] && [ -s "$tf" ]; then
				source $tf
			else
				tf="$DOTFILES_THEMES_DIR/$DOTFILES_THEME/$DOTFILES_THEME.theme.bash"
				if [ -e "$tf" ] && [ -s "$tf" ]; then
					source $tf
				else
					echo "ERROR: It was NOT possible to find theme ${DOTFILES_THEME}!"
				fi
			fi
		fi
	fi
}

netf-load-theme


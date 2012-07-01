#!/usr/bin/env bash

# Only set $DOTFILES_DIR if it's not already set
if [ -z "$DOTFILES_DIR" ];
then
	export DOTFILES_DIR="$HOME/dotfiles"
fi

if [ -z "$DOTFILES_PROFILE_DIR" ];
then
	export DOTFILES_PROFILE_DIR="$DOTFILES_DIR/profile"
fi

if [ -z "$DOTFILES_ENABLED_PROFILE_DIR" ];
then
	export DOTFILES_ENABLED_PROFILE_DIR="$DOTFILES_DIR/enabled/profile"
fi


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


dotf-load() {
	about '(re)loads all enabled extensions of a given type'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ dotf-load plugins'
	group 'dotadmin'

    if [ -z "$1" ]; then
		reference dotf-load
		return
    fi

	local exttype_arg=$1
	local exttype

	case $exttype_arg in
		export | exports)
			exttype="exports"
			;;
		alias | aliases)
			exttype="aliases"
			;;
		completion)
			exttype="completion"
			;;
		plugin | plugins)
			exttype="plugins"
			;;
		*)
			echo "Unknown extension type: $exttype_arg"
			return
			;;
	esac
	
	_try2source_dir "$DOTFILES_ENABLED_PROFILE_DIR/$exttype"
	
	_try2source_dir "$DOTFILES_PRIVATE_DIR/profile/$exttype"
	_try2source_dir "$DOTFILES_LOCAL_DIR/profile/$exttype"
}


dotf-load-all() {
	about '(re)loads all enabled extensions of all types'
	example '$ dotf-load-all'
	group 'dotadmin'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		dotf-load $type
	done
}


dotf-enable()
{
	about 'enables an extension'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	param '2: extension name or "all"'
	example '$ dotf-enable plugin rvm'
	group 'dotadmin'

    if [ -z "$1" ] || [ -z "$2" ]; then
		reference dotf-enable
		return
    fi

	local exttype_arg=$1
	local extname=$2
	local exttype
	local exttype_single

	case $exttype_arg in
		export | exports)
			exttype="exports"
			exttype_single="export"
			;;
		alias | aliases)
			exttype="aliases"
			exttype_single="alias set"
			exttype_plural="alias sets"
			;;
		completion)
			exttype="completion"
			exttype_single="completion"
			;;
		plugin | plugins)
			exttype="plugins"
			exttype_single="plugin"
			;;
		*)
			echo "Unknown extension type: $exttype_arg"
			return
			;;
	esac
	
	local ext_enabled_dir="$DOTFILES_ENABLED_PROFILE_DIR/$exttype"
	local ext_available_dir="$DOTFILES_PROFILE_DIR/available/$exttype"

	if [ -d "$ext_available_dir" ]; then
		if [ ! -d "$ext_enabled_dir" ]
		then
			mkdir -p "$ext_enabled_dir"
		fi

		if [ "$extname" = "all" ]; then
			local f
			local ext
			for f in $dotfiles_available_dir/*.bash
			do
				ext=$(basename $f)
				if [ ! -h $ext_enabled_dir/$ext ]; then
					ln -s $ext_available_dir/$ext $ext_enabled_dir/$ext
				fi
			done
		else
			local ext=$(command ls ${ext_available_dir}/${extname}.*bash 2>/dev/null | head -1)
			if [ -z "$ext" ]; then
				echo "sorry, that does not appear to be an available $exttype_single."
			else
				ext=$(basename $ext)
				if [ -e "${ext_enabled_dir}/$ext" ]; then
					echo "${exttype_single} ${extname} is already enabled."
				else
					ln -s $ext_available_dir/$ext $ext_enabled_dir/$ext
				fi
			fi
		fi
	fi

	echo "$exttype_single $extname enabled."
}


dotf-enable-all()
{
	about 'enables all extensions of all types'
	example '$ dotf-enable-all'
	group 'dotadmin'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		dotf-enable $type all
	done
}



dotf-disable()
{
	about 'disables an extension'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	param '2: extension name name'
	example '$ dotf-disable plugin rvm'
	group 'dotadmin'

    if [ -z "$1" ] || [ -z "$2" ]; then
		reference dotf-disable
		return
	fi

	local exttype_arg=$1
	local extname=$2
	local exttype
	local exttype_single

	case $exttype_arg in
		export | exports)
			exttype="exports"
			exttype_single="export"
			;;
		alias | aliases)
			exttype="aliases"
			exttype_single="alias set"
			;;
		completion)
			exttype="completion"
			exttype_single="completion"
			;;
		plugin | plugins)
			exttype="plugins"
			exttype_single="plugin"
			;;
		*)
			echo "Unknown extension type: $exttype_arg"
			return
			;;
	esac
	
	local ext_enabled_dir="$DOTFILES_ENABLED_PROFILE_DIR/$exttype"
	
	if [ -d "$ext_enabled_dir" ]; then
		if [ "$extname" = "all" ]; then
			local f ext
			for f in ${ext_enabled_dir}/*.bash
			do
				ext=$(basename $f)
				if [ -e ${ext_enabled_dir}/$ext ]; then
					if [ ! -h $ext ]; then
						echo "sorry, that does not appear to be an enabled $exttype_single."
					else
						rm ${ext_enabled_dir}/$(basename $ext)
					fi
				fi
			done
		else
			local ext=$(command ls ${ext_enabled_dir}/$extname.*bash 2>/dev/null | head -1)
			if [ ! -h $ext ]; then
				if [ -e ${ext_enabled_dir}/$ext ]; then
					local full_filename="${ext_enabled_dir}/$ext"
					echo "sorry, that does not appear to be an enabled $exttype_single (not a linked file) but some real file you placed at $full_filename."
				else
					echo "sorry, that does not appear to be an enabled $exttype_single."
				fi
			else
				rm ${ext_enabled_dir}/$(basename $ext)
			fi
		fi
	fi
	
	echo "$exttype_single $extname disabled."
}


dotf-disable-all()
{
	about 'disables all extensions of all types'
	example '$ dotf-disable-all'
	group 'dotadmin'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		dotf-disable $type all
	done
}



dotf-list-exts1()
{
    about 'summarizes the available extensions of a given type and their status'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ dotf-list-exts1 plugins'
	group 'dotadmin'

    if [ -z "$1" ]; then
		reference dotf-list-exts1
		return
	fi

	local is2cat_file="N"
	local filter
    if [ ! -z "$2" ] && [ "cat" = "$2" ]; then
		is2cat_file="S"
		if [ ! -z "$3" ]; then
			filter="$3"
		fi
	else
		is2cat_file="N"
		filter=""
	fi

	local exttype_arg=$1
	local exttype
	local exttype_single
	local exttype_plural

	case $exttype_arg in
		export | exports)
			exttype="exports"
			exttype_single="export"
			exttype_plural="exports"
			;;
		alias | aliases)
			exttype="aliases"
			exttype_single="alias set"
			exttype_plural="alias sets"
			;;
		completion)
			exttype="completion"
			exttype_single="completion"
			exttype_plural="completions"
			;;
		plugin | plugins)
			exttype="plugins"
			exttype_single="plugin"
			exttype_plural="plugins"
			;;
		*)
			echo "Unknown extension type: $exttype_arg"
			return
			;;
	esac
	
	local ext_enabled_dir="$DOTFILES_ENABLED_PROFILE_DIR/$exttype"
	local ext_available_dir="$DOTFILES_PROFILE_DIR/available/$exttype"

	local ext_private_dir="$DOTFILES_PRIVATE_DIR/profile/$exttype"
	local ext_local_dir="$DOTFILES_LOCAL_DIR/profile/$exttype"

	local d
	local f
	local enabled
	
	echo ""
	echo "=== Available ${exttype_plural}: ==="
	printf "%-20s%-10s%s\n" "$exttype_single" 'Enabled?' 'Description'
	for d in $ext_local_dir $ext_private_dir $ext_available_dir
	do
#	echo "FROM $d:"
		if [ -e "$d" ] && [ -d "$d" ]
		then
			for f in $d/${filter}*.bash
			do
				local bf=$(basename $f)
				
				if [ "$ext_available_dir" = "$d" ]
				then
					if [ -e $ext_enabled_dir/$(basename $f) ]; then
						enabled='y'
					else
						enabled=' '
					fi
				else
					enabled='y'
				fi
				printf "    %-20s%-10s%s\n" "$(basename $f | cut -d'.' -f1)" "  [$enabled]" "$(cat $f | metafor about-${exttype_single})"

			    if [ "$is2cat_file" = "S" ]; then
					echo "========== BEGIN definitions of alias ${bf}: =========="
					cat "$f"
					echo "=========== END definitions of alias ${bf}. ==========="
					echo
				fi
			done
		fi
	done
	echo ""
	echo "to enable a $exttype_single, do:"
	echo "\$ dotf-enable  $exttype_single <$exttype_single name> -or- $ dotf-enable $exttype_single all"
	echo ""
	echo "to disable a $exttype_single, do:"
	echo "\$ dotf-disable $exttype_single <$exttype_single name> -or- $ dotf-disable $exttype_single all"
	echo ""
}


dotf-list-exts-all()
{
    about 'summarizes the available extensions of all types and their status'
	example '$ dotf-list-exts-all'
	group 'dotadmin'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		dotf-list-exts1 $type
	done
}


dotf-setup() {
	about 'interactivly sets up all available extensions of a given type'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ dotf-setup plugin rvm'
	group 'dotadmin'

    if [ -z "$1" ]; then
		reference dotf-setup
		return
	fi

	local exttype_arg=$1
	local exttype
	local exttype_single
	local exttype_plural

	case $exttype_arg in
		export | exports)
			exttype="exports"
			exttype_single="export"
			exttype_plural="exports"
			;;
		alias | aliases)
			exttype="aliases"
			exttype_single="alias set"
			exttype_plural="alias sets"
			;;
		completion)
			exttype="completion"
			exttype_single="completion"
			exttype_plural="completions"
			;;
		plugin | plugins)
			exttype="plugins"
			exttype_single="plugin"
			exttype_plural="plugins"
			;;
		*)
			echo "Unknown extension type: $exttype_arg"
			return
			;;
	esac
	
	local ext_enabled_dir="$DOTFILES_ENABLED_PROFILE_DIR/$exttype"
	local ext_available_dir="$DOTFILES_PROFILE_DIR/available/$exttype"

	if [ -d "$ext_available_dir" ]; then
		local path
#		for path in `ls ${ext_available_dir}/[^_]*`
		local FILES="${ext_available_dir}/*.bash"
		for path in $FILES
		do		
			if [ ! -d "$ext_enabled_dir" ]
			then
				mkdir -p "$ext_enabled_dir"
			fi

			local file_name=$(basename "$path")
			while true
			do
				echo "$path"
				read -p "Would you like to enable the ${file_name%%.*} $exttype? [Y/N] " RESP
				## read -p "Would you like to enable the ${file_name} $exttype? [Y/N] " RESP
				case $RESP in
					[yY])
						ln -s "$path" "$ext_enabled_dir"
						break
						;;
					[nN])
						break
						;;
					*)
						echo "Please choose y or n."
						;;
				esac
			done
		done
		echo "done setting up available ${exttype_plural}."
	else
		echo "there are no available ${exttype_plural}!"
	fi
}


dotf-setup-all() {
	about 'interactivly sets up all extension types available'
	example '$ dotprofile-setup'
	group 'dotadmin'

	for type in "exports" "aliases" "plugins" "completion"
	do
		while true
		do
			echo
			read -p "Would you like to enable all, some, or no $type? Some of these may make bash slower to start up (especially completion). (all/some/none) " RESP
			case $RESP in
				some)
					dotf-setup $type
					break
					;;
				all)
					dotf-enable $type all
					break
					;;
				none)
					break
					;;
				*)
					echo "Unknown choice. Please enter some, all, or none"
					continue
					;;
			esac
		done
	done
}


dotf-help-exts()
{
    about 'summarizes the available extensions of the given types and their status'
	param '*: use "all" or a list of extension types - each must be one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ dotf-help-exts plugins aliases'
	example '$ dotf-help-exts all'
    group 'help'

    if [ -z "$1" ]; then
		reference dotf-help-exts
		return
	fi

	local type
	for type in "$@"
	do
		if [ "$type" = "all" ]
		then
			dotf-list-exts-all
			break;
		else
			dotf-list-exts1 $type
		fi
	done
}


dotf-help-aliasref-all()
{
    about 'presents the alias definition scripts for all available alias sets'
	example '$ dotf-help-aliasref-all'
	group 'dotadmin'

	dotf-list-exts1 "aliases" "cat"
}


dotf-help-aliasref()
{
    about 'presents the alias definition scripts for the given alias sets'
	param '*: use "all" or a list of alias set names'
	example '$ dotf-help-aliasref git vim'
	example '$ dotf-help-aliasref all'
    group 'help'

    if [ -z "$1" ]; then
		reference dotf-help-aliasref
		echo
		echo "Available alias sets..."
		dotf-help-exts "alias"
		return
	fi

	local alfilter
	for alfilter in "$@"
	do
		if [ "$alfilter" = "all" ]
		then
			dotf-help-aliasref-all
			break;
		else
			dotf-list-exts1 "aliases" "cat" "$alfilter"
		fi
	done
}


dotf-help-fgroups ()
{
	about 'displays all unique function groups'
	group 'help'

	local func
	for func in $(typeset_functions); do typeset -f $func | metafor group ; done | sort | uniq
	
#	typeset file=$(mktemp /tmp/composure.XXXX)
#	for func in $(typeset_functions)
#	do
#		typeset -f $func | metafor group >> $file
#	done
#	for func in $(typeset_functions); do; typeset -f $func; done
#	cat $file | sort
#	rm $file
}


dotf-help-funcs ()
{
	about 'summarize all functions defined by currently active plugins'
	param '*: use "all" or a function group - the available function groups will be displayed if you give no arguments'
	example '$ dotf-help-funcs help'
	example '$ dotf-help-funcs all'
    group 'help'

    if [ -z "$1" ]; then
		echo "!!!"
		reference dotf-help-funcs
		echo ""
		echo "=== Available function groups: ==="
		dotf-help-fgroups
		return
	fi
	
	local group_choice=$1

	# display a brief progress message...
	printf '%s' 'please wait, building help...'
	typeset grouplist=$(mktemp /tmp/grouplist.XXXX)
	typeset func
	for func in $(typeset_functions)
	do
		typeset group="$(typeset -f $func | metafor group)"
		if [ -z "$group" ]; then
			group='misc'
		fi
		if [ "$group_choice" = "all" ] || [ "$group_choice" = "$group" ]; then
			typeset about="$(typeset -f $func | metafor about)"
			letterpress "$about" $func >> $grouplist.$group
			echo $grouplist.$group >> $grouplist
		fi
	done
	# clear progress message
	printf '\r%s\r' '                              '
	typeset group
	typeset gfile
	for gfile in $(cat $grouplist | sort | uniq)
	do
		printf '%s\n' "=== ${gfile##*.} group functions: ==="
		cat $gfile
		printf '\n'
		rm $gfile 2> /dev/null
	done # | less
	rm $grouplist 2> /dev/null
}


dotf-help ()
{
	about 'summarize the available help functions'
#	group 'lib'
	group 'help'

	dotf-help-funcs help
}




#
# Custom Help

dotfiles() {
	echo "Dotfiles baby!!!"
	echo
	dotf-help
}


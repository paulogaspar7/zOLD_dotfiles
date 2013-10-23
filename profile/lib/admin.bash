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
	export DOTFILES_ENABLED_PROFILE_DIR="$DOTFILES_DIR/_ENABLED/profile"
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


df.load() {
	about '(re)loads all enabled extensions of a given type'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ df.load plugins'
	group 'dotfiles'

    if [ -z "$1" ]; then
		reference df.load
		return
    fi

	local exttype_arg=$1
	local exttype

	local exttype_arg_lo=`echo "$exttype_arg" | tr "[A-Z]" "[a-z]"`
	case $exttype_arg_lo in
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


df.load.allButExports() {
	about '(re)loads all enabled extensions of all types'
	example '$ df.load.all'
	group 'dotfiles'

	local type
	for type in "aliases" "plugins" "completion"
	do
		df.load $type
	done
}


df.enable()
{
	about 'enables an extension'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	param '2: extension name or "all"'
	example '$ df.enable plugin rvm'
	group 'dotfiles'

    if [ -z "$1" ] || [ -z "$2" ]; then
		reference df.enable
		return
    fi

	local exttype_arg=$1
	local extname=$2
	local exttype
	local exttype_single

	local exttype_arg_lo=`echo "$exttype_arg" | tr "[A-Z]" "[a-z]"`
	case $exttype_arg_lo in
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


df.enable.all()
{
	about 'enables all extensions of all types'
	example '$ df.enable.all'
	group 'dotfiles'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		df.enable $type all
	done
}



df.disable()
{
	about 'disables an extension'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	param '2: extension name name'
	example '$ df.disable plugin rvm'
	group 'dotfiles'

    if [ -z "$1" ] || [ -z "$2" ]; then
		reference df.disable
		return
	fi

	local exttype_arg=$1
	local extname=$2
	local exttype
	local exttype_single

	local exttype_arg_lo=`echo "$exttype_arg" | tr "[A-Z]" "[a-z]"`
	case $exttype_arg_lo in
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


df.disable.all()
{
	about 'disables all extensions of all types'
	example '$ df.disable.all'
	group 'dotfiles'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		df.disable $type all
	done
}



df.listexts.1()
{
    about 'summarizes the available extensions of a given type and their status'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	param '2: mode - can be "cat" to display details'
	param '3: filter'
	example '$ df.listexts.1 plugins'
	group 'dotfiles'

    if [ -z "$1" ]; then
		reference df.listexts.1
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

	local exttype_arg_lo=`echo "$exttype_arg" | tr "[A-Z]" "[a-z]"`
	case $exttype_arg_lo in
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
					if [ "$exttype" = "aliases" ]; then
						echo "========== BEGIN definitions of alias ${bf}: =========="
						cat "$f"
						echo "=========== END definitions of alias ${bf}. ==========="
						echo
					fi
					if [ "$exttype" = "plugins" ]; then
						local FUNC_GROUP=(${bf//./ })
						echo "========== BEGIN definitions of alias ${bf} - functions group $FUNC_GROUP: =========="
						df.help.funcs $FUNC_GROUP
						echo "=========== END definitions of alias ${bf} - functions group $FUNC_GROUP. ==========="
						echo
					fi
				fi
			done
		fi
	done
	echo ""
	echo "to enable a $exttype_single, do:"
	echo "\$ df.enable  $exttype_single <$exttype_single name> -or- $ df.enable $exttype_single all"
	echo ""
	echo "to disable a $exttype_single, do:"
	echo "\$ df.disable $exttype_single <$exttype_single name> -or- $ df.disable $exttype_single all"
	echo ""
}


df.listexts.all()
{
    about 'summarizes the available extensions of all types and their status'
	param '1: mode - can be "cat" to display details'
	param '2: filter'
	example '$ df.listexts.all'
	group 'dotfiles'

	local type
	for type in "exports" "aliases" "plugins" "completion"
	do
		df.listexts.1 $type $1 $2
	done
}


df.setup() {
	about 'interactivly sets up all available extensions of a given type'
	param '1: extension type - one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ df.setup plugin rvm'
	group 'dotfiles'

    if [ -z "$1" ]; then
		reference df.setup
		return
	fi

	local exttype_arg=$1
	local exttype
	local exttype_single
	local exttype_plural

	local exttype_arg_lo=`echo "$exttype_arg" | tr "[A-Z]" "[a-z]"`
	case $exttype_arg_lo in
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
				read -p "Would you like to enable the ${file_name%%.*} $exttype? [y/n/q] " RESP
				## read -p "Would you like to enable the ${file_name} $exttype? [Y/N/Q] " RESP
				local RESP_lo=`echo "$RESP" | tr "[A-Z]" "[a-z]"`
				case $RESP_lo in
					y | yes)
						ln -s "$path" "$ext_enabled_dir"
						break
						;;
					n | no)
						break
						;;
					q | quit)
						return
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


df.setup.all() {
	about 'interactivly sets up all extension types available'
	example '$ df.setup.all'
	group 'dotfiles'

	for type in "exports" "aliases" "plugins" "completion"
	do
		while true
		do
			echo
			read -p "Would you like to enable all, some, or no $type? Some of these may make bash slower to start up (especially completion). (all/some/none/quit) " RESP
			local RESP_lo=`echo "$RESP" | tr "[A-Z]" "[a-z]"`
			case $RESP_lo in
				s | some)
					df.setup $type
					break
					;;
				a | all)
					df.enable $type all
					break
					;;
				n | none)
					break
					;;
				q | quit)
					return
					;;
				*)
					echo "Unknown choice. Please enter some, all, or none"
					continue
					;;
			esac
		done
	done
}


df.help.exts()
{
    about 'summarizes the available extensions of the given types and their status'
	param '*: use "all" or a list of extension types - each must be one of: export or exports, alias or aliases, completion, plugin or plugins'
	example '$ df.help.exts plugins aliases'
	example '$ df.help.exts all'
	group 'dotfiles'

    if [ -z "$1" ]; then
		reference df.help.exts
		return
	fi

	local type
	for type in "$@"
	do
		if [ "$type" = "all" ]
		then
			df.listexts.all
			break;
		else
			df.listexts.1 $type
		fi
	done
}


df.help.alias()
{
    about 'summarizes the available aliases and their status'
	example '$ df.help.alias'
	group 'dotfiles'
	
	df.help.exts alias
}


df.help.plugin()
{
    about 'summarizes the available plugins and their status'
	example '$ df.help.plugin'
	group 'dotfiles'
	
	df.help.exts plugin
}


df.help.completion()
{
    about 'summarizes the available completions and their status'
	example '$ df.help.completion'
	group 'dotfiles'
	
	df.help.exts completion
}


df.help.aliasref.all()
{
    about 'presents the alias definition scripts for all available alias sets'
	example '$ df.help.aliasref.all'
	group 'dotfiles'

	df.listexts.1 "alias" "cat"
}


df.help.pluginref.all()
{
    about 'presents the alias definition scripts for all available alias sets'
	example '$ df.help.aliasref.all'
	group 'dotfiles'

	df.listexts.1 "plugin" "cat"
}


df.help.aliasref()
{
    about 'presents the alias definition scripts for the given alias sets'
	param '*: use "all" or a list of alias set names'
	example '$ df.help.aliasref git vim'
	example '$ df.help.aliasref all'
	group 'dotfiles'

    if [ -z "$1" ]; then
		reference df.help.aliasref
		echo
		echo "Available alias sets..."
		df.help.exts "alias"
		return
	fi

	local alfilter
	for alfilter in "$@"
	do
		if [ "$alfilter" = "all" ]
		then
			df.help.aliasref.all
			break;
		else
			df.listexts.1 "aliases" "cat" "$alfilter"
		fi
	done
}


df.help.fgroups ()
{
	about 'displays all unique function groups'
	group 'dotfiles'

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


df.help.funcs ()
{
	about 'summarize all functions defined by currently active plugins'
	param '*: use "all" or a function group - the available function groups will be displayed if you give no arguments'
	example '$ df.help.funcs help'
	example '$ df.help.funcs all'
	group 'dotfiles'

    if [ -z "$1" ]; then
		echo "!!!"
		reference df.help.funcs
		echo ""
		echo "=== Available function groups: ==="
		df.help.fgroups
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


df.help ()
{
	about 'summarize the available help functions'
	group 'dotfiles'

	df.help.funcs dotfiles
}




#
# Custom Help
dotfiles() {
	about 'summarize the available functions'
	group 'dotfiles'

	echo "Dotfiles baby!!!"
	echo
	df.help
	echo
	echo
	df.listexts.all $1 $2
}


alias df.help.aliases=df.help.alias
alias df.help.plugins=df.help.plugin
alias df.help.completions=df.help.completion


# top
#   help extensions
#   help dotfiles admin
#   interactive setup
#   setup




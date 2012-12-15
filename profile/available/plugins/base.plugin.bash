cite about-plugin
about-plugin 'miscellaneous tools'


diskusage ()
{
    about 'disk usage per directory, in Mac OS X and Linux'
    param '1: directory name'
    group 'base'
    if [ $(uname) = "Darwin" ]; then
        if [ -n $1 ]; then
            du -hd $1
        else
            du -hd 1
        fi

    elif [ $(uname) = "Linux" ]; then
        if [ -n $1 ]; then
            du -h --max-depth=1 $1
        else
            du -h --max-depth=1
        fi
    fi
}


ff ()
{
    about 'find a file on curren directory and its subdirectories'
    param 'file to find'
    example '$ ff foo'
    group 'base'

	find . -name "$@" -exec echo {} \;
}


mdcd ()
{
    about 'make a directory and cd into it'
    param 'path to create'
    example '$ mdcd foo'
    example '$ mdcd /tmp/img/photos/large'
    group 'base'
	mkdir -p "$@" && cd "$@"

##	mkdir -p "$*"
## 	cd "$*"
}

lsgrep ()
{
    about 'search through directory contents with grep'
    group 'base'
    ls | grep "$*"
}


pman ()
{
    about 'view man documentation in Preview'
    param '1: man page to view'
    example '$ pman bash'
    group 'base'
    man -t "${1}" | open -f -a $PREVIEW
}


command_exists ()
{
    about 'checks for existence of a command'
    param '1: command to check'
    example '$ command_exists ls && echo exists'
    group 'base'
    type "$1" &> /dev/null ;
}


# useful for administrators and configs
backwts ()
{
    about 'back up file with timestamp'
    param 'filename'
    group 'base'
    local filename=$1
    local filetime=$(date +%Y%m%d_%H%M%S)
    cp ${filename} ${filename}_${filetime}
}


pcurl ()
{
    about 'download file and Preview it'
    param '1: download URL'
    example '$ pcurl http://www.irs.gov/pub/irs-pdf/fw4.pdf'
    group 'base'
    curl "${1}" | open -f -a $PREVIEW
}


pmdown ()
{
    about 'preview markdown file in a browser'
    param '1: markdown file'
    example '$ pmdown README.md'
    group 'base'
    if command -v markdown &>/dev/null
    then
      markdown $1 | browser
    else
      echo "You don't have a markdown command installed!"
    fi
}


pickfrom ()
{
    about 'picks random line from file'
    param '1: filename'
    example '$ pickfrom /usr/share/dict/words'
    group 'base'
    local file=$1
    [ -z "$file" ] && reference $FUNCNAME && return
    length=$(cat $file | wc -l)
    n=$(expr $RANDOM \* $length \/ 32768 + 1)
    head -n $n $file | tail -1
}

pass ()
{
    about 'generates random password from dictionary words'
    param 'optional integer length'
    param 'if unset, defaults to 4'
    example '$ pass'
    example '$ pass 6'
    group 'base'
    local i pass length=${1:-4}
    pass=$(echo $(for i in $(eval echo "{1..$length}"); do pickfrom /usr/share/dict/words; done))
    echo "With spaces (easier to memorize): $pass"
    echo "Without (use this as the pass): $(echo $pass | tr -d ' ')"
}


if [ ! -e $DOTFILES_DIR/_ENABLED/profile/plugins/todo.plugin.bash ]; then
# if user has installed todo plugin, skip this...
t ()
{
    about 'one thing todo'
    param 'if not set, display todo item'
    param '1: todo text'
    group 'base'
	if [[ "$*" == "" ]] ; then
	    cat ~/.t
	else
	    echo "$*" > ~/.t
	fi
}
fi


quiet ()
{
    about 'what -does- this do?'
    group 'base'
	$* &> /dev/null &
}


#banish-cookies ()
#{
#    about 'redirect .adobe and .macromedia files to /dev/null'
#    group 'base'
#	rm -r ~/.macromedia ~/.adobe
#	ln -s /dev/null ~/.adobe
#	ln -s /dev/null ~/.macromedia
#}

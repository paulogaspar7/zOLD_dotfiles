cite about-plugin
about-plugin 'Hacking and programming'


dataurl() {
	about 'Create a data URL from an image - works for other file types too - if you tweak the Content-Type afterwards'
    param '1: image file name'
    example '$ dataurl pic.jpg'
    group 'hack'
    
	echo "data:image/${1##*.};base64,$(openssl base64 -in "$1")" | tr -d '\n'
}


function server() {
	about 'Start an HTTP server from a directory, optionally specifying the port'
	param '1: optional port number - defaults to 8000'
    example '$ server 9090'
    example '$ server'
	group 'hack'

	local port="${1:-8000}"
#	open "http://localhost:${port}/"
#	open "http://127.0.0.1:${port}/"

	java -jar $DOTFILES_DIR/profile/available/_helpers/dev-http-server.jar $port

	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
#	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"

#	$DOTFILES_DIR/profile/available/_helpers/www-devserver.rb port
}


function zip.dirs() {
	about 'Zips each subdirectory...'
	example '$ zip.dirs'
	group 'hack'

	local THIS_DIR=`pwd` # current working directory

	echo "Zip Dirs..."
	local G_DIRS1="$( find $THIS_DIR -maxdepth 1 -mindepth 1 -type d )"
	local D1
	for D1 in  $G_DIRS1 ; do
		local B=`basename $D1`
		local Z="${B}.zip"
		if [ -e "${THIS_DIR}/${Z}" ]
		then
			echo "zi.dirs operation interrupted: file ${THIS_DIR}/${Z} already exists!"
		else
			echo "Ziping $D1 ..."
			echo "zip -r $Z $B"
			zip -r $Z $B
		fi
	done
}


function gz() {
	about 'Returns the given file gzipped size'
	param '1: file name'
	example '$ gz mydoc.txt'
	group 'hack'

	echo "orig size (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}


extract () {
	about 'one command to extract them all...'
	param '1: compressed file name'
	example '$ extract mydoc.gz'
	group 'hack'
	
	if [ $# -ne 1 ]
	then
		echo "Error: No file specified."
		return 1
	fi
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xvjf $1   ;;
			*.tar.gz)  tar xvzf $1   ;;
			*.bz2)     bunzip2 $1    ;;
			*.rar)     unrar x $1    ;;
			*.gz)      gunzip $1     ;;
			*.tar)     tar xvf $1    ;;
			*.tbz2)    tar xvjf $1   ;;
			*.tgz)     tar xvzf $1   ;;
			*.zip)     unzip $1      ;;
			*.Z)       uncompress $1 ;;
			*.7z)      7z x $1       ;;
			*)         echo "'$1' cannot be extracted via extract" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}


# Test if HTTP compression (RFC 2616 + SDCH) is enabled for a given URL.
# Send a fake UA string for sites that sniff it instead of using the Accept-Encoding header. (Looking at you, ajax.googleapis.com!)
function httpcompression() {
	about 'Test if HTTP compression (RFC 2616 + SDCH) is enabled for a given URL'
	param '1: url to test'
	example '$ httpcompression ajax.googleapis.com'
	group 'hack'

	encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using ${encoding#* }" || echo "$1 is not using any encoding"
}


function gurl() {
	about 'Gzip-enabled `curl`'
	param '@: target url and other curl arguments'
	example '$ gurl http://www.somedomain.com/some/file.txt'
	group 'hack'

	curl -sH "Accept-Encoding: gzip" "$@" | gunzip
}


function json() {
	about 'Syntax-highlight JSON strings or files'
	param '1: json text'
	example '$ echo `{"foo":42}` | json'
	example '$ json `{"foo":42}`'
	group 'hack'

	if [ -p /dev/stdin ]; then
		# piping, e.g. `echo '{"foo":42}' | json`
		python -mjson.tool | pygmentize -l javascript
	else
		# e.g. `json '{"foo":42}'`
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	fi
}


function digga() {
	about 'All the dig info'
	param '1: host name'
	example 'digga github.com'
	group 'hack'

	dig +nocmd "$1" any +multiline +noall +answer
}

 
function escapeutf8() {
	about 'Escape UTF-8 characters into their 3-byte format'
	param '@: utf8 text'
	group 'hack'

	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	echo # newline
}


function unidecode() {
	about 'Decode \x{ABCD}-style Unicode escape sequences'
	param '@: unicode encoded text'
	group 'hack'

	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	echo # newline
}


function codepoint() {
	about 'Get a character’s Unicode code point'
	param '@: unicode text'
	group 'hack'

	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
	echo # newline
}



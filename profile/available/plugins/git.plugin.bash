cite about-plugin
about-plugin 'git helper functions'


# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@"
	}
fi


## TODO: test and check the "AWK" thing
function gh.log() {
	about 'git log with per-commit cmd-clickable GitHub URLs - iTerm'
	group 'git'

	local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
	[[ "$remote" ]] || return
	local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
	git log $* --name-status --color | awk "$(cat <<AWK
		/^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
		/^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
		/.*/ {print \$0}
AWK
	)" | less -F
}


function g.emptyfill() {
	about 'Add an empty .gitempty file to all empty sub directories'
	group 'git'

	find . -type d -empty -exec touch {}/.gitempty \;
}


function g.emptyclean() {
	about 'Remove .gitempty file to all empty sub directories'
	group 'git'

	find . -type f -empty -name '.gitempty' -ls -delete
}


function g.blamestats(){
	about 'blamed line statistics per author'
	group 'git'

	git ls-tree -r HEAD|cut -f 2|while read filename; do file "$filename"; done|grep -E ': .*text'|cut -f 1 -d : |xargs -n1 git blame --line-porcelain|grep "^author\ "|sort|uniq -c|sort -nr

	## git ls-tree -r HEAD|cut -f 2|grep -E '\.(java|jsp|xml|properties|wsdl|js|html|css|htm|txt)$' |xargs -n1 git blame --line-porcelain|grep "^author\ "|sort|uniq -c|sort -nr
}


function g.blamestats2(){
	about 'blamed line statistics per author'
	group 'git'

	git ls-tree -r HEAD|cut -f 2|grep -E '\.(java|jsp|xml|properties|wsdl|js|html|css|htm|txt)$' |xargs -n1 git blame --line-porcelain|grep "^author\ "|sort|uniq -c|sort -nr
}


function g.blamestatsJavaXml(){
	about 'blamed line statistics per author'
	group 'git'

	git ls-tree -r HEAD|cut -f 2|grep -E '\.(java|xml|properties)$' |xargs -n1 git blame --line-porcelain|grep "^author\ "|sort|uniq -c|sort -nr
}


## TODO: check this one
function g.export(){
	about 'take this repo and copy it to somewhere else minus the .git stuff'
	group 'git'
	
	git archive master | tar -x -C "$1"
}


function g.remote.addmine {
	about 'adds remote $GIT_HOSTING:$1 to current repo'
	group 'git'

	echo "Running: git remote add origin ${GIT_HOSTING}:$1.git"
	git remote add origin $GIT_HOSTING:$1.git
}

function g.push.1st {
	about 'push into origin refs/heads/master'
	group 'git'

	echo "Running: git push origin master:refs/heads/master"
	git push origin master:refs/heads/master
}


function g.rm.missing() {
	about "git rm's missing files"
	group 'git'

	git ls-files -d -z | xargs -0 git update-index --remove
}


function g.add.allchanges() {
	about "git adds all changes and rm's missing files"
	group 'git'

	git add -A
}



# Adds files to git's exclude file (same as .gitignore)
function g.ignore.localadd() {
	about 'adds file or path to git exclude file'
	param '1: file or path fragment to ignore'
	group 'git'
	echo "$1" >> .git/info/exclude
}

# get a quick overview for your git repo
function g.info() {
	about 'overview for your git repo'
	group 'git'

	if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
		# print informations
		echo "git repo overview"
		echo "-----------------"
		echo

		local GREMOTE
		if [ $# -eq 0 ]; then
		# print all remotes and their details
			for GREMOTE in $(git remote show); do
				echo $GREMOTE:
				git remote show $GREMOTE
				echo
			done
		else
			GREMOTE=$1
			echo $GREMOTE:
			git remote show $GREMOTE
			echo
		fi

		# print status of working repo
		echo "status:"
		if [ -n "$(git status -s 2> /dev/null)" ]; then
			git status -s
		else
			echo "working directory is clean"
		fi

		# print at least 5 last log entries
		echo
		echo "log:"
		git log -5 --oneline
		echo
	else
		echo "you're currently not in a git repository"
	fi
}

function g.stats {
	about 'display stats per author'
	group 'git'

# awesome work from https://github.com/esc/git-stats
# including some modifications

	if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
		echo "Number of commits per author:"
		git --no-pager shortlog -sn --all
		AUTHORS=$( git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
		LOGOPTS=""
		if [ "$1" == '-w' ]; then
			LOGOPTS="$LOGOPTS -w"
			shift
		fi
		if [ "$1" == '-M' ]; then
			LOGOPTS="$LOGOPTS -M"
			shift
		fi
		if [ "$1" == '-C' ]; then
			LOGOPTS="$LOGOPTS -C --find-copies-harder"
			shift
		fi
		for a in $AUTHORS
		do
			echo '-------------------'
			echo "Statistics for: $a"
			echo -n "Number of files changed: "
			git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f3 | sort -iu | wc -l
			echo -n "Number of lines added: "
			git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
			echo -n "Number of lines deleted: "
			git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
			echo -n "Number of merges: "
			git log $LOGOPTS --all --merges --author=$a | grep -c '^commit'
		done
	else
		echo "you're currently not in a git repository"
	fi
}


function g.cohead() {
	about 'Checks out all files from HEAD at local directory'
	example '$ g.cohead'
	group 'git'

	echo "Checking out all files from HEAD..."

	echo "git config --local --bool core.bare false"
	git config --local --bool core.bare false

	echo "git checkout HEAD -- ."
	git checkout HEAD -- .
	echo ""
}


function g.wipeignored() {
	git clean -fdx
}


function g.dryrun.wipeignored() {
	git clean -fdxn
}


function g.gobare() {
	about 'Makes current git directory bare'
	example '$ g.gobare'
	group 'git'

	local THIS_DIR=`pwd` # current working directory

	if [ -e "${THIS_DIR}/.git" ]
	then
		echo "GO BARE!"
		local G_DIRS1="$( find $THIS_DIR -maxdepth 1 -mindepth 1 -type d )"
		local D1
		for D1 in  $G_DIRS1 ; do
			local B=`basename $D1`
			if [ "$B" == '.git' ]
			then
				echo "This is the .git dir: $D1 ..."
			else
				echo "Removing $D1 ..."
				echo "rm -rf $D1"
				rm -rf $D1
			fi
		done
		local G_FILES1="$( find $THIS_DIR -maxdepth 1 -mindepth 1 -type f )"
		local F1
		for F1 in  $G_FILES1 ; do
			echo "Removing $F1 ..."
			echo "rm $F1"
			rm $F1
		done
		echo "git config --local --bool core.bare true"
		git config --local --bool core.bare true
	else
		echo "Directory $THIS_DIR is NOT a Git workspce"
	fi
}


function g.trackallbranches() {
	about 'tracks all branches on remote $1'
	param '1: remote name'
	example '$ g.trackallbranches'
	example '$ g.trackallbranches origin'
	group 'git'

	local GREMOTE
	if [ $# -eq 0 ]; then
		GREMOTE=origin
	else
		GREMOTE =$1
	fi

	echo "track and pull all branches @ $CURR"

	for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do
	    echo "git branch --track ${branch##*/} $branch"
	    git branch --track ${branch##*/} $branch
	done

	echo "git fetch --tags $GREMOTE # --all"
	git fetch --tags $GREMOTE  # --all

	echo "git pull $GREMOTE  # --all"
	git pull $GREMOTE  # --all
	echo ""
}


function g.cop() {
	about 'runs commands git co $1 ; git pull $1 $2'
	param '1: remote name'
	param '2: branch name'
	example '$ g.cop'
	example '$ g.cop origin mine'
	group 'git'

	local CURR=`pwd`
	echo "git co $2 + git pull $1 $2 @ $CURR"
	git checkout $2
	git pull $1 $2
}


function g.copmaster() {
	about 'runs commands git co master ; git pull origin master'
	example '$ g.copmaster'
	group 'git'

	g.cop origin master
}


# Consider this a private/helper function
function g.run() {
	local D1=`pwd`
	local CMD2CALL="$@"

	echo
	echo "=========="
	echo "@ $D1: $CMD2CALL"
	cd $D1
	$CMD2CALL
	echo
}


function g1.runall() {
	about 'runs the given command on all git repositories on 1st level subdirectories of current directory'
	param '@: command to execute'
	example '$ g1.runall git status'
	group 'git'

	if [ $# -eq 0 ]; then
		echo "No command was given to execute!"
		exit 1
	fi

	local CMD2CALL="$@"
	#	echo "args = $CMD2CALL"
	
	local TOP_DIR=`pwd` # current working directory
	local G_DIRS1="$( find $TOP_DIR -maxdepth 1 -mindepth 1 -type d )"
	local D1
	for D1 in  $G_DIRS1 ; do
		if [ -e "$D1/.git" ]
		then
			cd $D1
			g.run "$CMD2CALL"
		fi
	done
	cd $TOP_DIR
}


function g1.camall() {
	about 'runs the git cam command on all git repositories on 1st level subdirectories of current directory'
	param '@: command to execute'
	example '$ g1.camall "Some commit message."'
	group 'git'

	if [ $# -eq 0 ]; then
		echo "No message was given to commit!"
		exit 1
	fi

	local COMMIT_MSG="$@"
	#	echo "args = $COMMIT_MSG"
	
	local TOP_DIR=`pwd` # current working directory
	local G_DIRS1="$( find $TOP_DIR -maxdepth 1 -mindepth 1 -type d )"
	local D1
	for D1 in  $G_DIRS1 ; do
		if [ -e "$D1/.git" ]
		then
			cd $D1
			echo "git cam @ $D1..."
			git cam "\"$COMMIT_MSG\""
		fi
	done
	cd $TOP_DIR
}


function g1.runall.repoarg() {
	about 'runs the given command on all git repositories on 1st level subdirectories of current directory'
	param '@: command to execute'
	example '$ g1.runall git status'
	group 'git'

	if [ $# -eq 0 ]; then
		echo "No command was given to execute!"
		exit 1
	fi

	local CMD2CALL="$@"
	#	echo "args = $CMD2CALL"
	
	local TOP_DIR=`pwd` # current working directory
	local G_DIRS1="$( find $TOP_DIR -maxdepth 1 -mindepth 1 -type d )"
	local D1
	for D1 in  $G_DIRS1 ; do
		if [ -e "$D1/.git" ]
		then
			cd $D1
			DIR="${D1##*/}"
			g.run "$CMD2CALL$DIR"
		fi
	done
	cd $TOP_DIR
}


function g2.runall() {
	about 'runs the given command on all git repositories down to the 2nd level subdirectories of current directory'
	param '@: command to execute'
	example '$ g2.runall git status'
	group 'git'

	if [ $# -eq 0 ]; then
		echo "No command was given to execute!"
		exit 1
	fi

	local CMD2CALL="$@"
#	echo "args = $CMD2CALL"
	
	local TOP_DIR=`pwd` # current working directory
	local G_DIRS1="$( find $TOP_DIR -maxdepth 2 -mindepth 1 -type d )"
	local D1
	for D1 in  $G_DIRS1 ; do
		if [ -e "$D1/.git" ]
		then
			cd $D1
			g.run "$CMD2CALL"
		else
			g1.runall "$CMD2CALL"
		fi
	done
	cd $TOP_DIR
}


function g0.runall() {
	about 'runs the given command on all git repositories on any subdirectories of current directory'
	param '@: command to execute'
	example '$ g2.runall git status'
	group 'git'

	if [ $# -eq 0 ]; then
		echo "No command was given to execute!"
		exit 1
	fi

#	echo
#	echo "Processing subfolders from \"$TOP_DIR\"..."

	local CMD2CALL="$@"
#	echo "args = $CMD2CALL"
	
	local TOP_DIR=`pwd` # current working directory
	local G_DIRS1="$( find $TOP_DIR -maxdepth 1 -mindepth 1 -type d )"
	local D1
	for D1 in  $G_DIRS1 ; do
		cd $D1
		if [ -e ".git" ]
		then
			cd $D1
			g.run "$CMD2CALL"
		else
			g0.runall "$CMD2CALL"
		fi
	done
	cd $TOP_DIR
}



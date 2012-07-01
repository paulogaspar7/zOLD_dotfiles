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
function ghl() {
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


## TODO: check this one
function gitexport(){
	about 'take this repo and copy it to somewhere else minus the .git stuff'
	group 'git'
	
	git archive master | tar -x -C "$1"
}


function git_remote {
  about 'adds remote $GIT_HOSTING:$1 to current repo'
  group 'git'

  echo "Running: git remote add origin ${GIT_HOSTING}:$1.git"
  git remote add origin $GIT_HOSTING:$1.git
}

function git_first_push {
  about 'push into origin refs/heads/master'
  group 'git'

  echo "Running: git push origin master:refs/heads/master"
  git push origin master:refs/heads/master
}


function git_remove_missing_files() {
  about "git rm's missing files"
  group 'git'

  git ls-files -d -z | xargs -0 git update-index --remove
}


function git_add_allchanges() {
  about "git adds all changes and rm's missing files"
  group 'git'

  git add -A
}



# Adds files to git's exclude file (same as .gitignore)
function local-ignore() {
  about 'adds file or path to git exclude file'
  param '1: file or path fragment to ignore'
  group 'git'
  echo "$1" >> .git/info/exclude
}

# get a quick overview for your git repo
function git_info() {
    about 'overview for your git repo'
    group 'git'

    if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
        # print informations
        echo "git repo overview"
        echo "-----------------"
        echo

        # print all remotes and thier details
        for remote in $(git remote show); do
            echo $remote:
            git remote show $remote
            echo
        done

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

function git_stats {
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


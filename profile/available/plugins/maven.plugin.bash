
# Consider this a private/helper function
function m.run() {
	local D1=`pwd`
	local CMD2CALL="$@"

	echo
	echo "=========="
	echo "@ $D1: $CMD2CALL"
	cd $D1
	$CMD2CALL
	echo
}


function m1.runall() {
	about 'runs the given command on all pom.xml directories on 1st level subdirectories of current directory'
	param '@: command to execute'
	example '$ m1.runall cloc'
	group 'maven'

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
		local DD=`basename "$D1"`
		if [ "$DD" != '.git' ] && [ "$DD" != 'target' ]
		then
			cd $D1
			if [ -e "pom.xml" ]
			then
				m.run "$CMD2CALL"
			fi
		fi
	done

	cd $TOP_DIR
}


function m2.runall() {
	about 'runs the given command on all pom.xml directories down to the 2nd level subdirectories of current directory'
	param '@: command to execute'
	example '$ m2.runall cloc'
	group 'maven'

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
		local DD=`basename "$D1"`
		if [ "$DD" != '.git' ] && [ "$DD" != 'target' ]
		then
			cd $D1
			m1.runall "$CMD2CALL"
			if [ -e "pom.xml" ]
			then
				m.run "$CMD2CALL"
			fi
		fi
	done
	cd $TOP_DIR
}


function m0.runall() {
	about 'runs the given command on all pom.xml directories on any subdirectories of current directory'
	param '@: command to execute'
	example '$ m0.runall cloc'
	group 'maven'

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
		local DD=`basename "$D1"`
		if [ "$DD" != '.git' ] && [ "$DD" != 'target' ]
		then
			cd $D1
			m0.runall "$CMD2CALL"
			if [ -e "pom.xml" ]
			then
				m.run "$CMD2CALL"
			fi
		fi
	done
	cd $TOP_DIR
}

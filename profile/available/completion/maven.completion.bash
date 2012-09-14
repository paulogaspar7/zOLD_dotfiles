#!/bin/bash

cite about-completion
about-completion 'Maven related completions'


# echo "Maven completions..."

_m2_make_goals()
{
  plugin=$1
  mojos=$2
  for mojo in $mojos
  do
    export goals="$goals $plugin:$mojo"
  done
}

_m2_complete()
{
  local cur goals

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  goals='clean compile test install package deploy site'
  goals=$goals _m2_make_goals "eclipse" "eclipse"
  goals=$goals _m2_make_goals "idea" "idea"
  goals=$goals _m2_make_goals "assembly" "assembly"
  goals=$goals _m2_make_goals "plexus" "app bundle-application bundle-runtime descriptor runtime service"
  cur=`echo $cur | sed 's/\\\\//g'`
  COMPREPLY=($(compgen -W "${goals}" ${cur} | sed 's/\\\\//g') )
}

complete -F _m2_complete -o filenames mvn
## export LSCOLORS=gxgxcxdxbxegedabagacad  # cyan directories
## export PS1='\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '



### TODO: From here down it is all new. Should replace the above code???

_mvn()
{
   local cmds cur colonprefixes
   cmds="clean validate compile test package integration-test   \
      verify install deploy test-compile site generate-sources  \
      process-sources generate-resources process-resources      \
      eclipse:eclipse eclipse:add-maven-repo eclipse:clean      \
      idea:idea -DartifactId= -DgroupId= -Dmaven.test.skip=true \
      -Declipse.workspace= -DarchetypeArtifactId=               \
      netbeans-freeform:generate-netbeans-project               \
      tomcat:run tomcat:run-war tomcat:deploy jboss-as:deploy   \
      versions:display-dependency-updates                       \
      versions:display-plugin-updates dependency:analyze        \
      dependency:analyze-dep-mgt dependency:resolve             \
      dependency:sources dependency:tree release:prepare        \
      release:rollback release:perform --batch-mode"

   COMPREPLY=()
   cur=${COMP_WORDS[COMP_CWORD]}
   # Work-around bash_completion issue where bash interprets a colon
   # as a separator.
   # Work-around borrowed from the darcs work-around for the same
   # issue.
   colonprefixes=${cur%"${cur##*:}"}
   COMPREPLY=( $(compgen -W '$cmds'  -- $cur))
   local i=${#COMPREPLY[*]}
   while [ $((--i)) -ge 0 ]; do
      COMPREPLY[$i]=${COMPREPLY[$i]#"$colonprefixes"}
   done

        return 0
} &&
complete -F _mvn mvn

#!/usr/bin/env bash

cite about-alias
about-alias 'general aliases'


### Remember that, with completion, aliases do not have to be short to become short,
### as long as they have an unusual start.
### lets avoid collisions that make some of then unusable

##### List directory contents
## alias ls='ls -G'        # Compact view, show colors
alias l="ls -alAhp"
alias ls="ls -alAskp"

alias sl=ls
alias la='ls -AF'       # Compact view, show hidden
alias ll='ls -al'
#alias l='ls -a'
alias l1='ls -1'

# List only directories
alias lsd='ls -l | grep "^d"'

if [ $(uname) = "Linux" ]
then
  alias ls="ls --color=always"
fi

# File size
alias fs="stat -c \"%s bytes\""



##### Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~' # `cd` is probably faster to type though
alias -- -='cd -'

# Shell History
alias h='history'



##### More directory play...

# Tree
if [ ! -x "$(which tree 2>/dev/null)" ]
then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

# Directory
alias	md='mkdir -p'
alias	rd='rmdir'


#### sudo related

# Enable aliases to be sudo’ed
alias sudo='sudo '

alias _='sudo'


##### Misclleneous...

which gshuf &> /dev/null
if [ $? -eq 1 ]
then
  alias shuf=gshuf
fi

alias k='clear'
alias cls='clear'

alias edit="$EDITOR"
alias pager="$PAGER"

alias q='exit'

alias irc="$IRC_CLIENT"

alias rb='ruby'

# Pianobar can be found here: http://github.com/PromyLOPh/pianobar/
# alias piano="pianobar"



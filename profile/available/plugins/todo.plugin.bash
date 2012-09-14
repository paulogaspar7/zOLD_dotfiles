#!/bin/bash

# you may override any of the exported variables below in your .bash_profile

if [ -z "$TODO_DIR" ]; then
    export TODO_DIR=$DOTFILES_PRIVATE_DIR/data/todo  # store todo items in user's private data dir
	
fi
if [ ! -e $TODO_DIR ]; then
    mkdir -p $TODO_DIR
	
fi
if [ -z "$TODOTXT_DEFAULT_ACTION" ]; then
    export TODOTXT_DEFAULT_ACTION=ls       # typing 't' by itself will list current todos
fi
if [ -z "$TODO_SRC_DIR" ]; then
    export TODO_SRC_DIR=$DOTFILES_DIR/profile/available/plugins/todo
fi

# respect ENV var set in .bash_profile, default is 't'
alias $TODO='$TODO_SRC_DIR/todo.sh -d $TODO_SRC_DIR/todo.cfg'

export PATH=$PATH:$TODO_SRC_DIR
source $TODO_SRC_DIR/todo_completion   # bash completion for todo.sh
complete -F _todo $TODO                # enable completion for 't' alias

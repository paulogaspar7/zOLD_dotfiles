#!/usr/bin/env bash

cite about-alias
about-alias 'common git commands'

# Aliases
alias g='git'
alias gcl='git clone'
alias ga='git add'
alias gall='git add .'
## alias get='git'
alias gst='git status'
alias gs='git status'
alias gss='git status -s'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gpo='git push origin'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gci='git commit --interactive'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gexport='git archive --format zip --output'
alias gdel='git branch -D'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gll='git log --graph --pretty=oneline --abbrev-commit'

case $OSTYPE in
  linux*)
    alias gd='git diff | vim -R -'
    ;;
  darwin*)
    alias gd='git diff | mate'
    ;;
  darwin*)
    alias gd='git diff'
    ;;
esac

# Autocomplete for 'g' as well
complete -o default -o nospace -F _git g

# alias g.trackallb='g.trackallbranches'

alias g0.trackallb='g0.runall g.trackallbranches'
alias g1.trackallb='g1.runall g.trackallbranches'
alias g2.trackallb='g2.runall g.trackallbranches'

alias g0.status='g0.runall git status'
alias g1.status='g1.runall git status'
alias g2.status='g2.runall git status'

alias g0.remotes.view='g0.runall git remotes -v'
alias g1.remotes.view='g1.runall git remotes -v'
alias g2.remotes.view='g2.runall git remotes -v'

alias g0.origins.show='g0.runall git remote show origin'
alias g1.origins.show='g1.runall git remote show origin'
alias g2.origins.show='g2.runall git remote show origin'

alias g0.cop='g0.runall g.cop'
alias g1.cop='g1.runall g.cop'
alias g2.cop='g2.runall g.cop'

alias g0.copmaster='g0.runall g.copmaster'
alias g1.copmaster='g1.runall g.copmaster'
alias g2.copmaster='g2.runall g.copmaster'

alias g0.fetchall='g0.runall git fetch --all --tags'
alias g1.fetchall='g1.runall git fetch --all --tags'
alias g2.fetchall='g2.runall git fetch --all --tags'

alias g0.fetch='g0.runall git fetch --tags'
alias g1.fetch='g1.runall git fetch --tags'
alias g2.fetch='g2.runall git fetch --tags'

alias g0.pull='g0.runall git pull'
alias g1.pull='g1.runall git pull'
alias g2.pull='g2.runall git pull'


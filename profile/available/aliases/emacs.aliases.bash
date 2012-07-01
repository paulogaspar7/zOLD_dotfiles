#!/usr/bin/env bash

cite about-alias
about-alias 'Emacs related aliases'

case $OSTYPE in
  linux*)
    alias em='emacs'
    alias e='emacsclient -n'
    ;;
  darwin*)
    alias em="open -a emacs"
    ;;
esac

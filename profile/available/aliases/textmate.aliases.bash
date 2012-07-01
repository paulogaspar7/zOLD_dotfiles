#!/usr/bin/env bash

cite about-alias
about-alias 'TextMate related aliases'


case $OSTYPE in
  darwin*)
    # Textmate
    alias e='mate . &'
    alias et='mate app config db lib public script test spec config.ru Gemfile Rakefile README &'
    ;;
esac

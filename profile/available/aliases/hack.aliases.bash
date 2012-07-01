#!/usr/bin/env bash

cite about-alias
about-alias 'Hacking / programming related aliases'


# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'


# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'


# Canonical hex dump; some systems have this symlinked
type -t hd > /dev/null || alias hd="hexdump -C"

# `cat` with beautiful colors. requires Pygments installed.
alias c='pygmentize -O style=borland -f console256 -g'

##### Pygment styles:
# ['monokai', 'manni', 'rrt', 'perldoc', 'borland', 'colorful', 'default', 'murphy', 'vs', 
# 'trac', 'tango', 'fruity', 'autumn', 'bw', 'emacs', 'vim', 'pastie', 'friendly', 'native']
#
# good on white background
# 	manni, perldoc, borland, vs
#
# bad in white background
#	monokai, rrt, fruity, vim, native
#
# "meh!" in white background
#	colorful, default, murphy, trac, tango, autumn, emacs, pastie, friendly
#
# "bw" is just black



# Just for fun...
alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF R U DOIN'"


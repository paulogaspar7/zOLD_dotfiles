#!/usr/bin/env bash

cite about-alias
about-alias 'OS X related aliases'


##### really usual commands
alias subl='open -a "Sublime Text 2"'

alias j='jobs'
alias v='vim'
alias m='mate .'
alias s='subl .'
alias o='open'
alias oo='open .'


alias apache.start='sudo apachectl start'
alias apache.stop='sudo apachectl stop'



##### OS X Specific hacking...

# OS X has no `md5sum`, so use `md5` as a fallback
type -t md5sum > /dev/null || alias md5sum='md5'


## QuickView??
# alias qv='qlmanage -p "$@" >& /dev/null'


##### Clipboard...

# Trim new lines and copy to clipboard
alias c2clip="tr -d '\n' | pbcopy"

alias plaincopy="pbpaste -Prefer txt | pbcopy; pbpaste; echo"

##### Battery...
alias battery.summary='ioreg -n AppleSmartBattery -r'
alias battery.cycles='ioreg -n AppleSmartBattery -r|grep -i  CycleCount\" --color=never'


##### Maintenance, maintenance...
# Get OS X Software Updates
alias update='sudo softwareupdate -i -a'

# Update Homebrew itself, and upgrade installed Homebrew packages
alias updatebrew='brew update; brew upgrade'

# Update both above
alias updateall='sudo softwareupdate -i -a; brew update; brew upgrade'

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash"

# Also, clear Apple’s System Logs to improve shell startup speed
alias emptylogs="sudo rm -rfv /private/var/log/asl/*.asl"

# Recursively delete `.DS_Store` files
alias cleanmacfiles="find . -type f -name '*.DS_Store' -ls -delete"

# Flush Directory Service cache
alias flushcache='dscacheutil -flushcache'

# Disable Spotlight
alias spotoff='sudo mdutil -a -i off'

# Enable Spotlight
alias spoton='sudo mdutil -a -i on'


##### Sound...
alias stfu="osascript -e 'set volume output muted true'"
alias sound0="osascript -e 'set volume output muted true'"
alias soundoff="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"
alias soundmax="osascript -e 'set volume 7'"
alias sound1="osascript -e 'set volume 1'"
alias sound2="osascript -e 'set volume 2'"
alias sound3="osascript -e 'set volume 3'"
alias sound4="osascript -e 'set volume 4'"
alias sound5="osascript -e 'set volume 5'"
alias sound6="osascript -e 'set volume 6'"
alias sound7="osascript -e 'set volume 7'"


##### Show and hide...

# Show/hide hidden files in Finder
alias showhf='defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder'
alias hidehf='defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder'

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'


##### More defaults handling...

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy='/usr/libexec/PlistBuddy'


##### More navigation
alias dropbox='cd ~/Documents/Dropbox'


##### Desktop Programs

# Core stuff
alias preview="open -a '$PREVIEW'"
alias f='open -a Finder '
alias fh='open -a Finder .'

# Adobe
alias fireworks="open -a '/Applications/Adobe Fireworks CS3/Adobe Fireworks CS3.app'"
alias photoshop="open -a '/Applications/Adobe Photoshop CS3/Adobe Photoshop.app'"

# Mac Developer
alias xcode="open -a '/Developer/Applications/Xcode.app'"
alias filemerge="open -a '/Developer/Applications/Utilities/FileMerge.app'"

# Browsers
alias safari='open -a safari'
alias firefox='open -a firefox'
alias chrome="open -a google\ chrome"
alias chromium='open -a chromium'

# Programming Editors / Viewers
alias dashcode='open -a dashcode'
alias textedit='open -a TextEdit'
alias hex='open -a "Hex Fiend"'

if [ -s /usr/bin/firefox ] ; then
  unalias firefox
fi


# Requires growlnotify, which can be found in the Growl DMG under "Extras"
alias grnot='growlnotify -s -t Terminal -m "Done"'


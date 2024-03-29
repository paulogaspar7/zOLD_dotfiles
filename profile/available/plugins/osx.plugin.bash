cite about-plugin
about-plugin 'OS X specific functions'

function brew.fix() {
  about 'Usual Homebrew fix'
  param '1: apply usual fix to Homebrew directories'
  example '$ brew.fix'
  group 'osx'

  sudo chown -R $(whoami) /usr/local/bin
  sudo chown -R $(whoami) /usr/local/share
}

function tab.run() {
  about 'opens a new terminal tab and run given command'
  param '1: command to run on new tab'
  example '$ tab.run "echo H3llo W0rld!" 2d'
  group 'osx'

  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command "cd \"$PWD\"; $*" in window 1
    end tell
EOF
}


# this one switches your os x dock between 2d and 3d
# thanks to savier.zwetschge.org
function dock.switch() {
    about 'switch dock between 2d and 3d'
    param '1: "2d" or "3d"'
    example '$ dock-switch 2d'
    group 'osx'

    if [ $(uname) = "Darwin" ]; then

        if [ $1 = 3d ] ; then
            defaults write com.apple.dock no-glass -boolean NO
            killall Dock

        elif [ $1 = 2d ] ; then
            defaults write com.apple.dock no-glass -boolean YES
            killall Dock

        else
            echo "usage:"
            echo "dock-switch 2d"
            echo "dock-switch 3d."
        fi
    else
        echo "Sorry, this only works on Mac OS X"
    fi
}

# Download a file and open it in Preview

function prevcurl() {
  about 'download a file and open it in Preview'
  param '1: url'
  group 'osx'

  if [ ! $(uname) = "Darwin" ]
  then
    echo "This function only works with Mac OS X"
    return 1
  fi
  curl "$*" | open -fa "Preview"
}

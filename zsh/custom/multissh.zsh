#!/usr/bin/env zsh -e

function multissh() {
  # Open a new iTerm2 window
osascript -e '
  tell application "iTerm"
    create window with default profile
  end tell
'
servers=(
seadrift11
seadrift12
seadrift13
seadrift14
seadrift15
seadrift16
seadrift17
seadrift18
seadrift19
seadrift20
seadrift21
seadrift22
seadrift23
seadrift24
seadrift25
seadrift26
seadrift27
seadrift28
seadrift29
seadrift30
)

for num in $servers; do
  server="${num}.prv.bislr.net"
osascript <<END
  set command to "ssh $server"
  tell application "iTerm"
    tell current window
      create tab with default profile
    end tell
    tell current tab of current window
      set _new_session to last item of sessions
    end tell
    tell _new_session
      select
      write text (command)
    end tell
  end tell
END
done

# close the first window which is empty
osascript -e '
  tell application "iTerm"
  tell current window
    close first tab
  end tell
end tell
'
}

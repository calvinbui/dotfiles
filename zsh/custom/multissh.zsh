#!/usr/bin/env zsh -e

function multissh() {
  # Open a new iTerm2 window
osascript -e '
  tell application "iTerm"
    create window with default profile
  end tell
'
servers=(
  ap2bms5-notifications1
  ap2bms5-notifications2
  ap2bms5-notifications3
  ap2bms5-notifications4
  ap2bms5-notifications5
  ap2bms5-notifications6
  ap2bms5-notifications7
  ap2bms5-notifications8
  ap2bms5-notifications9
  ap2bms5-notifications10
  ap2bms5-notifications11
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

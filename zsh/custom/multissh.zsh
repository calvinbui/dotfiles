#!/usr/bin/env zsh -e

function multissh() {
  # Open a new iTerm2 window
osascript -e '
  tell application "iTerm"
    create window with default profile
  end tell
'
servers=(ap2bms5-notifications6 ap2bms5-redirect-lb chris-server pavilion staging-mongo1 tempsights3 tempsights4 tempsights5 tempsights6 tempsights7 tempsights8)

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

#!/usr/bin/env zsh -e

function multissh() {
  # Open a new iTerm2 window
osascript -e '
  tell application "iTerm"
    create window with default profile
  end tell
'
servers=(
ap2salamander61
ap2salamander62
ap2salamander63
ap2salamander64
ap2salamander65
ap2salamander66
ap2salamander67
ap2salamander68
ap2salamander69
ap2salamander70
ap2salamander71
ap2salamander72
ap2salamander73
ap2salamander74
ap2salamander75
ap2salamander76
ap2salamander77
ap2salamander78
ap2salamander79
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

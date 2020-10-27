#!/bin/bash

function changeBrowser() {
  swift run --package-path /Users/calvin/repos/DefaultBrowserTool/ DefaultBrowserTool --force --input "$1"
}

function getBrowser() {
  swift run --package-path /Users/calvin/repos/DefaultBrowserTool/ DefaultBrowserTool --silence
}

if ! pgrep Outlook > /dev/null && ! pgrep Slack > /dev/null; then
  browser="org.chromium.Chromium"
else
  browser="com.google.Chrome"
fi

currentBrowser=$(getBrowser)
if [ "$currentBrowser" != "$browser" ]; then
  changeBrowser "$browser"
  /usr/bin/osascript -e "display notification \"Changing default browser to $browser\""
fi

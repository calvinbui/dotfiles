#!/usr/bin/env bash

dmg2john_cmd(){
  echo "Generating hash file"
  "$(dirname $(readlink -f /usr/local/bin/john))/dmg2john" "$1"
}

dmgcrack(){
  dmg="$1"
  dmg2john_cmd "${dmg}" > "${dmg}".hash
  john --format=dmg-opencl --mask="mac-torrent-download.net_[0-9a-z][0-9a-z][0-9a-z]" "${dmg}".hash
  password=$(john --show "${dmg}".hash | sed '1q;d' | cut -d':' -f2)
  echo "The password for $dmg is $password"
  echo "Setting empty password"
  printf '%s\0' "$password" '' | hdiutil chpass "${dmg}" -oldstdinpass -newstdinpass 
}
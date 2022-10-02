#!/usr/bin/env bash

dmg2john_cmd(){
  echo "Generating hash file"
  "$(dirname $(readlink -f /opt/homebrew/bin/john))/dmg2john" "$1"
}

dmgcrack(){
  dmg="$1"
  dmg2john_cmd "${dmg}" > "${dmg}".hash
  john --format=dmg-opencl --mask="mac-torrent-download.net_[0-9a-z][0-9a-z][0-9a-z]" "${dmg}".hash
  password=$(john --show "${dmg}".hash | sed '1q;d' | cut -d':' -f2)
  echo "The password for $dmg is $password"
  echo "Setting empty password"
  printf '%s\0' "$password" '' | hdiutil chpass "${dmg}" -oldstdinpass -newstdinpass
  rm "${dmg}".hash
}

rar2john_cmd(){
  echo "Generating hash file"
  "$(dirname $(readlink -f /opt/homebrew/bin/john))/rar2john" "$1"
}

rarcrack(){
  rar="$1"
  rar2john_cmd "${rar}" > "${rar}".hash
  john --format=RAR5-opencl --mask="mac-torrent-download.net_[0-9a-z][0-9a-z][0-9a-z]" "${rar}".hash
  password=$(john --show "${rar}".hash | sed '1q;d' | cut -d':' -f2)
  echo "The password for $rar is $password"
  rm "${rar}".hash
}

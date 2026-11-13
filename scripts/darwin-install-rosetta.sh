#!/bin/sh
set -eu

# rosetta: run x86_64 binaries on Apple Silicon
if ! /usr/bin/pgrep -q oahd; then
  sudo softwareupdate --install-rosetta --agree-to-license
fi

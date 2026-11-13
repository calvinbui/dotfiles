#!/bin/sh
set -eu

if ! command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

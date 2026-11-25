#!/bin/sh
set -eu

# no analytics, including the installer's first brew commands
export HOMEBREW_NO_ANALYTICS=1

if ! command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# persist the opt-out for brew runs outside zsh (GUI apps, scripts, cron)
/opt/homebrew/bin/brew analytics off
/opt/homebrew/bin/brew analytics state

#!/bin/sh
set -eu

# the first bundle runs before platform.zsh is stowed
export HOMEBREW_NO_ANALYTICS=1

# installs whatever in the Brewfile is missing; --no-upgrade = upgrades stay manual
brew bundle --no-upgrade --file="$(dirname "$0")/../Brewfile"

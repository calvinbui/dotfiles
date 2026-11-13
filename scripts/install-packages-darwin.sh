#!/bin/sh
set -eu

# installs whatever in the Brewfile is missing; --no-upgrade = upgrades stay manual
brew bundle --no-upgrade --file="$(dirname "$0")/../Brewfile"

#!/bin/sh
set -eu

# regenerates Brewfile from what's actually installed
[ "$(uname -s)" = "Darwin" ] || exit 0
command -v brew >/dev/null 2>&1 || exit 0

BREWFILE="$(cd "$(dirname "$0")/.." && pwd)/Brewfile"

# skip the ~3s dump unless something was (un)installed since the last dump
# (Cellar/Caskroom mtimes change on any install/uninstall)
BREW_PREFIX="$(brew --prefix)"
if [ -f "$BREWFILE" ] \
  && [ ! "$BREW_PREFIX/Cellar" -nt "$BREWFILE" ] \
  && [ ! "$BREW_PREFIX/Caskroom" -nt "$BREWFILE" ]; then
  exit 0
fi

brew bundle dump --force --no-vscode --no-npm --no-describe --file="$BREWFILE"

#!/bin/sh
set -eu

# regenerates Brewfile from what's actually installed
[ "$(uname -s)" = "Darwin" ] || exit 0
command -v brew >/dev/null 2>&1 || exit 0

BREWFILE="$(cd "$(dirname "$0")/.." && pwd)/Brewfile"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

brew bundle dump --force --no-vscode --no-npm --no-describe --file="$TMP"

# only rewrite when the contents changed, so git and mtimes stay quiet
if [ -f "$BREWFILE" ] && cmp -s "$TMP" "$BREWFILE"; then
  echo "Brewfile already up to date"
else
  cp "$TMP" "$BREWFILE"
  echo "Brewfile updated"
fi

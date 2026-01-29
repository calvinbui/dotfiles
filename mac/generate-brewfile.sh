#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd
rm Brewfile
brew bundle dump \
  --no-vscode \
  --no-go \
  --no-cargo \
  --no-flatpak

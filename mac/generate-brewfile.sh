#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd
rm Brewfile
brew bundle \
  --no-cargo \
  --no-flatpak \
  --no-go \
  --no-krew \
  --no-npm \
  --no-vscode \
  dump

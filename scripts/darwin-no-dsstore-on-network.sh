#!/bin/sh
set -eu

# no .DS_Store litter on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

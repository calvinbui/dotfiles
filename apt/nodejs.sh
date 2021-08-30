#!/usr/bin/env bash
#
# https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions
set -e

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

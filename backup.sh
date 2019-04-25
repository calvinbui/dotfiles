#!/usr/bin/env bash

mac/mackup-backup.sh --force
mac/generate-brewfile.sh
pip/backup.sh
npm/backup.sh
vim/convert-plugins-to-submodules.sh
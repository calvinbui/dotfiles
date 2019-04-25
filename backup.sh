#!/usr/bin/env bash

atom/generate-package-list.sh
mac/mackup-backup.sh --force
mac/generate-brewfile.sh
pip/backup.sh
npm/backup.sh
vim/convert-plugins-to-submodules.sh
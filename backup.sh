#!/usr/bin/env bash
set -e

atom/generate-package-list.sh
mac/mackup-backup.sh --force
mac/generate-brewfile.sh
mac/defaults-backup.sh
pip/backup.sh
npm/backup.sh
# vim/convert-plugins-to-submodules.sh
#!/usr/bin/env bash
set -e

mac/generate-brewfile.sh
python/backup.sh
npm/backup.sh
# vim/convert-plugins-to-submodules.sh

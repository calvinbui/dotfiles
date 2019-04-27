#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export MACPREFS_BACKUP_DIR="${DIR}/macprefs"
macprefs restore
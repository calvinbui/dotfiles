#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR" || exit
./defaultbrowser "$1"
osascript ./confirm-system-dialog.app


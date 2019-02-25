#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
npm list -g --depth 0 | awk '{ print $2 }' | sed '/^$/d' >  $DIR/packages.txt
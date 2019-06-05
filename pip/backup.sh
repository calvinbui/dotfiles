#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pip2 freeze > $DIR/pip2-requirements.txt
pip3 freeze > $DIR/pip3-requirements.txt
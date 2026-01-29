#!/usr/bin/env bash

cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd

code --list-extensions > extensions.txt

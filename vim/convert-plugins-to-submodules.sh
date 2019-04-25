#!/usr/bin/env bash

for plugin in $(find ~/.vim/bundle/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
do
    pushd "$plugin"
    export url=$(git config --get remote.origin.url)
    popd
    git submodule add "$url" vim/bundle/$plugin
done

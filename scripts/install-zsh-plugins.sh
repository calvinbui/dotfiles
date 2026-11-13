#!/bin/sh
set -eu

# clones (or updates) the oh-my-zsh theme + plugins; run after install-oh-my-zsh.sh
CUSTOM="$HOME/.oh-my-zsh/custom"

clone() {
  if [ -d "$2/.git" ]; then
    git -C "$2" pull --ff-only
  else
    git clone --depth=1 "$1" "$2"
  fi
}

clone https://github.com/romkatv/powerlevel10k.git "$CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions.git "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$CUSTOM/plugins/fast-syntax-highlighting"
clone https://github.com/zdharma-continuum/history-search-multi-word.git "$CUSTOM/plugins/history-search-multi-word"

#!/bin/sh
set -eu

# oh-my-zsh manages its own updates; this only installs it on fresh machines.
# run before stowing the zsh package, or the installer aborts on ~/.oh-my-zsh existing.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

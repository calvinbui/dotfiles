#!/usr/bin/env zsh

typeset -U path PATH fpath FPATH
path=("$HOME/.local/bin" "$HOME/.opencode/bin" $path)

# Chosen by the Stow profile; sets zimfw_script. Must not print on startup.
[[ ! -r ~/.config/dotfiles/platform.zsh ]] || source ~/.config/dotfiles/platform.zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.zsh_history

# Rebuild init.zsh, installing missing modules, whenever ~/.zimrc changes.
ZIM_HOME=~/.zim
[[ "$ZIM_HOME/init.zsh" -nt ~/.zimrc ]] || source "$zimfw_script" init
source "$ZIM_HOME/init.zsh"
unset zimfw_script

for config in ~/.config/zsh/*.zsh(N); do source "$config"; done
unset config

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Machine-only overrides, deliberately not managed by Stow.
[[ ! -r ~/.zshrc.local ]] || source ~/.zshrc.local

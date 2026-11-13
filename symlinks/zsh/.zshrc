#!/usr/bin/env zsh

# Keep user-installed tools available on every machine, without duplicate paths.
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.opencode/bin" "${path[@]}")
export PATH

# Selected by the machine's Stow profile. These hooks must not print on startup.
[[ ! -r "$HOME/.config/dotfiles/platform.zsh" ]] ||
  source "$HOME/.config/dotfiles/platform.zsh"

# Add Homebrew completions before Oh My Zsh initializes completion.
if (( $+commands[brew] )); then
  fpath=("$(brew --prefix)/share/zsh/site-functions" "${fpath[@]}")
fi

# instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=~/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  fast-syntax-highlighting
  git
  gitfast
  history-search-multi-word
  zsh-autosuggestions
)

zstyle :plugin:history-search-multi-word reset-prompt-protect 1
if [[ "$OSTYPE" == darwin* ]]; then
  plugins+=(iterm2)
  zstyle :omz:plugins:iterm2 shell-integration yes
fi

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 "Oh My Zsh is not installed; run scripts/install-oh-my-zsh.sh from the dotfiles repo."
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Machine-only overrides, deliberately not managed by Stow.
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"

# Smarter cd: `z foo` jumps to the best match, `zi foo` picks with fzf.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

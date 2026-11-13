# Shared user-level tools. Platform-specific paths live in the platform package.
for bin_dir in "$HOME/go/bin" "$HOME/.krew/bin"; do
  [[ ! -d "$bin_dir" ]] || path=("$bin_dir" "${path[@]}")
done
unset bin_dir

# Set a usable default; ~/.zshrc.local can choose a different editor.
if (( $+commands[code] )); then
  export EDITOR="code -w"
elif (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vi
fi
export K9S_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"

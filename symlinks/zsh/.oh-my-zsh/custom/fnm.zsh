# The standalone installer uses this directory on Linux and macOS.
FNM_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"
[[ ! -d "$FNM_PATH" ]] || path=("$FNM_PATH" "${path[@]}")

if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

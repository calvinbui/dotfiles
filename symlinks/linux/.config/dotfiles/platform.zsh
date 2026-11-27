# Linux-only paths. WSL uses these too; Windows-specific additions can be separate.
for bin_dir in /usr/local/go/bin "$HOME/.tfenv/bin"; do
  [[ ! -d "$bin_dir" ]] || path=("$bin_dir" "${path[@]}")
done
unset bin_dir

# gpg's terminal pinentry asks for the passphrase (e.g. when signing commits).
export GPG_TTY=$TTY

# Downloaded by hand (see the README); `zimfw upgrade` updates it.
zimfw_script=~/.zim/zimfw.zsh

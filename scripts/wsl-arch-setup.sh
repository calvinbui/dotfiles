#!/bin/sh
# First-run setup for the Arch Linux WSL image. Run as root:
#   sh scripts/wsl-arch-setup.sh NAME
# Creates NAME with passwordless sudo, makes it WSL's default user, installs
# the prerequisites for the dotfiles, and points Git at Windows' Credential
# Manager. Safe to rerun.
set -eu

[ "$#" -eq 1 ] || { echo "Usage: $0 <user>" >&2; exit 1; }
user=$1
case "$user" in
  ''|-*|*[!a-z0-9_-]*) echo "Invalid user name: $user" >&2; exit 1 ;;
esac
[ "$(id -u)" -eq 0 ] || { echo "Run as root." >&2; exit 1; }
[ -f /etc/arch-release ] || { echo "This script is for Arch Linux." >&2; exit 1; }
grep -qi microsoft /proc/sys/kernel/osrelease || {
  echo "This script is for WSL." >&2
  exit 1
}

pacman -Syu --needed --noconfirm sudo stow zsh git curl openssh python less \
  zoxide fzf neovim gnupg python-pip

if ! id "$user" >/dev/null 2>&1; then
  useradd -m -G wheel "$user"
  echo "Set a password for $user:"
  passwd "$user"
fi

sudoers=/etc/sudoers.d/wheel
sudo_rule='%wheel ALL=(ALL:ALL) NOPASSWD: ALL'
if [ "$(cat "$sudoers" 2>/dev/null)" != "$sudo_rule" ]; then
  echo "$sudo_rule" > "$sudoers.tmp"
  chmod 440 "$sudoers.tmp"
  visudo -cf "$sudoers.tmp"
  mv "$sudoers.tmp" "$sudoers"
fi

if ! grep -q '^\[user\]' /etc/wsl.conf 2>/dev/null; then
  printf '\n[user]\ndefault=%s\n' "$user" >> /etc/wsl.conf
elif ! grep -qx "default=$user" /etc/wsl.conf; then
  echo "/etc/wsl.conf already has a [user] section; set default=$user there." >&2
fi

# The prompt's glyphs need a UTF-8 locale.
if ! grep -qi '^LANG=.*utf-\?8' /etc/locale.conf 2>/dev/null; then
  locale=${LOCALE:-en_US.UTF-8}
  sed -i "s/^#\\($locale UTF-8\\)/\\1/" /etc/locale.gen
  locale-gen
  echo "LANG=$locale" > /etc/locale.conf
fi

zimfw="/home/$user/.zim/zimfw.zsh"
if [ ! -f "$zimfw" ]; then
  runuser -u "$user" -- curl -fsSL --create-dirs -o "$zimfw" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Use Git for Windows' Credential Manager (browser sign-in, shared with
# Windows) instead of the shared config's plaintext store. Machine-only, so it
# goes in ~/.gitlocal.
gcm=
for path in "/mnt/c/Program Files/Git/ucrt64/bin" "/mnt/c/Program Files/Git/mingw64/bin"; do
  if [ -x "$path/git-credential-manager.exe" ]; then
    gcm="$path/git-credential-manager.exe"
    break
  fi
done
gitlocal="/home/$user/.gitlocal"
if [ -z "$gcm" ]; then
  echo "Git Credential Manager not found in Git for Windows; skipping." >&2
elif [ -L "$gitlocal" ]; then
  echo "$gitlocal is a link; set credential.helper there yourself." >&2
else
  helpers=$(runuser -u "$user" -- git config --file "$gitlocal" \
    --get-all credential.helper 2>/dev/null || true)
  if [ -z "$helpers" ]; then
    # An empty helper first resets the shared config's `store`.
    runuser -u "$user" -- git config --file "$gitlocal" credential.helper ''
    runuser -u "$user" -- git config --file "$gitlocal" --add credential.helper \
      "$(printf '%s' "$gcm" | sed 's/ /\\ /g')"
    chmod 600 "$gitlocal"
  elif ! printf '%s\n' "$helpers" | grep -qF git-credential-manager.exe; then
    echo "$gitlocal already sets credential.helper; leaving it alone." >&2
  fi
fi

# OpenCode's browse MCP server runs ~/.local/bin/browse. On WSL, link it to
# the Windows install (via interop) so it drives the Windows browser.
winhome=$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r' || true)
browse_exe=
[ -n "$winhome" ] && browse_exe="$(wslpath -u "$winhome")/.local/bin/browse.exe"
browse_link="/home/$user/.local/bin/browse"
if [ -z "$browse_exe" ] || [ ! -f "$browse_exe" ]; then
  echo "browse.exe not found in Windows' ~/.local/bin; skipping." >&2
elif [ -e "$browse_link" ] && [ ! -L "$browse_link" ]; then
  echo "$browse_link already exists; leaving it alone." >&2
else
  runuser -u "$user" -- mkdir -p "/home/$user/.local/bin"
  runuser -u "$user" -- ln -sfn "$browse_exe" "$browse_link"
fi


echo "Done. From PowerShell: wsl --terminate archlinux, then reopen it as $user."

# Homebrew on Apple Silicon or Intel Macs. Loaded before zimfw.
if (( $+commands[brew] )); then
  eval "$(brew shellenv zsh)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi

# zimfw comes from Homebrew, which also upgrades it.
zimfw_script="$HOMEBREW_PREFIX/opt/zimfw/share/zimfw.zsh"
zstyle ':zim' disable-version-check yes

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--no-quarantine"
export HOMEBREW_NO_ENV_HINTS="true"

if (( $+commands[brew] )); then
  brew_prefix=$(brew --prefix)
  for bin_dir in \
    opt/curl/bin opt/gnu-tar/libexec/gnubin opt/gnu-sed/libexec/gnubin \
    opt/mysql-client/bin opt/coreutils/libexec/gnubin opt/findutils/libexec/gnubin \
    opt/openssl@1.1/bin; do
    [[ ! -d "$brew_prefix/$bin_dir" ]] || path=("$brew_prefix/$bin_dir" "${path[@]}")
  done
  [[ ! -x "$brew_prefix/opt/grep/libexec/gnubin/grep" ]] ||
    alias grep="$brew_prefix/opt/grep/libexec/gnubin/grep"
  unset brew_prefix bin_dir
fi

[[ ! -d /Library/Frameworks/Python.framework/Versions/Current/bin ]] ||
  path=(/Library/Frameworks/Python.framework/Versions/Current/bin "${path[@]}")

alias flushdns="sudo killall -HUP mDNSResponder"
alias brew-cu='defaults export com.apple.dock /tmp/dock-layout.plist && brew cu -a && defaults import com.apple.dock /tmp/dock-layout.plist && killall Dock && launchctl stop com.apple.Dock.agent && launchctl start com.apple.Dock.agent'

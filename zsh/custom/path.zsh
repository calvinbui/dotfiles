if [ "$(uname -s)" = "Darwin" ]; then
  # curl
  export PATH="/opt/homebrew/opt/curl/bin:${PATH}"

  # ruby
  export PATH="/opt/homebrew/opt/ruby/bin:${PATH}"

  # gnu-tar
  export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:${PATH}"

  # sed
  export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:${PATH}"

  # mysql
  export PATH="/opt/homebrew/opt/mysql-client/bin:${PATH}"

  # go
  export PATH="${HOME}/go/bin/:${PATH}"

  # coreutils https://www.gnu.org/software/coreutils/
  export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"

  # findutils
  export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:${PATH}"

  # openssl
  export PATH="/opt/homebrew/opt/openssl@1.1/bin:${PATH}"

  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # kubectl krew
  export PATH="${HOME}/.krew/bin:${PATH}"

  # google-cloud-sdk
  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

elif [ "$(uname -s)" = "Linux" ]; then
  # python
  export PATH="${HOME}/.local/bin:${PATH}"

  # go
  export PATH="/usr/local/go/bin:${PATH}"

  # latex
  export PATH="/usr/local/texlive/2023/bin/x86_64-linux:${PATH}"
fi

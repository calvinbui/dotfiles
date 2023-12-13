if [ "$(uname -s)" = "Darwin" ]; then
  # curl
  export PATH="${PATH}:/opt/homebrew/opt/curl/bin"

  # ruby
  export PATH="${PATH}:/opt/homebrew/opt/ruby/bin"

  # gnu-tar
  export PATH="${PATH}:/opt/homebrew/opt/gnu-tar/libexec/gnubin"

  # sed
  export PATH="${PATH}:/opt/homebrew/opt/gnu-sed/libexec/gnubin"

  # mysql
  export PATH="${PATH}:/opt/homebrew/opt/mysql-client/bin"

  # go
  export PATH="${PATH}:${HOME}/go/bin/"

  # coreutils https://www.gnu.org/software/coreutils/
  export PATH="${PATH}:/opt/homebrew/opt/coreutils/libexec/gnubin"

  # findutils
  export PATH="${PATH}:/opt/homebrew/opt/findutils/libexec/gnubin"

  # openssl
  export PATH="${PATH}:/opt/homebrew/opt/openssl@1.1/bin"

  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # kubectl krew
  export PATH="${PATH}:${HOME}/.krew/bin"

elif [ "$(uname -s)" = "Linux" ]; then
  # python
  export PATH="${PATH}:${HOME}/.local/bin"

  # go
  export PATH="${PATH}:/usr/local/go/bin"

  # latex
  export PATH="${PATH}:/usr/local/texlive/2023/bin/x86_64-linux"
fi

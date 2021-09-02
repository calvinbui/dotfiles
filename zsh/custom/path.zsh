if [ "$(uname -s)" = "Darwin" ]; then
    # grep
    export PATH="/usr/local/opt/grep/libexec/gnubin:${PATH}"

    # curl
    export PATH="/usr/local/opt/curl/bin:${PATH}"

    # ruby
    export PATH="/usr/local/opt/ruby/bin:${PATH}"

    # gnu-tar
    export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:${PATH}"

    # sed
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}"

    # mysql
    export PATH="/usr/local/opt/mysql-client/bin:${PATH}"

    # # go
    # export PATH="${HOME}/go/bin/:${PATH}"

    # coreutils https://www.gnu.org/software/coreutils/
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

    # findutils
    export PATH="/usr/local/opt/findutils/libexec/gnubin:${PATH}"

    # openssl
    export PATH="/usr/local/opt/openssl@1.1/bin:${PATH}"

    # homebrew
    export PATH="/usr/local/sbin:${PATH}"

    # kubectl krew
    export PATH="${HOME}/.krew/bin:${PATH}"
elif [ "$(uname -s)" = "Linux" ]; then
    # python
    export PATH="${HOME}/.local/bin:${PATH}"
fi

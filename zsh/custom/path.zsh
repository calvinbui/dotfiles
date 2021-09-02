if [ "$(uname -s)" = "Darwin" ]; then
    # grep
    export PATH="${PATH}:/usr/local/opt/grep/libexec/gnubin"

    # curl
    export PATH="${PATH}:/usr/local/opt/curl/bin"

    # ruby
    export PATH="${PATH}:/usr/local/opt/ruby/bin"

    # gnu-tar
    export PATH="${PATH}:/usr/local/opt/gnu-tar/libexec/gnubin"

    # sed
    export PATH="${PATH}:/usr/local/opt/gnu-sed/libexec/gnubin"

    # mysql
    export PATH="${PATH}:/usr/local/opt/mysql-client/bin"

    # # go
    # export PATH="${PATH}:${HOME}/go/bin/"

    # coreutils https://www.gnu.org/software/coreutils/
    export PATH="${PATH}:/usr/local/opt/coreutils/libexec/gnubin"

    # findutils
    export PATH="${PATH}:/usr/local/opt/findutils/libexec/gnubin"

    # openssl
    export PATH="${PATH}:/usr/local/opt/openssl@1.1/bin"

    # homebrew
    export PATH="${PATH}:/usr/local/sbin"

    # kubectl krew
    export PATH="${PATH}:${HOME}/.krew/bin"
fi

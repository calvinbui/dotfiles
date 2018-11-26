## source the sb-toolkit
source /Users/calvin/Repos/sb-toolkit/load.sh
## Golang
export PATH="$PATH:/Users/calvin/go/bin"
## Protobuf for mysql-connector install using pip
export MYSQLXPB_PROTOC=/usr/local/opt/protobuf/bin/protoc
export MYSQLXPB_PROTOBUF_INCLUDE_DIR=/usr/local/opt/protobuf/include/
export MYSQLXPB_PROTOBUF_LIB_DIR=/usr/local/opt/protobuf/lib/
## PIP
alias pip=pip2
export PATH="$PATH:/Users/calvin/Library/Python/2.7/bin"
## Homebrew
export PATH="/usr/local/sbin:$PATH"
## aws completions
source /usr/local/bin/aws_zsh_completer.sh
## osx plugin overwrites this
alias spotify=/usr/local/bin/spotify
alias spot=/usr/local/bin/spotify
## shortcuts
alias chx="chmod a+x"

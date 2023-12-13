if [ "$(uname -s)" = "Darwin" ]; then
  # grep
  alias grep="/opt/homebrew/opt/grep/libexec/gnubin/grep"

  alias ops="cd ~/repos/ap3-ops"
  alias api="cd ~/repos/ap3-api"
  alias ui="cd ~/repos/ap3-ui"
  alias flushdns="sudo killall -HUP mDNSResponder"
  alias tflock="terraform providers lock -platform=linux_amd64 -platform=darwin_arm64"
fi

alias cdcustom="cd ~/.oh-my-zsh/custom"
alias cdrepo="cd ~/repos/"
alias tfiu="terraform init --upgrade"
alias htop="sudo htop"
alias vim="nvim"
alias ap="ansible-playbook"
alias aves="ansible-vault encrypt_string"

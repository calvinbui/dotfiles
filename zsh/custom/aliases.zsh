if [ "$(uname -s)" = "Darwin" ]; then
  # grep
  alias grep="/opt/homebrew/opt/grep/libexec/gnubin/grep"

  alias ops="cd ~/repos/ap3-ops"
  alias api="cd ~/repos/ap3-api"
  alias ui="cd ~/repos/ap3-ui"
  alias flushdns="sudo killall -HUP mDNSResponder"
fi

alias cdcustom="cd ~/.oh-my-zsh/custom"
alias cdrepo="cd ~/repos/"
alias htop="sudo htop"
alias vim="nvim"
alias ap="ansible-playbook"
alias aves="ansible-vault encrypt_string"
alias avesp="tr -dc 'A-Za-z0-9' < /dev/urandom | head -c32 | ansible-vault encrypt_string"

alias tf="tofu"
alias tfi="tofu init"
alias tfa="tofu apply"
alias tfp="tofu plan"

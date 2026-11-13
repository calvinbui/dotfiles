if [ "$(uname -s)" = "Darwin" ]; then
  # grep
  alias grep="/opt/homebrew/opt/grep/libexec/gnubin/grep"
  alias flushdns="sudo killall -HUP mDNSResponder"
fi

alias cdcustom="cd ~/.oh-my-zsh/custom"
alias cdrepo="cd ~/repos/"
alias htop="sudo htop"
alias vim="nvim"
alias ap="ansible-playbook"
alias aves="ansible-vault encrypt_string"
avesp() {
  LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom |
    head -c 32 |
    ansible-vault encrypt_string
}
alias lg="lazygit"

alias tf="tofu"
alias tfi="tofu init"
alias tfa="tofu apply"
alias tfp="tofu plan"

alias cdcustom="cd ~/.config/zsh"
alias cdrepo="cd ~/repos/"
alias htop="sudo htop"
if (( $+commands[nvim] )); then
  alias vim="nvim"
fi
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

alias k=kubectl

alias kgp="kubectl get pods"
alias kgcj="kubectl get cronjobs"
alias kgs="kubectl get service"

alias kg="kubectl get"
alias kd="kubectl describe"
alias kl="kubectl logs"

function _kube_completions() {
  COMPLETION_FILE=${ZSH_CACHE_DIR}/$1_completion
  [[ ! -f $COMPLETION_FILE ]] && $1 completion zsh >! $COMPLETION_FILE
  source $COMPLETION_FILE
}

# remove comment to enable, slow but
_kube_completions "kubectl"
_kube_completions "helm"
# _kube_completions "minikube"

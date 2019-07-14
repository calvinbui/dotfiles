function _kube_completions() {
  COMPLETION_FILE=${ZSH_CACHE_DIR}/$1_completion
  [[ ! -f $COMPLETION_FILE ]] && $1 completion zsh >! $COMPLETION_FILE
  source $COMPLETION_FILE
}

# remove comment to enable
# _kube_completions "kubectl"
# _kube_completions "minikube"
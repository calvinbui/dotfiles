alias k=kubectl

function kustomize() {
  local build_commands=("build")
  local cmd="$1"

  if [[ " ${build_commands[@]} " =~ " ${cmd} " ]]; then
    command kustomize "$cmd" --enable-alpha-plugins --enable-exec "${@:2}"
  else
    command kustomize "$@"
  fi
}

function _kube_completions() {
  COMPLETION_FILE=${ZSH_CACHE_DIR}/$1_completion
  [[ ! -f $COMPLETION_FILE ]] && $1 completion zsh >! $COMPLETION_FILE
  source $COMPLETION_FILE
}

# remove comment to enable, slow but
_kube_completions "kubectl"
_kube_completions "helm"
# _kube_completions "minikube"

export EDITOR="code -w"
export K9S_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"

alias kprod="k9s --context ap3-prod-eks"
alias kstg="k9s --context ap3-stg-eks"
alias kauprod="k9s --context ap3-auprod-eks"
alias keuprod="k9s --context ap3-euprod-eks"
alias kshared="k9s --context ops-shared-eks"
alias kap2stg="k9s --context ap2-stg-eks"
alias kap2prod="k9s --context ap2-prod-eks"

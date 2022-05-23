alias k=kubectl

function _kube_completions() {
  COMPLETION_FILE=${ZSH_CACHE_DIR}/$1_completion
  [[ ! -f $COMPLETION_FILE ]] && $1 completion zsh >! $COMPLETION_FILE
  source $COMPLETION_FILE
}

# remove comment to enable, slow but
_kube_completions "kubectl"
_kube_completions "helm"
# _kube_completions "minikube"

export EDITOR="atom -w"
export K9S_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"

alias kprod="k9s --context ap3-prod-eks"
alias kstg="k9s --context ap3-stg-eks"
alias kauprod="k9s --context ap3-auprod-eks"
alias kshared="k9s --context ops-shared-eks"
alias kcommon="k9s --context ap3-common-eks"

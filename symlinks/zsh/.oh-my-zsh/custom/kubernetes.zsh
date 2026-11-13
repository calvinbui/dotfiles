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
  (( $+commands[$1] )) || return 0
  local completion_file="${ZSH_CACHE_DIR}/$1_completion"
  if [[ ! -s "$completion_file" ]]; then
    mkdir -p "$ZSH_CACHE_DIR" || return
    local generated
    generated=$("$1" completion zsh) || return
    print -r -- "$generated" >| "$completion_file"
  fi
  source "$completion_file"
}

# remove comment to enable, slow but
_kube_completions "kubectl"
_kube_completions "helm"
# _kube_completions "minikube"

alias kprod="k9s --context ap3-prod-eks"
alias kstg="k9s --context ap3-stg-eks"
alias kauprod="k9s --context ap3-auprod-eks"
alias keuprod="k9s --context ap3-euprod-eks"
alias kshared="k9s --context ops-shared-eks"
alias kap2stg="k9s --context ap2-stg-eks"
alias kap2prod="k9s --context ap2-prod-eks"

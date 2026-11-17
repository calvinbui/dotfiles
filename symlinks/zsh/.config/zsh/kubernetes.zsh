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
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local completion_file="$cache_dir/$1_completion"
  if [[ ! -s "$completion_file" ]]; then
    mkdir -p "$cache_dir" || return
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

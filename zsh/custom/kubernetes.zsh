alias k=kubectl

alias kprod="kubectl config use-context gke_ap3-prod_us-central1_ap3-cluster-prod"
alias kstg="kubectl config use-context gke_ap3-stg_australia-southeast1-b_ap3-cluster-stg"
alias kops="kubectl config use-context gke_ap-ops_australia-southeast1-c_ops-cluster"

alias kp="kubectl get pods"
alias kcj="kubectl get cronjobs"
alias ks="kubectl get service"

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

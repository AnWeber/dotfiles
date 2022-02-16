
if  (($asdfPlugins[(Ie)kubectl])); then
  plugins+=('helm')
  plugins+=('kubectl')
  if type "kubectl" > /dev/null; then
    source <(kubectl completion zsh)
    if type "complete" > /dev/null; then
      complete -o default -F __start_kubectl k
    fi
  fi
fi


alias helm_prune='helm ls --all --short | xargs -L1 helm delete'
alias kube_prune='kubectl delete replicasets,services,deployments,jobs,pods --all'

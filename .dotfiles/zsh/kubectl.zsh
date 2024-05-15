
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


alias k="kubectl"

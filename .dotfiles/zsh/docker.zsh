fix_wsl2() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

if type "docker" > /dev/null; then
  plugins+=('docker')
  if ! docker info > /dev/null 2>&1; then
      sudo dockerd > /dev/null 2>&1 &
      disown
  fi
fi

alias docker-prune=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
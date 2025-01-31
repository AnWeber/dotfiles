if [[ -d ~/.asdf ]] then
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
  asdfPlugins=$(asdf plugin list)
fi
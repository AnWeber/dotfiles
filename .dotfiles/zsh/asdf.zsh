if [[ -d ~/.asdf ]] then
  . ~/.asdf/asdf.sh
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
  asdfPlugins=$(asdf plugin list)
fi
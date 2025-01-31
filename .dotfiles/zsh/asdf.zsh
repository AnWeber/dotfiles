if [[ -d ~/.asdf ]] then
  export PATH="$ASDF_DATA_DIR/shims:$PATH"
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
  asdfPlugins=$(asdf plugin list)
fi
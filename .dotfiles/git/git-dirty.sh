if [[ $(git diff --stat) != '' ]]; then
  echo '✘'
fi
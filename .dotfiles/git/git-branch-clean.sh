
while [[ "$#" -gt 0 ]]; do
  case $1 in
      --force) force=1 ;;
  esac
  shift
done
git fetch -p


if ! [ -z "$force" ]; then
  git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
else
  git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d
fi
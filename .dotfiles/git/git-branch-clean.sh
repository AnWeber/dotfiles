
while [[ "$#" -gt 0 ]]; do
  case $1 in
      --force) force=1 ;;
  esac
  shift
done
git fetch -p

git branch --merged | grep -i -v -E "master|main|dev|develop|development|head|HEAD"| xargs -n 1 -r git branch -d
if ! [ -z "$force" ]; then
  git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
else
  git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d
fi
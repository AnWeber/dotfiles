

while [[ "$#" -gt 0 ]]; do
  case $1 in
      --no-switch) noSwitch=1 ;;
  esac
  shift
done

git fetch --prune
if [ -z "$noSwitch" ]; then
  git dev
fi
git pull
git branch-clean "$@"

while [[ "$#" -gt 0 ]]; do
  case $1 in
      --force) force=1 ;;
  esac
  shift
done

defaultbranch=$(git branch-default)

# keep default branch, release branches, and common root branches
keep_branches () {
  awk -v b="$defaultbranch" '$0 != b && $0 !~ /^releases\//' \
    | grep -i -v -E "master|main|dev|develop|development|head|origin|HEAD"
}

git fetch -p

git branch --format='%(refname:short)' --merged | keep_branches | xargs -n 1 -r git branch -d
if ! [ -z "$force" ]; then
  git branch --format='%(refname:short)' -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | keep_branches | xargs -r git branch -D
else
  git branch --format='%(refname:short)' -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | keep_branches | xargs -r git branch -d
fi
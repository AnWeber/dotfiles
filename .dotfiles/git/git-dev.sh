

defaultbranch=$(git branch-default)
branch=$(git rev-parse --quiet --abbrev-ref HEAD)
if [[ ! "$defaultbranch" =~ "$branch" ]]; then
  git switch $defaultbranch
fi
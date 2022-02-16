
defaultbranch=$(git branch-default)
merged=$(git branch --merged $defaultbranch | egrep -v "(^\*|master|main|dev|development)$")

for branch in ${merged[@]}; do
  git branch -d ${branch}
done
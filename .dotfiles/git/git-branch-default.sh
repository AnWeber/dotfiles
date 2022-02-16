
allBranches=(main development master)

for branch in ${allBranches[@]}; do
  if git rev-parse --quiet --verify $branch &> /dev/null; then
    echo $branch
    break
  fi
done
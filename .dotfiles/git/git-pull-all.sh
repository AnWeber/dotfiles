#!/usr/bin/env bash

git fetch --quiet --prune


allBranches=$(git branch --format='%(refname:short)' -r | egrep -v "(^\*|master|main|dev|development|HEAD)$")
for branch in ${allBranches[@]}; do
  noOriginBranch=$(echo $branch | sed 's;origin/;;g')
  echo "Branch $noOriginBranch"
  git switch "$noOriginBranch"
done
git dev




#!/usr/bin/env bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -l|--local) remoteBranch=-1;;
        -r|--remote) localBranch=-1;;
        *) branch=$1;;
    esac
    shift
done
defaultbranch=$(git branch-default)
if [ -z "$branch" ]; then
  branch=$(git rev-parse --quiet --abbrev-ref HEAD)
fi
PROTECTED_BRANCHES=('main')
if [[ ! "${PROTECTED_BRANCHES[*]}" =~ "$branch" ]]; then
  git fetch --prune
  if git show-ref --quiet $branch; then
    if git branch --quiet --show-current | grep $branch; then
      git switch --quiet $defaultbranch
    fi
    if [ -z $localBranch ]; then
      if git rev-parse --quiet --verify $branch &> /dev/null   ; then
        echo "git erase local $branch"
        git branch -D --quiet $branch &>/dev/null || true
      fi
    fi
    if [ -z $remoteBranch ]; then
      if git branch -r --quiet | grep $branch; then
        echo "git erase remote $branch"
        git push origin --quiet -d $branch || true
      fi
    fi
  fi
else
  echo "git erase protected branch not supported"
fi


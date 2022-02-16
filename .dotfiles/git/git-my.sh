#!/usr/bin/env bash

weeks=4
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -e|--erase) erase=1; shift ;;
        -n|--now) now=1; shift ;;
        --weeks) weeks="$2" ;;
        *) user=$1 ;;
    esac
    shift
done
if [ -z "$user" ]; then
  user="Andreas Weber"
fi

allBranches=$(git branch -r --quiet | egrep -v "(^\*|master|main|dev|development)$")
for branch in ${allBranches[@]}; do
  if ! [ -z "$now" ] || [ -z "$(git log -1 --since='$weeks week ago' -s $branch)" ]; then
    author=$(git log --color --format="%an" $branch | head -n 1)
    if [ "$author" == "$user" ]; then
      git log --color --format="%ci _%C(magenta)%cr %C(bold cyan)$branch%Creset %s %C(bold blue)<%an>%Creset" $branch | head -n 1 | sort -r | cut -d_ -f2- | sed 's;origin/;;g' | head -10
      if ! [ -z "$erase" ]; then
        git erase $branch
      fi
    fi
  fi
done

#!/usr/bin/env bash

weeks=8
while [[ "$#" -gt 0 ]]; do
  case $1 in
      --erase) erase=1 ;;
      --merged) onlymerged=1 ;;
      --fetch) fetch=1 ;;
      --count) onlycount=1 ;;
      --no-color) nocolor=1 ;;
      --user) user="$2" ;;
      --weeks) weeks="$2" ;;
      --me) user="Weber[[:space:]]Andreas|Andreas[[:space:]]Weber";;
  esac
  shift
done

if ! [ -z "$fetch" ]; then
  git fetch --quiet --prune
fi

count=0
countMerged=0
countStale=0

mergeRequests=[]
if type "glab" &> /dev/null; then
  mergeRequests=$(glab mr list | cat)
fi
allBranches=$(git branch --format='%(refname:short)' -r | egrep -v "(^\*|master|main|dev|develop|development|head|HEAD|origin)$")
defaultbranch=$(git branch-default)
merged=$(git branch --format='%(refname:short)' -r --merged $defaultbranch | egrep -v "(^\*|master|main|dev|develop|development|head|HEAD|origin)$")

for branch in ${allBranches[@]}; do
  noOriginBranch=$(echo $branch | sed 's;origin/;;g')
  ((count=count+1))
  if [[ " ${merged[*]} " =~ "$branch" ]]; then
    ((countMerged=countMerged+1))
    if ! [ -z "$onlycount" ]; then
      continue
    fi
    if [ -z "$nocolor" ]; then
      git log --color --format="%ci _%C(magenta)merged %cr %C(bold cyan)$branch%Creset %s %C(bold blue)<%an>%Creset" $branch | head -n 1 | sort -r | cut -d_ -f2- | sed 's;origin/;;g' | head -10
    else
      git log --format="$branch (merged) | %cr | %s | %an" $branch | head -n 1 | sort -r | sed 's;origin/;;g' | head -10
    fi
    if ! [ -z "$erase" ]; then
      git push origin -d $noOriginBranch || true
    fi
  else
    if ! [ -z "$onlymerged" ]; then
      continue
    fi
    if [ -z "$(git log -1 --since="$weeks weeks ago" -s $branch)" ]; then


      if [[ "$mergeRequests" == *"$noOriginBranch"* ]]; then
        continue
      fi

      if ! [ -z "$user" ]; then
        if [ -z "$(git log --format="$branch | %cr | %s | %an" $branch | head -n 1 | sort -r | sed 's;origin/;;g' | head -10 | grep -E $user)" ]; then
            continue
        fi
      fi
      ((countStale=countStale+1))
      if ! [ -z "$onlycount" ]; then
        continue
      fi
      if [ -z "$nocolor" ]; then
        git log --color --format="%ci _%C(magenta)%cr %C(bold cyan)$branch%Creset %s %C(bold blue)<%an>%Creset" $branch | head -n 1 | sort -r | cut -d_ -f2- | sed 's;origin/;;g' | head -10
      else
        git log --format="$branch | %cr | %s | %an" $branch | head -n 1 | sort -r | sed 's;origin/;;g' | head -10
      fi
      if ! [ -z "$erase" ]; then
        git push origin -d $noOriginBranch || true
      fi
    fi
  fi
done
if ! [ -z "$onlycount" ]; then
  echo "$countMerged merged branches, $countStale stalled branches, $count branches"
fi

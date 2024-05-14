#!/usr/bin/env bash

branch="main"

while [ : ]; do
  case "$1" in
    --on)
        branch=$2
        shift
        shift
        ;;
    --) shift;
        break
        ;;
    *) break;;
  esac
done

for arg in "$@"
do
  if [[ -z $args ]]; then
    args=$arg
    continue
  fi
  if [[ $arg == -* ]] || ! [[ "$arg" =~ ( |\') ]] || [ $arg == $1 ]; then
    args+=" $arg"
  else
    args+=" \"$arg\""
  fi
done


if [[ $branch == "$(git current)" ]]; then
  eval "$args"
fi


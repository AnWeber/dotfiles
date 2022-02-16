#!/usr/bin/env bash

while [[ "$#" -gt 0 ]]; do
  case $1 in
      pipe|ci) ci=1 ;;
      pr|mr) merge=1 ;;
      issue) merge=1 ;;
  esac
  shift
done

open(){
  case $( uname -s ) in
    Darwin)   open='open';;
    MINGW*)   open='start';;
    MSYS*)    open='start';;
    CYGWIN*)  open='cygstart';;
    *)        # Try to detect WSL (Windows Subsystem for Linux)
              if uname -r | grep -q -i Microsoft; then
                open='powershell.exe -NoProfile start'
              else
                open='xdg-open'
              fi;;
  esac

  if (( print_only )); then
    BROWSER="echo"
  fi

  $open $1
}



openGit(){
  local url=$1
  if type "glab" &> /dev/null; then
    if ! [[ -z $ci ]]; then
      open ${url/\.git/"/-/pipelines"}
      return
    fi
    branch=$(git rev-parse --quiet --abbrev-ref HEAD)
    PROTECTED_BRANCHES=('master' 'main' 'development')
    if [[ ! "${PROTECTED_BRANCHES[*]}" =~ "$branch" ]]; then
      mr=$(glab mr list --source-branch=$branch | grep $branch | cut -f 1 -s | sed 's;!;;g')
    fi
    if ! [[ -z $merge ]] || ! [[ -z $mr ]]; then
      open ${url/\.git/"/merge_requests/$mr"}
      return
    fi
  fi
  if [[ "$url" == *"github"* ]]; then
    if ! [[ -z $ci ]]; then
      open ${url/\.git/"/actions"}
      return
    fi
    if ! [[ -z $merge ]]; then
      open ${url/\.git/"/pulls"}
      return
    fi
    if ! [[ -z $issue ]]; then
      open ${url/\.git/"/issues"}
      return
    fi
  fi
  open $url;
}

openGit $(git config --get remote.origin.url)
#!/usr/bin/env bash
# generate man page with: txt2man.sh -t git-fresh <(./git-fresh -?) > git-fresh.1

# git-fresh
# https://github.com/imsky/git-fresh
# By Ivan Malopinsky - http://imsky.co
# MIT License

usage () {
cat << EOT
NAME
  git-fresh

SYNOPSIS
  git-fresh [-fmrtRWS] [-sl] [remote] [root]

DESCRIPTION
  git-fresh helps keep your Git repo fresh.

  By default, git-fresh will:
  - update local root (master) to match remote root
  - stash changes
  - prune remote branches

  git-fresh will ignore any branches listed in a .freshignore file.
  freshignore should contain branch names you would like to ignore
  on separate lines. The file can exist in the current Git repo
  or in the home directory, i.e. ~/.freshignore.

  remote is origin by default. root is master by default.

OPTIONS
  -f  Delete stale local and remote branches
  -m  Merge remote root into current branch
  -r  Rebase current branch against remote root
  -t  Remove local tags that do not exist on remote
  -R  Reset local root to remote root
  -W  Wipe workspace clean
  -S  Clear all stash entries

  -s  Apply stashed changes after run
  -l  Only delete local stale branches

  -v  Print git-fresh version and exit

BUGS
  Issues are tracked on GitHub: https://github.com/imsky/git-fresh

AUTHOR
  Ivan Malopinsky - http://imsky.co
EOT

exit 0
}

say () {
  echo "[git-fresh] $@" 1>&2
}

die () {
  say $@
  exit 1
}

error () {
  ERR=${ERR:-unknown}
  die "Error on line $1: $ERR"
}

trap 'error $LINENO' ERR

if [[ "$1" = '--help' ]]; then
  usage
fi

while getopts ":fmrtslRWSTv" opt; do
  case $opt in
    f)
      FORCE_DELETE_STALE=true
      ;;
    m)
      MERGE=true
      ;;
    r)
      REBASE=true
      ;;
    t)
      TAGS=true
      ;;
    s)
      APPLY_STASH=true
      ;;
    l)
      DELETE_ONLY_LOCAL=true
      ;;
    R)
      RESET_ROOT=true
      ;;
    W)
      WIPE_WORKSPACE=true
      ;;
    S)
      CLEAR_STASH=true
      ;;
    T)
      TEST=true
      ;;
    v)
      VERSION=1.12.1
      ;;
    *)
      usage
      break
      ;;
  esac
done

shift $((OPTIND-1))

# Are we in version mode?

if [[ ! -z $VERSION ]]; then
  echo git-fresh $VERSION
  exit 0
fi

# Are we in testing mode?

if [[ $TEST = true ]]; then
  PATH=$(pwd):$PATH
  TEST_DIR=/tmp/git-fresh-test
  fail_test () {
    echo 'Tests failed!'
    rm -rf $TEST_DIR
    exit 1
  }

  rm -rf $TEST_DIR; mkdir -p $TEST_DIR; cd $TEST_DIR
  git init; touch test; git add test; git commit -am 'test'
  git checkout -b test; rm test; git commit -am 'delete test'
  git dev; git merge test; git checkout test
  git-fresh -fr; git rev-parse --verify test && fail_test || true
  git checkout -b test; git dev; git-fresh; git checkout -
  git rev-parse --abbrev-ref HEAD | grep -q test || fail_test
  rm -rf $TEST_DIR
  echo 'Tests passed!'
  exit 0
fi

# Are we inside a git repository?

INSIDE_GIT_REPO=$(git rev-parse --is-inside-work-tree 2> /dev/null)

if [[ -z "$INSIDE_GIT_REPO" ]]; then
  die "Not a git repository"
fi

# Are we in a non-empty git repository?
ERR="could not get top-level-directory"
TOP_LEVEL_DIRECTORY=$(git rev-parse --show-toplevel)
REMOTE=${1:-origin}

ROOT=$(git branch-default)

# Recover the root HEAD if it is missing or corrupt (e.g. master head reads "master")
recover_root () {
  ROOT_HEAD_FILE="$TOP_LEVEL_DIRECTORY/.git/refs/heads/$ROOT"

  if [[ -e "$ROOT_HEAD_FILE" ]]; then
    if [[ $(cat "$ROOT_HEAD_FILE") = $(echo $ROOT) ]]; then
      CORRUPT_ROOT_HEAD=true
    fi
  else
    MISSING_ROOT_HEAD=true
  fi

  if [[ "$CORRUPT_ROOT_HEAD" = "true" || "$MISSING_ROOT_HEAD" = "true" ]]; then
    ERR="failed to recover $ROOT HEAD"
    RECOVERED_ROOT_HEAD=$(cat "$TOP_LEVEL_DIRECTORY/.git/logs/refs/heads/$ROOT" | tail -n1 | cut -d' ' -f2)
    echo "$RECOVERED_ROOT_HEAD" > "$ROOT_HEAD_FILE"
    say "Recovered $ROOT HEAD, set to $RECOVERED_ROOT_HEAD"
    CORRUPT_ROOT_HEAD=false
    MISSING_ROOT_HEAD=false
  fi
}

recover_root

LAST_WORKING_DIRECTORY="$(pwd)"
cd "$TOP_LEVEL_DIRECTORY"

ERR="could not get current commit"
CURRENT=$(git rev-parse --abbrev-ref HEAD)
ERR=""

if [[ $(git remote -v | wc -l) -gt "0" ]]; then
  REMOTES=true
fi

# Is this branch in .freshignore?

FRESH_IGNORE="$TOP_LEVEL_DIRECTORY/.freshignore"

if [[ ! -f $FRESH_IGNORE ]]; then
  FRESH_IGNORE="~/.freshignore"
fi

if [[ -f $FRESH_IGNORE ]]; then
    if [[ ! -z $(grep -Fx "$CURRENT" "$FRESH_IGNORE") ]]; then
        die "Branch $CURRENT is ignored"
    fi
fi

STASH_STAMP=git-fresh-$(date +%s)

# Stash changed files

if ! git diff-files --quiet; then
  ERR="could not stash changes"
  git stash save $STASH_STAMP
fi

if [[ $REMOTES = true ]]; then
  # Update remotes and prune stale remotes
  ERR="could not update and prune remotes"
  git remote prune $REMOTE
  git remote update $REMOTE
  git remote prune $REMOTE
fi

# If we are not already on root branch, switch to root branch (master)

if [[ "$ROOT" != "$CURRENT" ]]; then
  ERR="could not check out $ROOT branch"
  git checkout $ROOT > /dev/null 2>&1
fi

# Wipe workspace?

if [[ $WIPE_WORKSPACE = true ]]; then
  ERR="could not wipe workspace"
  git clean -dfx
fi

if [[ $REMOTES = true ]]; then
  # Reset root?

  if [[ $RESET_ROOT = true ]]; then
    ERR="could not reset root"
    git reset --hard $REMOTE/$ROOT
  fi

  ERR="could not perform fast forward merge"
  git pull --quiet --ff-only $REMOTE $ROOT || say "Fast forward merge failed on $ROOT. You can reset local $ROOT by running git fresh -R."
fi

# Compute stale branches

ERR="could not determine stale branches"
SMART_STALE=$(git branch -a --merged | tr -d "\* " | grep -Ev ">|$ROOT" | cat)

LOCAL_STALE=$(grep -Ev "^remotes/" <<< "$SMART_STALE" | cat)
REMOTE_STALE=$(grep -E "^remotes/" <<< "$SMART_STALE" | cat)
#todo: add flag to prune all remote branches
REMOTE_STALE=$(grep "^remotes/$REMOTE" <<< "$REMOTE_STALE" | cat)
REMOTE_STALE=${REMOTE_STALE//remotes\/$REMOTE\/}

if [[ ! -z "${SMART_STALE// }" ]]; then
  if [[ ! -z "${LOCAL_STALE// }" ]]; then
    STALE_BRANCHES=true
    if [[ -f "$FRESH_IGNORE" ]]; then
      LOCAL_STALE=$(echo -n $LOCAL_STALE | tr " " "\n" | grep -Fxvf "$FRESH_IGNORE" | tr "\n" " ")
      if [[ -z $LOCAL_STALE ]]; then
        STALE_BRANCHES=false
      fi
    fi
    if [[ "$FORCE_DELETE_STALE" = true ]]; then
      ERR="could not delete stale local branches: $LOCAL_STALE"
      echo -n $LOCAL_STALE | tr " " "\0" | xargs -0 git branch -d 2> /dev/null
    else
      if [[ $STALE_BRANCHES = true ]]; then
        say "Local stale branches found:" $(echo -n $LOCAL_STALE | tr "\n" " ")
      fi
    fi
  fi

  if [[ ! -z "${REMOTE_STALE// }" ]]; then
    STALE_BRANCHES=true
    if [[ -f "$FRESH_IGNORE" ]]; then
      REMOTE_STALE=$(echo -n $REMOTE_STALE | tr " " "\n" | grep -Fxvf "$FRESH_IGNORE" | tr "\n" " ")
      if [[ -z $REMOTE_STALE ]]; then
        STALE_BRANCHES=false
      fi
    fi
    if [[ "$FORCE_DELETE_STALE" = true ]]; then
      if [[ "$DELETE_ONLY_LOCAL" != true ]]; then
        ERR="could not delete stale remote branches: $REMOTE_STALE"
        echo -n $REMOTE_STALE | tr " " "\0" | xargs -0 git push $REMOTE --delete
      fi
    else
      if [[ $STALE_BRANCHES = true ]]; then
        say "Remote stale branches found:" $(echo -n $REMOTE_STALE | tr "\n" " ")
      fi
    fi
  fi

  if [[ "$FORCE_DELETE_STALE" != true && "$STALE_BRANCHES" = true ]]; then
    say "Delete stale branches with: git fresh -f"
  fi
fi

# Remove tracking information for missing upstreams

if [[ ! -z $(git branch -vv | grep -F "[$REMOTE/$CURRENT: gone]") ]]; then
  git branch --unset-upstream $CURRENT
fi

# Rebase or merge remote root against local branch

if [[ ! -z $(git rev-parse --verify --quiet "$CURRENT") ]]; then
  if [[ "$ROOT" != "$CURRENT" ]]; then
    ERR="could not check out $CURRENT branch"
    git checkout $CURRENT
    recover_root
  fi

  if [ "$REBASE" = true ] && [ "$MERGE" = true ]; then
    say "Rebase and merge enabled, skipping both"
  else
    if [[ "$REMOTES" = true ]]; then
      if [[ "$REBASE" = true ]]; then
        ERR="could not rebase against $ROOT branch"
        git rebase $ROOT
      fi

      if [[ "$MERGE" = true ]]; then
        ERR="could not merge $ROOT branch"
        git merge --no-edit $ROOT
      fi
    fi
  fi
else
  echo "$CURRENT branch was stale, staying on $ROOT"
fi

# Remove local tags that are missing on the remote

if [[ "$TAGS" = true ]]; then
  ERR="could not get remote tags"
  REMOTE_TAGS=$(git ls-remote --tags $REMOTE | cut -f 2)
  LOCAL_TAGS=$(git show-ref --tags | cut -d' ' -f 2)

  for tag in $LOCAL_TAGS; do
    if [[ -z $(grep $tag <<< "$REMOTE_TAGS" | cat) ]]; then
      MISSING_TAG="${tag//refs\/tags\/}"
      git tag -d $MISSING_TAG
    fi
  done
fi

# Restore stashed changes

if [[ ! -z $(git stash list | grep $STASH_STAMP | cat) ]]; then
  if [[ "$APPLY_STASH" = true ]]; then
    ERR="could not apply stashed changes"
    git stash pop
  else
    say "Stashed changes present, apply with: git stash pop"
  fi
fi

# Clear stashed changes

if [[ "$CLEAR_STASH" = true ]]; then
  ERR="could not clear stashed changes"
  git stash clear
fi

if ! git gc --auto --force; then
  ERR="git prune failed"
  git prune
  rm -rf "$TOP_LEVEL_DIRECTORY/.git/gc.log"
fi

if [[ -d "$LAST_WORKING_DIRECTORY" ]]; then
    cd "$LAST_WORKING_DIRECTORY"
else
    say "Previous working directory does not exist on the branch $ROOT"
fi

recover_root

ERR=""
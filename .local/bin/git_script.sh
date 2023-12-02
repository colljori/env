#!/usr/bin/env bash

# this is build thanks to 
# https://stackoverflow.com/questions/36433572/how-does-ancestry-path-work-with-git-log/36437843#36437843

#################################################################################
# VARIABLES
###



#################################################################################
# SCRIPT
###
find_starting_branch()
{
  (
    # get the name of the local repo
    local local_repo=$(basename `git rev-parse --show-toplevel`)
    # find in all branch available for this repo in BASELINE_BRANCHES
    # this var is define in $TOOLS_ROOT/tools/env/baseline_management.sh
    declare -a local_branches=()
    for entry in "${!BASELINE_BRANCHES[@]}"; do
      local tested_repo="${entry#*, }"
      if [[ "$local_repo" == "$tested_repo" ]]; then
        local_branches+=(${BASELINE_BRANCHES[$entry]})
      fi
    done

    # find the sha1 of the last merge starting from HEAD
    # NOTE : for this script to work properly, your local branch shall not
    # have made local merge since the branch creation
    local last_merge=$(git log --merges --pretty=format:"%H" -1)

    # for each possible starting branch, find if the base of the local branch 
    # is a commit of the said starting branch
    for branch in "${local_branches[@]}"; do
      local is_from_branch=$(git log $last_merge..$branch --ancestry-path -1 --pretty=format:"%H")
      [[ ! -z $is_from_branch ]] && echo "local branch started from $branch"
    done
  )
}


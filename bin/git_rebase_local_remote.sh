#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_rebase_pair.sh OUTDATED_DOWNSTREAM_BRANCH [DESIRED_UPSTREAM_BRANCH]
#/ Description: Rebase local and remote OUTDATED_DOWNSTREAM_BRANCHs onto a DESIRED_UPSTREAM_BRANCH
#/    Default DESIRED_UPSTREAM_BRANCH is the currently active branch
#/ Examples: ./git_rebase_pair.sh develop completed-feature
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }


# Util fxns ----
# Identify Current Branch
# copied from ~/.oh_my_zsh/lib/git.zsh
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}


# Parse input ----
if [ $# -eq 0 ];
then
    usage
    exit 66
fi

OUTDATED_DOWNSTREAM_BRANCH=$1

# If no DESIRED_UPSTREAM_BRANCH, default to current branch
# I assume I'll want to rebase onto the branch I'm actively working on
if [ $# -eq 1 ];
then
    DESIRED_UPSTREAM_BRANCH=$(git_current_branch)
else
    DESIRED_UPSTREAM_BRANCH=$2
fi


# MAIN ----
echo "Rebasing local and remote ${OUTDATED_DOWNSTREAM_BRANCH} onto ${DESIRED_UPSTREAM_BRANCH}"

git checkout ${OUTDATED_DOWNSTREAM_BRANCH}
git rebase ${DESIRED_UPSTREAM_BRANCH}

# Ask before rewriting remote history
info "Local ${OUTDATED_DOWNSTREAM_BRANCH} rebased.  Should we also rebase the remote?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) git push --force; break;;
        No ) break;;
    esac
done

git checkout ${DESIRED_UPSTREAM_BRANCH}

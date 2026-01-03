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

# Source shared coloring library
readonly LOG_FILE="/tmp/$(basename "$0").log"
# Get script directory - handle both direct execution and execution via PATH/alias
_script_path="${BASH_SOURCE[0]:-$0}"
if [[ ! "$_script_path" =~ ^/ ]]; then
  if command -v "$_script_path" >/dev/null 2>&1; then
    _script_path="$(command -v "$_script_path")"
  fi
fi
if [[ -L "$_script_path" ]]; then
  _script_path="$(readlink -f "$_script_path" 2>/dev/null || readlink "$_script_path" 2>/dev/null || echo "$_script_path")"
fi
SCRIPT_DIR="$(cd "$(dirname "$_script_path")" && pwd)"
unset _script_path
source "${SCRIPT_DIR}/colors.sh"


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
  echo "${ref#refs/heads/}"
}


# Parse input ----
if [ $# -eq 0 ];
then
    usage
    exit 1
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
info "Rebasing local and remote ${OUTDATED_DOWNSTREAM_BRANCH} onto ${DESIRED_UPSTREAM_BRANCH}"

git checkout "${OUTDATED_DOWNSTREAM_BRANCH}"
git rebase "${DESIRED_UPSTREAM_BRANCH}"

# Force push to remote
info "Local ${OUTDATED_DOWNSTREAM_BRANCH} rebased. Force pushing to remote..."
git push --force

git checkout "${DESIRED_UPSTREAM_BRANCH}"

#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_rm_pair.sh RM_BRANCH
#/ Description: Convenience function to remove a local-remote branch pair
#/ Examples: ./git_rm_pair.sh merged-feature-branch
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


# Parse input
if [ $# -eq 0 ];
then
    usage
    exit 1
fi

RM_BRANCH=$1


# Main
info "Removing local and remote \"${RM_BRANCH}\" branches."

# delete local branch (force delete to avoid sync check)
git branch -D "${RM_BRANCH}"

# delete remote branch
info "Deleting remote branch ${RM_BRANCH}"
git push origin --delete "${RM_BRANCH}"

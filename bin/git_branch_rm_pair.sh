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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

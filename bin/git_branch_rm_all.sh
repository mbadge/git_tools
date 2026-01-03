#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_branch_rm_all.sh RM_BRANCH
#/ Description: Convenience function to remove a local branch and from all remotes
#/ Examples: ./git_branch_rm_all.sh merged-feature-branch
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
info "Removing local and remote \"${RM_BRANCH}\" branches from all remotes."

# delete local branch (force delete to avoid sync check)
git branch -D "${RM_BRANCH}"

# Find all remotes that have this branch
info "Checking all remotes for branch \"${RM_BRANCH}\"..."
remotes_with_branch=()

# Get list of all remotes
all_remotes=$(git remote)

if [ -z "$all_remotes" ]; then
    info "No remotes configured."
    exit 0
fi

# Check each remote for the branch
while IFS= read -r remote; do
    if git ls-remote --heads "$remote" | grep -q "refs/heads/${RM_BRANCH}$"; then
        remotes_with_branch+=("$remote")
        info "Found branch \"${RM_BRANCH}\" on remote: $remote"
    fi
done <<< "$all_remotes"

# If no remotes have the branch, we're done
if [ ${#remotes_with_branch[@]} -eq 0 ]; then
    info "Branch \"${RM_BRANCH}\" not found on any remote."
    exit 0
fi

# Delete from all remotes
info "Deleting branch \"${RM_BRANCH}\" from all remotes: ${remotes_with_branch[*]}"
for remote in "${remotes_with_branch[@]}"; do
    info "Deleting branch \"${RM_BRANCH}\" from remote: $remote"
    if git push "$remote" --delete "${RM_BRANCH}"; then
        info "Successfully deleted from $remote"
    else
        error "Failed to delete from $remote"
    fi
done

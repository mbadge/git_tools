#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_push_set_upstream.sh [--force|--force-with-lease]
#/ Description: designate upstream remote for all remotes {current branch} and push
#/ Options:
#/   --help: Display this help message
#/   --force: Force push to all remotes (dangerous, overwrites remote history)
#/   --force-with-lease: Force push with lease (safer, fails if remote has new commits)
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# Source shared coloring library
readonly LOG_FILE="/tmp/$(basename "$0").log"
# Get script directory - handle both direct execution and execution via PATH/alias
# First source colors.sh to get the helper function, but we need the dir first...
# So we'll do it inline here
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

# Parse force push flags
FORCE_FLAG=""
if [[ "$*" =~ --force-with-lease ]]; then
    FORCE_FLAG="--force-with-lease"
elif [[ "$*" =~ --force ]]; then
    FORCE_FLAG="--force"
    warning "Using --force flag. This will overwrite remote history!"
fi


# Identify Branch
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

current_branch=$(git_current_branch)

# Get all remotes
all_remotes=$(git remote)

if [ -z "$all_remotes" ]; then
    fatal "No remotes configured."
fi

# Convert to array for display
remotes_array=()
while IFS= read -r remote; do
    remotes_array+=("$remote")
done <<< "$all_remotes"

if [ -n "$FORCE_FLAG" ]; then
    info "Force pushing branch \"${current_branch}\" to all remotes: ${remotes_array[*]}"
else
    info "Pushing branch \"${current_branch}\" to all remotes: ${remotes_array[*]}"
fi

for remote in "${remotes_array[@]}"; do
    info "Pushing to remote: $remote"
    if [ -n "$FORCE_FLAG" ]; then
        if git push --set-upstream $FORCE_FLAG "$remote" "$current_branch"; then
            success "Successfully force pushed to $remote"
        else
            error "Failed to force push to $remote"
        fi
    else
        if git push --set-upstream "$remote" "$current_branch"; then
            success "Successfully pushed to $remote"
        else
            error "Failed to push to $remote"
        fi
    fi
done


#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_push_set_upstream.sh
#/ Description: designate upstream remote for all remotes {current branch} and push
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }


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

info "Pushing branch \"${current_branch}\" to all remotes: ${remotes_array[*]}"
for remote in "${remotes_array[@]}"; do
    info "Pushing to remote: $remote"
    if git push --set-upstream "$remote" "$current_branch"; then
        info "Successfully pushed to $remote"
    else
        error "Failed to push to $remote"
    fi
done


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

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }


# Parse input ----
if [ $# -eq 0 ];
then
    usage
    exit 66
fi

RM_BRANCH=$1

info "Removing local and remote \"${RM_BRANCH}\" branches."
git branch -d ${RM_BRANCH}
warning "Local ${RM_BRANCH} deleted. Delete remote also?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) git push origin --delete ${RM_BRANCH}; break;;
        No ) break;;
    esac
done

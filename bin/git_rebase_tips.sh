#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

#/ Usage: ./git_rebase_tips.sh
#/ Description: Rebase all branches matching tip-* onto tip
#/  This relieves the tediousness of keeping many tips on top of tip
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# Source shared coloring library
readonly LOG_FILE="/tmp/$(basename "$0").log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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


################################################################################
####                                 MAIN                                   ####
################################################################################
DESIRED_UPSTREAM=tip

# branches=$( git branch | cut -f2- -d' ' | sed "s/^\\s//" )
branch_tips=$(grep tip- <(git branch | cut -f2- -d' ' | sed "s/^\\s//") )

section "Rebasing tip branches"
info "Branches to rebase: ${branch_tips}"
for i in "${branch_tips[@]}"
do
    info "Rebasing branch: ${i}"
    git checkout "${i}"
    git rebase "${DESIRED_UPSTREAM}"
done

info "Local tips rebased. Force pushing to remotes..."
for i in "${branch_tips[@]}"; do
    git checkout "${i}" && git push --force
done

git checkout "${DESIRED_UPSTREAM}"

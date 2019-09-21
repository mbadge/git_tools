#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_push_set_upstream.sh
#/ Description: designate upstream remote as the origin {current branch} and push
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }


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
  echo ${ref#refs/heads/}
}

info "Run git push --set-upstream origin $(git_current_branch)?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) git push --set-upstream origin $(git_current_branch); break;;
        No ) exit;;
    esac
done


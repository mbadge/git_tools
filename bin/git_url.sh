#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: ./git_url.sh
#/ Description: Fetch the front-end url to the current git repo
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


# Main ----
# Extract remote origin git repo path from `git remote -v`
RES=$(git remote -v | grep origin | sed -n '1p' | cut -f2 | cut -d" " -f1)

# Transform git's path to the corresponding https browser path
if [[ "${RES}" =~ ^git@.* ]];
then
    info "git repo starts with 'git'"
    HTTPS_RES=$(sed -e 's/git@/https:\/\//' -e 's/nak\.co:/nak.co\//' <<< "${RES}")
else
    info "git repo already starts with 'https'"
    HTTPS_RES="${RES}"
fi


# Extended output ----
# see https://git.nak.co/home/git-tools/issues/2
# Implementation inspired by ~/bin/stow/reporting/*_gitlab.sh

# Preconditions
# ensure my Cp utility is available
if [ -e ~/bin/stow/sh/sourceMe/Cp.sh ]; then
  source ~/bin/stow/sh/sourceMe/Cp.sh
fi

# Write output to a tmp file
tmpfile=$(mktemp "${TMPDIR:-/tmp/}$(basename "$0").XXX")
echo "${HTTPS_RES}" | tee -a "${tmpfile}"

# Copy output tmp file
Cpf "${tmpfile}"

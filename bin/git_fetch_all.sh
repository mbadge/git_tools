#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: git_fetch_all.sh
#/ Description: Wrapper for mr program.
#/  See [git-tools#9](https://git.nak.co/home/git-tools/issues/9)
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


################################################################################
####                                PARAMS                                  ####
################################################################################

################################################################################

# preconditions ----

# input interface ----

################################################################################
####                                 MAIN                                   ####
################################################################################
section "Fetch all repos"
cd / && mr fetch -p
# ^ change to root directory so I fetch all repos instead of (default) only downstream repos
#   including repos on other drives: e.g., `/media/marcus/*`



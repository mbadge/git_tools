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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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



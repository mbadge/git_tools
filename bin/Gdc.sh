#!/usr/bin/env bash
set -Eeuxo pipefail
IFS=$'\n\t'

#/ Usage: Gdc.sh
#/ Description: Show differences in working directory
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# TODO: figure out how to include untracked but not ignored files also
watch --color -n1 --no-title \
    "git diff --cached"

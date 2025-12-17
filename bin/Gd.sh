#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

#/ Usage: Gd.sh
#/ Description: Show unstaged changes in in working directory
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# include all unstaged files by indexing them as a new file
fp_unstaged=$( git ls-files --others --exclude-standard )
echo "${fp_unstaged[@]}" | xargs git add -N

# watch all unstaged changes
watch --color -n1 --no-title \
    "git diff"

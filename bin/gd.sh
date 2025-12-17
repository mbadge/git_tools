#!/usr/bin/env bash
set -Eeuxo pipefail
IFS=$'\n\t'

# include all unstaged files by indexing them as a new file
fp_unstaged=$( git ls-files --others --exclude-standard )
echo "${fp_unstaged[@]}" | xargs git add -N

# diff all unstaged changes
git diff

#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Git log inspection functions
# Pretty formatting of either the selecting revision range or all commits
# Default shows max info
# Override shows filtered range
# Problem: Other flags are incorrectly interpreted because they fill the first positional arg spot where
# a revision range is expected

# workaround:
# make separate functions for the 2 most commonly used flags:
# * `glv`: --stat
# * `glvv`: -p


function glv() {
    {
        echo -e "git log --stat --graph --pretty=format:\"%C(auto)%h %Cblue%cr%Creset%C(auto) %d %s\" ${1}\n"
        git log --stat --graph --pretty=format:"%C(auto)%h %Cblue%cr%Creset%C(auto) %d %s" "${1}"
    } | less
}

glv "${1:---all}"

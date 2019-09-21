#!/bin/bash

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

function glvv() {
    git log -p --graph --pretty=format:"%C(auto)%h %Cblue%cr%Creset%C(auto) %d %s" ${1}
}
glvv ${1:---all}

#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: Gl.sh COMMIT_RANGE
#/ Description: watch a live git log with color
#/ Examples: Gl.sh master..develop
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage


COMMIT_RANGE=${1:---all}
FORMAT_GIT_LOG="%C(auto)%h %Cblue%cr%Creset%C(auto) %d %s"

watch --color -n1 --no-title \
    "git log --stat --color --graph --oneline --pretty=\"${FORMAT_GIT_LOG}\" ${COMMIT_RANGE}"
#                                               ^ enquote expansion of formatting variable


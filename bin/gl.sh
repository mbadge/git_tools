#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: gl.sh INCLUDE_AUTHOR COMMIT_RANGE
#/ Description: Pretty formatting of either the selected revision range or all commits.
#/	include author: boolean true/false. default: false
#/	commit range: defaul --all.  provide range with COMMIT1..COMMIT2
#/ Examples: gl.sh true develop..master
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage


################################################################################
####                                PARAMS                                  ####
################################################################################
INCLUDE_AUTHOR=${1:-false}
COMMIT_RANGE=${2:---all}
################################################################################


################################################################################
####                                 MAIN                                   ####
################################################################################
if $INCLUDE_AUTHOR
then
	FORMAT_GIT_LOG="%C(auto)%h %cn%  %Cblue%cr%Creset%C(auto) %d %s"
else
	FORMAT_GIT_LOG="%C(auto)%h %Cblue%cr%Creset%C(auto) %d %s"
fi

{
    echo -e "git log --graph --pretty=\"${FORMAT_GIT_LOG}\" ${COMMIT_RANGE}\n"
    git log --graph --pretty="${FORMAT_GIT_LOG}" "${COMMIT_RANGE}"
} | less
#						 ^ formatting variable requires enquoting
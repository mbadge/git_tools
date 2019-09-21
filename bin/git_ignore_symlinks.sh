#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage:
#/ The command should be run in the git repository root.
#/ It adds all symlinks to a .gitignore file that aren't in there already.
#/
#/ TODO: port a version that works for vcsh, given pwd downstream of ${HOME} and
#/ modify target output to vcsh's implementation of gitignore
#/
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }


for f in $(git status --porcelain | grep '^??' | sed 's/^?? //'); do
    if test -L "$f"
    then
        test -L "$f" && echo $f >> .gitignore;
    elif test -d "$f"
    then
        find ${f%/} -type l -not -exec grep -q "^{}$" .gitignore \; -print >> .gitignore
    fi
done

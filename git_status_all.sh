#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: git_status_all.sh
#/ Description: Wrapper for mr program.
#/  See [git-tools#9](https://git.nak.co/home/git-tools/issues/9)
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# Output Formatting Facilities ----
# :.,+14fo
# in-line formatter vars --
# compound style schema: FMT_[STYLE]
FMT_CODE="\e[0;31;47m"  # red on grey
FMT_YAML="\e[0;38;5;130m"  # brown
# single style schema: FMT_[PROPERTY]_[VALUE]
FMT_BKG_PURP="\e[0;30;45m"  # normal black on purple
FMT_TXT_YELL="\e[1;33;40m"  # bold yellow on black
FMT_TXT_RED="\e[1;31;40m"   # bold red on black
FMT_OFF="\e[0m"

# whole-line formatter cmds --
readonly LOG_FILE="/tmp/$(basename "$0").log"
title()   { echo -e "\n${FMT_BKG_PURP}\n
                          $*                            \n${FMT_OFF}"; }
section() { echo -e "\n${FMT_TXT_YELL}$*${FMT_OFF}"; }
code()    { echo -e "${FMT_CODE}\$ $*${FMT_OFF}"; }
warning() { echo -e "${FMT_TXT_YELL}[WARNING] $*${FMT_OFF}" ; }
error()   { echo -e "${FMT_TXT_RED}[ERROR]   $*${FMT_OFF}" ; }
yaml()    { echo -e "${FMT_YAML}$*${FMT_OFF}"; }


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
cd / && mr status
# ^ change to base directory so I status all repos instead of (default) only downstream repos



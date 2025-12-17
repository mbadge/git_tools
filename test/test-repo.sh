#!/usr/bin/env bash
# Create a tmp test git repo
# test repo is always started fresh and left with a local+remote develop + local master
set -Eeuxo pipefail
IFS=$'\n\t'


# Output Formatting Facilities ----

# in-line formatter vars --
# style schema: FMT_[STYLE]
FMT_CODE="\e[0;31;47m"  # red on grey

# var_name schema: FMT_[PROPERTY]_[VALUE]
FMT_BKG_PURP="\e[0;30;45m"  # normal black on purple
FMT_BKG_AQUA="\e[1;30;46m"  # bold grey on aqua
FMT_TXT_YELL="\e[1;33;40m"  # bold yellow on black
FMT_TXT_RED="\e[1;31;40m"   # bold red on black
FMT_OFF="\e[0m"

# whole-line formatter cmds
title()   { echo -e "\n\n${FMT_BKG_AQUA}######## $* ########${FMT_OFF}"; }
section() { echo -e "\n${FMT_TXT_YELL}$*${FMT_OFF}"; }

warning() { echo -e "${FMT_TXT_YELL}[WARNING] $*${FMT_OFF}" ; }
error()   { echo -e "${FMT_TXT_RED}[ERROR]   $*${FMT_OFF}" ; }



# PARAMS ----
DIR_TMP_GIT="/tmp/$(basename "${0%.sh}")"


# MAIN ----
title "Tmp GIT repo"

section "Create test repo in ${DIR_TMP_GIT}"

# Fresh start
rm -rf "${DIR_TMP_GIT}"
mkdir "${DIR_TMP_GIT}"
cd "${DIR_TMP_GIT}"
echo -e "${FMT_CODE} \$ git flow init ${FMT_OFF}"

# Set up local branches
git flow init -d
#              ^ use default branch names

# Set up remote branches (force)
git remote add origin git@bitbucket.org:MarcusBadgeley/git-test.git
git checkout master
git push -f -u origin master
git checkout develop
git push -f -u origin develop

# advance develop with dummy work
touch a.txt
git add a.txt
git commit -m "New txt file feature. #1"
git push



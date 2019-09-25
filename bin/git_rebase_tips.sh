#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

#/ Usage: ./git_rebase_tips.sh
#/ Description: Rebase all branches matching tip-* onto tip
#/  This relieves the tediousness of keeping many tips on top of tip
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



# Util fxns ----
# Identify Current Branch
# copied from ~/.oh_my_zsh/lib/git.zsh
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}


################################################################################
####                                 MAIN                                   ####
################################################################################
DESIRED_UPSTREAM=tip

# branches=$( git branch | cut -f2- -d' ' | sed "s/^\\s//" )
branch_tips=$(grep tip- <(git branch | cut -f2- -d' ' | sed "s/^\\s//") )

echo -e "Rebasing tip branches:\n${branch_tips}"
for i in ${branch_tips[@]}
do
    git checkout ${i}
    git rebase ${DESIRED_UPSTREAM}
done

echo "Local tips rebased. Should we also rebase the remotes?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) for i in ${branch_tips[@]}; do git checkout ${i} && git push --force; done; break;;
        No ) break;;
    esac
done

git checkout ${DESIRED_UPSTREAM}

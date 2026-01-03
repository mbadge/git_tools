#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: docker_enter CONTAINER
#/ Description: wrapper for `docker exec -il CONTAINER bash`
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; echo -e "\n running containers:"; docker ps; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# CLI
if [ "$#" -lt 1 ] ; then
    echo -e "ERROR: Please provide argument CONTAINER\n"
    usage
    echo -e "\nHere are your running containers:"
fi

# PARAMS
CONTAINER=$1

# MAIN
docker exec -it "${CONTAINER}" bash

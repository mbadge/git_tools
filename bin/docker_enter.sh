#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: docker_enter CONTAINER
#/ Description: wrapper for `docker exec -il CONTAINER bash`
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; echo -e "\n running containers:"; docker ps; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# Source shared coloring library
readonly LOG_FILE="/tmp/$(basename "$0").log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

# CLI
if [ "$#" -lt 1 ] ; then
    error "Please provide argument CONTAINER"
    usage
    echo -e "\nHere are your running containers:"
fi

# PARAMS
CONTAINER=$1

# MAIN
docker exec -it "${CONTAINER}" bash

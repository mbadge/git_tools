#!/usr/bin/env bash
set -Eeuxo pipefail
IFS=$'\n\t'

# PARAMS ----
FP_TEST=${HOME}/stow/git-tools/bin/$(basename "${0/test-/}")
FP_TEST_REPO=test-repo.sh

# preconditions
if [ ! -f "${FP_TEST}" ]; then echo "No file found: ${FP_TEST}"; stop 67; fi
if [ ! -f "${FP_TEST_REPO}" ]; then echo "No file found: ${FP_TEST_REPO}"; stop 67; fi

# MAIN ----
./"${FP_TEST_REPO}"

# give user chance to inspect repo
echo "cd /tmp/test-repo && git status"
read -n 1 -s -r -p "Press any key to continue"

cd /tmp/test-repo
git checkout -b feature-1
git push -f -u origin feature-1

git checkout master
read -n 1 -s -r -p "Press any key to continue"
"${FP_TEST}" feature-1


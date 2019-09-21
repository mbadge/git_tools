#!/usr/bin/env bash
# Re-install packages in stow directory PRN
#
# duplicated and derived from dot-files repo `~/bin/stow/sh/restow.sh`

#! code generator snippets ------------------------
#! List all downstream directories to install
#! (to paste space separated entries in `stow` cmd)
#$ Cp "$(ls -1 | tr '\n' ' ')"
#!
#! Extension of above to build basic stow invocation cmd
#$ Cp "stow --restow $(ls -1 | tr '\n' ' ')"
#! ------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

echo 'Restowing `~/` directory'
cd ~/stow

stow --restow \
    --verbose=2 \
    --ignore='Makefile' \
    --ignore='restow.sh' \
    --ignore='.*\.swp' \
    --ignore='.*\.swo' \
    git-tools

# check for bogus symlinks (pointing to non-existent files)
chkstow -b


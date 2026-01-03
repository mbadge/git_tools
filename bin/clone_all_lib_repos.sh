#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Source shared coloring library
readonly LOG_FILE="/tmp/$(basename "$0").log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

section "Cloning libR repositories"
git clone git@git.nak.co:libR/MyUtils.git
git clone git@git.nak.co:libR/vizR.git
git clone git@git.nak.co:libR/MlAnalysis.git
git clone git@git.nak.co:libR/R-DlAnalysis.git
git clone git@git.nak.co:libR/AnalysisToolkit.git
git clone git@git.nak.co:libR/thirdparty.git
git clone git@git.nak.co:libR/testr.git

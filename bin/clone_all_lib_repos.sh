#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Source shared coloring library
readonly LOG_FILE="/tmp/$(basename "$0").log"
# Get script directory - handle both direct execution and execution via PATH/alias
_script_path="${BASH_SOURCE[0]:-$0}"
if [[ ! "$_script_path" =~ ^/ ]]; then
  if command -v "$_script_path" >/dev/null 2>&1; then
    _script_path="$(command -v "$_script_path")"
  fi
fi
if [[ -L "$_script_path" ]]; then
  _script_path="$(readlink -f "$_script_path" 2>/dev/null || readlink "$_script_path" 2>/dev/null || echo "$_script_path")"
fi
SCRIPT_DIR="$(cd "$(dirname "$_script_path")" && pwd)"
unset _script_path
source "${SCRIPT_DIR}/colors.sh"

section "Cloning libR repositories"
git clone git@git.nak.co:libR/MyUtils.git
git clone git@git.nak.co:libR/vizR.git
git clone git@git.nak.co:libR/MlAnalysis.git
git clone git@git.nak.co:libR/R-DlAnalysis.git
git clone git@git.nak.co:libR/AnalysisToolkit.git
git clone git@git.nak.co:libR/thirdparty.git
git clone git@git.nak.co:libR/testr.git

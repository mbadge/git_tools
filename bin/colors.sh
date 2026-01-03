#!/usr/bin/env bash
# Shared coloring and output formatting library for git-tools scripts
# Source this file in your script to get consistent colored output

# Helper function to get the script directory, handling both direct execution and PATH/alias execution
# Usage: SCRIPT_DIR=$(get_script_dir)
get_script_dir() {
  local script_path="${BASH_SOURCE[1]:-${BASH_SOURCE[0]:-$0}}"
  # If it's not an absolute path, try to find it
  if [[ ! "$script_path" =~ ^/ ]]; then
    # Try to find the script in PATH
    if command -v "$script_path" >/dev/null 2>&1; then
      script_path="$(command -v "$script_path")"
    elif [[ -f "$script_path" ]]; then
      # If it's a relative path, make it absolute
      script_path="$(cd "$(dirname "$script_path")" && pwd)/$(basename "$script_path")"
    fi
  fi
  # Resolve symlinks to get the real path
  if [[ -L "$script_path" ]]; then
    script_path="$(readlink -f "$script_path" 2>/dev/null || readlink "$script_path" 2>/dev/null || echo "$script_path")"
  fi
  echo "$(cd "$(dirname "$script_path")" && pwd)"
}

# Color constants ----
# ANSI escape codes for terminal colors
# compound style schema: FMT_[STYLE]
readonly FMT_CODE="\e[0;31;47m"      # red on grey
readonly FMT_YAML="\e[0;38;5;130m"   # brown
# single style schema: FMT_[PROPERTY]_[VALUE]
readonly FMT_BKG_PURP="\e[0;30;45m"  # normal black on purple
readonly FMT_TXT_YELL="\e[1;33;40m"  # bold yellow on black
readonly FMT_TXT_RED="\e[1;31;40m"   # bold red on black
readonly FMT_TXT_GREEN="\e[1;32;40m" # bold green on black
readonly FMT_TXT_CYAN="\e[1;36;40m"  # bold cyan on black
readonly FMT_TXT_BLUE="\e[1;34;40m"  # bold blue on black
readonly FMT_BOLD="\e[1m"            # bold
readonly FMT_GREEN="\e[1;32m"        # green
readonly FMT_CYAN="\e[1;36m"         # cyan
readonly FMT_YELLOW="\e[1;33m"       # yellow
readonly FMT_OFF="\e[0m"             # reset

# Initialize LOG_FILE if not already set
# Scripts should set LOG_FILE before sourcing this file, but we provide a fallback
# Use BASH_SOURCE to get the calling script's name when sourced
if [[ -z "${LOG_FILE:-}" ]]; then
  # Get the calling script's name from BASH_SOURCE stack
  _caller_script="${BASH_SOURCE[1]:-colors.sh}"
  LOG_FILE="/tmp/$(basename "$_caller_script").log"
  unset _caller_script
fi
# Make LOG_FILE readonly after initialization (only if not already readonly)
# Check if variable is already readonly to avoid "readonly: LOG_FILE: readonly variable" error
if ! readonly -p LOG_FILE >/dev/null 2>&1; then
  readonly LOG_FILE
fi

# Basic logging functions with colors ----
# These functions write to both stderr and the log file
# Using log_ prefix to avoid conflicts with system commands (info, dircolors, etc.)
function log_info() {
  echo -e "${FMT_TXT_CYAN}[INFO]    $*${FMT_OFF}" | tee -a "$LOG_FILE" >&2
}

function log_warning() {
  echo -e "${FMT_TXT_YELL}[WARNING] $*${FMT_OFF}" | tee -a "$LOG_FILE" >&2
}

function log_error() {
  echo -e "${FMT_TXT_RED}[ERROR]   $*${FMT_OFF}" | tee -a "$LOG_FILE" >&2
}

function log_fatal() {
  echo -e "${FMT_TXT_RED}[FATAL]   $*${FMT_OFF}" | tee -a "$LOG_FILE" >&2
  exit 1
}

function log_success() {
  echo -e "${FMT_TXT_GREEN}[SUCCESS] $*${FMT_OFF}" | tee -a "$LOG_FILE" >&2
}

# Create wrapper functions for backward compatibility (without log_ prefix)
# These MUST take precedence over system commands (info, dircolors, etc.)
# Unalias and unset any existing definitions first
unalias info dircolors 2>/dev/null || true
unset -f info 2>/dev/null || true
# Define as functions to ensure they take precedence over commands
function info() { 
  log_info "$@"
}
function warning() { 
  log_warning "$@"
}
function error() { 
  log_error "$@"
}
function fatal() { 
  log_fatal "$@"
}
function success() { 
  log_success "$@"
}
# Verify functions are defined (they should take precedence over commands)
if ! declare -f info >/dev/null 2>&1; then
  echo "Error: info function not properly defined" >&2
  exit 1
fi

# Advanced formatting functions ----
# These functions provide structured output formatting
function title() {
  echo -e "\n${FMT_BKG_PURP}\n                          $*                            \n${FMT_OFF}"
}

function section() {
  echo -e "\n${FMT_TXT_YELL}$*${FMT_OFF}"
}

function code() {
  echo -e "${FMT_CODE}\$ $*${FMT_OFF}"
}

function yaml() {
  echo -e "${FMT_YAML}$*${FMT_OFF}"
}


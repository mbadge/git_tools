#!/usr/bin/env bash
# Helper to set terminal window title
# Source this from other scripts: source "$(dirname "$0")/terminal_title.sh"

# Set terminal title using ANSI escape sequence (works for script's own terminal)
# Usage: set_terminal_title "title string"
set_terminal_title() {
    local title="$1"
    # ANSI escape sequence - writes to this script's terminal, not the "active" window
    # This is correct for scripts launched in their own terminal
    printf '\033]0;%s\007' "$title"
}

# Set title showing script name, repo, and path
# Usage: set_git_terminal_title "$0" "$@"
set_git_terminal_title() {
    local script_name
    script_name=$(basename "$1")
    shift
    local args="$*"

    local repo_path repo_name title
    repo_path=$(git rev-parse --show-toplevel 2>/dev/null || echo "")

    if [ -n "$repo_path" ]; then
        repo_name=$(basename "$repo_path")
        # Shorten home prefix
        repo_path="${repo_path/#$HOME/~}"
        if [ -n "$args" ]; then
            title="${script_name} ${args}: ${repo_name} [${repo_path}]"
        else
            title="${script_name}: ${repo_name} [${repo_path}]"
        fi
    else
        title="${script_name} ${args}"
    fi

    set_terminal_title "$title"
}

#!/usr/bin/env bash
# Test helper functions and setup for BATS tests

# Get the directory of this script
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TEST_DIR}/.." && pwd)"
BIN_DIR="${PROJECT_ROOT}/bin"

# Load BATS libraries using absolute paths
load "${TEST_DIR}/lib/bats-support/load"
load "${TEST_DIR}/lib/bats-assert/load"
load "${TEST_DIR}/lib/bats-file/load"

# Setup function - runs before each test
setup() {
    # Create a temporary directory for test files
    TEST_TEMP_DIR="$(mktemp -d -t git_tools_test.XXXXXX)"
    export TEST_TEMP_DIR

    # Save original directory
    ORIGINAL_DIR="$(pwd)"
    export ORIGINAL_DIR
}

# Teardown function - runs after each test
teardown() {
    # Return to original directory
    cd "${ORIGINAL_DIR}" || true

    # Clean up temporary directory
    if [ -n "${TEST_TEMP_DIR:-}" ] && [ -d "${TEST_TEMP_DIR}" ]; then
        rm -rf "${TEST_TEMP_DIR}"
    fi
}

# Helper: Create a mock git repository
create_mock_git_repo() {
    local repo_dir="${1:-${TEST_TEMP_DIR}/test-repo}"
    mkdir -p "${repo_dir}"
    cd "${repo_dir}"
    git init >/dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    # Disable commit signing for tests
    git config commit.gpgsign false
    git config gpg.format ""
    echo "# Test Repo" > README.md
    git add README.md >/dev/null 2>&1
    git commit -m "Initial commit" >/dev/null 2>&1
    echo "${repo_dir}"
}

# Helper: Create a mock git repository with a remote
create_mock_git_repo_with_remote() {
    local repo_dir="${1:-${TEST_TEMP_DIR}/test-repo}"
    local remote_url="${2:-git@github.com:user/repo.git}"

    create_mock_git_repo "${repo_dir}" >/dev/null
    git remote add origin "${remote_url}" >/dev/null 2>&1
    echo "${repo_dir}"
}

# Helper: Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Helper: Skip test if git is not available
require_git() {
    if ! command_exists git; then
        skip "git is not installed"
    fi
}

# Helper: Run a bin script
run_bin_script() {
    local script_name="$1"
    shift
    run "${BIN_DIR}/${script_name}" "$@"
}

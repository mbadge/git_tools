#!/usr/bin/env bats
# Tests for mr wrapper scripts (git_fetch_all.sh and git_status_all.sh)

load test_helper

@test "git_fetch_all.sh: displays help message" {
    run_bin_script "git_fetch_all.sh" --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "git_fetch_all.sh"
}

@test "git_status_all.sh: displays help message" {
    run_bin_script "git_status_all.sh" --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "git_status_all.sh"
}

@test "git_fetch_all.sh: requires mr command" {
    if ! command_exists mr; then
        skip "mr is not installed"
    fi

    run_bin_script "git_fetch_all.sh"
    # Script should run if mr is available
    # We don't check success because it depends on mr configuration
}

@test "git_status_all.sh: requires mr command" {
    if ! command_exists mr; then
        skip "mr is not installed"
    fi

    run_bin_script "git_status_all.sh"
    # Script should run if mr is available
    # We don't check success because it depends on mr configuration
}

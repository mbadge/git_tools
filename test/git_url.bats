#!/usr/bin/env bats
# Tests for git_url.sh

load test_helper

@test "git_url.sh: displays help message" {
    run_bin_script "git_url.sh" --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "Fetch the front-end url"
}

@test "git_url.sh: converts git@ URL to https" {
    require_git

    # Create mock repo with git@ remote
    local repo_dir
    repo_dir=$(create_mock_git_repo_with_remote "${TEST_TEMP_DIR}/repo" "git@github.com:user/repo.git")
    cd "${repo_dir}"

    run_bin_script "git_url.sh"
    assert_success
    assert_output --partial "https://github.com/user/repo.git"
}

@test "git_url.sh: handles https URL" {
    require_git

    # Create mock repo with https remote
    local repo_dir
    repo_dir=$(create_mock_git_repo_with_remote "${TEST_TEMP_DIR}/repo" "https://github.com/user/repo.git")
    cd "${repo_dir}"

    run_bin_script "git_url.sh"
    assert_success
    assert_output --partial "https://github.com/user/repo.git"
}

@test "git_url.sh: transforms nak.co git URL" {
    require_git

    # Create mock repo with nak.co remote
    local repo_dir
    repo_dir=$(create_mock_git_repo_with_remote "${TEST_TEMP_DIR}/repo" "git@nak.co:home/git-tools.git")
    cd "${repo_dir}"

    run_bin_script "git_url.sh"
    assert_success
    assert_output --partial "https://nak.co/home/git-tools.git"
}

@test "git_url.sh: fails outside git repository" {
    cd "${TEST_TEMP_DIR}"

    run_bin_script "git_url.sh"
    assert_failure
}

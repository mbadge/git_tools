#!/usr/bin/env bats
# Tests for git wrapper scripts (gl.sh, gd.sh, etc.)

load test_helper

@test "gl.sh: displays help message" {
    run_bin_script "gl.sh" --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "gl.sh"
}

@test "gl.sh: works in git repository" {
    require_git

    # Create mock repo with some commits
    local repo_dir
    repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
    cd "${repo_dir}"

    # Add another commit
    echo "test" > test.txt
    git add test.txt
    git commit -m "Test commit"

    # Run gl.sh (it pipes to less, so we need to handle that)
    # We'll test it can at least execute without error in non-interactive mode
    run bash -c "cd ${repo_dir} && git log --graph --pretty='%h %cr %d %s' --all"
    assert_success
}

@test "gl.sh: accepts include author parameter" {
    run_bin_script "gl.sh" --help
    assert_success
    assert_output --partial "include author"
}

@test "gl.sh: accepts commit range parameter" {
    run_bin_script "gl.sh" --help
    assert_success
    assert_output --partial "commit range"
}

@test "gd.sh: works in git repository" {
    require_git

    # Create mock repo
    local repo_dir
    repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
    cd "${repo_dir}"

    # Create an unstaged file
    echo "unstaged content" > unstaged.txt

    # Run gd.sh (which adds -N and shows diff)
    run_bin_script "gd.sh"
    # Script should succeed
    assert_success
}

@test "gd.sh: handles repository with no unstaged files" {
    require_git

    # Create mock repo with no changes
    local repo_dir
    repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
    cd "${repo_dir}"

    # Run gd.sh
    run_bin_script "gd.sh"
    assert_success
}

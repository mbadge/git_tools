#!/usr/bin/env bats
# Tests for git_ignore_symlinks.sh

load test_helper

@test "git_ignore_symlinks.sh: displays help message" {
    run_bin_script "git_ignore_symlinks.sh" --help
    assert_success
    assert_output --partial "Usage:"
}

@test "git_ignore_symlinks.sh: adds symlinks to gitignore" {
    require_git

    # Create mock repo
    local repo_dir
    repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
    cd "${repo_dir}"

    # Create a symlink
    echo "target content" > target.txt
    ln -s target.txt link.txt

    # Verify symlink is untracked
    run git status --porcelain
    assert_output --partial "?? link.txt"

    # Run the script
    run_bin_script "git_ignore_symlinks.sh"
    assert_success

    # Verify symlink was added to .gitignore
    assert_file_exist .gitignore
    run cat .gitignore
    assert_output --partial "link.txt"
}

@test "git_ignore_symlinks.sh: handles symlinks in directories" {
    require_git

    # Create mock repo
    local repo_dir
    repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
    cd "${repo_dir}"

    # Create directory with symlink
    mkdir -p subdir
    echo "target content" > target.txt
    ln -s ../target.txt subdir/link.txt

    # Run the script
    run_bin_script "git_ignore_symlinks.sh"
    assert_success

    # Verify symlink was added to .gitignore
    assert_file_exist .gitignore
    run cat .gitignore
    assert_output --partial "subdir/link.txt"
}

@test "git_ignore_symlinks.sh: works in repo without symlinks" {
    require_git

    # Create mock repo without symlinks
    local repo_dir
    repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
    cd "${repo_dir}"

    # Create a regular file
    echo "content" > regular.txt

    # Run the script
    run_bin_script "git_ignore_symlinks.sh"
    assert_success
}

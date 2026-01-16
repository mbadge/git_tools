# Testing Documentation

This directory contains automated tests for the shell scripts in the `bin/` directory.

## Testing Framework

The tests use [BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core), a TAP-compliant testing framework for Bash.

### BATS Libraries

The testing setup includes these BATS helper libraries:

- **bats-core**: Core testing framework
- **bats-support**: Supporting library with common utilities
- **bats-assert**: Assertions for test validation
- **bats-file**: File and directory assertions

## Setup

### First Time Setup

Install the BATS testing framework and dependencies:

```bash
./test/setup_bats.sh
```

This will clone the BATS framework and helper libraries into `test/lib/` (git-ignored).

## Running Tests

### Run All Tests

```bash
./test/run_tests.sh
```

### Run Specific Tests

Filter tests by filename pattern:

```bash
./test/run_tests.sh --filter git_url
```

### Verbose Output

Show detailed test output:

```bash
./test/run_tests.sh --verbose
```

### Help

```bash
./test/run_tests.sh --help
```

## Writing Tests

### Test File Structure

Test files use the `.bats` extension and follow this structure:

```bash
#!/usr/bin/env bats
# Tests for script_name.sh

load test_helper

@test "script_name.sh: test description" {
    run_bin_script "script_name.sh" --args
    assert_success
    assert_output --partial "expected output"
}
```

### Test Helpers

The `test_helper.bash` file provides utilities:

- **setup()**: Runs before each test (creates temp directory)
- **teardown()**: Runs after each test (cleans up)
- **create_mock_git_repo()**: Creates a temporary git repository
- **create_mock_git_repo_with_remote()**: Creates a git repo with remote
- **command_exists()**: Check if a command is available
- **require_git()**: Skip test if git is not installed
- **run_bin_script()**: Run a script from the bin directory

### Available Assertions

From bats-assert:

- `assert_success`: Command exited with status 0
- `assert_failure`: Command exited with non-zero status
- `assert_output`: Check output matches exactly
- `assert_output --partial`: Check output contains substring
- `assert_line`: Check specific line of output
- `refute_output`: Output should not match

From bats-file:

- `assert_file_exist`: File exists
- `assert_file_not_exist`: File does not exist
- `assert_dir_exist`: Directory exists

### Example Test

```bash
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
```

## Test Coverage

Current test files:

- `git_url.bats`: Tests for git_url.sh
- `git_ignore_symlinks.bats`: Tests for git_ignore_symlinks.sh
- `git_branch_rm_all.bats`: Tests for git_branch_rm_all.sh
- `git_mr_wrappers.bats`: Tests for git_fetch_all.sh and git_status_all.sh
- `git_wrappers.bats`: Tests for gl.sh and gd.sh

## CI/CD Integration

Tests are automatically run on every push and pull request through:

### GitHub Actions

Workflow file: `.github/workflows/test.yml`

- Runs on every push and pull request
- Uses Ubuntu latest
- Executes all tests with verbose output
- Shows test results in the Actions tab

### GitLab CI

Configuration file: `.gitlab-ci.yml`

- Runs on all branches and merge requests
- Tests on multiple bash versions (4 & 5)
- Caches BATS libraries for faster builds
- Generates JUnit test reports

### Manual CI/CD Setup

If you need to add tests to another CI/CD system:

```bash
# Setup and run tests
./test/setup_bats.sh
./test/run_tests.sh
```

The test runner exits with:
- `0` if all tests pass
- `1` if any tests fail

## Troubleshooting

### BATS Not Found

If you get "BATS executable not found":

```bash
./test/setup_bats.sh
```

### Permission Denied

If you get permission errors:

```bash
chmod +x ./test/*.sh
```

### Tests Failing

Run with verbose output to see details:

```bash
./test/run_tests.sh --verbose
```

## Best Practices

1. **Test Isolation**: Each test should be independent
2. **Mock External Dependencies**: Use mock git repos instead of real ones
3. **Clean Up**: Use teardown() to clean temporary files
4. **Skip Appropriately**: Skip tests if required commands are unavailable
5. **Descriptive Names**: Use clear test descriptions
6. **Test Both Success and Failure**: Cover happy path and error cases

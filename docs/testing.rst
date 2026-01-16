Testing
=======

Git Tools includes a comprehensive testing framework using BATS (Bash Automated Testing System).

Testing Framework
-----------------

BATS Overview
~~~~~~~~~~~~~

`BATS <https://github.com/bats-core/bats-core>`_ is a TAP-compliant testing framework for Bash that provides:

* Clear test syntax with ``@test`` blocks
* Assertions for validating behavior
* Setup and teardown hooks
* Extensibility through helper libraries

BATS Libraries
~~~~~~~~~~~~~~

The testing setup includes these helper libraries:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Library
     - Purpose
   * - **bats-core**
     - Core testing framework
   * - **bats-support**
     - Common utilities and helpers
   * - **bats-assert**
     - Assertions for test validation
   * - **bats-file**
     - File and directory assertions

Setup
-----

First Time Setup
~~~~~~~~~~~~~~~~

Install the BATS testing framework and dependencies:

.. code-block:: bash

   ./test/setup_bats.sh

This script:
  * Clones the BATS framework
  * Downloads helper libraries
  * Installs everything into ``test/lib/`` (git-ignored)
  * Makes the test runner executable

Running Tests
-------------

Run All Tests
~~~~~~~~~~~~~

Execute the complete test suite:

.. code-block:: bash

   ./test/run_tests.sh

Run Specific Tests
~~~~~~~~~~~~~~~~~~

Filter tests by filename pattern:

.. code-block:: bash

   # Run only git_url tests
   ./test/run_tests.sh --filter git_url

   # Run all branch management tests
   ./test/run_tests.sh --filter branch

Verbose Output
~~~~~~~~~~~~~~

Show detailed test output including assertion details:

.. code-block:: bash

   ./test/run_tests.sh --verbose

Get Help
~~~~~~~~

Display usage information:

.. code-block:: bash

   ./test/run_tests.sh --help

Writing Tests
-------------

Test File Structure
~~~~~~~~~~~~~~~~~~~

Test files use the ``.bats`` extension and follow this structure:

.. code-block:: bash

   #!/usr/bin/env bats
   # Tests for script_name.sh

   load test_helper

   @test "script_name.sh: test description" {
       run_bin_script "script_name.sh" --args
       assert_success
       assert_output --partial "expected output"
   }

Test Helpers
~~~~~~~~~~~~

The ``test_helper.bash`` file provides utilities:

**setup()**
  Runs before each test - creates temporary directory

**teardown()**
  Runs after each test - cleans up temporary files

**create_mock_git_repo()**
  Creates a temporary git repository for testing

  .. code-block:: bash

     repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")

**create_mock_git_repo_with_remote()**
  Creates a git repository with a remote configured

  .. code-block:: bash

     repo_dir=$(create_mock_git_repo_with_remote "${TEST_TEMP_DIR}/repo" "git@github.com:user/repo.git")

**command_exists()**
  Check if a command is available

  .. code-block:: bash

     if ! command_exists git; then
       skip "git not installed"
     fi

**require_git()**
  Skip test if git is not installed

  .. code-block:: bash

     require_git

**run_bin_script()**
  Run a script from the bin directory

  .. code-block:: bash

     run_bin_script "git_url.sh" --args

Available Assertions
--------------------

From bats-assert
~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Assertion
     - Purpose
   * - ``assert_success``
     - Command exited with status 0
   * - ``assert_failure``
     - Command exited with non-zero status
   * - ``assert_output "text"``
     - Output matches exactly
   * - ``assert_output --partial "text"``
     - Output contains substring
   * - ``assert_line "text"``
     - Specific line of output matches
   * - ``refute_output "text"``
     - Output should not match

From bats-file
~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Assertion
     - Purpose
   * - ``assert_file_exist path``
     - File exists
   * - ``assert_file_not_exist path``
     - File does not exist
   * - ``assert_dir_exist path``
     - Directory exists

Example Tests
-------------

Basic Test
~~~~~~~~~~

.. code-block:: bash

   @test "git_url.sh: displays help with --help flag" {
       run_bin_script "git_url.sh" --help
       assert_success
       assert_output --partial "Usage:"
   }

Test with Mock Repository
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   @test "git_url.sh: converts git@ URL to https" {
       require_git

       # Create mock repo with git@ remote
       local repo_dir
       repo_dir=$(create_mock_git_repo_with_remote \
           "${TEST_TEMP_DIR}/repo" \
           "git@github.com:user/repo.git")
       cd "${repo_dir}"

       run_bin_script "git_url.sh"
       assert_success
       assert_output --partial "https://github.com/user/repo"
   }

Test with File Assertions
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   @test "git_create_repo.sh: creates directory" {
       run_bin_script "git_create_repo.sh" --in-place test-repo
       assert_success
       assert_dir_exist "test-repo"
       assert_file_exist "test-repo/.git/config"
   }

Test Coverage
-------------

Current test files and their coverage:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Test File
     - Scripts Tested
   * - ``git_url.bats``
     - ``git_url.sh``
   * - ``git_ignore_symlinks.bats``
     - ``git_ignore_symlinks.sh``
   * - ``git_branch_rm_all.bats``
     - ``git_branch_rm_all.sh``
   * - ``git_mr_wrappers.bats``
     - ``git_fetch_all.sh``, ``git_status_all.sh``
   * - ``git_wrappers.bats``
     - ``gl.sh``, ``gd.sh``

CI/CD Integration
-----------------

Tests run automatically on every push and pull request.

GitHub Actions
~~~~~~~~~~~~~~

**Workflow**: ``.github/workflows/test.yml``

* Runs on every push and pull request
* Uses Ubuntu latest
* Executes all tests with verbose output
* Shows results in the Actions tab
* Badge: |test-badge|

.. |test-badge| image:: https://github.com/mbadge/git_tools/actions/workflows/test.yml/badge.svg
   :alt: Shell Tests
   :target: https://github.com/mbadge/git_tools/actions/workflows/test.yml

GitLab CI
~~~~~~~~~

**Configuration**: ``.gitlab-ci.yml``

* Runs on all branches and merge requests
* Tests on multiple bash versions (4 & 5)
* Caches BATS libraries for faster builds
* Generates JUnit test reports
* Parallel testing across versions

Manual CI/CD Setup
~~~~~~~~~~~~~~~~~~

For other CI/CD systems:

.. code-block:: bash

   # Setup and run tests
   ./test/setup_bats.sh
   ./test/run_tests.sh

The test runner exits with:
  * ``0`` if all tests pass
  * ``1`` if any tests fail

Best Practices
--------------

Test Isolation
~~~~~~~~~~~~~~

Each test should be independent and not rely on other tests:

.. code-block:: bash

   @test "isolated test" {
       # Create own test data
       local temp_file="${TEST_TEMP_DIR}/data"
       echo "test" > "${temp_file}"

       # Test logic
       run cat "${temp_file}"
       assert_output "test"

       # Teardown happens automatically
   }

Mock External Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use mock git repositories instead of real ones:

.. code-block:: bash

   @test "test with mock repo" {
       local repo_dir=$(create_mock_git_repo "${TEST_TEMP_DIR}/repo")
       cd "${repo_dir}"

       # Test logic with mock repo
   }

Clean Up Resources
~~~~~~~~~~~~~~~~~~

Use teardown() for cleanup:

.. code-block:: bash

   teardown() {
       # Custom cleanup beyond automatic temp directory removal
       if [ -n "${CUSTOM_RESOURCE:-}" ]; then
           cleanup_custom_resource
       fi
   }

Skip Appropriately
~~~~~~~~~~~~~~~~~~

Skip tests when dependencies are unavailable:

.. code-block:: bash

   @test "test requiring special tool" {
       if ! command_exists special_tool; then
           skip "special_tool not installed"
       fi

       # Test logic
   }

Descriptive Names
~~~~~~~~~~~~~~~~~

Use clear, descriptive test names:

.. code-block:: bash

   # Good
   @test "git_url.sh: converts SSH URL to HTTPS format"

   # Bad
   @test "url test 1"

Test Both Paths
~~~~~~~~~~~~~~~

Cover both success and failure cases:

.. code-block:: bash

   @test "git_branch_rm_all.sh: succeeds with valid branch" {
       # Setup
       # Test success case
       assert_success
   }

   @test "git_branch_rm_all.sh: fails with invalid branch" {
       # Test failure case
       assert_failure
       assert_output --partial "error"
   }

Troubleshooting
---------------

BATS Not Found
~~~~~~~~~~~~~~

If you get "BATS executable not found":

.. code-block:: bash

   ./test/setup_bats.sh

Permission Denied
~~~~~~~~~~~~~~~~~

If you get permission errors:

.. code-block:: bash

   chmod +x ./test/*.sh
   chmod +x ./test/lib/bats-core/bin/bats

Tests Failing
~~~~~~~~~~~~~

Run with verbose output to see details:

.. code-block:: bash

   ./test/run_tests.sh --verbose

Check specific test file:

.. code-block:: bash

   ./test/lib/bats-core/bin/bats ./test/git_url.bats --verbose

See Also
--------

* :doc:`composers` - Information about testable composer scripts
* :doc:`contributing` - Guidelines for contributing tests
* `BATS Documentation <https://bats-core.readthedocs.io/>`_

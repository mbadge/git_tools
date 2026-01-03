Contributing
============

Contributions to Git Tools are welcome! This guide will help you contribute effectively.

Getting Started
---------------

Fork and Clone
~~~~~~~~~~~~~~

1. Fork the repository on GitHub or GitLab
2. Clone your fork:

   .. code-block:: bash

      cd ~/stow
      git clone git@github.com:yourusername/git-tools.git

3. Add upstream remote:

   .. code-block:: bash

      cd git-tools
      git remote add upstream git@git.nak.co:home/git-tools.git

Development Setup
~~~~~~~~~~~~~~~~~

1. Install dependencies:

   .. code-block:: bash

      # Install Git Tools dependencies
      # (Git, Bash, GNU Stow should already be installed)

2. Set up testing framework:

   .. code-block:: bash

      ./test/setup_bats.sh

3. Run tests to verify setup:

   .. code-block:: bash

      ./test/run_tests.sh

Types of Contributions
----------------------

Bug Reports
~~~~~~~~~~~

**Use GitLab issue templates**

When reporting bugs, include:

* **Description**: Clear description of the issue
* **Steps to Reproduce**: Exact steps to reproduce the problem
* **Expected Behavior**: What should happen
* **Actual Behavior**: What actually happens
* **Environment**: Bash version, OS, Git version
* **Logs**: Relevant log output from ``/tmp/*.log``

Example:

.. code-block:: text

   **Description**: git_create_repo.sh fails with 404 error

   **Steps to Reproduce**:
   1. Run: git_create_repo.sh --github test-repo
   2. Enter GitHub token when prompted

   **Expected**: Repository created successfully
   **Actual**: 404 Not Found error

   **Environment**:
   - Bash: 5.0.17
   - OS: Ubuntu 20.04
   - Git: 2.25.1

   **Logs**:
   [ERROR] API request failed: 404

Feature Proposals
~~~~~~~~~~~~~~~~~

**Use GitLab feature proposal template**

When proposing features, include:

* **Use Case**: Why is this needed?
* **Proposed Solution**: How should it work?
* **Alternatives Considered**: Other approaches you've thought about
* **Implementation Ideas**: Rough implementation plan if you have one

Code Contributions
~~~~~~~~~~~~~~~~~~

See the sections below for detailed guidelines on contributing code.

Development Workflow
--------------------

Create a Feature Branch
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   git checkout -b feature/your-feature-name

Make Changes
~~~~~~~~~~~~

1. Edit the code
2. Follow the coding standards (see below)
3. Add or update tests
4. Update documentation if needed

Test Your Changes
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Run all tests
   ./test/run_tests.sh

   # Run specific tests
   ./test/run_tests.sh --filter your_script

   # Run with verbose output
   ./test/run_tests.sh --verbose

Commit Your Changes
~~~~~~~~~~~~~~~~~~~

Use clear, descriptive commit messages:

.. code-block:: bash

   git commit -m "Add feature: description of what you added"

Good commit messages:
  * ``Fix: git_url.sh fails on SSH URLs without .git extension``
  * ``Add: git_merge_latest.sh composer for merge workflows``
  * ``Update: improve error handling in git_create_repo.sh``
  * ``Docs: add examples for git_branch_rm_pair.sh``

Push and Create Pull Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   git push origin feature/your-feature-name

Then create a pull request on GitHub/GitLab with:
  * Clear title describing the change
  * Description of what was changed and why
  * Reference to related issues (``Fixes #123``)

Coding Standards
----------------

Script Structure
~~~~~~~~~~~~~~~~

All scripts should follow this structure:

.. code-block:: bash

   #!/usr/bin/env bash
   set -euo pipefail
   IFS=$'\n\t'

   #/ Usage: script_name.sh [OPTIONS] ARGS
   #/ Description: What this script does
   #/ Examples:
   #/   script_name.sh --option value
   #/ Options:
   #/   --help: Display this help message
   #/   --option: What this option does
   usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
   expr "$*" : ".*--help" > /dev/null && usage

   readonly LOG_FILE="/tmp/$(basename "$0").log"
   info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
   warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
   error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
   fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

   # Main script logic here

Naming Conventions
~~~~~~~~~~~~~~~~~~

**Wrappers**: 2-3 letter codes

* Strong preference: ``gl.sh``, ``gd.sh``
* Weak preference: ``gl_.sh``

**Composers**: ``git_snake_case.sh``

* Example: ``git_create_repo.sh``
* Example: ``git_branch_rm_pair.sh``

Bash Best Practices
~~~~~~~~~~~~~~~~~~~

**Use strict mode**:

.. code-block:: bash

   set -euo pipefail

**Quote variables**:

.. code-block:: bash

   # Good
   echo "${MY_VAR}"

   # Bad
   echo $MY_VAR

**Use readonly for constants**:

.. code-block:: bash

   readonly API_URL="https://api.github.com"

**Check for required commands**:

.. code-block:: bash

   command -v git >/dev/null 2>&1 || fatal "git is required"

Error Handling
~~~~~~~~~~~~~~

Use the logging functions:

.. code-block:: bash

   # Informational
   info "Creating repository: ${REPO_NAME}"

   # Warning (non-fatal)
   warning "No .gitignore found, creating one"

   # Error (logged but continues)
   error "Failed to push to remote"

   # Fatal (exits immediately)
   fatal "Repository name is required"

Documentation
~~~~~~~~~~~~~

**Help Text**: Every script must have help text in the header comments

**Examples**: Include usage examples in the help text

**Comments**: Add comments for complex logic, but prefer self-documenting code

Testing Requirements
--------------------

All New Scripts
~~~~~~~~~~~~~~~

Every new script must have accompanying BATS tests.

Create ``test/your_script.bats``:

.. code-block:: bash

   #!/usr/bin/env bats
   # Tests for your_script.sh

   load test_helper

   @test "your_script.sh: displays help" {
       run_bin_script "your_script.sh" --help
       assert_success
       assert_output --partial "Usage:"
   }

   @test "your_script.sh: performs main function" {
       # Setup
       local test_file="${TEST_TEMP_DIR}/test"
       echo "test" > "${test_file}"

       # Execute
       run_bin_script "your_script.sh" "${test_file}"

       # Assert
       assert_success
       assert_output --partial "expected output"
   }

Existing Scripts
~~~~~~~~~~~~~~~~

When modifying existing scripts:

1. Ensure existing tests still pass
2. Add tests for new functionality
3. Add tests for bug fixes (regression tests)

Test Coverage
~~~~~~~~~~~~~

Aim for good test coverage:

* **Happy Path**: Test normal, successful execution
* **Error Cases**: Test failure conditions
* **Edge Cases**: Test boundary conditions
* **Invalid Input**: Test with bad input

CI/CD
~~~~~

All tests must pass in CI/CD:

* **GitHub Actions**: Tests run automatically on pull requests
* **GitLab CI**: Tests run on multiple bash versions

Check the test badge on the README before submitting.

Documentation Updates
---------------------

When to Update Docs
~~~~~~~~~~~~~~~~~~~

Update documentation when:

* Adding new scripts
* Changing script behavior
* Adding new options or flags
* Fixing bugs that affect usage

What to Update
~~~~~~~~~~~~~~

* **README.md**: For major changes or new features
* **Command Reference**: Add new commands or options
* **Relevant Guides**: Update wrappers.md, composers.md, etc.
* **This Sphinx Documentation**: Update corresponding .rst files

Building Documentation
~~~~~~~~~~~~~~~~~~~~~~

After updating documentation, rebuild:

.. code-block:: bash

   cd docs
   make html
   open _build/html/index.html

Code Review Process
-------------------

All contributions go through code review:

Review Criteria
~~~~~~~~~~~~~~~

Reviewers will check for:

* **Functionality**: Does it work as intended?
* **Tests**: Are there adequate tests?
* **Code Quality**: Does it follow coding standards?
* **Documentation**: Is it properly documented?
* **Compatibility**: Does it work on Bash 4 and 5?

Addressing Feedback
~~~~~~~~~~~~~~~~~~~

1. Make requested changes
2. Push to the same branch
3. The pull request updates automatically
4. Respond to comments to show changes were made

Merging
~~~~~~~

Once approved:

* Maintainers will merge your pull request
* Your contribution will be included in the next release

Project Structure
-----------------

Understanding the Layout
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   git_tools/
   ├── bin/                    # All executable scripts
   │   ├── Wrappers            # Simple wrappers
   │   └── Composers           # Complex workflows
   ├── test/                   # BATS testing framework
   │   ├── *.bats              # Test files
   │   ├── test_helper.bash    # Test utilities
   │   ├── setup_bats.sh       # BATS installation
   │   └── run_tests.sh        # Test runner
   ├── templates/              # Git templates
   │   └── GIT_TEMPLATE_DIR/
   ├── .config/                # Configuration
   │   └── mr/                 # Myrepos config
   ├── docs/                   # Sphinx documentation
   │   ├── conf.py             # Sphinx config
   │   ├── *.rst               # Documentation files
   │   └── _build/             # Built HTML (ignored)
   ├── .github/                # GitHub Actions
   ├── .gitlab/                # GitLab templates
   ├── README.md               # Main documentation
   ├── programs.md             # Wrapper vs composer philosophy
   └── vcsh.md                 # VCSH documentation

Where to Put New Files
~~~~~~~~~~~~~~~~~~~~~~

* **Scripts**: ``bin/your_script.sh``
* **Tests**: ``test/your_script.bats``
* **Documentation**: ``docs/`` (update relevant .rst files)
* **Templates**: ``templates/`` (if adding Git templates)
* **Configuration**: ``.config/`` (if adding myrepos config)

Release Process
---------------

(For Maintainers)

Versioning follows semantic versioning:

* **Major**: Breaking changes
* **Minor**: New features
* **Patch**: Bug fixes

Getting Help
------------

If you need help contributing:

* **GitHub Issues**: Ask questions in issues
* **GitLab Issues**: Use issue templates
* **Documentation**: Read :doc:`getting-started` and :doc:`testing`

Communication Guidelines
------------------------

* **Be Respectful**: Treat all contributors with respect
* **Be Constructive**: Provide constructive feedback
* **Be Patient**: Maintainers are volunteers
* **Be Clear**: Provide clear descriptions and examples

License
-------

By contributing, you agree that your contributions will be licensed under the same license as the project.

Thank You!
----------

Thank you for contributing to Git Tools! Every contribution, no matter how small, helps make the project better.

See Also
--------

* :doc:`testing` - Testing framework documentation
* :doc:`wrappers` - Writing wrapper scripts
* :doc:`composers` - Writing composer scripts
* :doc:`getting-started` - Getting started guide

Composers
=========

Composers are complex scripts that call a series of Git commands to consolidate and automate multi-step tasks.

Philosophy
----------

Composers handle workflows that require:

* **Multiple Git Commands**: Chain several operations together
* **Conditional Logic**: Make decisions based on repository state
* **User Interaction**: Prompt for confirmation or input
* **External APIs**: Integrate with GitHub, GitLab, or other services
* **Error Handling**: Gracefully handle failures and edge cases

Naming Convention
-----------------

Composers follow the naming pattern: ``git_snake_case.sh``

Examples:
  * ``git_create_repo.sh``
  * ``git_branch_rm_pair.sh``
  * ``git_rebase_local_remote.sh``

This naming makes it clear that:
  1. The script relates to Git operations
  2. It's a multi-word, descriptive name
  3. It performs a complex task

Available Composers
-------------------

Repository Creation
~~~~~~~~~~~~~~~~~~~

git_create_repo.sh
^^^^^^^^^^^^^^^^^^

**Purpose**: Create new repositories via GitHub or GitLab API and initialize them locally

**Features**:
  * Support for both GitHub and GitLab
  * Public or private repositories
  * Organization/namespace support
  * Optional myrepos registration
  * Automatic initial commit
  * Browser integration

**Example Workflow**:

.. code-block:: bash

   # Create a private GitLab repository
   git_create_repo.sh my-awesome-project

This single command:
  1. Calls the GitLab API to create the repository
  2. Initializes a local Git repository
  3. Creates an initial commit
  4. Sets up the remote
  5. Pushes to the remote
  6. Registers with myrepos (if available)
  7. Opens the repository in your browser

See :doc:`command-reference` for all available options.

Branch Management
~~~~~~~~~~~~~~~~~

git_branch_rm_pair.sh
^^^^^^^^^^^^^^^^^^^^^

**Purpose**: Safely remove both local and remote branch pairs

**Features**:
  * Checks if branch is merged before deletion
  * Prompts for confirmation before force deletion
  * Separate confirmation for remote deletion
  * Prevents accidental data loss

**Example Workflow**:

.. code-block:: bash

   git_branch_rm_pair.sh feature-completed

Interactive flow:
  1. Attempts to delete local branch with ``-d`` flag
  2. If not merged, prompts to confirm force delete
  3. Asks for confirmation before deleting remote branch
  4. Executes ``git push origin --delete`` if confirmed

git_branch_rm_all.sh
^^^^^^^^^^^^^^^^^^^^

**Purpose**: Remove a branch from all configured remotes

**Example Workflow**:

.. code-block:: bash

   git_branch_rm_all.sh old-feature

This iterates through all remotes and removes the specified branch from each.

Remote Operations
~~~~~~~~~~~~~~~~~

git_fetch_all.sh
^^^^^^^^^^^^^^^^

**Purpose**: Fetch updates from all configured remotes

**Example Workflow**:

.. code-block:: bash

   git_fetch_all.sh

Iterates through ``git remote`` output and fetches from each remote.

git_status_all.sh
^^^^^^^^^^^^^^^^^

**Purpose**: Show comprehensive status across all remotes

**Example Workflow**:

.. code-block:: bash

   git_status_all.sh

Provides a unified view of your repository's status across all remotes.

git_push_set_upstream.sh
^^^^^^^^^^^^^^^^^^^^^^^^

**Purpose**: Push with automatic upstream tracking setup

**Example Workflow**:

.. code-block:: bash

   git_push_set_upstream.sh origin feature-branch

Combines ``git push`` with ``-u`` flag to set up tracking in one command.

Rebase Workflows
~~~~~~~~~~~~~~~~

git_rebase_local_remote.sh
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Purpose**: Automated rebase workflow for local and remote branches

**Example Workflow**:

.. code-block:: bash

   git_rebase_local_remote.sh

Handles the complete rebase process including:
  1. Fetching from remote
  2. Checking for conflicts
  3. Performing the rebase
  4. Handling errors

git_rebase_tips.sh
^^^^^^^^^^^^^^^^^^

**Purpose**: Display helpful rebasing guidance

**Example Workflow**:

.. code-block:: bash

   git_rebase_tips.sh

Shows tips and best practices for successful rebasing.

URL Management
~~~~~~~~~~~~~~

git_url.sh
^^^^^^^^^^

**Purpose**: Extract and convert repository URLs

**Example Workflow**:

.. code-block:: bash

   git_url.sh

Transforms:
  * SSH URLs (``git@git.nak.co:home/project.git``)
  * To HTTPS (``https://git.nak.co/home/project``)
  * Copies to clipboard if available

Configuration
~~~~~~~~~~~~~

git_ignore_symlinks.sh
^^^^^^^^^^^^^^^^^^^^^^

**Purpose**: Configure Git to ignore symbolic link changes

**Example Workflow**:

.. code-block:: bash

   git_ignore_symlinks.sh

Sets the appropriate Git configuration options.

Creating Your Own Composers
----------------------------

Composers follow a more complex pattern. Here's a template:

.. code-block:: bash

   #!/usr/bin/env bash
   set -euo pipefail
   IFS=$'\n\t'

   #/ Usage: ./git_my_workflow.sh [OPTIONS] ARGS
   #/ Description: What this script does
   #/ Examples: ./git_my_workflow.sh --option value
   #/ Options:
   #/   --help: Display this help message
   usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
   expr "$*" : ".*--help" > /dev/null && usage

   readonly LOG_FILE="/tmp/$(basename "$0").log"
   info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
   warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
   error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
   fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

   # Your workflow logic here
   info "Starting workflow"
   git command1
   git command2
   git command3
   info "Workflow complete"

Best Practices
--------------

1. **Use Strict Mode**: Always include ``set -euo pipefail``
2. **Provide Help**: Include usage documentation in comments
3. **Log Output**: Use info/warning/error functions for clear output
4. **Handle Errors**: Use fatal for unrecoverable errors
5. **Prompt for Dangerous Actions**: Confirm before destructive operations
6. **Make It Idempotent**: Script should be safe to run multiple times

Error Handling
~~~~~~~~~~~~~~

.. code-block:: bash

   # Check if we're in a git repository
   git rev-parse --git-dir > /dev/null 2>&1 || fatal "Not a git repository"

   # Check if branch exists
   git rev-parse --verify "$BRANCH" > /dev/null 2>&1 || fatal "Branch does not exist"

User Interaction
~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Prompt for confirmation
   warning "This will delete data. Continue?"
   select yn in "Yes" "No"; do
       case $yn in
           Yes ) break;;
           No ) exit 0;;
       esac
   done

When to Use Composers vs Wrappers
----------------------------------

Use **composers** when:
  * You need multiple Git commands
  * The workflow requires conditional logic
  * User confirmation is needed
  * You're integrating with external services
  * Error handling is critical

Use **wrappers** when:
  * You're enhancing a single Git command
  * It's just about preferred options
  * The script is very simple (1-5 lines)

See :doc:`wrappers` for information about simple command wrappers.

Testing Composers
-----------------

All composers should have corresponding BATS tests. See :doc:`testing` for details.

Example test structure:

.. code-block:: bash

   @test "git_create_repo creates repository" {
     run git_create_repo.sh --no-browser test-repo
     assert_success
     assert_dir_exists "test-repo"
   }

See Also
--------

* :doc:`command-reference` - Complete command reference
* :doc:`wrappers` - Simple command wrappers
* :doc:`testing` - Testing framework documentation

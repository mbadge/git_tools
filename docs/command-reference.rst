Command Reference
=================

This page provides a complete reference of all available commands in Git Tools.

Wrappers
--------

Simple command wrappers that enhance basic Git commands with better defaults and formatting.

Git Log Wrappers
~~~~~~~~~~~~~~~~

**gl.sh**
  Enhanced git log with better formatting (strong preference - overwrites default ``gl`` alias)

  .. code-block:: bash

     gl.sh

**gl_.sh**
  Alternative git log variant (weak preference - non-default alternative)

  .. code-block:: bash

     gl_.sh

**Gl.sh**
  Uppercase variant of git log wrapper

  .. code-block:: bash

     Gl.sh

**glv.sh**
  Git log with verbose output

  .. code-block:: bash

     glv.sh

**Glv.sh**
  Uppercase variant of verbose git log

  .. code-block:: bash

     Glv.sh

**glvv.sh**
  Git log with extra verbose output

  .. code-block:: bash

     glvv.sh

Git Diff Wrappers
~~~~~~~~~~~~~~~~~

**gd.sh**
  Enhanced git diff with preferred options

  .. code-block:: bash

     gd.sh

**Gd.sh**
  Uppercase variant of git diff wrapper

  .. code-block:: bash

     Gd.sh

**Gdc.sh**
  Git diff cached (staged changes)

  .. code-block:: bash

     Gdc.sh

Composers
---------

Complex workflow scripts that chain multiple Git commands to accomplish sophisticated tasks.

Repository Management
~~~~~~~~~~~~~~~~~~~~~

**git_create_repo.sh**
  Create GitHub/GitLab repository via API and initialize local git repo

  Usage:
    .. code-block:: bash

       git_create_repo.sh [OPTIONS] REPO_NAME

  Options:
    * ``--help`` - Display help message
    * ``--github`` - Use GitHub API (default is GitLab)
    * ``--gitlab`` - Use GitLab API (default)
    * ``--public`` - Create public repository (default is private)
    * ``--namespace NAME`` - GitLab namespace/group
    * ``--org ORG`` - GitHub organization
    * ``--in-place`` - Use current directory instead of creating new one
    * ``--no-register`` - Skip myrepos registration
    * ``--no-initial-commit`` - Skip creating initial commit
    * ``--no-browser`` - Skip opening URL in browser

  Examples:
    .. code-block:: bash

       # Create private GitLab repo
       git_create_repo.sh my-new-repo

       # Create private GitHub repo
       git_create_repo.sh --github my-new-repo

       # Create public GitLab repo
       git_create_repo.sh --public my-new-repo

       # Create in GitLab namespace
       git_create_repo.sh --gitlab --namespace libR myrepo

       # Create in GitHub organization
       git_create_repo.sh --github --org myorg myrepo

       # Use current directory
       git_create_repo.sh --in-place my-repo

**git_url.sh**
  Extract and convert repository URLs from git remote to HTTPS format

  Usage:
    .. code-block:: bash

       git_url.sh

  Description:
    Fetches the front-end URL to the current git repository. Automatically converts
    SSH URLs to HTTPS format and copies the result to clipboard (if Cp utility available).

Branch Management
~~~~~~~~~~~~~~~~~

**git_branch_rm_pair.sh**
  Remove local and remote branch pairs with confirmation

  Usage:
    .. code-block:: bash

       git_branch_rm_pair.sh BRANCH_NAME

  Examples:
    .. code-block:: bash

       git_branch_rm_pair.sh merged-feature-branch

  Description:
    Convenience function to safely remove both local and remote branches.
    Prompts for confirmation before deleting remote branches.

**git_branch_rm_all.sh**
  Remove branches from all configured remotes

  Usage:
    .. code-block:: bash

       git_branch_rm_all.sh BRANCH_NAME

  Description:
    Removes a branch from all configured remotes in the repository.

Remote Operations
~~~~~~~~~~~~~~~~~

**git_fetch_all.sh**
  Fetch from all configured remotes

  Usage:
    .. code-block:: bash

       git_fetch_all.sh

  Description:
    Fetches updates from all remotes configured in the repository.

**git_status_all.sh**
  Show git status across all configured remotes

  Usage:
    .. code-block:: bash

       git_status_all.sh

  Description:
    Displays comprehensive status information for all remotes.

**git_push_set_upstream.sh**
  Push to remote with automatic upstream tracking setup

  Usage:
    .. code-block:: bash

       git_push_set_upstream.sh [REMOTE] [BRANCH]

  Description:
    Pushes the current branch to remote and sets up upstream tracking automatically.

Rebase Workflows
~~~~~~~~~~~~~~~~

**git_rebase_local_remote.sh**
  Automated rebase workflow for local and remote branches

  Usage:
    .. code-block:: bash

       git_rebase_local_remote.sh

  Description:
    Performs a complete rebase workflow, handling both local and remote branches.

**git_rebase_tips.sh**
  Display helpful tips and best practices for rebasing

  Usage:
    .. code-block:: bash

       git_rebase_tips.sh

  Description:
    Shows guidance and tips for successful Git rebasing operations.

Configuration
~~~~~~~~~~~~~

**git_ignore_symlinks.sh**
  Configure Git to ignore symlink changes

  Usage:
    .. code-block:: bash

       git_ignore_symlinks.sh

  Description:
    Sets Git configuration to ignore symbolic link modifications.

Utility Scripts
---------------

**clone_all_lib_repos.sh**
  Clone all library repositories in bulk

  Usage:
    .. code-block:: bash

       clone_all_lib_repos.sh

  Description:
    Batch clone multiple related library repositories.

**docker_enter.sh**
  Enter a running Docker container

  Usage:
    .. code-block:: bash

       docker_enter.sh [CONTAINER_NAME]

  Description:
    Convenience script to enter a running Docker container with a bash shell.

Getting Help
------------

All scripts support the ``--help`` flag:

.. code-block:: bash

   git_create_repo.sh --help
   git_branch_rm_pair.sh --help

See Also
--------

* :doc:`wrappers` - Detailed explanation of wrapper philosophy
* :doc:`composers` - In-depth guide to composer scripts
* :doc:`getting-started` - Quick start guide

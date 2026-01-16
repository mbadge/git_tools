Getting Started
===============

Welcome to Git Tools! This guide will help you get up and running quickly.

Overview
--------

Git Tools is a suite of Bash/Shell utilities that enhance your Git workflow by providing:

* **Wrappers**: Simple command wrappers with sensible defaults
* **Composers**: Complex multi-step workflows for common Git tasks
* **API Integration**: Create repositories directly from the command line
* **Multi-Repo Management**: Handle multiple repositories with ease

Quick Start
-----------

1. **Clone the repository**:

   .. code-block:: bash

      cd ~/stow
      git clone git@git.nak.co:home/git-tools.git

2. **Install**:

   .. code-block:: bash

      cd git-tools
      make

3. **Start using**:

   .. code-block:: bash

      gl.sh  # Enhanced git log
      git_status_all.sh  # Check status across all remotes

Next Steps
----------

* Read the :doc:`installation` guide for detailed setup instructions
* Browse the :doc:`command-reference` to see all available commands
* Learn about :doc:`wrappers` and :doc:`composers`
* Set up :doc:`testing` if you want to contribute

Project Structure
-----------------

.. code-block:: text

   git_tools/
   ├── bin/              # All executable scripts
   │   ├── Wrappers      # Simple command wrappers
   │   └── Composers     # Complex workflow scripts
   ├── test/             # BATS testing framework
   ├── templates/        # Git template directory
   ├── .config/          # Configuration files
   └── docs/             # This documentation

Key Concepts
------------

Wrappers vs Composers
~~~~~~~~~~~~~~~~~~~~~

**Wrappers** are simple scripts that wrap a single Git command with enhanced functionality:

* ``gl.sh`` - Enhanced git log with better formatting
* ``gd.sh`` - Git diff with preferred options
* ``Gl.sh`` - Alternative git log variant

**Composers** are complex scripts that chain multiple Git commands together:

* ``git_create_repo.sh`` - Create repositories via GitHub/GitLab API
* ``git_branch_rm_all.sh`` - Remove branches from all remotes
* ``git_rebase_local_remote.sh`` - Automated rebase workflow

See :doc:`wrappers` and :doc:`composers` for complete details.

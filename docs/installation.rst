Installation
============

This guide covers the installation and setup of Git Tools on your system.

Prerequisites
-------------

Required Dependencies
~~~~~~~~~~~~~~~~~~~~~

* **Git** - Version control system
* **Bash** - Version 4 or 5
* **GNU Stow** - Symlink farm manager

Optional Dependencies
~~~~~~~~~~~~~~~~~~~~~

* **vcsh** - For managing bare dotfile repositories (see :doc:`vcsh`)
* **myrepos (mr)** - For managing collections of repositories
* **BATS** - For running the test suite (see :doc:`testing`)

Installation Steps
------------------

Step 1: Clone the Repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The repository should be cloned into ``~/stow/`` to enable symlink farming:

.. code-block:: bash

   cd ~/stow
   git clone git@git.nak.co:home/git-tools.git

.. note::
   This repository is designed to have symlinks farmed to your home directory.
   The ``~/stow/`` location is required for GNU Stow to work correctly.

Step 2: Farm Symlinks
~~~~~~~~~~~~~~~~~~~~~

Use the provided Makefile to create symlinks:

.. code-block:: bash

   cd ~/stow/git-tools
   make

This will:

* Create symlinks for all scripts in ``bin/`` to ``~/bin/``
* Link configuration files to appropriate locations
* Set up Git templates

Step 3: Verify Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Verify that the commands are available:

.. code-block:: bash

   which gl.sh
   # Should output: /home/yourusername/bin/gl.sh

   gl.sh --help
   # Should display help information

Configuration
-------------

Git Configuration
~~~~~~~~~~~~~~~~~

The following Git configuration files are included:

* ``.gitconfig`` - Global Git settings
* ``.gitignore`` - Global ignore patterns
* ``.gitmodules`` - Submodule configuration
* ``templates/GIT_TEMPLATE_DIR`` - Template directory for new repositories

The ``GIT_TEMPLATE_DIR`` should be exported in your shell environment
(typically in ``~/.aliases`` or ``~/.bashrc``):

.. code-block:: bash

   export GIT_TEMPLATE_DIR="$HOME/templates/GIT_TEMPLATE_DIR"

Myrepos Configuration
~~~~~~~~~~~~~~~~~~~~~

If using myrepos for multi-repository management:

* ``.mrconfig`` - Main myrepos configuration
* ``.config/mr/available.d/`` - Available repository configurations
* ``.config/mr/config.d/`` - Active repository configurations

Uninstallation
--------------

To remove the symlinks while keeping the source repository intact:

.. code-block:: bash

   cd ~/stow/git-tools
   make clean

This will remove all managed symlinks but leave the repository and your
configuration files untouched.

Complete Removal
~~~~~~~~~~~~~~~~

To completely remove Git Tools:

.. code-block:: bash

   cd ~/stow/git-tools
   make clean
   cd ..
   rm -rf git-tools

Troubleshooting
---------------

Symlink Conflicts
~~~~~~~~~~~~~~~~~

If you encounter errors about existing files during installation:

1. Check which files conflict:

   .. code-block:: bash

      stow -n git-tools

2. Back up or remove conflicting files
3. Re-run ``make``

Permission Issues
~~~~~~~~~~~~~~~~~

If scripts aren't executable:

.. code-block:: bash

   chmod +x ~/bin/*.sh

Path Issues
~~~~~~~~~~~

Ensure ``~/bin`` is in your ``PATH``:

.. code-block:: bash

   echo $PATH | grep "$HOME/bin"

If not present, add to your ``~/.bashrc`` or ``~/.zshrc``:

.. code-block:: bash

   export PATH="$HOME/bin:$PATH"

VCSH Integration
================

Git Tools integrates with VCSH (Version Control System for $HOME) for managing dotfiles and home directory configuration.

What is VCSH?
-------------

VCSH allows you to maintain multiple Git repositories in your home directory without conflicts. It's particularly useful for:

* **Dotfile Management**: Version control your configuration files
* **Multiple Repositories**: Separate concerns (shell config, vim config, git config, etc.)
* **Sparse Checkouts**: Only track specific files, not the entire home directory
* **No Conflicts**: Multiple repositories coexist without interfering

How It Works
------------

VCSH creates bare Git repositories that track files in your home directory:

.. code-block:: text

   $HOME/
   ├── .config/vcsh/repo.d/
   │   ├── dotfiles.git        # Bare repo for general dotfiles
   │   ├── vim.git             # Bare repo for vim config
   │   └── git-tools.git       # Bare repo for git tools config
   ├── .bashrc                 # Tracked by dotfiles
   ├── .vimrc                  # Tracked by vim
   └── .gitconfig              # Tracked by git-tools

Each bare repository tracks only specific files, so they don't conflict.

Installation
------------

Install VCSH
~~~~~~~~~~~~

On Debian/Ubuntu:

.. code-block:: bash

   sudo apt-get install vcsh

On macOS with Homebrew:

.. code-block:: bash

   brew install vcsh

From source:

.. code-block:: bash

   git clone https://github.com/RichiH/vcsh.git
   cd vcsh
   sudo make install

Basic Usage
-----------

Initialize a Repository
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   vcsh init dotfiles

This creates ``~/.config/vcsh/repo.d/dotfiles.git``

Enter Repository
~~~~~~~~~~~~~~~~

Enter the repository context:

.. code-block:: bash

   vcsh enter dotfiles

Now Git commands operate on the dotfiles repository.

Add Files
~~~~~~~~~

.. code-block:: bash

   vcsh dotfiles add ~/.bashrc ~/.bash_aliases
   vcsh dotfiles commit -m "Add bash configuration"

List Repositories
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   vcsh list

Clone a VCSH Repository
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   vcsh clone git@github.com:user/dotfiles.git dotfiles

Git Tools Integration
---------------------

Configuration Files
~~~~~~~~~~~~~~~~~~~

Git Tools tracks several configuration files that integrate well with VCSH:

* ``.gitconfig`` - Global Git settings
* ``.gitignore`` - Global ignore patterns
* ``.gitmodules`` - Submodule configuration
* ``.config/mr/`` - Myrepos configuration
* ``templates/GIT_TEMPLATE_DIR/`` - Git templates

Using Git Tools with VCSH
~~~~~~~~~~~~~~~~~~~~~~~~~~

You can track Git Tools configuration with VCSH:

.. code-block:: bash

   # Initialize VCSH repository for git tools
   vcsh init git-tools

   # Add git tools configuration
   vcsh git-tools add ~/.gitconfig
   vcsh git-tools add ~/.gitignore
   vcsh git-tools add ~/templates/GIT_TEMPLATE_DIR

   # Commit
   vcsh git-tools commit -m "Add git tools configuration"

   # Push to remote
   vcsh git-tools remote add origin git@github.com:user/git-tools-config.git
   vcsh git-tools push -u origin main

Myrepos Integration
-------------------

VCSH works seamlessly with myrepos (mr) for managing multiple repositories.

Setup
~~~~~

Git Tools includes myrepos configuration in ``.config/mr/``:

* ``.config/mr/available.d/`` - Available repository configurations
* ``.config/mr/config.d/`` - Active repository configurations

Configuration
~~~~~~~~~~~~~

Example ``.mrconfig`` entry for a VCSH repository:

.. code-block:: ini

   [.config/vcsh/repo.d/dotfiles.git]
   checkout = vcsh clone git@github.com:user/dotfiles.git dotfiles

Managing Multiple Repos
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Update all repositories
   mr update

   # Status of all repositories
   mr status

   # Commit changes in all repositories
   mr commit

Sparse Checkouts
----------------

VCSH inherently uses sparse checkouts, but you can make this explicit:

.. code-block:: bash

   vcsh dotfiles add ~/.bashrc
   # Only .bashrc is tracked, everything else in $HOME is ignored

This prevents accidentally tracking your entire home directory.

Best Practices
--------------

Separate Concerns
~~~~~~~~~~~~~~~~~

Create different VCSH repositories for different purposes:

* ``dotfiles`` - General shell configuration
* ``vim`` - Vim configuration
* ``emacs`` - Emacs configuration
* ``git-tools`` - Git tools and configuration

Example:

.. code-block:: bash

   vcsh init dotfiles
   vcsh init vim
   vcsh init git-tools

Use Gitignore
~~~~~~~~~~~~~

Create ``.gitignore.d/`` directory for repository-specific ignore patterns:

.. code-block:: bash

   mkdir -p ~/.config/vcsh/gitignore.d/
   echo '*' > ~/.config/vcsh/gitignore.d/dotfiles
   echo '!.bashrc' >> ~/.config/vcsh/gitignore.d/dotfiles
   echo '!.bash_aliases' >> ~/.config/vcsh/gitignore.d/dotfiles

Version Control .mrconfig
~~~~~~~~~~~~~~~~~~~~~~~~~~

Track your ``.mrconfig`` file with VCSH:

.. code-block:: bash

   vcsh dotfiles add ~/.mrconfig
   vcsh dotfiles commit -m "Add myrepos configuration"

Regular Backups
~~~~~~~~~~~~~~~

Since VCSH manages critical configuration, push regularly:

.. code-block:: bash

   vcsh dotfiles push
   vcsh vim push
   vcsh git-tools push

Or use myrepos:

.. code-block:: bash

   mr push

Known Issues
------------

Sparse Checkout Documentation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**TODO**: Document how to use ``git clone`` with sparse checkout to avoid top-level README files cluttering the home directory.

Workaround for now:

.. code-block:: bash

   # Clone without checking out
   vcsh clone git@github.com:user/dotfiles.git dotfiles --no-checkout

   # Configure sparse checkout
   vcsh dotfiles config core.sparseCheckout true

   # Specify files to checkout
   echo ".bashrc" >> ~/.config/vcsh/repo.d/dotfiles.git/info/sparse-checkout
   echo ".bash_aliases" >> ~/.config/vcsh/repo.d/dotfiles.git/info/sparse-checkout

   # Checkout
   vcsh dotfiles checkout

Advanced Usage
--------------

Hooks
~~~~~

VCSH supports Git hooks for automation:

.. code-block:: bash

   # Post-merge hook to update submodules
   cat > ~/.config/vcsh/hooks-enabled/dotfiles.post-merge << 'EOF'
   #!/bin/sh
   vcsh dotfiles submodule update --init --recursive
   EOF
   chmod +x ~/.config/vcsh/hooks-enabled/dotfiles.post-merge

Status Overview
~~~~~~~~~~~~~~~

Check status of all VCSH repositories:

.. code-block:: bash

   vcsh status

Or with myrepos:

.. code-block:: bash

   mr status

Migrating to VCSH
~~~~~~~~~~~~~~~~~

If you have existing dotfiles in a regular Git repository:

.. code-block:: bash

   # Backup existing dotfiles
   mv ~/.dotfiles ~/.dotfiles.backup

   # Initialize VCSH repository
   vcsh init dotfiles

   # Add files from backup
   vcsh dotfiles add ~/.bashrc ~/.vimrc
   vcsh dotfiles commit -m "Initial import"

   # Add remote and push
   vcsh dotfiles remote add origin git@github.com:user/dotfiles.git
   vcsh dotfiles push -u origin main

Resources
---------

* `VCSH Repository <https://github.com/RichiH/vcsh>`_
* `Myrepos Documentation <https://myrepos.branchable.com/>`_
* :doc:`installation` - Git Tools installation guide
* ``.mrconfig`` - Included in Git Tools

See Also
--------

* :doc:`installation` - Installation and configuration
* :doc:`getting-started` - Quick start guide

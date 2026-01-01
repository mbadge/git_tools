Wrappers
========

Wrappers are simple scripts that call a single Git command with preferred defaults or enhanced functionality.

Philosophy
----------

Wrappers provide two key benefits:

1. **Consistent Defaults**: Encode your preferred options so you don't have to type them repeatedly
2. **Enhanced Output**: Add formatting, colors, or additional information to standard Git output

Naming Convention
-----------------

Wrappers use a specific naming convention based on desired masking with aliases:

Strong Preferences
~~~~~~~~~~~~~~~~~~

**Format**: 2-3 letter Git alias (e.g., ``gl.sh``, ``gd.sh``)

These wrappers are intended to **overwrite** the standard Git alias. Use this when you have a strong preference for how a command should behave.

Examples:
  * ``gl.sh`` - Preferred git log format
  * ``gd.sh`` - Preferred git diff behavior

Weak Preferences
~~~~~~~~~~~~~~~~

**Format**: 2-3 letter Git alias with appended underscore (e.g., ``gl_.sh``)

These provide **non-default alternatives** alongside the standard command. Use this when you want an option but don't want to replace the default behavior.

Examples:
  * ``gl_.sh`` - Alternative git log format

Available Wrappers
------------------

Git Log Family
~~~~~~~~~~~~~~

The Git log wrappers provide various levels of verbosity and formatting:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Command
     - Description
   * - ``gl.sh``
     - Standard enhanced git log
   * - ``gl_.sh``
     - Alternative git log format
   * - ``Gl.sh``
     - Uppercase variant
   * - ``glv.sh``
     - Verbose git log
   * - ``Glv.sh``
     - Verbose uppercase variant
   * - ``glvv.sh``
     - Extra verbose git log

Example usage:

.. code-block:: bash

   # Basic enhanced log
   gl.sh

   # Alternative format
   gl_.sh

   # Extra verbose output
   glvv.sh

Git Diff Family
~~~~~~~~~~~~~~~

The Git diff wrappers provide enhanced diff viewing:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Command
     - Description
   * - ``gd.sh``
     - Enhanced git diff
   * - ``Gd.sh``
     - Uppercase variant
   * - ``Gdc.sh``
     - Git diff cached (staged changes)

Example usage:

.. code-block:: bash

   # View unstaged changes
   gd.sh

   # View staged changes
   Gdc.sh

Creating Your Own Wrappers
---------------------------

Wrappers follow a simple pattern. Here's a template:

.. code-block:: bash

   #!/usr/bin/env bash
   set -euo pipefail

   # Your preferred git command with options
   git log --oneline --graph --decorate --all

Save this in ``bin/`` with the appropriate naming convention, make it executable,
and farm the symlink using ``make``.

Best Practices
--------------

1. **Keep It Simple**: Wrappers should call exactly one Git command
2. **Document Behavior**: Add a comment explaining what makes this wrapper special
3. **Use Consistent Naming**: Follow the strong/weak preference naming convention
4. **Make It Obvious**: The wrapper name should make it clear what Git command it wraps

When to Use Wrappers vs Composers
----------------------------------

Use **wrappers** when:
  * You want to enhance a single Git command
  * You're encoding personal preferences
  * The script is 1-5 lines long

Use **composers** when:
  * You need to call multiple Git commands
  * You're automating a workflow
  * You need conditional logic or user interaction

See :doc:`composers` for information about complex workflow scripts.

See Also
--------

* :doc:`command-reference` - Complete command reference
* :doc:`composers` - Complex workflow scripts

# Git Programs

## FS Location

cli commands are stored in `bin/*.sh`

## wrappers vs composers

* **wrappers**: call a single git command with preferred defaults or enhanced functionality (e.g., continuous update)
  * e.g, `gl.sh`, `glvv.sh`, `Gl.sh`, `Glvv.sh`
  * naming based on desired masking with aliases:
    * for strong preferences - overwrite the alias for a git command (usually 2 or 3 letters)
      * `gl.sh`
    * for weak preferences - provide a "non-default" alternative: the git alias 2/3 letter code with appended "_"
      * `gl_.sh`

* **composers**: call a series of git commands to consolidate a task
  * e.g., `git_rebase_local_remote.sh`
  * naming **git_snake_case.sh**

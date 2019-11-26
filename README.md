# Git tools repository

## Objective

[**configs**](#configurations) and [**programs**](#programs) to seamlessly interface with my git repositories

## Setup

this repo is intended to have symlinks farmed to user's home directory.  As such, the repo should be cloned into a subdir of `~/stow/`:

Step 1: clone repo

```sh
cd ~/stow
git clone git@git.nak.co:home/git-tools.git
```

Step 2: farm symlinks

```sh
cd git-tools && make
```
----

Clean-up:

_remove managed symlinks_

```sh
cd ~/stow/git-tools
make clean
```

* leaves source repo intact

## Dependencies

* **git**
* **vcsh**: for managing *dot-file* repos (bare repos dispersed throughout `~/`)
* **myrepos**: for managing *collections* of repos
* GNU **stow** to farm symlinks to integrate isolated repos

----

## Configurations

### git

* `.gitconfig`
* `.gitignore`
* `.gitmodules`
* `templates/GIT_TEMPLATE_DIR`
  * exported to sh environment by `~/.aliases` (tracked by **dot-files** repo)
  * manifest: description, exclude Rproj, pre-commit hook

### mr

* `.mrconfig`  
* `.config/mr/available.d`
* `.config/mr/config.d`

----

## Programs

**Location**: cli commands are stored in `bin/*.sh`

### Types  

* **singleton** git command wrappers for preferred options
  * e.g, `gl.sh`, `glvv.sh`
* routines with **multiple** git commands
  * e.g., `git_rebase_local_remote.sh`

# Git tools repository

## Objective
**configs** and **programs** to seamlessly interface with my git repositories

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

---
**clean-up: remove managed symlinks**
leaves source repo intact
```sh
cd ~/stow/git-tools
make clean
```

## Codebase Design/Dependencies
wrappers/native configs for **git** as well as third-party git wrapper programs:   

* **vcsh**: for managing *dot-file* repos (bare repos dispersed throughout `~/`)
* **myrepos**: for managing *collections* of repos

additionally leverages GNU **stow** to integrate/activate nested repos collections


## Configurations
### git
`.gitconfig`
`.gitignore`
`.gitmodules`
`templates/GIT_TEMPLATE_DIR`
> * exported to sh environment by `~/.aliases` (tracked by **dot-files** repo)
> * manifest: description, exclude Rproj, pre-commit hook

### mr
`.mrconfig`
`.config/mr/available.d`
`.config/mr/config.d`


## Programs
`bin/*.sh`

### Classes  
* wrappers for preferred **singleton** git command implementations
	* e.g, `gl.sh`, `glvv.sh`
* routines for custom task that involves **multiple** git commands
	* e.g., `git_rebase_local_remote.sh`

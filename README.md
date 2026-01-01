# Git tools repository

[![Shell Tests](https://github.com/mbadge/git_tools/actions/workflows/test.yml/badge.svg)](https://github.com/mbadge/git_tools/actions/workflows/test.yml)

[**programs**](programs.md) and [**configs**](#configurations) to seamlessly interface with my git repositories

---

## Setup

### step 1: clone repo

```sh
cd ~/stow
git clone git@git.nak.co:home/git-tools.git
```

> This repo is intended to have symlinks farmed to user's home directory. For this to work, this project directory should be a subdirectory of `~/stow/`

### Step 2: farm symlinks

```sh
cd git-tools && make
```

## Clean-up

remove managed symlinks

```sh
cd ~/stow/git-tools
make clean
```

> leaves source repo intact

## Dependencies

* **git**
* **vcsh**: for managing bare *dot-file* repos (see [vcsh](vcsh.md))
* **myrepos**: for managing **collections** of repos
* GNU **stow** to farm symlinks

---

## Testing

Automated tests are available for the shell scripts in `bin/`. Tests run automatically on every push via GitHub Actions and GitLab CI.

### Run Tests Locally

```sh
# First time setup
./test/setup_bats.sh

# Run all tests
./test/run_tests.sh

# Run specific tests
./test/run_tests.sh --filter git_url

# Verbose output
./test/run_tests.sh --verbose
```

### CI/CD

- **GitHub Actions**: Tests run on every push and pull request
- **GitLab CI**: Tests run on multiple bash versions (4 & 5)

See [test/README.md](test/README.md) for detailed testing documentation.

---

## Configuration

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

# Git tools repository

[![Shell Tests](https://github.com/mbadge/git_tools/actions/workflows/test.yml/badge.svg)](https://github.com/mbadge/git_tools/actions/workflows/test.yml)
[![Documentation](https://github.com/mbadge/git_tools/actions/workflows/docs.yml/badge.svg)](https://github.com/mbadge/git_tools/actions/workflows/docs.yml)
[![Documentation Status](https://img.shields.io/badge/docs-sphinx-blue.svg)](https://mbadge.github.io/git_tools/)

[**programs**](programs.md) and [**configs**](#configurations) to seamlessly interface with my git repositories

📖 **[View Full Documentation](https://mbadge.github.io/git_tools/)** - Complete guide with examples, API reference, and tutorials

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

## Documentation

**📚 Full documentation is available at [mbadge.github.io/git_tools](https://mbadge.github.io/git_tools/)**

The comprehensive Sphinx documentation includes:

- **[Getting Started](https://mbadge.github.io/git_tools/getting-started.html)** - Quick introduction and setup
- **[Installation Guide](https://mbadge.github.io/git_tools/installation.html)** - Detailed installation instructions
- **[Command Reference](https://mbadge.github.io/git_tools/command-reference.html)** - Complete reference for all 21 scripts
- **[Wrappers Guide](https://mbadge.github.io/git_tools/wrappers.html)** - Simple command wrappers philosophy
- **[Composers Guide](https://mbadge.github.io/git_tools/composers.html)** - Complex workflow scripts
- **[Testing](https://mbadge.github.io/git_tools/testing.html)** - BATS testing framework documentation
- **[VCSH Integration](https://mbadge.github.io/git_tools/vcsh.html)** - Dotfile management
- **[Contributing](https://mbadge.github.io/git_tools/contributing.html)** - Development guidelines

### Building Documentation Locally

```sh
# Install dependencies
pip3 install -r docs/requirements.txt

# Build HTML documentation
cd docs && make html

# Open in browser
open _build/html/index.html  # macOS
xdg-open _build/html/index.html  # Linux
```

The documentation is automatically rebuilt and deployed on every push to the main branch via GitHub Actions.

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

# Git-Tools Project Learnings

Reference notes for future Claude sessions working on this repository.

## Project Structure

- **Stow-managed repo**: Files are symlinked to `~` via GNU Stow (`make build`)
- **bin/**: Shell scripts symlinked to `~/bin/`
- **Naming convention**: Composers use `git_snake_case.sh`, wrappers use short names like `gl.sh`

## Stow and Broken Symlinks

### Problem: Abridged command aliases
Users may create aliases without `.sh` extension (e.g., `~/bin/git_branch_rm_pair` -> `~/bin/git_branch_rm_pair.sh`). When the source script is deleted:
1. Stow removes `~/bin/git_branch_rm_pair.sh`
2. The alias `~/bin/git_branch_rm_pair` becomes a broken symlink
3. `chkstow -b` doesn't detect these (only finds symlinks pointing directly into stow dirs)

### Solution
The Makefile now includes cleanup logic after stow:
```makefile
# remove broken symlinks in ~/bin that appear to be from this repo
@find ~/bin -maxdepth 1 -xtype l 2>/dev/null | while read -r link; do \
    target=$$(readlink "$$link" 2>/dev/null); \
    name=$$(basename "$$link"); \
    if echo "$$target" | grep -qE "(git-tools|stow.*/bin)" || \
       echo "$$name" | grep -qE "^(git_|gl|gd|Gl|Gd|Gdc|clone_all|docker_enter)"; then \
        rm -f "$$link" 2>/dev/null && echo "Removed broken link: $$link" || \
        echo "Warning: cannot remove $$link (permission denied)"; \
    fi; \
done
```

## Shell Completion

### User's shell environment
- **Shell**: zsh (not bash)
- **Framework**: oh-my-zsh
- **fpath setup**: `~/.zsh_functions` is added to fpath in `.zshrc`

### Oh-my-zsh completion loading order issue
oh-my-zsh calls `compinit` BEFORE user's `.zshrc` modifications to `fpath`. This means completions in `~/.zsh_functions/` won't be discovered.

### Solution
Place zsh completions in oh-my-zsh's custom completions directory:
```
~/.oh-my-zsh/custom/completions/_git_branch_rm_all.sh
```

This directory is added to fpath by oh-my-zsh BEFORE compinit runs.

### Zsh completion file format
```zsh
#compdef git_branch_rm_all.sh

_git_branch_rm_all.sh() {
    local -a branches
    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi
    branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
    _describe 'branch' branches
}

_git_branch_rm_all.sh "$@"
```

Key points:
- File must be named `_<command-name>` (with underscore prefix)
- First line `#compdef <command>` associates it with the command
- Use `_describe` to provide completions with descriptions
- `${(f)"..."}` splits output by newlines into an array

### After adding completions
User must either:
1. Start a new terminal, or
2. Run: `rm -f ~/.zcompdump* && compinit`

## Documentation Updates

When removing/renaming scripts, update:
- `docs/command-reference.rst`
- `docs/composers.rst`
- `docs/getting-started.rst`
- `docs/testing.rst`
- `docs/contributing.rst`
- `test/README.md`
- Associated test files (`test/*.bats`)

## Testing

- Framework: BATS (Bash Automated Testing System)
- Test files: `test/*.bats`
- Run tests: `./test/run_tests.sh`
- Test helper: `test/test_helper.bash`

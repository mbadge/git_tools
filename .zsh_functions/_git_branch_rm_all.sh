#compdef git_branch_rm_all.sh
# Zsh completion for git_branch_rm_all.sh
#
# Provides tab-completion for branch names in the active repository.

_git_branch_rm_all.sh() {
    local -a branches

    # Only complete if we're in a git repository
    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi

    # Get list of local branch names
    branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})

    _describe 'branch' branches
}

_git_branch_rm_all.sh "$@"

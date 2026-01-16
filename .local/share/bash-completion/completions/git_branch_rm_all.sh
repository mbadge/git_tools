# Bash completion for git_branch_rm_all.sh
#
# Provides tab-completion for branch names in the active repository.

_git_branch_rm_all() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Only complete if we're in a git repository
    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi

    # Get list of local branch names, excluding current branch (marked with *)
    local branches
    branches=$(git branch --format='%(refname:short)' 2>/dev/null)

    COMPREPLY=($(compgen -W "${branches}" -- "${cur}"))
}

complete -F _git_branch_rm_all git_branch_rm_all.sh

0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ -z "$ZPWR_ALL_GIT_DIRS" ]]; then
    export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"
fi

if [[ -z "$ZPWR_ALL_GIT_DIRS_DIRTY" ]]; then
    export ZPWR_ALL_GIT_DIRS=_DIRTY"$HOME/.zsh-git-repo-cache-dirty"
fi

if [[ -z "$ZPWR_ALL_GIT_DIRS_CLEAN" ]]; then
    export ZPWR_ALL_GIT_DIRS_CLEAN="$HOME/.zsh-git-repo-cache-clean"
fi

if [[ -z "$ZPWR_TEMPFILE3" ]]; then
    export ZPWR_TEMPFILE3="$TMPDIR/.zsh-git-repo-temp"
fi

if [[ -z "$ZPWR_FZF" ]]; then
    export ZPWR_FZF="fzf"
fi 

if ! type -a -- zpwrExists>/dev/null 2>&1; then

        function zpwrExists(){
            #alternative is command -v
            type -a -- "$1" &>/dev/null || return 1 &&
            [[ $(type -a -- "$1" 2>/dev/null) != *"suffix alias"* ]]
        }
fi

if ! zpwrExists zpwrPrettyPrint; then
    zpwrPrettyPrint(){
        echo "$@"
    }
fi

fpath+=("${0:h}/autoload")

autoload -Uz "${0:h}/autoload/"*(.:t)

if (( ${+ZPWR_VERBS} )); then
    ZPWR_VERBS[gitreposlist]='zsh-git-repo-searchAllGitRepos n list=search $ZPWR_ALL_GIT_DIRS'
    ZPWR_VERBS[gitreposcleanlist]='zsh-git-repo-searchCleanGitRepos n list=search clean $ZPWR_ALL_GIT_DIRS_CLEAN'
    ZPWR_VERBS[gitreposdirtylist]='zsh-git-repo-searchDirtyGitRepos n list =search dirty $ZPWR_ALL_GIT_DIRS_DIRTY'
    ZPWR_VERBS[gitreposcleancachelist]='zsh-git-repo-searchCleanGitReposCache n list=search clean cached $ZPWR_ALL_GIT_DIRS_CLEAN'
    ZPWR_VERBS[gitreposdirtycachelist]='zsh-git-repo-searchDirtyGitReposCache n list=search dirty cached $ZPWR_ALL_GIT_DIRS_DIRTY'

    ZPWR_VERBS[gitrepos]='zsh-git-repo-searchAllGitRepos=search $ZPWR_ALL_GIT_DIRS in fzf'
    ZPWR_VERBS[gitreposclean]='zsh-git-repo-searchCleanGitRepos=search clean $ZPWR_ALL_GIT_DIRS_CLEAN in fzf'
    ZPWR_VERBS[gitreposdirty]='zsh-git-repo-searchDirtyGitRepos=search dirty $ZPWR_ALL_GIT_DIRS_DIRTY in fzf'
    ZPWR_VERBS[gitreposcleancache]='zsh-git-repo-searchCleanGitReposCache=search clean cached $ZPWR_ALL_GIT_DIRS_CLEAN in fzf'
    ZPWR_VERBS[gitreposdirtycache]='zsh-git-repo-searchDirtyGitReposCache=search dirty cached $ZPWR_ALL_GIT_DIRS_DIRTY in fzf'
fi

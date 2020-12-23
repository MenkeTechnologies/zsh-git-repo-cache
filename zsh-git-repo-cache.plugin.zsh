0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ -z "$ZPWR_ALL_GIT_DIRS" ]]; then
    export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"
fi

if [[ -z "$ZPWR_ALL_GIT_DIRS_DIRTY" ]]; then
    export ZPWR_ALL_GIT_DIRS=_DIRTY"$HOME/.zsh-git-repo-cache-dirty"
fi

if [[ -z "$ZPWR_TEMPFILE3" ]]; then
    export ZPWR_TEMPFILE3="$TMPDIR/.zsh-git-repo-temp"
fi

if [[ -z "$ZPWR_FZF" ]]; then
    export ZPWR_FZF="fzf"
fi 

if ! type -- zpwrExists>/dev/null 2>&1; then

        function zpwrExists(){
            #alternative is command -v
            type -- "$1" &>/dev/null || return 1 &&
            [[ $(type -- "$1" 2>/dev/null) != *"suffix alias"* ]]
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
    ZPWR_VERBS[gitrepos]='zsh-git-repo-searchAllGitRepos=search \$ZPWR_ALL_GIT_DIRS in fzf'
    ZPWR_VERBS[gitreposdirty]='zsh-git-repo-searchDirtyGitRepos=search dirty \$ZPWR_ALL_GIT_DIRS in fzf'
fi

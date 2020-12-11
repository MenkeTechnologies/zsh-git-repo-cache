0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ -z "$ZPWR_ALL_GIT_DIRS" ]]; then
    export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"
fi

if [[ -z "$ZPWR_TEMPFILE3" ]]; then
    export ZPWR_TEMPFILE3="$TMPDIR/.zsh-git-repo-temp"
fi

if [[ -z "$ZPWR_FZF" ]]; then
    export ZPWR_FZF="fzf"
fi

fpath+=("${0:h}/autoload")

autoload -Uz "${0:h}/autoload/"*(.:t)

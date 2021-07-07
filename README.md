# zsh-git-repo-cache


## Summary

This plugin searches root of filesystem at /  for all git repos and adds to cache file for searching.

## Functions

### zsh-git-repo-regenAllGitRepos
- rebuild the cache file which is at:
```sh
export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"
```
- uses fd-find if exists otherwise find to search /

### zsh-git-repo-searchAllGitRepos
- search the cache file which is at:
```sh
export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"
```


### zsh-git-repo-searchDirtyGitRepos
- search for dirty repos from the cache file which is at:
```sh
export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"

```
### zsh-git-repo-searchCleanGitRepos
- search for clean repos from the cache file which is at:
```sh
export ZPWR_ALL_GIT_DIRS="$HOME/.zsh-git-repo-cache"
```

### zsh-git-repo-searchDirtyGitReposCache
- search for dirty repos from a cache file.  Git repo cache file will also be created if does not exist.
```sh
export ZPWR_ALL_GIT_DIRS_DIRTY="$HOME/.zsh-git-repo-cache-dirty"
```

### zsh-git-repo-searchCleanGitReposCache
- search for clean repos from a cache file.  Git repo cache file will also be created if does not exist.
```sh
export ZPWR_ALL_GIT_DIRS_CLEAN="$HOME/.zsh-git-repo-cache-clean"
```

[zpwr](https://github.com/MenkeTechnologies/zpwr) verbs added are:
```sh
ZPWR_VERBS[gitreposlist]='zsh-git-repo-searchAllGitRepos n list=search \$ZPWR_ALL_GIT_DIRS'
ZPWR_VERBS[gitreposcleanlist]='zsh-git-repo-searchCleanGitRepos n list=search clean \$ZPWR_ALL_GIT_DIRS_CLEAN'
ZPWR_VERBS[gitreposdirtylist]='zsh-git-repo-searchDirtyGitRepos n list =search dirty \$ZPWR_ALL_GIT_DIRS_DIRTY'
ZPWR_VERBS[gitreposcleancachelist]='zsh-git-repo-searchCleanGitReposCache n list=search clean cached \$ZPWR_ALL_GIT_DIRS_CLEAN'
ZPWR_VERBS[gitreposdirtycachelist]='zsh-git-repo-searchDirtyGitReposCache n list=search dirty cached \$ZPWR_ALL_GIT_DIRS_DIRTY'

ZPWR_VERBS[gitrepos]='zsh-git-repo-searchAllGitRepos=search \$ZPWR_ALL_GIT_DIRS in fzf'
ZPWR_VERBS[gitreposclean]='zsh-git-repo-searchCleanGitRepos=search clean \$ZPWR_ALL_GIT_DIRS_CLEAN in fzf'
ZPWR_VERBS[gitreposdirty]='zsh-git-repo-searchDirtyGitRepos=search dirty \$ZPWR_ALL_GIT_DIRS_DIRTY in fzf'
ZPWR_VERBS[gitreposcleancache]='zsh-git-repo-searchCleanGitReposCache=search clean cached \$ZPWR_ALL_GIT_DIRS_CLEAN in fzf'
ZPWR_VERBS[gitreposdirtycache]='zsh-git-repo-searchDirtyGitReposCache=search dirty cached \$ZPWR_ALL_GIT_DIRS_DIRTY in fzf'
```

# created by MenkeTechnologies

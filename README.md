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

# created by MenkeTechnologies

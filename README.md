```
 ██████╗ ██╗████████╗    ██████╗ ███████╗██████╗  ██████╗
██╔════╝ ██║╚══██╔══╝    ██╔══██╗██╔════╝██╔══██╗██╔═══██╗
██║  ███╗██║   ██║       ██████╔╝█████╗  ██████╔╝██║   ██║
██║   ██║██║   ██║       ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║
╚██████╔╝██║   ██║       ██║  ██║███████╗██║     ╚██████╔╝
 ╚═════╝ ╚═╝   ╚═╝       ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝
       ██████╗ █████╗  ██████╗██╗  ██╗███████╗
      ██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝
      ██║     ███████║██║     ███████║█████╗
      ██║     ██╔══██║██║     ██╔══██║██╔══╝
      ╚██████╗██║  ██║╚██████╗██║  ██║███████╗
       ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
```

[![CI](https://github.com/MenkeTechnologies/zsh-git-repo-cache/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/zsh-git-repo-cache/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![zsh](https://img.shields.io/badge/zsh-plugin-cyan.svg)](https://github.com/MenkeTechnologies/zpwr)

### `[GIT REPO METADATA CACHE FOR ZSH // FAST PROMPT, FAST cd]`

> *"Sub-millisecond `git status` in the prompt, even in massive worktrees."*

> *Jack into the filesystem. Index every git repo. Know everything.*

### [`strykelang`](https://github.com/MenkeTechnologies/strykelang) &middot; [`zshrs`](https://github.com/MenkeTechnologies/zshrs) · [`MenkeTechnologiesMeta`](https://github.com/MenkeTechnologies/MenkeTechnologiesMeta) · [`zsh-git-acp`](https://github.com/MenkeTechnologies/zsh-git-acp) · [`zsh-more-completions`](https://github.com/MenkeTechnologies/zsh-more-completions) · [`zpwr`](https://github.com/MenkeTechnologies/zpwr)

---

## Table of Contents

- [\[0x00\] // SYSTEM OVERVIEW](#0x00-system-overview)
- [\[0x01\] // INSTALL](#0x01-install)
- [\[0x02\] // DATA NODES](#0x02-data-nodes)
- [\[0x03\] // FUNCTIONS](#0x03-functions)
- [\[0x04\] // ZPWR INTERFACE](#0x04-zpwr-interface)
- [\[0x05\] // SIGNAL](#0x05-signal)

---

## [0x00] // SYSTEM OVERVIEW

A zsh plugin that crawls the root filesystem `/` to locate **every git repository** on your machine and caches the results for instant retrieval. Uses `fd` when available, falls back to `find`. Integrates with [fzf](https://github.com/junegunn/fzf) for interactive selection.

```
[ SCAN ] ──> [ CACHE ] ──> [ QUERY ]
   │              │              │
  fd/find     ~/.zsh-git-   fzf / list
   @ /        repo-cache      output
```

## [0x01] // INSTALL

**Zinit:**
```zsh
zinit light MenkeTechnologies/zsh-git-repo-cache
```

**Oh-My-Zsh:**
```zsh
git clone https://github.com/MenkeTechnologies/zsh-git-repo-cache \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-git-repo-cache
```

## [0x02] // DATA NODES

| Variable | Cache File | Purpose |
|---|---|---|
| `ZPWR_ALL_GIT_DIRS` | `~/.zsh-git-repo-cache` | All repos |
| `ZPWR_ALL_GIT_DIRS_DIRTY` | `~/.zsh-git-repo-cache-dirty` | Dirty repos |
| `ZPWR_ALL_GIT_DIRS_CLEAN` | `~/.zsh-git-repo-cache-clean` | Clean repos |

## [0x03] // FUNCTIONS

### `zsh-git-repo-regenAllGitRepos`
> Scorched earth rescan. Crawls `/` and rebuilds the master cache.

### `zsh-git-repo-regenAllGitReposDirty`
> Regenerate the dirty repos cache.

### `zsh-git-repo-searchAllGitRepos`
> Query the cache. Returns all indexed repos.

### `zsh-git-repo-searchDirtyGitRepos`
> Filter for repos with uncommitted changes -- the ones that need your attention.

### `zsh-git-repo-searchCleanGitRepos`
> Filter for repos with a clean working tree.

### `zsh-git-repo-searchDirtyGitReposCache`
> Search dirty repos from a dedicated cache file. Auto-generates the cache if it doesn't exist.

### `zsh-git-repo-searchCleanGitReposCache`
> Search clean repos from a dedicated cache file. Auto-generates the cache if it doesn't exist.

## [0x04] // ZPWR INTERFACE

When running inside [zpwr](https://github.com/MenkeTechnologies/zpwr), the following verbs are jacked in:

```
VERB                      ACTION
────────────────────────  ──────────────────────────────────
gitreposlist              list all repos
gitreposcleanlist         list clean repos
gitreposdirtylist         list dirty repos
gitreposcleancachelist    list clean repos (cached)
gitreposdirtycachelist    list dirty repos (cached)
gitrepos                  search all repos in fzf
gitreposclean             search clean repos in fzf
gitreposdirty             search dirty repos in fzf
gitreposcleancache        search clean repos in fzf (cached)
gitreposdirtycache        search dirty repos in fzf (cached)
```

## [0x05] // SIGNAL

```
created by MenkeTechnologies
```

---

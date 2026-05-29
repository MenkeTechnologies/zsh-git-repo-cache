#!/usr/bin/env zunit
#{{{                    MARK:Header
##### Purpose: zsh-git-repo-cache — third-tier surface pins:
#####          - ZPWR_TEMPFILE3 falls under $TMPDIR (XDG-friendly, not /tmp hardcode)
#####          - regen fn prefers fd over find (perf path)
#####          - regen fn strips trailing /.git via perl substitution
#####          - searchGitCommon delegates to zsh-git-repo-goThere (callback contract)
#####          - every autoload file ends with `<fn> "$@"` (autoload contract)
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    pluginFile="$pluginDir/zsh-git-repo-cache.plugin.zsh"
    autoloadDir="$pluginDir/autoload"
    regenFile="$autoloadDir/zsh-git-repo-regenAllGitRepos"
    searchFile="$autoloadDir/zsh-git-repo-searchAllGitRepos"
    commonFile="$autoloadDir/zsh-git-repo-searchGitCommon"
}

@test 'ZPWR_TEMPFILE3 default resolves under $TMPDIR (not /tmp hardcode)' {
    # Pin: caller can override TMPDIR (e.g., per-user runtime dir). The
    # default MUST be `$TMPDIR/.zsh-git-repo-temp`, not `/tmp/...` —
    # otherwise sandboxed contexts (Snap, Flatpak, macOS App Sandbox) break.
    grep -qE 'ZPWR_TEMPFILE3="\$TMPDIR/' "$pluginFile"
    assert $? equals 0
}

@test 'regen fn prefers fd over find (the perf-path branch)' {
    # Pin: fd is dramatically faster than find for tree walks (8 threads
    # parallel vs single-threaded). The plugin must prefer fd, falling
    # back to find. Swapping the branches silently regresses perf.
    grep -qE 'if zpwrExists fd; then' "$regenFile"
    assert $? equals 0
}

@test 'regen fn strips trailing /.git via perl substitution' {
    # Pin: fd/find return `.../.git` directories. The cache file should
    # contain the REPO root, not the `.git` subdir. The perl substitution
    # `s@/.git$@@` strips the trailing /.git from every line.
    grep -qF "s@/.git\$@@" "$regenFile"
    assert $? equals 0
}

@test 'searchGitCommon delegates to zsh-git-repo-goThere (callback contract)' {
    # Pin: the shared search fn invokes a per-caller callback named
    # `zsh-git-repo-goThere`. Each caller defines this nested fn so the
    # common path stays generic. Removing the call would silently
    # disable the search-and-cd action.
    grep -qF 'zsh-git-repo-goThere' "$commonFile"
    assert $? equals 0
}

@test 'every autoload file ends with `<fnName> "$@"` (autoload +X contract)' {
    # Pin: zsh autoload +X mode loads the function definition AND invokes
    # it. Each file must end with a bare call passing "$@". Missing it
    # means the fn loads but never runs.
    local missing="" f stem last
    for f in "$autoloadDir"/*; do
        [[ -f "$f" ]] || continue
        stem="${f##*/}"
        last=$(grep -vE '^\s*$|^#' "$f" | tail -1)
        # Accept either `<stem> "$@"` or `<stem>` (some files invoke bare)
        [[ "$last" == "$stem \"\$@\"" || "$last" == "$stem" ]] || missing="$missing $stem"
    done
    assert "$missing" is_empty
}

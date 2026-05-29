#!/usr/bin/env zunit
#{{{                    MARK:Header
#**************************************************************
##### Purpose: fn-presence pins for zsh-git-repo-cache. The plugin
#####          exports ~10 zsh-git-repo-* fns that the cache UI calls;
#####          renames or accidental removal lands as a CI failure.
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
}

@test 'sourcing the plugin registers more than 5 zsh-git-repo-* fns' {
    local count
    count=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f | grep -cE '^zsh-git-repo-'
    ")
    local result=$([[ "$count" -ge 5 ]] && echo yes || echo "no:$count")
    assert "$result" same_as 'yes'
}

@test 'regen-all-git-repos fn is defined' {
    local out
    out=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f zsh-git-repo-regenAllGitRepos >/dev/null && echo defined
    ")
    assert "$out" same_as 'defined'
}

@test 'regen-all-dirty fn is defined' {
    local out
    out=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f zsh-git-repo-regenAllGitReposDirty >/dev/null && echo defined
    ")
    assert "$out" same_as 'defined'
}

@test 'search-all-git-repos fn is defined' {
    local out
    out=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f zsh-git-repo-searchAllGitRepos >/dev/null && echo defined
    ")
    assert "$out" same_as 'defined'
}

@test 'search-clean + search-dirty pair both defined (mirror invariant)' {
    # The plugin pairs every "all" / "clean" / "dirty" variant. If one
    # half drops, the cache UI breaks asymmetrically — pin both.
    for fn in zsh-git-repo-searchCleanGitRepos zsh-git-repo-searchDirtyGitRepos; do
        local out
        out=$(zsh -c "
            emulate zsh
            source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
            typeset -f $fn >/dev/null && echo defined
        ")
        assert "$out" same_as 'defined'
    done
}

@test 'cached-search variants both defined (Clean + Dirty)' {
    for fn in zsh-git-repo-searchCleanGitReposCache zsh-git-repo-searchDirtyGitReposCache; do
        local out
        out=$(zsh -c "
            emulate zsh
            source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
            typeset -f $fn >/dev/null && echo defined
        ")
        assert "$out" same_as 'defined'
    done
}

@test 'shared search fn zsh-git-repo-searchGitCommon is defined' {
    local out
    out=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f zsh-git-repo-searchGitCommon >/dev/null && echo defined
    ")
    assert "$out" same_as 'defined'
}

@test 'plugin sourcing is idempotent — fn count unchanged after re-source' {
    local first second
    first=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f | grep -cE '^zsh-git-repo-'
    ")
    second=$(zsh -c "
        emulate zsh
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        source '$pluginDir/zsh-git-repo-cache.plugin.zsh' 2>/dev/null
        typeset -f | grep -cE '^zsh-git-repo-'
    ")
    assert "$first" equals "$second"
}

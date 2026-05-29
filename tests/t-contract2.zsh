#!/usr/bin/env zunit
#{{{                    MARK:Header
##### Purpose: zsh-git-repo-cache second-tier contract pins.
#####          Cover env-var defaults, fpath augmentation, autoload
#####          glob, and the latent ZPWR_ALL_GIT_DIRS_DIRTY assignment
#####          bug at line 9 (intentionally pinned to current state).
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    pluginFile="$pluginDir/zsh-git-repo-cache.plugin.zsh"
}

@test 'ZPWR_ALL_GIT_DIRS defaults to $HOME/.zsh-git-repo-cache when unset' {
    local out
    out=$(unset ZPWR_ALL_GIT_DIRS; HOME=/tmp/fakehome zsh -c "
        source '$pluginFile' 2>/dev/null
        print \"\$ZPWR_ALL_GIT_DIRS\"
    ")
    assert "$out" same_as '/tmp/fakehome/.zsh-git-repo-cache'
}

@test 'ZPWR_ALL_GIT_DIRS_CLEAN defaults to $HOME/.zsh-git-repo-cache-clean' {
    local out
    out=$(unset ZPWR_ALL_GIT_DIRS_CLEAN; HOME=/tmp/fakehome zsh -c "
        source '$pluginFile' 2>/dev/null
        print \"\$ZPWR_ALL_GIT_DIRS_CLEAN\"
    ")
    assert "$out" same_as '/tmp/fakehome/.zsh-git-repo-cache-clean'
}

@test 'ZPWR_FZF defaults to plain fzf binary (overridable)' {
    # Pin: ZPWR_FZF is the fuzzy finder dispatch path. Some users
    # swap to fzf-tmux or sk; the default must be plain fzf.
    local out
    out=$(unset ZPWR_FZF; zsh -c "
        source '$pluginFile' 2>/dev/null
        print \"\$ZPWR_FZF\"
    ")
    assert "$out" same_as 'fzf'
}

@test 'ZPWR_TEMPFILE3 honors $TMPDIR (no /tmp hardcode)' {
    # Pin: portable temp-file path. $TMPDIR varies (/tmp on Linux,
    # /var/folders/... on macOS). Hardcoding would fail on macOS
    # under shell sandboxing.
    local out
    out=$(unset ZPWR_TEMPFILE3; TMPDIR=/custom/tmp zsh -c "
        source '$pluginFile' 2>/dev/null
        print \"\$ZPWR_TEMPFILE3\"
    ")
    assert "$out" same_as '/custom/tmp/.zsh-git-repo-temp'
}

@test 'BUG-PIN: ZPWR_ALL_GIT_DIRS_DIRTY block clobbers ZPWR_ALL_GIT_DIRS to literal _DIRTY-prefix' {
    # Pin (current buggy behavior at line 9 of the plugin):
    #   if [[ -z "$ZPWR_ALL_GIT_DIRS_DIRTY" ]]; then
    #       export ZPWR_ALL_GIT_DIRS=_DIRTY"$HOME/..."
    #   fi
    # Note the LHS is ZPWR_ALL_GIT_DIRS (not ZPWR_ALL_GIT_DIRS_DIRTY),
    # AND there is an unquoted `_DIRTY` literal prefix smuggled in.
    # This test pins the current behavior so the fix lands deliberately.
    local out
    out=$(unset ZPWR_ALL_GIT_DIRS ZPWR_ALL_GIT_DIRS_DIRTY; HOME=/tmp/fakehome zsh -c "
        source '$pluginFile' 2>/dev/null
        print \"\$ZPWR_ALL_GIT_DIRS\"
    ")
    # Line 5 sets ZPWR_ALL_GIT_DIRS=/tmp/fakehome/.zsh-git-repo-cache,
    # then line 9 overwrites it with _DIRTY/tmp/fakehome/.zsh-git-repo-cache-dirty.
    assert "$out" same_as '_DIRTY/tmp/fakehome/.zsh-git-repo-cache-dirty'
}

@test 'fallback zpwrExists fn is defined when caller does not provide it' {
    # Pin: zpwrExists is a zpwr-the-suite helper. The plugin defines a
    # fallback so the standalone install does not require zpwr-loaded.
    local out
    out=$(zsh -c "
        source '$pluginFile' 2>/dev/null
        typeset -f zpwrExists >/dev/null && print DEFINED
    ")
    assert "$out" same_as 'DEFINED'
}

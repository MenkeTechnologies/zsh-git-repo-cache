#!/usr/bin/env zunit
#{{{                    MARK:Header
##### Purpose: zsh-git-repo-cache — fourth-tier contracts.
#####          Pins for tempfile-driven pipeline: ZPWR_TEMPFILE3 is
#####          tee-d then perl-edited in-place then sort/uniq-d,
#####          fd-vs-find branch selection by zpwrExists, and
#####          macOS-specific System path scrubbing.
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    regenFile="$pluginDir/autoload/zsh-git-repo-regenAllGitRepos"
}

@test 'regen pipeline tees to ZPWR_TEMPFILE3 then perl-edits IN-PLACE' {
    # Pin: the rewrite chain is `tee TEMP` then `perl -i -pe ... TEMP`.
    # The `-i` is what makes the edit in place; dropping it means perl
    # writes to stdout and TEMP retains pre-edit content. Verify both.
    grep -qE 'tee "\$ZPWR_TEMPFILE3"' "$regenFile"
    local has_tee=$?
    grep -qE 'perl -i -pe' "$regenFile"
    local has_iplace=$?
    assert $(( has_tee + has_iplace )) equals 0
}

@test 'macOS System paths are scrubbed only under $ZPWR_OS_TYPE == darwin' {
    # Pin: the two System/Volumes rewrites are guarded by an OS check.
    # Running these scrubs on Linux would corrupt valid paths starting
    # with /System (some Linux distros use that prefix). Pin the guard.
    grep -qE 'if \[\[ \$ZPWR_OS_TYPE == darwin \]\]; then' "$regenFile"
    local guard=$?
    # Both System scrubs must live inside that block.
    awk '/if \[\[ \$ZPWR_OS_TYPE == darwin \]\]/,/^[[:space:]]*fi/' "$regenFile" > /tmp/grc_dwn.$$
    local sysdata sysupd
    grep -qF 'System/Volumes/Data' /tmp/grc_dwn.$$ && sysdata=0 || sysdata=1
    grep -qF 'System/Volumes/Update' /tmp/grc_dwn.$$ && sysupd=0 || sysupd=1
    rm -f /tmp/grc_dwn.$$
    assert $(( guard + sysdata + sysupd )) equals 0
}

@test 'final cache write uses sort | uniq (per-repo dedup, not per-line)' {
    # Pin: `sort TEMP | uniq > ZPWR_ALL_GIT_DIRS`. Dropping `sort`
    # leaves duplicates from sibling /System scrubs that survive only
    # by ordering. Pin the canonical sort-then-uniq form.
    grep -qE 'sort "\$ZPWR_TEMPFILE3" \| uniq > "\$ZPWR_ALL_GIT_DIRS"' "$regenFile"
    assert $? equals 0
}

@test 'fd branch selected via zpwrExists fd, find branch as fallback' {
    # Pin: the function branches on the presence of fd. Dropping the
    # zpwrExists check would always run find, losing the 8-thread
    # speedup. Pin both branch lines.
    grep -qE 'if zpwrExists fd; then' "$regenFile"
    local has_if=$?
    grep -qE 'sudo find / -name \.git -type d -prune' "$regenFile"
    local has_find=$?
    assert $(( has_if + has_find )) equals 0
}

@test 'fd invocation passes --threads=8 for parallel scan' {
    # Pin: explicit thread count keeps the scan from saturating slow
    # disks (`--threads=$nproc` would peg every core). Pin the literal
    # 8 — bumping it silently changes resource footprint.
    grep -qE -- '--threads=8' "$regenFile"
    assert $? equals 0
}

function _atuin_fzf_source -a mode -d "Atuin history for fzf as plain<US>coloured records, NUL-separated"
    set -l tmp (mktemp -d)
    atuin search --cmd-only --print0 --filter-mode $mode >$tmp/plain
    # One fish_indent pass over all commands, separated by a sentinel comment
    # line; --only-indent keeps line counts, so records can be paired back.
    gawk 'BEGIN { RS = "\0"; ORS = "" } { print $0 "\n#\036\n" }' $tmp/plain \
        | _atuin_fzf_indent >$tmp/colour
    # Pair each command with its coloured copy; on any count mismatch fall
    # back to plain text so a coloured line never fronts the wrong command.
    gawk -v colour=$tmp/colour '
        BEGIN {
            while ((getline line < colour) > 0) {
                bare = line
                gsub(/\033\[[0-9;]*m/, "", bare)
                if (bare ~ /^[ \t]*#\036$/) { c[++n] = cur; started = 0; continue }
                cur = started ? cur "\n" line : line
                started = 1
            }
            RS = "\0"; ORS = "\0"
        }
        { p[++m] = $0 }
        END { for (i = 1; i <= m; i++) print p[i] "\037" (m == n ? c[i] : p[i]) }
    ' $tmp/plain
    rm -rf $tmp
end

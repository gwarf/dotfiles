function _atuin_fzf_preview -d "Preview or layout decision for the atuin fzf picker"
    # Usage: _atuin_fzf_preview [--layout] FILE, where FILE holds the command.
    set -l layout 0
    if test "$argv[1]" = --layout
        set layout 1
        set -e argv[1]
    end
    set -l cmd (string trim -r -c \x1f < $argv[1] | string collect)

    if test $layout = 0
        printf '%s\n' $cmd | _atuin_fzf_indent
    # Only commands that do not fit on one full-width row need the pane.
    else if test (count (string split \n -- $cmd)) -gt 1
        or test (string length -- $cmd) -gt (math $FZF_COLUMNS - 4)
        echo show-preview
    else
        echo hide-preview
    end
end

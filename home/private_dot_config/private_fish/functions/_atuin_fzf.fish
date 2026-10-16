function _atuin_fzf -d "Search atuin history with fzf"
    # Enter runs the command and Tab only puts it on the prompt, like atuin's enter_accept.
    set -l out (_atuin_fzf_source global | fzf --read0 --print0 \
        --scheme=history --highlight-line --no-multi --expect=tab \
        --ansi --delimiter=\x1f --with-nth=2.. --accept-nth=1 \
        --with-shell=(status fish-path)" -c" \
        --query=(commandline) --prompt='global> ' \
        --header='alt-g global  alt-h host  alt-s session  alt-d directory  alt-w workspace  ctrl-r sort' \
        --preview='_atuin_fzf_preview {f1}' --preview-window='right,50%,wrap,hidden' \
        --bind='focus,resize:transform:_atuin_fzf_preview --layout {f1}' \
        --bind='ctrl-r:toggle-sort' \
        --bind='alt-g:reload(_atuin_fzf_source global)+change-prompt(global> )' \
        --bind='alt-h:reload(_atuin_fzf_source host)+change-prompt(host> )' \
        --bind='alt-s:reload(_atuin_fzf_source session)+change-prompt(session> )' \
        --bind='alt-d:reload(_atuin_fzf_source directory)+change-prompt(directory> )' \
        --bind='alt-w:reload(_atuin_fzf_source workspace)+change-prompt(workspace> )' \
        | string split0)

    if set -q out[2]
        commandline -r -- $out[2]
        test "$out[1]" != tab; and commandline -f execute
    end
    commandline -f repaint
end

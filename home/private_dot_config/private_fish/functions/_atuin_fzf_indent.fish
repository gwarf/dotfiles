function _atuin_fzf_indent -d "Syntax-colour fish code from stdin with the catppuccin-macchiato theme"
    # fish_indent cannot resolve the --theme= indirection in fish_color_*, and
    # the builtin ignores function-scoped vars: export real values, run the binary.
    for line in (status get-file themes/catppuccin-macchiato.theme 2>/dev/null \
            | sed -n '/^\[dark\]/,$p' | string match -r '^fish_color_\S+ \S.*')
        set -l kv (string split -m1 ' ' -- $line)
        set -fx $kv[1] (string split ' ' -- $kv[2])
    end
    command fish_indent --only-indent --ansi
end

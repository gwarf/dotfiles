function fish_should_add_to_history -d "Skip leading-space commands and literal secrets"
    # Defining this function replaces fish's own leading-space rule.
    string match -q -- ' *' $argv[1]; and return 1
    # Keep in sync with history_filter in atuin's config.toml.
    set -l patterns \
        'eyJ[A-Za-z0-9_-]{8,}\.eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}' \
        '://[^/[:space:]:@$]+:[^/[:space:]@$(]{8,}@' \
        '(^|[[:space:]"\':-])([Bb]earer|[Tt]oken|PRIVATE-TOKEN:)[[:space:]]+[A-Za-z0-9._~+/=-]{8,}[a-z0-9][A-Za-z0-9._~+/=-]{7,}' \
        '(token|token_auth|api_key|apikey|access_token|password|passwd|secret)=["\']?[A-Za-z0-9._~+/=-]{8,}[a-z0-9][A-Za-z0-9._~+/=-]{7,}' \
        '(glpat-|ghp_|gho_|ghs_|github_pat_|xox[abp]-|sk-)[A-Za-z0-9_-]{16,}' \
        'AKIA[0-9A-Z]{16}'
    for p in $patterns
        string match -rq -- $p $argv[1]; and return 1
    end
    return 0
end

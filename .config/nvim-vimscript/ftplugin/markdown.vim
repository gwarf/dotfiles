" Check spell using native spell checker
" setlocal spell

" Disable some checks related to Markdown markup
let g:ale_languagetool_options='--autoDetect --disable WORD_CONTAINS_UNDERSCORE,DASH_RULE,WHITESPACE_RULE,EN_QUOTES'

" ale settings
" https://github.com/dense-analysis/ale

" Always show status columnd
let g:ale_sign_column_always = 1

" Moving between errors/warnings with Ctrl-k/j
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Error list window
let g:ale_open_list = 1

" Customize echo message
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%code: %%s [%linter%] [%severity%]'

" Show 5 lines of errors (default: 10)
let g:ale_list_window_size = 5

" Fix files when saving
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1

let g:ale_linters = {
\   'bash': ['bashate', 'shellcheck'],
\   'markdown': ['prettier'],
\}

" XXX disabled while testing lessspace.vim
"\   '*': ['remove_trailing_lines', 'trim_whitespace'],
" XXX Don't want to remove trailing spaces in emails!
" See mail ftplugin
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'yaml': ['prettier'],
\   '*': ['remove_trailing_lines'],
\}

let g:ale_javascript_prettier_options = '--prose-wrap always --print-width 80 --tab-width 2'

let g:ale_languagetool_options='--autoDetect --disable WORD_CONTAINS_UNDERSCORE,DASH_RULE,WHITESPACE_RULE,EN_QUOTES'

" bashate: we don't want indent to be multiple of 4 spaces
let g:ale_sh_bashate_options = '-i E003'

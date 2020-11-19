" ale settings
" https://github.com/dense-analysis/ale

" Always show status column
let g:ale_sign_column_always = 1

" Use quickfix list instead of location list to not interfer with Coc
" https://github.com/dense-analysis/ale/issues/1482
" https://github.com/dense-analysis/ale/issues/1945
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" Error list window
let g:ale_open_list = 1

" Moving between errors/warnings with Ctrl-k/j
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

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
\   'python': ['flake8'],
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
\   'python': ['black', 'isort', 'trim_whitespace'],
\   '*': ['remove_trailing_lines'],
\}

let g:ale_javascript_prettier_options = '--prose-wrap always --print-width 80 --tab-width 2'

let g:ale_languagetool_options='--autoDetect --disable WORD_CONTAINS_UNDERSCORE,DASH_RULE,WHITESPACE_RULE,EN_QUOTES'

" Configure flake8 to comply with black
" https://black.readthedocs.io/en/stable/compatible_configs.html#flake8
let g:ale_python_flake8_options='--extend-ignore=E203,W503 --max-line-length=88'

" bashate: we don't want indent to be multiple of 4 spaces
let g:ale_sh_bashate_options = '-i E003'

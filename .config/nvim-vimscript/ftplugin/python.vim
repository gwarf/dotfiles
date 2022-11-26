" Python
set textwidth=79  " lines longer than 79 columns will be broken
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set smartindent

set cinwords=if,elif,else,for,while,try,except,finally,def,class
set omnifunc=pythoncomplete#Complete

" syntastic configuration
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5

" python-mode configuration
" We use syntastic for syntax checking
" :help syntastic-pymode
let g:pymode_lint_write = 0
" Override go-to.definition key shortcut to Ctrl-]
let g:pymode_rope_goto_definition_bind = "<C-]>"

" Override run current python file key shortcut to Ctrl-Shift-e
let g:pymode_run_bind = "<C-S-e>"

" Override view python doc key shortcut to Ctrl-Shift-d
let g:pymode_doc_bind = "<C-S-d>"

" vim:set ft=vim et sw=2:

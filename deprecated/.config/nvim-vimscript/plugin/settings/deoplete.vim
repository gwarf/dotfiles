" depolete: use tab/s-tab or c-n/c-p to navigate options

" Use deoplete
" Debug run :checkhealth
" let g:deoplete#enable_at_startup = 1

" Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
" let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" enmable email completeion
"call deoplete#custom#source('omni', 'functions', {
"  \ 'mail': 'mailcomplete#Complete',
"  \})

"call deoplete#custom#var('omni', 'input_patterns', {
"   \ 'mail': '\w+',
"   \})

" let g:deoplete#sources = {}
" let g:deoplete#sources.gitcommit=['github']
" let g:deoplete#keyword_patterns = {}
" let g:deoplete#keyword_patterns.gitcommit = '.+'
" let g:deoplete#omni#input_patterns = {}
" let g:deoplete#omni#input_patterns.gitcommit = '.+'

" <C-h>, <BS>: close popup and delete backword char
"inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <TAB>: completion
" inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" Taken from https://github.com/Shougo/shougo-s-github/blob/84071518e4238cc8b816cdb97ebc00c2aedda69f/vim/rc/plugins/deoplete.rc.vim
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ deoplete#manual_complete()
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~ '\s'
"endfunction

" <S-TAB>: completion back
"inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

"inoremap <expr><C-g>       deoplete#refresh()
"inoremap <expr><C-e>       deoplete#cancel_popup()
"inoremap <silent><expr><C-l>       deoplete#complete_common_string()

" <CR>: close popup and save indent
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function() abort
"  return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
"endfunction

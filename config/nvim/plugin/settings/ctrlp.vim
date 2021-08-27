" CtrlP

" Fix ctrl-p's mixed mode https://github.com/kien/ctrlp.vim/issues/556
let g:ctrlp_extensions = ['mixed']
nnoremap <c-p> :CtrlPMixed<cr>

" Speeding up CtrlP by ignoring files defined git .gitignore
" https://medium.com/a-tiny-piece-of-vim/making-ctrlp-vim-load-100x-faster-7a722fae7df6

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .g?view=graph-rest-1.0itignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'],
    \ },
  \ 'fallback': 'ag %s -l --nocolor -g ""'
  \ }

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
else
  " Use ag in CtrlP for listing files. Lightning fast and respects .g?view=graph-rest-1.0itignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 1
endif

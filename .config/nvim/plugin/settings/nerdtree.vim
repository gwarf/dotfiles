" https://github.com/scrooloose/nerdtree
" Autostart Startify and NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter *
    \ if argc() == 0 && !exists("s:std_in")
    \ | Startify
    \ | NERDTree
    \ | wincmd w
    \ | endif
" XXX ensure it's not breaking other binding
map <C-n> :NERDTreeToggle<CR>

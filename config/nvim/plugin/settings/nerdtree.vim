" Auto start nedtree and startify
" https://github.com/scrooloose/nerdtree
" autocmd vimenter * NERDTree
autocmd VimEnter *
            \   if !argc()
            \ |   Startify
            \ |   NERDTree
            \ |   wincmd w
            \ | endif
map <C-n> :NERDTreeToggle<CR>

" http://vim.wikia.com/wiki/Learn_to_use_help
" Enter to jump to the subject under the cursor
nnoremap <buffer> <CR> <C-]>
" Backspace to return from the last jump
nnoremap <buffer> <BS> <C-T>
" o to find next option
nnoremap <buffer> o /'\l\{2,\}'<CR>
" O to find previous option
nnoremap <buffer> O ?'\l\{2,\}'<CR>
" s to find next subject
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
" S to find previous subject
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

" XML

set omnifunc=xmlcomplete#CompleteTags
set tabstop=2 shiftwidth=2
"autocmd Filetype html,xml,xsl source ~/.vim/scripts/closetag.vim
autocmd BufNewFile,BufRead *.sgml,*.xsl set autoindent formatoptions=tcq2l textwidth=72 shiftwidth=2 softtabstop=2 tabstop=2 noexpandtab

" vim:set ft=vim et sw=2:

" VimWiKi
" https://github.com/vimwiki/vimwiki/issues/95

" Do not use vimwiki type globally on all .md files
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = ''
" Do not conceal links
let g:vimwiki_url_maxsave = 0

" <Leader>wt to start
" <Leader>ww to start
" ~/GoogleDrive/wiki/: work
" ~/wiki/: perso/home
let wiki_work = {}
let wiki_work.path = '~/wiki_work/'
let wiki_work.syntax = 'markdown'
let wiki_work.index = 'README'
let wiki_work.ext = '.md'

let wiki_home = {}
let wiki_home.path = '~/repos/wiki/'
let wiki_home.syntax = 'markdown'
let wiki_home.index = 'README'
let wiki_home.ext = '.md'

let g:vimwiki_list = [wiki_work, wiki_home]

" Keep using Tab for completion
:nmap <Leader>wn <Plug>VimwikiNextLink
:nmap <Leader>wp <Plug>VimwikiPrevLink

" Setup to write mails with vim

" Enable spell checks using native spell checker
" setlocal spell
" No indentation when copying
set nocopyindent

" Automatic line wrap
" max line length
set textwidth=72
" :help fo-table
set formatoptions=nawrjtcq
" set fo=tcqnaw
set comments+=n:\|  " '|' is a quote char.
set comments+=n:% " '%' as well.

" Disable LessSpace for emails
let g:lessspace_enabled = 0

" Disable automatic indent for emails
let b:sleuth_automatic = 0

" vim-mail
" https://github.com/dbeniamine/vim-mail/
" Do not add custom keymaps
" XXX some are nice to move inside the file
let g:VimMailDoNotMap=1
let g:VimMailDoNotFold=1
" let g:VimMailSpellLangs=['en_gb', 'fr']
" Remove quoted signature is killing mine due to flow automatic formatting
"let g:VimMailStartFlags={'reply' :"boir" }
let g:VimMailStartFlags={
    \'blank': 'TAi',
    \'nosubject': 'SAi',
    \'default' : 'bOi'}
let g:VimMailContactsProvider=['khard']
" Use mu
" let g:VimMailContactsCommands={'mu' :
"         \{ 'query' : "mu cfind",

"             \'sync': "mu index",
"             \'config': {
"                 \'default': {
"                     \'home': '$HOME/.mu',
"                     \'maildir': '$HOME/Mail',
"                 \}
"             \}
"         \}
"     \}

" XXX Don't want to remove trailing spaces in emails!
" XXX disabled while testing lessspace.vim
" let g:ale_fix_on_save = 0
" let g:ale_languagetool_options='--autoDetect --disable WORD_CONTAINS_UNDERSCORE,DASH_RULE,FRENCH_WITHESPACE'

" Hide ALE error list window
let g:ale_open_list = 0

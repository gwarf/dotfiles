"" ============================================================================
""   ~/.vim/mail
""   Cedric Duval
"" ============================================================================

" Setup to write mails with vim
" To use with Mutt, just put this line your ~/.vimrc :
"   autocmd BufRead /tmp/mutt*      :source ~/.vim/mail

"" ----------------------------------------------------------------------------
""   Automatic line wrap
"" ----------------------------------------------------------------------------

set textwidth=72  " max line length
" :help fo-table
set formatoptions=nawrjtcq
set comments+=n:\|  " '|' is a quote char.
set comments+=n:% " '%' as well.

set omnifunc=mailcomplete#Complete

" * <F1> to re-format the current paragraph correctly
" * <F2> to format a line which is too long, and go to the next line
" * <F3> to merge the previous line with the current one, with a correct
"        formatting (sometimes useful associated with <F2>)
"
" These keys might be used both in command mode and edit mode.
"
" <F1> might be smarter to use with the Mail_Del_Empty_Quoted() function
" defined below

nmap  <F1>  gqap
nmap  <F2>  gqqj
nmap  <F3>  kgqj
map!  <F1>  <ESC>gqapi
map!  <F2>  <ESC>gqqji
map!  <F3>  <ESC>kgqji

"" ----------------------------------------------------------------------------
""   Suppressing quoted signature(s) if any when replying
"" ----------------------------------------------------------------------------

" Thanks to Luc Hermitte for the original function
" (http://hermitte.free.fr/vim/ressources/vimfiles/ftplugin/mail/Mail_Sig_set_vim.html)
" Thanks to Loïc Minier and Martin Treusch von Buttlar who pointed out an
" issue with the user's own sig.

function! Mail_Erase_Sig_old()
  let i = line('$')
  let j = i
  " search for the signature pattern (takes into account signature delimiters
  " from broken mailers that forget the space after the two dashes)
  while ((i > 0) && (getline(i) !~ '^> *-- \=$'))
    if (getline(i) =~ '^-- $')
      " this is my own sig. please don't delete it!
      let j = i - 1
    endif
    let i = i - 1
  endwhile

  " if found, then
  if (i != 0)
    " search for the last non empty (non sig) line
    while ((i > 0) && (getline(i - 1) =~ '^\(>\s*\)*$'))
      let i = i - 1
    endwhile
    " and delete those lines plus the signature
    exe ':'.i.','.j.'d'
  endif
endfunction

" this new version handles cases where there are several signatures
" (sometimes added by mailing list software)
function! Mail_Erase_Sig()
  " search for the signature pattern (takes into account signature delimiters
  " from broken mailers that forget the space after the two dashes)
  let i = 0
  while ((i <= line('$')) && (getline(i) !~ '^> *-- \=$'))
    let i = i + 1
  endwhile

  " if found, then
  if (i != line('$') + 1)
    " first, look for our own signature, to avoid deleting it
    let j = i
    while (j < line('$') && (getline(j + 1) !~ '^-- $'))
      let j = j + 1
    endwhile

    " second, search for the last non empty (non sig) line
    while ((i > 0) && (getline(i - 1) =~ '^\(>\s*\)*$'))
      let i = i - 1
    endwhile

    " third, delete those lines plus the signature
    exe ':'.i.','.j.'d'
  endif
endfunction

"" ----------------------------------------------------------------------------
""   Replacing empty quoted lines (e.g. "> $") with empty lines
""   (convenient to automatically reformat one paragraph)
"" ----------------------------------------------------------------------------

function! Mail_Del_Empty_Quoted()
  "exe "normal :%s/^>[[:space:]\%\|\#>]\\+$//e\<CR>"
  exe "normal :%s/^>[[:space:]\%\|\#>]\*$//e\<CR>"
endfunction

"" ----------------------------------------------------------------------------
""   Moving the cursor at the begining of the mail
"" ----------------------------------------------------------------------------

function! Mail_Begining()
  exe "normal gg"
  if getline (line ('.')) =~ '^From: '
    " if we use edit_headers in Mutt, then go after the headers
    exe "normal /^$\<CR>"
  endif
endfunction

"" ----------------------------------------------------------------------------
""
""   Initialization
""
"" ----------------------------------------------------------------------------

call Mail_Erase_Sig()
call Mail_Del_Empty_Quoted()
call Mail_Begining()

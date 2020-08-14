" XXX disabled as it breaks mostly all spell checks
" Disable spell for capital-staring and camelcase words
" https://stackoverflow.com/questions/18196399/exclude-capitalized-words-from-vim-spell-check
" fun! IgnoreCamelCaseSpell()
"   syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell transparent
"   syn cluster Spell add=myExCapitalWords
"   syn match CamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
"   syn cluster Spell add=CamelCase
" endfun
" autocmd BufRead,BufNewFile * :call IgnoreCamelCaseSpell()

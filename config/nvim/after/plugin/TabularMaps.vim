if !exists(':Tabularize')
  finish " Tabular.vim wasn't loaded
endif

" Make line wrapping possible by resetting the 'cpo' option, first saving it
let s:save_cpo = &cpo
set cpo&vim

AddTabularPattern! puppet_params /=>

AddTabularPattern! assignment /[|&+*/%<>=!~-]\@<!\([<>!=]=\|=\~\)\@![|&+*/%<>=!~-]*=/l1r1

AddTabularPattern! two_spaces / /l0

AddTabularPipeline! multiple_spaces / / map(a:lines, "substitute(v:val, ' *', ' ', 'g')") | tabular#TabularizeStrings(a:lines, ' ', 'l0')

AddTabularPipeline! argument_list /(.*)/ map(a:lines, 'substitute(v:val, ''\s*\([(,)]\)\s*'', ''\1'', ''g'')')
  \ | tabular#TabularizeStrings(a:lines, '[(,)]', 'l0')
  \ | map(a:lines, 'substitute(v:val, ''\(\s*\),'', '',\1 '', "g")')
  \ | map(a:lines, 'substitute(v:val, ''\s*)'', ")", "g")')

" Restore the saved value of 'cpo'
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim et sw=2:

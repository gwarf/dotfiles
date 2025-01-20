" Java
set omnifunc=javacomplete#Complete completefunc=javacomplete#CompleteParamsInfo
autocmd BufNewfile,BufRead *.java,*.jsp, set autoindent noexpandtab tabstop=4 shiftwidth=4
let java_highlight_java_lang_ids=1
let java_highlight_functions="style"
let java_highlight_debug=1
let java_mark_braces_in_parens_as_errors=1
let java_highlight_all=1
let java_highlight_debug=1
let java_ignore_javadoc=1
let java_highlight_java_lang_ids=1
let java_highlight_functions="style"
let java_minlines = 150
let java_comment_strings=1
let java_highlight_java_lang_ids=1
"Java anonymous classes. Sometimes, you have to use them.
set cinoptions+=j1

" vim:set ft=vim et sw=2:

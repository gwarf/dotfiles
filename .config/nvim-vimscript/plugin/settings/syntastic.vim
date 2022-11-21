" Syntastic
" https://github.com/scrooloose/syntastic

" Always populate location list with errors
let g:syntastic_always_populate_loc_list = 1
" Automatically close error window when no errors are left
let g:syntastic_auto_loc_list = 1
" Jump to the first error detected
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

"let g:syntastic_puppet_puppetlint_quiet_messages = { "regex": "line has more than 80 characters" }
"let g:syntastic_puppet_puppetlint_args = "--no-class_inherits_from_params_class-check"

" Use virtualenv for installing/conifugring python stuff
"let g:syntastic_python_python_exec = '/usr/bin/python2'
"let g:syntastic_python_flake8_exec = 'flake8-python2'
" https://github.com/liamcurry/py3kwarn
" https://docs.python.org/3/whatsnew/3.0.html
" https://docs.python.org/2.6/library/2to3.html#fixers
" To be installed using pip in python venv used by neovim
let g:syntastic_python_checkers=['flake8']
"let g:syntastic_python_checkers=['flake8', 'py3kwarn']
let g:syntastic_rst_checkers = ['rstcheck']
let g:syntastic_yaml_checkers = ['yamllint']

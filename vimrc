" ~/.vimrc
"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

filetype off " required for vundle setup

call plug#begin('~/.vim/plugged')

" SuperTab
" Plug 'ervandew/supertab'
" Snippets
"Plug 'SirVer/ultisnips'
" Completion
"Plug 'Valloric/YouCompleteMe'
if has('nvim')
  Plug 'Shougo/deoplete.nvim'
else
  Plug 'Shougo/neocomplete'
endif
" Theme
" Colorscheme
if has('nvim')
  Plug 'lifepillar/vim-solarized8'
else
  Plug 'altercation/vim-colors-solarized'
endif
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
" Airline statusbar
Plug 'bling/vim-airline'
" CheckAttach
Plug 'chrisbra/CheckAttach'
" Ctrl-P for quick file/buffer access
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
" Notes taking
" Plug 'fmoralesc/vim-pad'
Plug 'vimoutliner/vimoutliner'
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-after'
"Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'dhruvasagar/vim-table-mode'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-shell'
" Plug 'jceb/vim-orgmode'
" Tabular alignement
Plug 'godlygeek/tabular'
" Snippets for UltiSnipps
Plug 'honza/vim-snippets'
" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Preview registers
" Seems to break tabular and completion
"Plug 'junegunn/vim-peekaboo'
" Puppet-related stuff
Plug 'mv/mv-vim-puppet'
" Ansible support
Plug 'pearofducks/ansible-vim'
" Markdown support
Plug 'plasticboy/vim-markdown'
"Plug 'tpope/vim-markdown'
"Plug 'gabrielelana/vim-markdown'
" SilverSearcy plugin
Plug 'rking/ag.vim'
" Syntax validation
Plug 'scrooloose/syntastic'
" git integration
Plug 'tpope/vim-fugitive'
" gitk for Vim.
Plug 'gregsexton/gitv', {'on': ['Gitv']}
" Sensible default settings
Plug 'tpope/vim-repeat'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'tpope/vim-speeddating'
" Easy change of surrounding stuff (tags, quotes...)
Plug 'tpope/vim-surround'
" Hilight utf8-related trolls
Plug 'vim-utils/vim-troll-stopper'
Plug 'vim-scripts/utl.vim'
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-scripts/taglist.vim'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
"Plug 'vim-scripts/AutoClose'
Plug 'vim-scripts/spec.vim'
Plug 'Konfekt/FastFold'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mattn/calendar-vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'vimperator/vimperator.vim'
Plug 'vimwiki/vimwiki'
Plug 'fmoralesc/vim-tutor-mode'
Plug 'tmux-plugins/vim-tmux'
Plug 'mrtazz/simplenote.vim'
Plug 'dag/vim-fish'
Plug 'neomutt/neomutt.vim'

" All of your Plugins must be added before the following line
call plug#end()

if !has('nvim')
  " Required to allow to override sensible.vim configuration
  runtime plugin/sensible.vim
endif

" Theme
if has('nvim')
  colorscheme solarized8_dark
else
  colorscheme solarized
  set background=dark
endif

" Create new window below current one.
set splitbelow

" Show line number
set number relativenumber

" draw a vertical line
if v:version >= 703
set colorcolumn=80
endif

" Enable modelines
set modeline

" use tab for expansion in menus
set wildchar=<TAB>

" Competion mode for wildchar in menus
set wildmode=list:longest,full

" Search
set ignorecase
" No ignorecase if pattern contains Uppercase char
set smartcase
" highlight all matches
set hlsearch

" Default indentation: 2 space
set expandtab
set shiftwidth=2    " taille de l'indentation.
set tabstop=2       " Taille des tabulations

"set mouse-=a
"set mouse=

" Highlight problematic whitespace
set list
set listchars=tab:>.,trail:.,extends:\#,nbsp:.

" Use F10 to toggle paste mode
set pastetoggle=<F10>

" Do not unload buffers on abandon (opening a new file un current buffer)
" Use Ctrl-o to switch back to location save in jumplist
set hidden

" Backup configuration
silent execute '!mkdir -p $HOME/.vimbackup'
silent execute '!mkdir -p $HOME/.vimswap'
silent execute '!mkdir -p $HOME/.vimviews'
set backup  " Bacup modified files
set backupdir=$HOME/.vimbackup
set backupskip=/tmp/*,/private/tmp/*
set writebackup

" Swap file configuration
set swapfile
set directory=$HOME/.vimswap

let mapleader=","

" Keys

" Use :w!! to write to a read only file by calling sudo
cmap w!! %!sudo tee > /dev/null %

" Use Ctrl-a to access begining of line in command mode
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" Use jk instead of ESC for leaving insert mode
inoremap jk <ESC>

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Monaco\ 12
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

""""""""""""""""""""""""""""""
" *-(specific|related) options
""""""""""""""""""""""""""""""

" Mail edition for mutt
" :help fo-table
" autocmd BufEnter /tmp/mutt* so ~/.vim/mutt.colors
autocmd BufEnter,BufNewFile,BufRead ~/tmp/mutt* set spell spelllang=en,fr complete+=kspell noci ft=mail et fo=tcqnaw

""""""""""""""""""
" Custom functions
""""""""""""""""""

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
function! s:CursorOldPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
    exe "normal g`\""
  endif
endfunction
autocmd BufReadPost * silent! call s:CursorOldPosition()

"""""""""""""""""""""""
" Plugins configuration
"""""""""""""""""""""""

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline_line_fonts = 1
" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

" CtrlP
" Fix ctrl-p's mixed mode https://github.com/kien/ctrlp.vim/issues/556
let g:ctrlp_extensions = ['mixed']
nnoremap <c-p> :CtrlPMixed<cr>

" fzf
nnoremap <c-p> :FZF<cr>
let g:fzf_action = {
  \ 'ctrl-m': 'e',
  \ 'ctrl-t': 'tabedit',
  \ 'alt-j':  'botright split',
  \ 'alt-k':  'topleft split',
  \ 'alt-h':  'vertical topleft split',
  \ 'alt-l':  'vertical botright split' }

" Syntastic
" https://github.com/scrooloose/syntastic
" Always populate location list with errors
"let g:syntastic_always_populate_loc_list = 1
" Automatically close error window
"let g:syntastic_auto_loc_list = 2
" Jump to the first error detected
"let g:syntastic_auto_jump = 2
"let g:syntastic_check_on_open = 0
"let g:syntastic_puppet_puppetlint_quiet_messages = { "regex": "line has more than 80 characters" }
"let g:syntastic_puppet_puppetlint_args = "--no-class_inherits_from_params_class-check"

" Let's code with python 2
" Use virtualenv for installing/conifugring python stuff
"let g:syntastic_python_python_exec = '/usr/bin/python2'
"let g:syntastic_python_flake8_exec = 'flake8-python2'
" https://github.com/liamcurry/py3kwarn
" https://docs.python.org/3/whatsnew/3.0.html
" https://docs.python.org/2.6/library/2to3.html#fixers
"let g:syntastic_python_checkers=['flake8']
"let g:syntastic_python_checkers=['flake8', 'py3kwarn']

" The Silver Searcher
" http://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap K :Ag! "\b<C-R><C-W>\b"<CR>:cw<CR>
" The Silver Searcher Ag
" e    to open file and close the quickfix window
" o    to open (same as enter)
" go   to preview file (open but maintain focus on ag.vim results)
" t    to open in new tab
" T    to open in new tab silently
" h    to open in horizontal split
" H    to open in horizontal split silently
" v    to open in vertical split
" gv   to open in vertical split silently
" q    to close the quickfix window

" bind \ (backward slash) to grep shortcut
"command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" UltiSnips
let g:snips_author_email='baptiste.grenier@egi.eu'
let g:snips_email='baptiste.grenier@egi.eu'
"let g:snips_author_email='baptiste@bapt.name'
let g:snips_author='Baptiste Grenier'
let g:snips_author_initials='BG'
let g:snips_company='EGI Foundation'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" Custom snippets
let g:UltiSnipsSnippetsDir        = '~/.vim/UltiSnips/'

" No more user tab/s-tab with youcompleteme to allow to use tab for UltiSnips
"let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']

" Working
" Not using <tab> with https://github.com/Valloric/YouCompleteMe.
" YouCompleteMe: use tab/s-tab or c-n/c-p to navigate options
" UltiSnips: use c-j to trigger snippet
"let g:UltiSnipsExpandTrigger       ="<c-j>"

" Goal
" YouCompleteMe: use tab/s-tab or c-n/c-p to navigate options
" UltiSnips: use tab to trigger snippet
"let g:UltiSnipsExpandTrigger       ="<tab>"

"function! g:UltiSnips_Complete()
"    call UltiSnips#ExpandSnippet()
"    if g:ulti_expand_res == 0
"        if pumvisible()
"            return "\<C-n>"
"        else
"            call UltiSnips#JumpForwards()
"            if g:ulti_jump_forwards_res == 0
"               return "\<TAB>"
"            endif
"        endif
"    endif
"    return ""
"endfunction
"
""au BufEnter,BufRead,BufNewFile,Buf * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"let g:UltiSnipsJumpForwardTrigger="<cr>"
"let g:UltiSnipsListSnippets="<c-e>"
"" this mapping Enter key to <C-y> to chose the current highlight item
"" and close the selection list, same as other IDEs.
"" CONFLICT with some plugins like tpope/Endwise
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

let g:ycm_collect_identifiers_from_tags_files = 1

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'

if has('nvim')
  let g:deoplete#enable_at_startup = 1
else
  let g:neocomplete#enable_at_startup = 1
endif

" better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Notes using vim-pad
let g:pad#dir = "~/GoogleDrive/notes"
"let g:pad#local_dir = "notes"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Notes using vim-notes
let g:notes_directories = ["~/notes"]
let g:notes_suffix = '.txt'
"let g:notes_suffix = '.md'
"let g:notes_smart_quotes = 0

" Use ranger
let g:checkattach_filebrowser = 'ranger'
let g:checkattach_once = 'y'

" Said required to fix editorconfig with Fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

source ~/.simplenoterc

" Fix arrow keys with 256 color term
set t_ku=OA
set t_kd=OB
set t_kr=OC
set t_kl=OD

" Use hjkl-movement between rows when soft wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Some useful abreviations

:iab brb Best regards,<enter>Baptiste
:iab cb Cheers,<enter>Baptiste

" vimWiki
" No folder suppor, 'path_html': '~/public_html/'t
"let g:vimwiki_list = [{'path': '~/GoogleDrive/wiki/'}]

" https://github.com/tpope/vim-sensible/pull/127
let g:is_posix=1

" vim:set ft=vim et sw=2:

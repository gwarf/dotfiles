" ~/.vimrc
" XXX Move to dein to replace vim-plug?
" https://github.com/Shougo/dein.vim
"
" https://github.com/junegunn/vim-plug
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
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/denite.nvim'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
" Theme
" Colorscheme
if has('nvim')
  Plug 'lifepillar/vim-solarized8'
else
  Plug 'altercation/vim-colors-solarized'
endif
" one colorscheme
" Plug 'rakr/vim-one'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
" Airline statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" CheckAttach
Plug 'chrisbra/CheckAttach'
" Ctrl-P for quick file/buffer access
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
" Notes taking
" Plug 'fmoralesc/vim-pad'
Plug 'vimoutliner/vimoutliner'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-after'
" Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'dhruvasagar/vim-table-mode'
" XXX disabled, evaluating to vimwiki
" Plug 'xolox/vim-notes'
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
" Should come after tabular
Plug 'plasticboy/vim-markdown'
" Instant markdown preview
" Plug 'suan/vim-instant-markdown'
"Plug 'tpope/vim-markdown'
"Plug 'gabrielelana/vim-markdown'
" SilverSearch plugin
Plug 'rking/ag.vim'
" Syntax validation
Plug 'scrooloose/syntastic'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
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
Plug 'tpope/vim-unimpaired'
" Hilight utf8-related trolls
Plug 'vim-utils/vim-troll-stopper'
Plug 'vim-scripts/utl.vim'
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-scripts/taglist.vim'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'vim-scripts/AutoClose'
Plug 'vim-scripts/spec.vim'
Plug 'Konfekt/FastFold'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mattn/calendar-vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'vimperator/vimperator.vim'
Plug 'vimwiki/vimwiki'
Plug 'teranex/vimwiki-tasks'
Plug 'fmoralesc/vim-tutor-mode'
Plug 'tmux-plugins/vim-tmux'
Plug 'mrtazz/simplenote.vim'
Plug 'w0rp/ale'
Plug 'dag/vim-fish'
Plug 'neomutt/neomutt.vim'
Plug 'blindFS/vim-taskwarrior'
Plug 'reedes/vim-litecorrect'
Plug 'mbbill/undotree'
" Could break airline bar if no proper font is configured
" Works with nerd fonts
" brew tap caskroom/fonts
" brew install font-hack-nerd-font
" or font-meslo-nerd-font font-sourcecodepro-nerd-font
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Fancy start screen
Plug 'mhinz/vim-startify'
" Display available commands
" https://github.com/hecal3/vim-leader-guide
Plug 'hecal3/vim-leader-guide'
" Buffers list in the command bar
Plug 'bling/vim-bufferline'

" All of your Plugins must be added before the following line
call plug#end()

if !has('nvim')
  " Required to allow to override sensible.vim configuration
  runtime plugin/sensible.vim
endif

" Theme
set background=dark
if has('nvim')
  " Use true colors
  " https://www.cyfyifanchen.com/neovim-true-color/
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  "set termguicolors
  let g:solarized_use16 = 1
  colorscheme solarized8_flat
  " colorscheme one
else
  colorscheme solarized
endif

if !has('nvim')
  " For devicons on vim
  set encoding=UTF-8
endif

" Pyenv with neovim on Mac OS X
" https://github.com/tweekmonster/nvim-python-doctor/wiki/Advanced:-Using-pyenv
let g:python_host_prog = '/Users/baptistegrenier/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/baptistegrenier/.pyenv/versions/neovim3/bin/python'

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
" if (empty($TMUX))
"   if (has("nvim"))
"   "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"   endif
"   "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"   "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"   " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"   if (has("termguicolors"))
"     set termguicolors
"   endif
" endif

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

" Test Leader key customization
" let mapleader=","
let mapleader=" "
map <Space> <Leader>
nnoremap <Leader>x i
set showcmd

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

" Auto start nedtree and startify
" https://github.com/scrooloose/nerdtree
" autocmd vimenter * NERDTree
autocmd VimEnter *
            \   if !argc()
            \ |   Startify
            \ |   NERDTree
            \ |   wincmd w
            \ | endif
map <C-n> :NERDTreeToggle<CR>

" vim-airline
let g:airline_theme='ravenpower'
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
let g:syntastic_always_populate_loc_list = 1
" Automatically close error window when no errors are left
let g:syntastic_auto_loc_list = 1
" Jump to the first error detected
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
"let g:syntastic_puppet_puppetlint_quiet_messages = { "regex": "line has more than 80 characters" }
"let g:syntastic_puppet_puppetlint_args = "--no-class_inherits_from_params_class-check"

" Let's code with python 2
" Use virtualenv for installing/conifugring python stuff
"let g:syntastic_python_python_exec = '/usr/bin/python2'
"let g:syntastic_python_flake8_exec = 'flake8-python2'
" https://github.com/liamcurry/py3kwarn
" https://docs.python.org/3/whatsnew/3.0.html
" https://docs.python.org/2.6/library/2to3.html#fixers
let g:syntastic_python_checkers=['flake8']
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

" Use deoplete
let g:deoplete#enable_at_startup = 1

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
" https://peterodding.com/code/vim/notes
let g:notes_directories = ["~/GoogleDrive/notes"]
let g:notes_suffix = '.txt'
"let g:notes_suffix = '.md'
" Disabling text substitutions (Like quotes)
let g:notes_smart_quotes = 0
" Disabling unicode characters for bullets, arrows..)
" let g:notes_unicode_enabled = 0
" Do not hide code block marks
let g:notes_conceal_code = 0
" Do not hide URL schemes
let g:notes_conceal_url = 0

" Use ranger
let g:checkattach_filebrowser = 'ranger'
let g:checkattach_once = 'y'

" Said required to fix editorconfig with Fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Vertical diff
set diffopt+=vertical

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

" https://github.com/tpope/vim-sensible/pull/127
let g:is_posix=1

" vim-taskwarrior
nnoremap <leader>t :tabnew <bar> :TW<CR>

" Autocorrect in text and markdown files

augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END
" Force the top-ranked correction on the first misspelled word before the
" cursor.
nnoremap <C-s> [s1z=<c-o>
inoremap <C-s> <c-g>u<Esc>[s1z=`]A<c-g>u

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

" Keep using TAb for completion
:nmap <Leader>wn <Plug>VimwikiNextLink
:nmap <Leader>wp <Plug>VimwikiPrevLink

" Toggle undotree panel
nnoremap <F5> :UndotreeToggle<cr>
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

" vim-markdown
" Disable folding
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2

" vim:set ft=vim et sw=2:

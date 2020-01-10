" ~/.vimrc
" XXX Move to dein to replace vim-plug?
" https://github.com/Shougo/dein.vim
"
" https://github.com/junegunn/vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

filetype off " required for vundle setup

call plug#begin('~/.config/nvim/plugged')

" SuperTab
" Plug 'ervandew/supertab'
" Completion
if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/denite.nvim'
  " Possible replacement for deoplete
  " https://github.com/neoclide/coc.nvim
  " Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
"Plug 'SevereOverfl0w/deoplete-github'
"
" Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Theme
" Colorscheme
if has('nvim')
  Plug 'lifepillar/vim-solarized8'
else
  Plug 'altercation/vim-colors-solarized'
endif

" Colorscheme
Plug 'arcticicestudio/nord-vim'
" Plug 'rakr/vim-one'
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'morhetz/gruvbox'

" Airline statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Could break airline bar if no proper font is configured
" Works with nerd fonts
" brew tap caskroom/fonts
" brew install font-hack-nerd-font
" or font-meslo-nerd-font font-sourcecodepro-nerd-font
Plug 'ryanoasis/vim-devicons'

" Buffers list in the command bar
Plug 'bling/vim-bufferline'

" Snippets
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

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
Plug 'robertbasic/vim-hugo-helper'
" Plug 'jceb/vim-orgmode'

" Tabular alignement
Plug 'godlygeek/tabular'

" Clean spaces at EOL
Plug 'thirtythreeforty/lessspace.vim'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Fuzzy finding + clap
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'liuchengxu/vim-clap'
" SilverSearch plugin
Plug 'rking/ag.vim'

" Preview registers
" Seems to break tabular and completion
"Plug 'junegunn/vim-peekaboo'

" Languages' support
Plug 'sheerun/vim-polyglot'
" Plug 'pearofducks/ansible-vim'
" Plug 'mv/mv-vim-puppet'
" Plug 'PotatoesMaster/i3-vim-syntax'
" Plug 'mechatroner/rainbow_csv'
" Plug 'cespare/vim-toml'
" Plug 'tmux-plugins/vim-tmux'
" Markdown support should come after tabular
" Plug 'plasticboy/vim-markdown'
" Instant markdown preview
" Plug 'suan/vim-instant-markdown'
"Plug 'tpope/vim-markdown'
"Plug 'gabrielelana/vim-markdown'

" Syntax validation
" Plug 'scrooloose/syntastic'
Plug 'dense-analysis/ale'

" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" gitk for Vim.
Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'mattn/gist-vim'

" Sensible default settings
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
" Automatic indentation autoconfiguration
Plug 'tpope/vim-sleuth'

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
" Conflicts with some mappint for coc.nvim
"Plug 'vim-scripts/AutoClose'
" Seems OK
" Plug 'Raimondi/delimitMate'
Plug 'cohama/lexima.vim'
Plug 'vim-scripts/spec.vim'
Plug 'Konfekt/FastFold'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mattn/calendar-vim'
Plug 'vimperator/vimperator.vim'
Plug 'vimwiki/vimwiki'
Plug 'teranex/vimwiki-tasks'
Plug 'fmoralesc/vim-tutor-mode'
"Plug 'mrtazz/simplenote.vim'
Plug 'dag/vim-fish'
" Plug 'blindFS/vim-taskwarrior'
Plug 'reedes/vim-litecorrect'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Fancy start screen
Plug 'mhinz/vim-startify'

" Save sessions
Plug 'tpope/vim-obsession'

" Zoom windows using <C-w>-m instead of <c-w>-|, <c-w>-_, and <c-w>-=
Plug 'dhruvasagar/vim-zoom'

" Mail support
" mu integration when editing emails in mutt
Plug 'dbeniamine/vim-mail'
Plug 'neomutt/neomutt.vim'
Plug 'chrisbra/CheckAttach'

" All of your Plugins must be added before the following line
call plug#end()

if !has('nvim')
  " Required to allow to override sensible.vim configuration
  runtime plugin/sensible.vim
endif

" Use true colors
if (has('termguicolors'))
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set t_8f=[38;2;%lu;%lu;%lum
  set t_8b=[48;2;%lu;%lu;%lum
  set termguicolors
endif
if has('nvim')
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Theme
set background=dark

let g:nord_italic=1
let g:nord_italic_comments=1
let g:nord_underline=1
let g:nord_cursor_line_number_background=0
colorscheme nord
" colorscheme one
" Works nicely with Nord palette
" colorscheme gruvbox
" if has('nvim')
  " let g:solarized_use16 = 1
  " colorscheme solarized8
" else
  " colorscheme solarized
" endif

" Use a specific colorscheme for vimdiff
" if &diff
"   colorscheme evening
" endif

" Highlight current line
set cursorline

if !has('nvim')
  " For devicons on vim
  set encoding=UTF-8
endif

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " Pyenv with neovim on Mac OS X
    " https://github.com/tweekmonster/nvim-python-doctor/wiki/Advanced:-Using-pyenv
    let g:python_host_prog = '/home/baptiste/.pyenv/versions/neovim2/bin/python'
    let g:python3_host_prog = '/home/baptiste/.pyenv/versions/neovim3/bin/python'
    " ruby version
    let g:ruby_host_prog = 'rvm ruby-2.6.0@neovim do neovim-ruby-host'
   " else
   "   let g:powerline_pycmd = "py3"
  endif
endif

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
" Disable mouse support
set mouse=

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

" Leader key customization
let mapleader=" "
map <Space> <Leader>
" Leader for mappings local to a buffer
" could be useful to have per-file-type keys like
" In a ~/.vim/after/ftplugin/{file extension}.vim
" nnoremap <buffer> <silent> <LocalLeader>b :update|make
" , is by default for backward seach on line
let g:maplocalleader = ','
" \ is safer but less convenient
"let g:maplocalleader = '\'

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

" Set spell language
set spelllang=en,fr
" Enable completion of spell
set complete+=kspell

" Mail edition for mutt
" :help fo-table
autocmd BufEnter,BufNewFile,BufRead ~/tmp/mutt* set spell noci ft=mail et fo=tcqnaw

" Spelling for markdown and ReStructuredText
" XXX testing using ftplugin for this
" autocmd FileType markdown,rst set spell spelllang=en,fr complete+=kspell

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
" let g:airline_theme='ravenpower'
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
" nnoremap \ :Ag<SPACE>

" UltiSnips
let g:snips_author_email='baptiste.grenier@egi.eu'
let g:snips_email='baptiste.grenier@egi.eu'
"let g:snips_author_email='baptiste@bapt.name'
let g:snips_author='Baptiste Grenier'
let g:snips_author_initials='BG'
let g:snips_company='EGI Foundation'

" depolete: use tab/s-tab or c-n/c-p to navigate options

" Use deoplete
" Debug run :checkhealth
" let g:deoplete#enable_at_startup = 1

" Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
" let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" enmable email completeion
"call deoplete#custom#source('omni', 'functions', {
"  \ 'mail': 'mailcomplete#Complete',
"  \})

"call deoplete#custom#var('omni', 'input_patterns', {
"   \ 'mail': '\w+',
"   \})

" let g:deoplete#sources = {}
" let g:deoplete#sources.gitcommit=['github']
" let g:deoplete#keyword_patterns = {}
" let g:deoplete#keyword_patterns.gitcommit = '.+'
" let g:deoplete#omni#input_patterns = {}
" let g:deoplete#omni#input_patterns.gitcommit = '.+'

" <C-h>, <BS>: close popup and delete backword char
"inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <TAB>: completion
" inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" Taken from https://github.com/Shougo/shougo-s-github/blob/84071518e4238cc8b816cdb97ebc00c2aedda69f/vim/rc/plugins/deoplete.rc.vim
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ deoplete#manual_complete()
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~ '\s'
"endfunction

" <S-TAB>: completion back
"inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

"inoremap <expr><C-g>       deoplete#refresh()
"inoremap <expr><C-e>       deoplete#cancel_popup()
"inoremap <silent><expr><C-l>       deoplete#complete_common_string()

" <CR>: close popup and save indent
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function() abort
"  return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
"endfunction

" ale
" Not only run linters named in ale_linters settings.
let g:ale_linters_explicit = 0
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
" Show 5 lines of errors (default: 10)
let g:ale_list_window_size = 5

let g:ale_linters = {
\   'bash': ['bashate'],
\}

" XXX disabled while testing lessspace.vim
"\   '*': ['remove_trailing_lines', 'trim_whitespace'],
" XXX Don't want to remove trailing spaces in emails!
" See mail ftplugin
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'yaml': ['prettier'],
\   '*': ['remove_trailing_lines'],
\}

" coc.nvim
" https://github.com/neoclide/coc.nvim

" Better display for messages
set cmdheight=2

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" end of coc.nvim config

" Notes using vim-pad
let g:pad#dir = "~/GoogleDrive/notes"
"let g:pad#local_dir = "notes"

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

" source ~/.simplenoterc

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

" Some useful abbreviations

:iab brb Best regards,<enter>Baptiste
:iab cb Cheers,<enter>Baptiste
" XXX find a better abbreviation
:iab cl ---------8<--------8<-------------8<------------8<------------8<----------

" https://github.com/tpope/vim-sensible/pull/127
let g:is_posix=1

" vim-taskwarrior
" nnoremap <leader>t :tabnew <bar> :TW<CR>

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

" Keep using Tab for completion
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

" Complete emails address in every files
set completefunc=vimmail#contacts#CompleteAddr

" vim:set ft=vim et sw=2:

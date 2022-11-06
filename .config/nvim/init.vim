" ~/.vimrc

" Interesting readings
" About text objects: https://yanpritzker.com/learn-to-speak-vim-verbs-nouns-and-modifiers-d7bfed1f6b2d

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

" Snippets
" "Editing snippets for current filetype
" :CocCommand snippets.editSnippets
" XXX Replaced by https://github.com/neoclide/coc-snippets
"Plug 'Shougo/neosnippet'
"Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

" Colorscheme
Plug 'dracula/vim', { 'as': 'dracula' }

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

" Line numbering
Plug 'jeffkreeftmeijer/vim-numbertoggle'

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

" Tabular alignment
Plug 'godlygeek/tabular'

" Clean spaces at EOL for lines that are edited
Plug 'thirtythreeforty/lessspace.vim'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Fuzzy finding + clap
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'liuchengxu/vim-clap'
" SilverSearch plugin
Plug 'rking/ag.vim'

" Fuzzy finder for files/buffers and so on
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" Preview registers
" Seems to break tabular and completion
"Plug 'junegunn/vim-peekaboo'

" File types' support
Plug 'sheerun/vim-polyglot'
Plug 'darfink/vim-plist'
Plug 'zdharma-continuum/zinit-vim-syntax'
" Plug 'pearofducks/ansible-vim'
" Plug 'mv/mv-vim-puppet'
" Plug 'PotatoesMaster/i3-vim-syntax'
" Plug 'mechatroner/rainbow_csv'
" Plug 'cespare/vim-toml'
" Plug 'tmux-plugins/vim-tmux'
Plug 'Yggdroot/indentLine'

" Grammar/language checking
" https://www.vimfromscratch.com/articles/spell-and-grammar-vim/
" If LanguageTool is installed, ALE will use it for text, md and mails
" https://github.com/dense-analysis/ale/blob/36e5337e30095afb10d02ef2ae362c8d6055e70d/doc/ale.txt#L2215
" XXX write-good to be checked
" https://github.com/btford/write-good
" LanguageTool-based solutions
" https://github.com/rhysd/vim-grammarous
" https://github.com/vigoux/LanguageTool.nvim
" https://github.com/dpelle/vim-LanguageTool

" Load locally available config files
" For per-project settings
Plug 'embear/vim-localvimrc'

" Syntax validation
" Plug 'scrooloose/syntastic'
Plug 'dense-analysis/ale'

" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" git commit browser
Plug 'junegunn/gv.vim'
Plug 'mattn/gist-vim'

" Enable repeating in supported plugin maps using "."
Plug 'tpope/vim-repeat'

" Sensible default settings
Plug 'tpope/vim-sensible'

" Automatic indentation autoconfiguration
Plug 'tpope/vim-sleuth'

" Correctly increment/decrement dates/times
Plug 'tpope/vim-speeddating'

" Easy change of surrounding stuff (tags, quotes...)
" sa: sandwich add + text object + text
" saw`: surround word with `
" sd: sandwich delete
" sdt: delete surrounding tag
" sr: sandwich replace
" sr_`: replace _ by `
Plug 'machakann/vim-sandwich'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Hilight utf8-related trolls
Plug 'vim-utils/vim-troll-stopper'
Plug 'vim-scripts/utl.vim'
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-scripts/taglist.vim'
Plug 'mattn/webapi-vim'
" Conflicts with some mappings for coc.nvim
"Plug 'vim-scripts/AutoClose'
" Seems OK
" Plug 'Raimondi/delimitMate'
Plug 'cohama/lexima.vim'
Plug 'vim-scripts/spec.vim'
Plug 'Konfekt/FastFold'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mattn/calendar-vim'
Plug 'vimperator/vimperator.vim'
" Plug 'vimwiki/vimwiki'
" Plug 'teranex/vimwiki-tasks'
Plug 'fmoralesc/vim-tutor-mode'
"Plug 'mrtazz/simplenote.vim'
Plug 'dag/vim-fish'
" Plug 'blindFS/vim-taskwarrior'
Plug 'reedes/vim-litecorrect'
Plug 'mbbill/undotree'
" NERDTree (navigation) menu
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'nathanaelkane/vim-indent-guides'

" Fancy start screen
Plug 'mhinz/vim-startify'

" Browsing RFC
" depends on nokogiri
" rvm ruby-2.7.0@neovim do gem install nokogiri
" FIXME index file is empty (not downloaded?)
Plug 'mhinz/vim-rfc'

" Save sessions
Plug 'tpope/vim-obsession'

" Zoom windows using <C-w>-m instead of <c-w>-|, <c-w>-_, and <c-w>-=
Plug 'dhruvasagar/vim-zoom'

" Easy movements
" https://github.com/easymotion/vim-easymotion
Plug 'easymotion/vim-easymotion'

" Mail support
" mu integration when editing emails in mutt
Plug 'dbeniamine/vim-mail'
Plug 'neomutt/neomutt.vim'
" Doesn't work with my Mac setup
" Plug 'chrisbra/CheckAttach'

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

" Use a specific colorscheme for vimdiff
" if &diff
"   colorscheme industry
" else
colorscheme dracula
" endif

" Highlight current line
set cursorline

if !has('nvim')
  " For devicons on vim
  set encoding=UTF-8
endif

if has("unix")
  " ruby integration via a rvm virualenv and gemset
  " rvm install 2.7.0
  " rvm ruby-2.7.0 do rvm gemset create neovim
  " rvm ruby-2.7.0@neovim do gem install neovim
  let g:ruby_host_prog = 'rvm ruby-2.7.0@neovim do neovim-ruby-host'
  " Pyenv with neovim
  " https://gist.github.com/gwarf/42a0a13ff2bf32a0e79d347e43831cae
  let g:python_host_prog = $HOME . '/.virtualenvs/neovim2/bin/python'
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'
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

" Use W to write a file as root using sudo
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" Alternate: Use :w!! to write to a read only file by calling sudo
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
set spelllang=en_gb,fr
" Enable completion of spell
set complete+=kspell

" Mail edition for mutt
autocmd BufEnter,BufNewFile,BufRead ~/tmp/mutt* set ft=mail
autocmd BufEnter,BufNewFile,BufRead ~/tmp/neomutt* set ft=mail

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

" Vertical diff
set diffopt+=vertical

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

" https://github.com/tpope/vim-sensible/pull/127
let g:is_posix=1

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

" Toggle undotree panel
nnoremap <F5> :UndotreeToggle<cr>
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

" vim-markdown (from vim-polyglot)
" Disable folding
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
" Disable concealing
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" Folding with markers
set foldmethod=marker
nnoremap <space> za

" Complete emails address in every files
set completefunc=vimmail#contacts#CompleteAddr

" Don't mess with whitespaces in those files
let g:lessspace_blacklist = ['diff']

" localvimrc
" Store and restore all decisions.
let g:localvimrc_persistent = 2

" https://github.com/Yggdroot/LeaderF
let g:Lf_ShortcutF = "<leader>ff"
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1

" vim:set ft=vim et sw=2:

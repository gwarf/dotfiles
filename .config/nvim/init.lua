-- https://github.com/jdhao/nvim-config
-- https://github.com/LunarVim/LunarVim/
-- https://github.com/wbthomason/dotfiles/blob/main/dot_config/nvim/init.lua

local g = vim.g
local keymap = vim.keymap
local opt = vim.opt

-- Missing
-- * Word completion from words in all buffers
-- * Syntax checking
-- * Automatic linting/formatting using prettier
-- * spell check using ltex, allowing to add exception to a custom file
-- * Y to copy a full line
-- * mutt setup
-- * which-key to give hints on keys
-- * Mason install all LSP + linterss, like pylint
-- * Autoindent when adding new lines/codes: ie. use {"wasa/asas", ... }
-- * Fix bootstrap

-- Speed up startup
local i_installed, impatient = pcall(require, "impatient")
if i_installed then
  -- See results with :LuaCacheProfile
  impatient.enable_profile()
end

-- Use rcarriga/nvim-notify as default notification manager
local n_installed, notify = pcall(require, "notify")
if n_installed then
  vim.notify = notify
end

-- Set some globals settings {{{

-- Skip some remote provider loading
g.loaded_python3_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Enable highlighting for lua, Python and Ruby HERE doc inside script
g.vimsyn_embed = "lPr"

-- Use English as main language
vim.cmd("language en_GB.UTF-8")
-- }}}

-- Set default options {{{
-- Sensible defaults settings: https://github.com/tpope/vim-sensible
-- Check value of an option:
-- :verbose set showcmd?

-- swap
opt.swapfile = true
opt.directory = vim.fn.expand("~/.local/share/nvim/swapfile")

-- backup
opt.backup = true
opt.writebackup = true
opt.backupdir = vim.fn.expand("~/.local/share/nvim/backup")
opt.backupskip = { "/tmp/*" }

-- Do not unload buffers on abandon (opening a new file un current buffer)
-- Use Ctrl-o to switch back to location save in jumplist
opt.hidden = true

-- completion
opt.completeopt = "menu,menuone,noselect"

-- Disable mouse
opt.mouse = ""

-- Highlight current line
opt.cursorline = true
opt.colorcolumn = "80"

-- Default indentation: 2 spaces
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- For devicons on vim
opt.encoding = "UTF-8"

-- Show line number
opt.number = true
opt.relativenumber = true

-- Create new window below current one.
opt.splitbelow = true
opt.splitright = true

-- Highlight problematic whitespace
opt.list = true
opt.listchars = {
  tab = ">.",
  trail = ".",
  extends = "#",
  nbsp = ".",
}

-- Search configuration
opt.ignorecase = true

-- Undo management
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/share/nvim/undodir")

-- Folding with markers
opt.foldmethod = "marker"

-- Theme
opt.termguicolors = true
opt.background = "dark"
-- }}}

-- Key mappings {{{
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
-- Custom mapping <leader> (see `:h mapleader` for more info)
-- keymap.set("", "<Space>", "<Nop>", opts)
g.mapleader = " "
g.maplocalleader = " "
-- Use jk as ESC for leaving insert mode
keymap.set("i", "jk", "<Esc>")
-- Turn the word under cursor to upper case
keymap.set("i", "<c-u>", "<Esc>viwUea")
-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")
-- Go to the beginning and end of current line in insert mode
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")
-- Go to beginning and ebd of of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")
keymap.set("c", "<C-E>", "<END>")
-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>", opts)
keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
-- Better terminal navigation
keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
-- }}}

-- Bootstrap packer and install plugins
require("plugins")

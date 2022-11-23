-- https://github.com/jdhao/nvim-config
-- https://github.com/LunarVim/LunarVim/
-- https://github.com/wbthomason/dotfiles/blob/main/dot_config/nvim/init.lua
-- https://git.vigoux.giize.com/nvim-config/blob/master/lua/plugins.lua
-- https://github.com/devinschulz/dotfiles/tree/master/nvim
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/nanotee/nvim-lua-guide
-- Requirements
-- GNU/Linux: xsel

local api = vim.api
local g = vim.g
local keymap = vim.keymap
local opt = vim.opt

-- Missing {{{
-- * Word completion from words in all buffers
-- * spell check using ltex, allowing to add exception to a custom file
-- * Lookg for possibly duplicated keymaps
-- * mutt/mail setup:
--   * https://opensource.com/article/20/1/vim-email-calendar
--   * https://github.com/soywod/himalaya
--   * https://git.sr.ht/~soywod/himalaya-vim
-- * Test Neorg: https://github.com/nvim-neorg/neorg
-- * Fix rainbow brackets
-- }}}

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
opt.smartindent = true
opt.autoindent = true

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

-- spell - used by ltex-ls too
opt.spelllang = { "en", "fr" }
opt.spellfile = table.concat(api.nvim_get_runtime_file("spell/*.add", true) or {}, ",")
opt.spelloptions = { "noplainbuffer" }

-- Search configuration
opt.ignorecase = true

-- Undo management
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/share/nvim/undodir")

-- Folding with markers
opt.foldmethod = "marker"
opt.foldcolumn = "1"
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

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

-- Autocommand that update file type for ansible files
-- vim.cmd([[
--   augroup set_ansible_ft
--     autocmd!
--     autocmd BufRead,BufNewFile *.yml, *.yaml if search('ansible\.\|roles:\|hosts:\|tasks:', 'nw') | set ft=yaml.ansible | endif
--   augroup end
-- ]])
local set_as_ansible = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_lines = api.nvim_buf_get_lines(bufnr, 0, -1, true)
  for _, buffer_line in pairs(buffer_lines) do
    if string.find(buffer_line, "ansible%..+:") then
      opt.filetype = "yaml.ansible"
    end
  end
end
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yaml", "*.yml" },
  callback = function()
    set_as_ansible()
  end,
})

-- Bootstrap packer and install plugins
require("plugins")

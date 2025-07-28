-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- Enable backups
opt.backup = true
opt.backupdir = vim.fn.stdpath('state') .. '/backup/'
opt.writebackup = true
opt.swapfile = true

-- Using ufo provider: need a large value
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

-- Default indentation: 2 spaces
-- XXX: not needed?
-- opt.softtabstop = 2

-- Indentation management
opt.autoindent = false
-- Indent wrapped lines to match line start
-- opt.breakindent = true
-- Fix indentation of new comments
-- opt.cinkeys:remove({ "0#" })

-- Wrap long lines
opt.wrap = true

-- Set max line length and display column to show line length
opt.textwidth = 78
opt.colorcolumn = "80"

-- Disable mouse
opt.mouse = ""

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable python, perl, ruby and node support
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- XXX: was used when enabling python3 provider and using venvs
-- vim.g.python3_host_prog = "/Users/baptiste/.pyenv/versions/neovim/bin/python3"
-- vim.g.python_host_prog = "/Users/baptiste/.pyenv/versions/neovim/bin/python"

-- Use basedpyright instead of old pyright
-- vim.g.lazyvim_python_lsp = "basedpyright"

-- Use a global statusline
vim.g.laststatus = 3

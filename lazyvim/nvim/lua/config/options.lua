-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

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

-- Set max line length and display column to show light length
opt.textwidth = 90
opt.colorcolumn = "90"

-- Disable mouse
opt.mouse = ""

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable python, perl, ruby and node support
-- XXX: re-enabled for testing semshi, cf https://github.com/numirias/semshi/issues/74
-- vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Use a global statusline
vim.g.laststatus = 3

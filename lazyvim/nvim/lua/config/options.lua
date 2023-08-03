-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

-- Default indentation: 2 spaces
opt.softtabstop = 2
-- XXX breaking indentation of new comments
-- https://unix.stackexchange.com/a/543571
-- opt.smartindent = false
opt.autoindent = false
-- Indent wrapped lines to match line start
-- opt.breakindent = true
-- Fix indentation of new comments
-- opt.cinkeys:remove({ "0#" })

-- Wrap long lines
opt.wrap = true

-- Set max line length
opt.textwidth = 90

-- Display column to show light length
opt.colorcolumn = "90"

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

-- Use a global statusline
vim.g.laststatus = 3

-- Quicker timeout for mappings, to speed up showing which-key menu
opt.timeoutlen = 300

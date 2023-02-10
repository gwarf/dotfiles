-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- Default indentation: 2 spaces
opt.softtabstop = 2
-- XXX breaking indentation of new comments
-- https://unix.stackexchange.com/a/543571
opt.smartindent = false
opt.autoindent = false
-- Indent wrapped lines to match line start
opt.breakindent = true
-- Fix indentation of new comments
opt.cinkeys:remove({ "0#" })

-- Wrap long lines
opt.wrap = true

-- Set max line length
opt.textwidth = 90

-- Display column to show light length
opt.colorcolumn = "80"

-- Disable mouse
opt.mouse = ""

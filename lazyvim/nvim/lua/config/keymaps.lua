-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

-- Move to window using the arrow keys
keymap.set("n", "<left>", "<C-w>h")
keymap.set("n", "<down>", "<C-w>j")
keymap.set("n", "<up>", "<C-w>k")
keymap.set("n", "<right>", "<C-w>l")

-- Go to beginning and end of of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")
keymap.set("c", "<C-E>", "<END>")

-- Commenting is done using https://github.com/echasnovski/mini.comment
-- use gc in normal/visual mode
-- use gcc to toggle current line

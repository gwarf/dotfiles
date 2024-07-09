-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

-- wrap but no spell check in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Show LSP diagnostic on hover
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

-- Set yaml.ansible filetype when we are in an ansible role
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*{group,host}_vars/*.{yaml,yml}",
    "{playbook*,site,requirements}.{yaml,yml}",
    "*{roles,tasks,handlers}/*.{yaml,yml}",
    "ansible*/*.{yaml,yml}",
  },
  command = "setlocal filetype=yaml.ansible",
})
-- TODO: add an autocommand setting filetypes for jinja template
-- like *.rb.j2 => 'setlocal filetype=ruby'
-- See https://github.com/pearofducks/ansible-vim/blob/master/ftdetect/ansible.vim

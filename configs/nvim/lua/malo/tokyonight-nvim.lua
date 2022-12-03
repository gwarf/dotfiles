local utils = require'malo.utils'

-- tokyonight.nvim
-- https://github.com/folke/tokyonight.nvim
vim.cmd 'packadd tokyonight.nvim'
vim.cmd([[colorscheme tokyonight]])
-- https://github.com/nvim-lualine/lualine.nvim
vim.cmd 'packadd lualine.nvim'
require("lualine").setup({
  options = { theme = "tokyonight" },
})

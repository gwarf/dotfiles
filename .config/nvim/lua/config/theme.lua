-- For dracula theme
-- require("dracula").setup({
--   -- show the '~' characters after the end of buffers
--   show_end_of_buffer = true, -- default false
--   -- set italic comment
--   italic_comment = false, -- default false
-- })
require("lualine").setup({
  options = { theme = "tokyonight" },
})
vim.cmd([[colorscheme tokyonight]])

-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/ui.lua
return {
  -- Alternative themes
  -- { "shaunsingh/oxocarbon.nvim" },
  -- { "habamax/vim-habamax" },
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "rose-pine/neovim", name = "rose-pine" },
  -- { "drewtempelmeyer/palenight.vim" },
  -- treesitter-aware fork of dracula theme
  -- { "Mofiqul/dracula.nvim" },
  -- { "bluz71/vim-nightfly-colors" },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },

  {
    "akinsho/bufferline.nvim",
    opts = {
      -- options = {
      --   mode = "tabs",
      -- },
    },
  },

  -- Override LazyVim configuration to select colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "moonfly",
      colorscheme = "nightfly",
      -- colorscheme = "dracula",
      -- colorscheme = "catppuccin-frappe",
      -- colorscheme = function()
      --   ---@diagnostic disable-next-line: missing-fields
      --   require("tokyonight").load({ style = "moon" })
      -- end,
    },
  },

  -- style windows with different colorschemes
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    opts = {
      themes = {
        -- markdown = { colorscheme = "dracula" },
        help = { colorscheme = "catppuccin-frappe" },
        -- noice = { colorscheme = "catppuccin-frappe" },
      },
    },
  },

  -- floating winbar
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    version = false,
    config = function()
      local colors = require("tokyonight.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = "#FC56B1", guifg = colors.black },
            InclineNormalNC = { guifg = "#FC56B1", guibg = colors.black },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          ---@diagnostic disable-next-line: no-unknown
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          ---@diagnostic disable-next-line: no-unknown
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- scrollbar
  -- {
  --   "petertriho/nvim-scrollbar",
  --   event = "BufReadPost",
  --   config = function()
  --     local scrollbar = require("scrollbar")
  --     local colors = require("tokyonight.colors").setup()
  --     scrollbar.setup({
  --       handle = { color = colors.bg_highlight },
  --       excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
  --       marks = {
  --         Search = { color = colors.orange },
  --         Error = { color = colors.error },
  --         Warn = { color = colors.warning },
  --         Info = { color = colors.info },
  --         Hint = { color = colors.hint },
  --         Misc = { color = colors.purple },
  --       },
  --     })
  --   end,
  -- },

  -- dims inactive portions of the code
  -- { "folke/twilight.nvim" },

  { "HiPhish/rainbow-delimiters.nvim" },
}

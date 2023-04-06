-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/ui.lua
return {
  -- Install treesitter-aware fork of dracula theme
  { "Mofiqul/dracula.nvim" },
  { "shaunsingh/oxocarbon.nvim" },
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "rose-pine/neovim", name = "rose-pine" },
  -- { "drewtempelmeyer/palenight.vim" },
  {
    "tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        sidebars = {
          "qf",
          "vista_kind",
          "terminal",
          "spectre_panel",
          "startuptime",
          "Outline",
        },
        dim_inactive = true,
        -- When `true`, section headers in the lualine theme will be bold
        lualine_bold = true,
        ---@param hl Highlights
        ---@param c ColorScheme
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.LineNr = { bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          -- XXX: disabled to test vanilla configuration
          -- local prompt = "#2d3149"
          -- hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          -- hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopePromptNormal = { bg = prompt }
          -- hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          -- hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          -- hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
          hl.WinSeparator = { fg = c.blue }
        end,
      }
    end,
  },

  -- Override LazyVim configuration to select colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "dracula",
      -- colorscheme = "catppuccin-frappe",
      colorscheme = function()
        require("tokyonight").load({ style = "storm" })
      end,
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
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- auto-resize windows
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = false },
    },
    keys = { { "<leader>Z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
    config = function()
      vim.o.winwidth = 5
      vim.o.equalalways = false
      require("windows").setup({
        animation = { enable = false, duration = 150 },
      })
    end,
  },

  -- scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      local scrollbar = require("scrollbar")
      local colors = require("tokyonight.colors").setup()
      scrollbar.setup({
        handle = { color = colors.bg_highlight },
        excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
        marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        },
      })
    end,
  },

  -- style windows with different colorschemes
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    opts = {
      themes = {
        markdown = { colorscheme = "catppuccin-frappe" },
        help = { colorscheme = "oxocarbon", background = "dark" },
      },
    },
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return require("util.dashboard").status()
        end,
      })
    end,
  },
}

-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/colorscheme.lua
return {
  -- Install treesitter-aware fork of dracula theme
  { "Mofiqul/dracula.nvim" },
  -- { "shaunsingh/oxocarbon.nvim" },
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
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.LineNr = { fg = c.orange, bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          local prompt = "#2d3149"
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
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
}

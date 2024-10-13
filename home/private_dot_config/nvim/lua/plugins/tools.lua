-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/tools.lua
return {

  {
    "gbprod/yanky.nvim",
    opts = {
      -- FIXME: not finding sqlite3 on NixOS and now on nix-darwin
      -- ring = { storage = (jit.os:find("Windows") or jit.os:find("Linux")) and "shada" or "sqlite" },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    -- Required: https://github.com/folke/lazy.nvim/issues/688
    lazy = false,
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = { ".git", ".DS_Store" },
        },
        group_empty_dirs = true,
      },
      event_handlers = {
        {
          -- auto close when a file got selected
          event = "file_opened",
          handler = function(_)
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    },
  },

  -- better diffing
  {
    "sindrets/diffview.nvim",
  },

  -- Color hex/rgb color codes
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        cmp_docs = {
          always_update = true,
        },
        cmp_menu = {
          always_update = true,
        },
      })
    end,
  },

  -- ChatGPT client
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   cmd = { "ChatGPTActAs", "ChatGPT" },
  --   opts = {},
  -- },
}

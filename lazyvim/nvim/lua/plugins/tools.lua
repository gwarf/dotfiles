-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/tools.lua
return {
  -- Edit and review GitHub issues and pull requests
  { "pwntester/octo.nvim", opts = {}, cmd = "Octo" },

  -- git integration :Neogit
  -- LazyGit and Gitsigns are installed by default
  {
    "TimUntersberger/neogit",
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Launch Neogit" } },
    opts = {
      integrations = {
        diffview = true,
      },
      disable_commit_confirmation = true,
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
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },

  -- Explicit project switch
  {
    "ahmedkhalf/project.nvim",
    opts = {
      silent_chdir = true,
      scope_chdir = "tab",
    },
  },

  -- ChatGPT client
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   cmd = { "ChatGPTActAs", "ChatGPT" },
  --   opts = {},
  -- },
}

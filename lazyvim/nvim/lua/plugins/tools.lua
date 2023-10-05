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
      window = {
        position = "left",
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".git", ".DS_Store" },
        },
        follow_current_file = {
          enabled = true,
        },
        group_empty_dirs = true,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        {
          -- auto close when a file got selected
          event = "file_opened",
          handler = function(file_path)
            require("neo-tree").close_all()
          end,
        },
      },
    },
  },

  -- markdown preview
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>op",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "light", app = "browser" },
  },

  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },

  -- ChatGPT client
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   cmd = { "ChatGPTActAs", "ChatGPT" },
  --   opts = {},
  -- },
}

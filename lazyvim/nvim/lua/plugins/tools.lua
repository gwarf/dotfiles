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

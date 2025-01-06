-- https://github.com/mmai/dotfiles/blob/master/.config/LazyVim/lua/plugins/markdown.lua
return {
  -- Blink Auto-completion for Obsidian (replace nvim_cmp)
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        opts = {
          ui = { enable = false },
          workspaces = {
            {
              name = "Main",
              path = "~/Obsidian/Main",
            },
          },
          completion = {
            -- Set to false to disable completion.
            nvim_cmp = false,
            -- Trigger completion at 2 chars.
            min_chars = 2,
          },
        },
      },
      "saghen/blink.compat",
    },
    opts = {
      -- LazyVim as custom option compat to pass in external sources with blink.compat
      sources = {
        compat = { "obsidian", "obsidian_new", "obsidian_tags" },
      },
    },
  },
}

-- https://github.com/mmai/dotfiles/blob/master/.config/LazyVim/lua/plugins/markdown.lua
-- TODO: check and merge useful bits from other configurations
-- https://github.com/Gentleman-Programming/Gentleman.Dots/blob/main/GentlemanNvim/nvim/lua/plugins/obsidian.lua
-- https://github.com/epwalsh/obsidian.nvim/issues/770
-- https://github.com/maxclax/dotfiles/blob/main/private_dot_config/nvim-custom/lua/plugins/obsidian.lua.tmpl
if not vim.uv.os_uname().sysname:find("FreeBSD") then
  return {
    -- Blink Auto-completion for Obsidian (replace nvim_cmp)
    {
      "saghen/blink.cmp",
      dependencies = {
        {
          "obsidian-nvim/obsidian.nvim",
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
else
  return {}
end

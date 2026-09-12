-- https://github.com/mmai/dotfiles/blob/master/.config/LazyVim/lua/plugins/markdown.lua
-- TODO: check and merge useful bits from other configurations
-- https://github.com/Gentleman-Programming/Gentleman.Dots/blob/main/GentlemanNvim/nvim/lua/plugins/obsidian.lua
-- https://github.com/epwalsh/obsidian.nvim/issues/770
-- https://github.com/maxclax/dotfiles/blob/main/private_dot_config/nvim-custom/lua/plugins/obsidian.lua.tmpl
if not vim.uv.os_uname().sysname:find("FreeBSD") then
  return {
    {
      "obsidian-nvim/obsidian.nvim",
      version = "*", -- recommended, use latest release instead of latest commit
      lazy = true,
      ft = "markdown",
      opts = {
        daily_notes = {
          -- No folder: the plugin joins workspace / folder / date_format, and
          -- date_format already carries the full path from the vault root.
          -- Setting it also made the plugin mkdir an empty folder of that name.
          date_format = "03. Agenda 🗓️/%Y/%m/%Y-%m-%d",
          default_tags = { "journal", "agenda" },
          workdays_only = false,
        },
        ui = { enable = false },
        workspaces = {
          {
            name = "Perso",
            path = "~/Documents/Notes/",
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
  }
else
  return {}
end

return {
  -- neorg, org-mode like
  -- https://github.com/nvim-neorg/neorg
  -- Bindings mapped via localleader (\)
  -- ~/.local/share/nvim/lazy/neorg/lua/neorg/modules/core/keybinds/keybinds.lua
  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    enabled = true,
    ft = "norg",
    build = ":Neorg sync-parsers",
    cmd = "Neorg",
    dependencies = { "nvim-lua/plenary.nvim", "max397574/neorg-contexts", "nvim-neorg/neorg-telescope" },
    opts = {
      load = {
        -- Load default modules
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = {
          config = { engine = "nvim-cmp" },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              work = "~/Documents/notes/work",
              home = "~/Documents/notes/home",
            },
          },
        },
        -- https://github.com/nvim-neorg/neorg/wiki/Journal
        -- TODO: https://github.com/pysan3/neorg-templates
        ["core.journal"] = {
          config = {
            workspace = "work",
          },
        },
        ["core.summary"] = {},
        -- Neovim 0.10.0+ required for core.tempus module
        -- ["core.ui.calendar"] = {},
        ["core.integrations.telescope"] = {},
        ["external.context"] = {},
      },
    },
  },
}

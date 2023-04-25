return {
  -- neorg, org-mode like
  -- https://github.com/nvim-neorg/neorg
  -- Bindings: ~/.local/share/nvim/lazy/neorg/lua/neorg/modules/core/keybinds/keybinds.lua
  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
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
      },
    },
  },
}

-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/tools.lua
return {

  -- {
  --   "gbprod/yanky.nvim",
  --   opts = {
  --     -- FIXME: not finding sqlite3 on NixOS and now on nix-darwin
  --     -- ring = { storage = (jit.os:find("Windows") or jit.os:find("Linux")) and "shada" or "sqlite" },
  --     -- XXX: https://github.com/gbprod/yanky.nvim/issues/123
  --     system_clipboard = { sync_with_ring = false },
  --   },
  -- },

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

  -- Read RFCs
  -- FIXME: this needs pyhon 3 support
  -- { "mhinz/vim-rfc" },

  -- ChatGPT client
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   cmd = { "ChatGPTActAs", "ChatGPT" },
  --   opts = {},
  -- },
}

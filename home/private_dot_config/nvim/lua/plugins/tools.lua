-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/tools.lua
return {

  -- better diffing
  -- { "sindrets/diffview.nvim" },

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

  -- Open links without netrw using gx mapping
  { "chrishrb/gx.nvim" },
}

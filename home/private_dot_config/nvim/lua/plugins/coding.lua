-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/coding.lua
return {
  -- improved %
  {
    "andymass/vim-matchup",
    -- XXX: Need to run master as tagged release is outdated
    version = false,
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  -- supercharged .
  -- makes some plugins dot-repeatable
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- Syntax and indentation for kdl
  { "imsnif/kdl.vim", lazy = true, ft = "kdl" },
}

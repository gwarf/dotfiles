-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/coding.lua
return {
  -- TODO: check if useful and incorporate if needed
  -- https://github.com/AckslD/nvim-FeMaco.lua

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

  -- Use the w, e, b motions like a spider. Considers camelCase and skips insignificant punctuation.
  -- {
  --   "chrisgrieser/nvim-spider",
  --   lazy = true,
  --   keys = {
  --     { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider-w" },
  --     { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider-e" },
  --     { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider-b" },
  --   },
  -- },

  -- Syntax and indentation for kdl
  { "imsnif/kdl.vim", lazy = true, ft = "kdl" },
}

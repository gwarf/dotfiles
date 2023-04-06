-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/misc.lua
return {
  -- dims inactive portions of the code
  "folke/twilight.nvim",

  -- Use the w, e, b motions like a spider. Considers camelCase and skips insignificant punctuation.
  { "chrisgrieser/nvim-spider", lazy = true },

  -- Open links without netrw using gx mapping
  {
    "chrishrb/gx.nvim",
    -- FIXME register existing gx mapping in which-key
    -- config = function()
    --   local wk = require("which-key")
    --   wk.register({
    --     g = {
    --       x = "Open link",
    --     },
    --   })
    -- end,
  },

  {
    "Wansmer/treesj",
    -- keys: <space>m - toggle, <space>j - join, <space>s - split
    -- keys = {
    --   { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    -- },
    -- opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sR",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  -- add vim-repeat to supercharge .
  { "tpope/vim-repeat" },

  -- add nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {},

    init = function()
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },
}

-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/treesitter.lua
return {
  {
    "mfussenegger/nvim-treehopper",
    keys = { { "m", mode = { "o", "x" } } },
    -- Disable when doing a file diff
    cond = not vim.opt.diff:get(),
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    -- Disable when doing a file diff
    cond = not vim.opt.diff:get(),
    opts = {
      ensure_installed = {
        "css",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "http",
        "java",
        "latex",
        "meson",
        "nix",
        "norg",
        "org",
        "php",
        "rust",
        "scss",
        "sql",
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },
}

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
}

-- Example: https://github.com/folke/dot/tree/master/config/nvim
-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

return {
  -- Install support for editing nix files
  { "LnL7/vim-nix" },

  -- add vim-repeat to supercharge .
  { "tpope/vim-repeat" },

  -- XXX tools are managed via nix
  -- add any tools you want to have installed below
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "stylua",
  --       "shellcheck",
  --       "shfmt",
  --       "flake8",
  --     },
  --   },
  -- },
}

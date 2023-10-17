local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- import LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import extras LazyVim modules
    -- better copy/paste
    { import = "lazyvim.plugins.extras.coding.yanky" },
    -- support more languages
    -- { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.python" },
    -- Semantic highlighting for python
    -- XXX: breaking when opening python files
    -- See https://github.com/numirias/semshi/issues/120
    -- Had to run :UpdateRemotePlugins manually
    { import = "lazyvim.plugins.extras.lang.python-semshi" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    -- Animate common Neovim actions (cursor movement, scrolling...)
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- create and manage predefined window layouts
    { import = "lazyvim.plugins.extras.ui.edgy" },
    -- project management
    -- { import = "lazyvim.plugins.extras.util.project" },
    -- Update conf for treesitter based on what is installed
    { import = "lazyvim.plugins.extras.util.dot" },
    -- copilot disabled until there is an easy way to opt in
    -- { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "catppuccin" } },
  checker = { enabled = false }, -- automatically check for plugin updates
  -- diff = {
  --   cmd = "terminal_git",
  -- },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- Replaced by https://github.com/nvim-neo-tree/neo-tree.nvim
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

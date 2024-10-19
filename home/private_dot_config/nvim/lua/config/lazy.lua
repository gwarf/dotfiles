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
    -- Semantic highlighting for python
    -- XXX: breaking when opening python files
    -- See https://github.com/numirias/semshi/issues/120
    -- Had to run :UpdateRemotePlugins manually
    -- { import = "lazyvim.plugins.extras.lang.python-semshi" },
    -- copilot disabled until there is an easy way to choose when to use it
    -- { import = "lazyvim.plugins.extras.coding.copilot" },
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
        -- XXX: re-enable netrw until a way to open file via SSH is found
        -- Replaced by https://github.com/nvim-neo-tree/neo-tree.nvim
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- https://github.com/devinschulz/dotfiles/blob/master/nvim/.config/nvim/lua/config/treesitter.lua
local status_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

-- Use clang and llvm
require("nvim-treesitter.install").compilers = { "clang" }

ts_configs.setup({
  -- A list of parser names, or "all"
  -- ensure_installed = "all",
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "comment",
    "css",
    "diff",
    "dockerfile",
    "gitcommit",
    "git_rebase",
    "gitignore",
    "help",
    "html",
    "http",
    "javascript",
    "json",
    "latex",
    "lua",
    "make",
    "markdown",
    "norg",
    "python",
    "regex",
    "sql",
    "toml",
    "vim",
    "yaml",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
  -- Use treesitter to autoclose and autorename html tag
  autotag = {
    enable = true
  },
  -- Set commentstring option based on the cursor location in the file
  context_commentstring = {
    enable = false,
  },
  -- View treesitter information directly in Neovim!
  playground = {
    enable = true,
  },
  -- Rainbow parentheses for neovim using tree-sitter.
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  -- Using this option may slow down your editor, and you may see some duplicate highlights.
  -- Instead of true it can also be a list of languages
  additional_vim_regex_highlighting = false,
  -- enable comment string
})

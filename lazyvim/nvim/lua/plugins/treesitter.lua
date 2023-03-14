-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/treesitter.lua
return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

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
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
    -- Disable context when doing a file diff
    cond = not vim.opt.diff:get(),
  },

  {
    "nvim-treesitter/nvim-treesitter",
    -- Disable when doing a file diff
    cond = not vim.opt.diff:get(),
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "cmake",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "cpp",
        "css",
        "diff",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "help",
        "html",
        "http",
        "java",
        "javascript",
        "jsdoc",
        "jsonc",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "meson",
        "ninja",
        "nix",
        "norg",
        "org",
        "php",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "svelte",
        "teal",
        "toml",
        "tsx",
        "typescript",
        "vhs",
        "vim",
        "vue",
        "wgsl",
        "yaml",
        -- "wgsl",
        "json",
        -- "markdown",
      },
      matchup = {
        enable = true,
      },
      highlight = { enable = true },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    },
  },
}

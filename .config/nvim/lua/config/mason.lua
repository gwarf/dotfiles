require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    -- XXX now installed via nix
    -- "alex",
    -- "actionlint",
    -- "black",
    -- "beautysh",
    -- "isort",
    -- "jedi-language-server",
    -- "stylua",
    -- "markdownlint",
    -- "pylint",
    -- "prettier",
    -- "shellcheck",
    -- "shfmt",
  },
  auto_update = false,
  run_on_start = false,
  tart_delay = 3000, -- 3 second delay
})

require("mason-lspconfig").setup({
  ensure_installed = {
    -- XXX now installed via nix
    -- "ansiblels",
    -- "bashls",
    -- "grammarly",
    --  "html",
    -- "jsonls",
    -- "lemminx",
    -- "ltex",
    -- "marksman",
    --  "prosemd_lsp",
    --  Struggling with plugins and pylint
    --  https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/pylsp/README.md
    -- "pylsp",
    -- "pyright",
    -- "rnix",
    -- "ruby_ls",
    -- "sumneko_lua",
    -- "vimls",
    -- "yamlls",
  },
  automatic_installation = false,
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "ansiblels",
    "bashls",
    -- "grammarly",
    --  "html",
    "jsonls",
    --  "lemminx",
    "ltex",
    "marksman",
    --  "prosemd_lsp",
    --  Struggling with plugins and pylint
    --  https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/pylsp/README.md
    "pylsp",
    "pyright",
    --  "ruby_ls",
    "sumneko_lua",
    "vimls",
    "yamlls",
  },
  automatic_installation = true,
})

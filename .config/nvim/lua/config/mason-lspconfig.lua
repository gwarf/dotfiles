require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
      "ansiblels",
      "bashls",
      -- "grammarly",
      --  "html",
      --  "jsonls",
      --  "lemminx",
      "ltex",
      "marksman",
      --  "prosemd_lsp",
      "pylsp",
      --  "ruby_ls",
      "sumneko_lua",
      "vimls",
      -- "yamlls",
    },
    automatic_installation = true,
})

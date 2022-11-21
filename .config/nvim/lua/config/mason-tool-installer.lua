require("mason-tool-installer").setup({
  ensure_installed = {
    "alex",
    "stylua",
    "markdownlint",
    "pylint",
    "prettier",
    "shellcheck",
    "shfmt",
  },
  auto_update = true,
  run_on_start = true,
  tart_delay = 3000, -- 3 second delay
})

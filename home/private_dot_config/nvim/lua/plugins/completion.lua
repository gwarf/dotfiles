-- XXX: currently on FreeBSD blink.cmp is failing to install
-- https://github.com/Saghen/blink.cmp/issues/940
if not vim.uv.os_uname().sysname:find("FreeBSD") then
  return {
    {
      "saghen/blink.cmp",
      dependencies = {
        "hrsh7th/cmp-emoji",
        "saghen/blink.compat",
      },
      opts = {
        sources = {
          compat = { "emoji" },
        },
      },
    },
  }
else
  return {
    {
      "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "hrsh7th/cmp-emoji" },
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, { name = "emoji" })
      end,
    },
  }
end

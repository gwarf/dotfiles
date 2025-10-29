-- Loading CMP source in blink using https://github.com/Saghen/blink.compat
-- derived from https://github.com/LazyVim/LazyVim/blob/c1ee761dd88ec71fa9c9eb9706828598e7522c5d/lua/lazyvim/plugins/extras/ai/tabnine.lua#L40
-- https://github.com/Saghen/blink.compat/issues/19
-- XXX: currently on FreeBSD blink.cmp is failing to install
-- https://github.com/Saghen/blink.cmp/issues/940
if not vim.uv.os_uname().sysname:find("FreeBSD") then
  return {
    {
      "saghen/blink.cmp",
      dependencies = {
        -- FIXME: this is not working
        -- https://github.com/codybuell/cmp-lbdb/issues/11
        {
          "codybuell/cmp-lbdb",
          -- lazy = true,
          ft = "mail",
          -- opts = {
          --   mail_header_only = false,
          -- },
        },
        "saghen/blink.compat",
      },
      opts = {
        sources = {
          compat = { "lbdb" },
        },
      },
    },
  }
else
  return {
    {
      "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "codybuell/cmp-lbdb" },
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, { name = "lbdb" })
      end,
    },
  }
end

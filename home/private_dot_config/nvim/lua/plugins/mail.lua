-- Loading CMP source in blink using https://github.com/Saghen/blink.compat
-- derived from https://github.com/LazyVim/LazyVim/blob/c1ee761dd88ec71fa9c9eb9706828598e7522c5d/lua/lazyvim/plugins/extras/ai/tabnine.lua#L40
-- https://github.com/Saghen/blink.compat/issues/19
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      -- works
      "hrsh7th/cmp-emoji",
      -- FIXME: does not work
      {
        "codybuell/cmp-lbdb",
        -- lazy = true,
        -- ft = "mail",
        -- opts = {
        --   mail_header_only = false,
        -- },
      },
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        compat = { "lbdb", "emoji" },
      },
    },
  },
}

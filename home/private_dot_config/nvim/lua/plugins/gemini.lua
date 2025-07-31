return {
  -- {
  --   "kiddos/gemini.nvim",
  -- },
  -- {
  --   "jonroosevelt/gemini-cli.nvim",
  --   config = function()
  --     require("gemini").setup()
  --   end,
  -- },
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              default = "gemini-2.5-flash-preview-05-20",
            },
          },
          env = {
            api_key = "GEMINI_API_KEY",
          },
        })
      end,
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "codecompanion" },
      },
    },
  },
}

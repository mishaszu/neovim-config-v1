return {
  "stevearc/conform.nvim",
  dependencies = { "williamboman/mason.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    format_on_save = { lsp_fallback = true, async = false, timeout_ms = 1000 },
    formatters_by_ft = {
      markdown = { "mdformat" },
      -- python = { "isort", "black" },
    },
  },
  keys = {
    {
      "<leader>mp",
      function()
        require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
      end,
      mode = { "n", "v" },
      desc = "Format file or range",
    },
    {
      "<C-f>",
      function()
        require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
      end,
      desc = "Format file",
    },
  },
}

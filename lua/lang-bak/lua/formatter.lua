return {
  {
    "stevearc/conform.nvim",
    ft = { "lua" },
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.lua = { "stylua" }
    end,
  },
}

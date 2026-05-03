return {
  "stevearc/conform.nvim",
  ft = { "haskell" },
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.haskell = { "ormolu" } -- or { "fourmolu" }

    opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
      ormolu = {
        command = "ormolu",
        args = { "--stdin-input-file", "$FILENAME" },
        stdin = true,
      },
      fourmolu = {
        command = "fourmolu",
        args = { "--stdin-input-file", "$FILENAME" },
        stdin = true,
      },
    })
  end,
}

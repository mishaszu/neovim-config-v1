return {
  "mfussenegger/nvim-lint",
  ft = { "haskell" },
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.haskell = { "hlint" }
  end,
}

return {
  "mfussenegger/nvim-lint",
  ft = { "rust" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = lint.linters_by_ft or {}

    lint.linters_by_ft.rust = { "clippy" }
  end,
}

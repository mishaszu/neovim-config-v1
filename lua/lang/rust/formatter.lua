return {
  "stevearc/conform.nvim",
  ft = { "rust" },
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Prefer leptosfmt when present; otherwise rustfmt.
    opts.formatters_by_ft.rust = { "leptosfmt", "rustfmt" }

    opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
      rustfmt = {
        command = "rustfmt", -- from rustup
        stdin = true,
      },
      leptosfmt = {
        command = "leptosfmt",
        args = { "--stdin" },
        stdin = true,
        condition = function()
          return vim.fn.executable("leptosfmt") == 1
        end,
      },
    })
  end,
}

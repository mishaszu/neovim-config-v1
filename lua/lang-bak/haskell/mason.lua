return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local conform = opts.mason_conform
    local dap = opts.mason_dap
    local extend = vim.list_extend

    -- installed with ghcup + haskell-tools
    -- extend(lsp.ensure_installed, { "hls" })
    extend(conform.ensure_installed, { "hlint" })
    extend(conform.ensure_installed, { "ormolu" })

    extend(dap.ensure_installed, { "haskell-debug-adapter" })
  end,
}

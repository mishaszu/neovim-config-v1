return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local lsp = opts.mason_lspconfig
    local extend = vim.list_extend

    extend(lsp.ensure_installed, { "wasm_language_tools" })

    vim.lsp.enable("wasm_language_tools")
  end,
}

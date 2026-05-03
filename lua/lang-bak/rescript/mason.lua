return {
  "williamboman/mason.nvim",
  dependencies = {
    "rescript-lang/tree-sitter-rescript",
  },
  opts = function(_, opts)
    local lsp = opts.mason_lspconfig
    local extend = vim.list_extend

    extend(lsp.ensure_installed, { "rescriptls" })

    -- installed and used with mason
    -- vim.lsp.config["rescript"] = {
    --   cmd = { "rescript-language-server", "--stdio" },
    --   filetypes = { "rescript" },
    -- }
    --
    -- vim.lsp.enable("rescript")
  end,
}

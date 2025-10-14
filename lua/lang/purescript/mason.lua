return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local lsp = opts.mason_lspconfig
    local extend = vim.list_extend
    local conform = opts.mason_conform

    extend(lsp.ensure_installed, { "purescriptls" })
    extend(conform.ensure_installed, { "purescript-tidy" })

    vim.lsp.config["purescriptls"] = {
      settings = {
        purescript = {
          formatter = "purs-tidy",
          addSpagoSources = true,
        },
      },
    }

    vim.lsp.enable("purescriptls")
  end,
}

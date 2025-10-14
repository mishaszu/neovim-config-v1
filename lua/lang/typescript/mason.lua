return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local lsp = opts.mason_lspconfig
    local extend = vim.list_extend
    local conform = opts.mason_conform

    extend(lsp.ensure_installed, { "ts_ls" })
    extend(conform.ensure_installed, { "prettier" })
    extend(conform.ensure_installed, { "eslint_d" })

    vim.lsp.config["ts_ls"] = {
      cmd = { "typescript-language-server", "--stdio" }, -- Global binary
      filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
      },
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      on_attach = function(client)
        -- optional: disable formatting if using prettier or eslint
        client.server_capabilities.documentFormattingProvider = false
      end,
    }

    vim.lsp.enable("ts_ls")
  end,
}

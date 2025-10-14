return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "stevearc/conform.nvim",
    "zapling/mason-conform.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  opts = {
    mason = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    mason_lspconfig = {
      ensure_installed = {},
      handlers = {},
      automatic_installation = true,
    },
    mason_conform = {
      ensure_installed = {},
      automatic_installation = true,
      handlers = {}, -- this configures formatters/linters etc automatically
    },
    mason_dap = {
      ensure_installed = {},
      handlers = {}, -- configures dap automatically
      automatic_installation = true,
    },
  },
  config = function(_, opts)
    -- print(vim.inspect(opts))
    require("mason").setup(opts.mason)
    require("mason-lspconfig").setup(opts.mason_lspconfig)
    require("mason-conform").setup(opts.mason_conform)
    require("mason-nvim-dap").setup(opts.mason_dap)
  end,
}

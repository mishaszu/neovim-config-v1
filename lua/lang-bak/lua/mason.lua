return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local lsp = opts.mason_lspconfig
    local dap = opts.mason_dap
    local extend = vim.list_extend

    extend(lsp.ensure_installed, { "lua_ls" })

    vim.lsp.config["lua_ls"] = {
      filetypes = { "lua" },
      -- cmd = { "lua-language-server" },
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
    extend(dap.ensure_installed, { "stylua" })
  end,

  vim.lsp.enable("lua_ls"),
}

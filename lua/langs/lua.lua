-- lsp
vim.lsp.config["lua_ls"] = {
  filetypes = { "lua" },
  cmd = { "lua-language-server" },
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

vim.lsp.enable("lua_ls")

-- formatting
local opts = require("packages.conform").opts
opts.formatters_by_ft = opts.formatters_by_ft or {}
opts.formatters_by_ft.lua = { "stylua" }

-- required tools
local tools = {
  stylua = "sudo pacman -S stylua",
  ["lua-language-server"] = "sudo pacman -S lua-language-server",
}

return tools

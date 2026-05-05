vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
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
    client.server_capabilities.documentFormattingProvider = false
  end,
})

vim.lsp.enable("ts_ls")

local opts = require("packages.conform").opts
opts.formatters_by_ft = opts.formatters_by_ft or {}

for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  opts.formatters_by_ft[ft] = { "prettier" }
end

local tools = {
  ["typescript-language-server"] = "npm install -g typescript-language-server typescript",
  prettier = "npm install -g prettier",
}

return tools

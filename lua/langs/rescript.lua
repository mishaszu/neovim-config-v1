vim.lsp.config("rescriptls", {
  cmd = { "rescript-language-server", "--stdio" },
  filetypes = { "rescript" },
  root_markers = { "rescript.json", "bsconfig.json", ".git" },
})

vim.lsp.enable("rescriptls")

local tools = {
  ["rescript-language-server"] = "npm install -g @rescript/language-server",
}

return tools

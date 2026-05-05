vim.lsp.enable("wasm_language_tools")

local tools = {
  ["wasm-language-tools"] = "cargo install wasm-language-tools",
}

return tools

local M = {}

M.opts = {
  formatters_by_ft = {},
}

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})

vim.keymap.set({ "n", "v" }, "<leader>cf", "<cmd>Format<cr>", { desc = "Format code" })

return M

local M = {}

function M.setup_forall_shortcuts(buf)
  local opts = { buffer = buf, noremap = true, silent = true, desc = "Insert ∀" }

  vim.keymap.set("i", [[\fa]], "∀", opts)
  vim.keymap.set("i", [[\forall]], "∀", opts)
end

return M

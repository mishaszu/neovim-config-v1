local M = {}

function M.setup_forall_shortcuts(buf)
  local opts = { buffer = buf, noremap = true, silent = true, desc = "Insert ∀" }

  local shortcuts = {
    { [[\fa]], "∀", "forall" },
    { [[\forall]], "∀", "forall" },
    { [[\ex]], "∃", "exists" },
    { [[\lam]], "λ", "lambda" },
    { [[\to]], "→", "right arrow" },
    { [[\implies]], "⇒", "implies" },
    { [[\gets]], "←", "left arrow" },
    { [[\::]], "∷", "type annotation" },
    { [[\.]], "∘", "composition" },
    { [[\and]], "∧", "and" },
    { [[\or]], "∨", "or" },
    { [[\not]], "¬", "not" },
  }

  for _, shortcut in ipairs(shortcuts) do
    vim.keymap.set("i", shortcut[1], shortcut[2], vim.tbl_extend("force", opts, { desc = "Insert " .. shortcut[3] }))
  end
end

return M

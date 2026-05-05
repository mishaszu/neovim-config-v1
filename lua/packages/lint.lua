local lint = require("lint")
local tools = require("config.tools")

lint.linters_by_ft = {}

if tools.lang_enabled("web", false) then
  lint.linters_by_ft.javascript = { "eslint_d" }
  lint.linters_by_ft.typescript = { "eslint_d" }
  lint.linters_by_ft.javascriptreact = { "eslint_d" }
  lint.linters_by_ft.typescriptreact = { "eslint_d" }
  lint.linters_by_ft.svelte = { "eslint_d" }
end

if tools.lang_enabled("python", false) then
  lint.linters_by_ft.python = { "pylint" }
end

if tools.lang_enabled("rust", true) then
  lint.linters_by_ft.rust = { "clippy" }
end

local function linter_available(name)
  local linter = lint.linters[name]
  if not linter then
    return false
  end

  local cmd = linter.cmd
  if type(cmd) == "function" then
    local ok, resolved = pcall(cmd)
    if not ok then
      return false
    end
    cmd = resolved
  end

  if type(cmd) ~= "string" then
    return false
  end

  return vim.fn.executable(cmd) == 1
end

local function available_linters()
  local names = lint.linters_by_ft[vim.bo.filetype] or {}
  local available = {}

  for _, name in ipairs(names) do
    if linter_available(name) then
      table.insert(available, name)
    end
  end

  return available
end

local function try_lint_available()
  local names = available_linters()
  if #names > 0 then
    lint.try_lint(names)
  end
end

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = try_lint_available,
})

vim.keymap.set("n", "<leader>l", try_lint_available, { desc = "Trigger linting" })

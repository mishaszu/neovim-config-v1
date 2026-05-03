local M = {}

local Terminal = require("toggleterm.terminal").Terminal
local terminals = {}

function M.get(name, opts)
  if not terminals[name] then
    terminals[name] = Terminal:new(vim.tbl_extend("force", {
      direction = "horizontal",
      hidden = true,
      close_on_exit = false,
    }, opts or {}))
  end

  return terminals[name]
end

function M.toggle(name, opts)
  M.get(name, opts):toggle()
end

function M.send(name, opts, text)
  local term = M.get(name, opts)
  term:open()
  term:send(text, true)
end

function M.current_line()
  return vim.api.nvim_get_current_line()
end

function M.visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2] - 1
  local end_line = end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

  return table.concat(lines, "\n")
end

return M

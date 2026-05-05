vim.lsp.config("purescriptls", {
  settings = {
    purescript = {
      formatter = "purs-tidy",
      addSpagoSources = true,
    },
  },
})

vim.lsp.enable("purescriptls")

local opts = require("packages.conform").opts
opts.formatters_by_ft = opts.formatters_by_ft or {}
opts.formatters_by_ft.purescript = { "purs-tidy" }

opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
  ["purs-tidy"] = {
    command = "purs-tidy",
    args = { "format" },
    stdin = true,
  },
})

local tools = {
  ["purescript-language-server"] = "npm install -g purescript-language-server",
  purs = "npm install -g purescript",
  spago = "npm install -g spago@next",
  ["purs-tidy"] = "npm install -g purs-tidy",
}

local function setup_buffer(ev)
  local repl = require("config.repl")
  local opts = { noremap = true, silent = true, buffer = ev.buf }
  local repl_opts = {
    cmd = "spago repl",
    display_name = "spago repl",
  }

  vim.api.nvim_buf_create_user_command(ev.buf, "PursRepl", function()
    repl.toggle("purescript-repl", repl_opts)
  end, {})

  vim.api.nvim_buf_create_user_command(ev.buf, "PursTest", function()
    repl.toggle("purescript-test", { cmd = "spago test", display_name = "spago test" })
  end, {})

  vim.api.nvim_buf_create_user_command(ev.buf, "PursSendLine", function()
    repl.send("purescript-repl", repl_opts, repl.current_line())
  end, {})

  vim.api.nvim_buf_create_user_command(ev.buf, "PursSendSelection", function()
    repl.send("purescript-repl", repl_opts, repl.visual_selection())
  end, { range = true })

  vim.keymap.set("n", "<leader>rr", "<cmd>PursRepl<cr>", vim.tbl_extend("force", opts, { desc = "Toggle spago repl" }))
  vim.keymap.set("n", "<leader>rt", "<cmd>PursTest<cr>", vim.tbl_extend("force", opts, { desc = "Run spago test" }))
  vim.keymap.set(
    "n",
    "<leader>rl",
    "<cmd>PursSendLine<cr>",
    vim.tbl_extend("force", opts, { desc = "Send line to spago repl" })
  )
  vim.keymap.set(
    "v",
    "<leader>rs",
    "<cmd>PursSendSelection<cr>",
    vim.tbl_extend("force", opts, { desc = "Send selection to spago repl" })
  )
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "purescript",
  callback = setup_buffer,
})

return tools

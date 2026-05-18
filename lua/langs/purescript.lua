vim.lsp.config("purescriptls", {
  cmd = { "purescript-language-server", "--stdio" },
  filetypes = { "purescript" },
  root_markers = {
    "bower.json",
    "flake.nix",
    "package.json",
    "psc-package.json",
    "shell.nix",
    "spago.dhall",
    "spago.yaml",
  },
  settings = {
    purescript = {
      formatter = "purs-tidy",
      addSpagoSources = true,
      addNpmPath = true,
      buildCommand = "spago build --json-errors",
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

local function normalize_code_action(action)
  if action.edit == vim.NIL then
    action.edit = nil
  end
  if action.command == vim.NIL then
    action.command = nil
  end
  return action
end

local function apply_replace_suggestion(command, client)
  local arguments = command.arguments or {}
  local uri = arguments[1]
  local replacement = arguments[2]
  local range = arguments[3]

  if type(uri) ~= "string" or type(replacement) ~= "string" or type(range) ~= "table" then
    return false
  end

  vim.lsp.util.apply_workspace_edit({
    changes = {
      [uri] = {
        {
          range = range,
          newText = replacement,
        },
      },
    },
  }, client.offset_encoding)

  return true
end

local function apply_code_action(action, client, ctx)
  action = normalize_code_action(action)
  local applied = false

  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    applied = true
  end

  if action.command then
    local command = type(action.command) == "table" and action.command or action
    if command.command == "purescript.replaceSuggestion" and apply_replace_suggestion(command, client) then
      return
    end

    client:request("workspace/executeCommand", {
      command = command.command,
      arguments = command.arguments or {},
    }, function(err, result)
      if err then
        vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
        return
      end

      if type(result) ~= "table" then
        return
      end

      local edit = result.edit or result
      if edit.documentChanges or edit.changes then
        vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
      end
    end, ctx.bufnr)
    applied = true
  end

  if not applied then
    vim.notify("Selected PureScript code action had no edit or command", vim.log.levels.WARN)
  end
end

local function purescript_code_action()
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "purescriptls", method = "textDocument/codeAction" })

  if #clients == 0 then
    vim.notify("purescriptls is not attached or does not support code actions", vim.log.levels.WARN)
    return
  end

  local actions = {}
  local pending = #clients

  for _, client in ipairs(clients) do
    local params = vim.lsp.util.make_range_params(win, client.offset_encoding)
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = vim.api.nvim_win_get_cursor(win)[1] - 1 })
    params.context = {
      diagnostics = vim.tbl_map(function(diagnostic)
        return diagnostic.user_data and diagnostic.user_data.lsp or diagnostic
      end, diagnostics),
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    }

    client:request("textDocument/codeAction", params, function(err, result, ctx)
      pending = pending - 1

      if err then
        vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
      else
        for _, action in ipairs(result or {}) do
          table.insert(actions, { action = normalize_code_action(action), client = client, ctx = ctx })
        end
      end

      if pending > 0 then
        return
      end

      if #actions == 0 then
        vim.notify("No PureScript code actions available", vim.log.levels.INFO)
        return
      end

      vim.ui.select(actions, {
        prompt = "PureScript code actions:",
        format_item = function(item)
          return item.action.title or item.action.command or "<unnamed action>"
        end,
      }, function(choice)
        if not choice then
          return
        end

        local action = choice.action
        if action.disabled then
          vim.notify(action.disabled.reason, vim.log.levels.ERROR)
          return
        end

        if not (action.edit and action.command) and choice.client:supports_method("codeAction/resolve") then
          choice.client:request("codeAction/resolve", action, function(resolve_err, resolved_action)
            if resolve_err or not resolved_action then
              apply_code_action(action, choice.client, choice.ctx)
              return
            end

            resolved_action = normalize_code_action(resolved_action)
            if not resolved_action.command then
              resolved_action.command = action.command
            end
            if not resolved_action.edit then
              resolved_action.edit = action.edit
            end

            apply_code_action(resolved_action, choice.client, choice.ctx)
          end, bufnr)
        else
          apply_code_action(action, choice.client, choice.ctx)
        end
      end)
    end, bufnr)
  end
end

local function setup_buffer(ev)
  require("config.symbols").setup_forall_shortcuts(ev.buf)

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

  vim.api.nvim_buf_create_user_command(ev.buf, "PursBuild", function()
    vim.lsp.buf.execute_command({ command = "purescript.build", arguments = {} })
  end, {})

  vim.api.nvim_buf_create_user_command(ev.buf, "PursRestartIde", function()
    vim.lsp.buf.execute_command({ command = "purescript.restartPscIde", arguments = {} })
  end, {})

  vim.api.nvim_buf_create_user_command(ev.buf, "PursCodeAction", purescript_code_action, {})

  vim.keymap.set("n", "<leader>rr", "<cmd>PursRepl<cr>", vim.tbl_extend("force", opts, { desc = "Toggle spago repl" }))
  vim.keymap.set("n", "<leader>rt", "<cmd>PursTest<cr>", vim.tbl_extend("force", opts, { desc = "Run spago test" }))
  vim.keymap.set(
    "n",
    "<leader>rb",
    "<cmd>PursBuild<cr>",
    vim.tbl_extend("force", opts, { desc = "Run PureScript build" })
  )
  vim.keymap.set(
    { "n", "v" },
    "<leader>ca",
    "<cmd>PursCodeAction<cr>",
    vim.tbl_extend("force", opts, { desc = "PureScript code action" })
  )
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

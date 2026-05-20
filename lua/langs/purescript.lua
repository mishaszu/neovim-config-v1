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

local function nil_if_json_null(value)
  if value == vim.NIL then
    return nil
  end
  return value
end

local function normalize_command(command)
  if type(command) ~= "table" then
    return command
  end

  command.arguments = nil_if_json_null(command.arguments)
  return command
end

local function normalize_code_action(action)
  action.edit = nil_if_json_null(action.edit)
  action.command = normalize_command(nil_if_json_null(action.command))
  return action
end

local function apply_workspace_edit(edit, client)
  edit = nil_if_json_null(edit)
  if type(edit) == "table" and (edit.documentChanges or edit.changes) then
    vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
    return true
  end
  return false
end

local function apply_text_edit(uri, range, new_text, client)
  if type(uri) ~= "string" or type(range) ~= "table" or type(new_text) ~= "string" then
    return false
  end

  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)
  vim.lsp.util.apply_text_edits({
    {
      range = range,
      newText = new_text,
    },
  }, bufnr, client.offset_encoding)
  return true
end

local function apply_replace_suggestion(command, client)
  local arguments = command.arguments or {}
  return apply_text_edit(arguments[1], arguments[3], arguments[2], client)
end

local function apply_replace_all_suggestions(command, client)
  local arguments = command.arguments or {}
  local uri = arguments[1]
  local suggestions = arguments[2]

  if type(uri) ~= "string" or type(suggestions) ~= "table" then
    return false
  end

  local edits = {}
  for _, suggestion in ipairs(suggestions) do
    if
      type(suggestion) == "table"
      and type(suggestion.range) == "table"
      and type(suggestion.replacement) == "string"
    then
      table.insert(edits, {
        range = suggestion.range,
        newText = suggestion.replacement,
      })
    end
  end

  if #edits == 0 then
    return false
  end

  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)
  vim.lsp.util.apply_text_edits(edits, bufnr, client.offset_encoding)
  return true
end

local function lua_pattern_escape(value)
  return (value:gsub("([^%w])", "%%%1"))
end

local function import_exists(lines, module, qualifier)
  local module_pattern = lua_pattern_escape(module)
  local qualifier_pattern = qualifier and lua_pattern_escape(qualifier)

  for _, line in ipairs(lines) do
    if
      qualifier_pattern and line:match("^%s*import%s+" .. module_pattern .. "%s+as%s+" .. qualifier_pattern .. "%s*$")
    then
      return true
    end

    if not qualifier and line:match("^%s*import%s+" .. module_pattern .. "%s*$") then
      return true
    end
  end

  return false
end

local function find_import_insert_lnum(lines)
  local insert_lnum = 0

  for index, line in ipairs(lines) do
    if line:match("^%s*import%s+") then
      insert_lnum = index
    end
  end

  if insert_lnum > 0 then
    return insert_lnum
  end

  for index, line in ipairs(lines) do
    if line:match("^%s*where%s*$") or line:match("^%s*module%s+.+%s+where%s*$") then
      return index
    end
  end

  return 0
end

local function add_module_import(uri, module, qualifier)
  if type(uri) ~= "string" or type(module) ~= "string" or module == "" then
    return false
  end

  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if import_exists(lines, module, qualifier) then
    return true
  end

  local import_line = "import " .. module
  if type(qualifier) == "string" and qualifier ~= "" then
    import_line = import_line .. " as " .. qualifier
  end

  vim.api.nvim_buf_set_lines(
    bufnr,
    find_import_insert_lnum(lines),
    find_import_insert_lnum(lines),
    false,
    { import_line }
  )
  return true
end

local function identifier_range_at(line, character)
  local byte_col = character + 1
  local start_col = byte_col
  local end_col = byte_col

  while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_']") do
    start_col = start_col - 1
  end

  while end_col <= #line and line:sub(end_col, end_col):match("[%w_']") do
    end_col = end_col + 1
  end

  if start_col == end_col then
    return nil
  end

  return {
    start = start_col - 1,
    ["end"] = end_col - 1,
  }
end

local function apply_fix_typo(command, client)
  local arguments = command.arguments or {}
  local uri = arguments[1]
  local line = arguments[2]
  local character = arguments[3]
  local typo = arguments[4]

  if type(uri) ~= "string" or type(line) ~= "number" or type(character) ~= "number" or type(typo) ~= "table" then
    return false
  end

  local identifier = typo.identifier
  local module = typo.mod
  local qualifier = nil_if_json_null(typo.qualifier)
  local should_replace_identifier = type(command.title) == "string" and command.title:match("^Replace with") ~= nil
  if type(identifier) ~= "string" or type(module) ~= "string" then
    return false
  end

  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)

  local current_line = should_replace_identifier and vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or nil
  if should_replace_identifier and type(current_line) == "string" then
    local range = identifier_range_at(current_line, character)
    if range then
      local replacement = identifier
      if type(qualifier) == "string" and qualifier ~= "" then
        replacement = qualifier .. "." .. identifier
      end

      local current_identifier = current_line:sub(range.start + 1, range["end"])
      if current_identifier ~= replacement then
        vim.lsp.util.apply_text_edits({
          {
            range = {
              start = { line = line, character = range.start },
              ["end"] = { line = line, character = range["end"] },
            },
            newText = replacement,
          },
        }, bufnr, client.offset_encoding)
      end
    end
  end

  return add_module_import(uri, module, qualifier)
end

local function format_typed_hole_option(option)
  if type(option) ~= "table" then
    return tostring(option)
  end

  local identifier = option.identifier or "<unnamed>"
  local module = option["module'"] or option.module
  if type(module) == "string" and module ~= "" then
    return ("%s (%s)"):format(identifier, module)
  end
  return identifier
end

local function select_typed_hole(command, client, ctx)
  local arguments = command.arguments or {}
  local name = arguments[1]
  local uri = arguments[2]
  local range = arguments[3]
  local options = vim.list_slice(arguments, 4)

  if type(name) ~= "string" or type(uri) ~= "string" or type(range) ~= "table" or #options == 0 then
    return false
  end

  vim.ui.select(options, {
    prompt = "PureScript typed hole suggestions:",
    format_item = format_typed_hole_option,
  }, function(choice)
    if not choice then
      return
    end

    client:request("workspace/executeCommand", {
      command = "purescript.typedHole-explicit",
      arguments = { name, uri, range, choice },
    }, function(err)
      if err then
        vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
      end
    end, ctx.bufnr)
  end)

  return true
end

local function execute_command(command, client, ctx)
  command = normalize_command(command)
  if type(command) ~= "table" or type(command.command) ~= "string" then
    return false
  end

  if command.command == "purescript.replaceSuggestion" then
    return apply_replace_suggestion(command, client)
  end

  if command.command == "purescript.replaceAllSuggestions" then
    return apply_replace_all_suggestions(command, client)
  end

  if command.command == "purescript.fixTypo" then
    return apply_fix_typo(command, client)
  end

  if command.command == "purescript.typedHole" then
    return select_typed_hole(command, client, ctx)
  end

  client:request("workspace/executeCommand", {
    command = command.command,
    arguments = command.arguments or {},
  }, function(err, result)
    if err then
      vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
      return
    end

    result = nil_if_json_null(result)
    if type(result) ~= "table" then
      if command.command:match("^purescript%.") then
        vim.cmd("checktime")
      end
      return
    end

    if not apply_workspace_edit(result.edit or result, client) and command.command:match("^purescript%.") then
      vim.cmd("checktime")
    end
  end, ctx.bufnr)

  return true
end

local function apply_code_action(action, client, ctx)
  action = normalize_code_action(action)

  local applied = apply_workspace_edit(action.edit, client)
  local command = type(action.command) == "table" and action.command or action
  applied = execute_command(command, client, ctx) or applied

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
        kind = "codeaction",
        format_item = function(item)
          local command = item.action.command
          if type(command) == "table" then
            command = command.command
          end
          return item.action.title or command or "<unnamed action>"
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

        if type(action.title) == "string" and type(action.command) == "string" then
          apply_code_action(action, choice.client, choice.ctx)
          return
        end

        if not (action.edit and action.command) and choice.client:supports_method("codeAction/resolve", bufnr) then
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
    purescript_code_action,
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

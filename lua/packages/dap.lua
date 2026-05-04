local tools = require("config.tools")

if not tools.env_enabled("NVIM_ENABLE_DAP", false) then
  return
end

local dap = require("dap")

local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " "))
    return vim.split(vim.fn.expand(new_args), " ")
  end
  return config
end

vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Breakpoint Condition" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>da", function()
  dap.continue({ before = get_args })
end, { desc = "Run with Args" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", dap.goto_, { desc = "Go to line (no execute)" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", dap.session, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dw", function()
  require("dap.ui.widgets").hover()
end, { desc = "Widgets" })

local ok_dapui, dapui = pcall(require, "dapui")
if ok_dapui then
  dapui.setup()
  vim.keymap.set("n", "<leader>du", function()
    dapui.toggle({})
  end, { desc = "Dap UI" })
  vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Eval" })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

pcall(function()
  require("nvim-dap-virtual-text").setup({})
end)

if tools.lang_enabled("rust", true) then
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.rust = {
    {
      name = "Debug executable (cargo run)",
      type = "codelldb",
      request = "launch",
      program = function()
        vim.fn.jobstart({ "cargo", "build" }, { detach = true })
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
    {
      name = "Debug tests",
      type = "codelldb",
      request = "launch",
      program = function()
        vim.fn.jobstart({ "cargo", "test", "--no-run" }, { detach = true })
        return vim.fn.input("Test binary: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

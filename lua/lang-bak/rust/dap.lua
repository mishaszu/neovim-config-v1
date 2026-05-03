return {
  "mfussenegger/nvim-dap",
  ft = { "rust" },
  config = function()
    local dap = require("dap")

    -- Resolve codelldb paths from Mason
    local mason = vim.fn.stdpath("data") .. "/mason"
    local codelldb_root = mason .. "/packages/codelldb/extension/"
    local adapter_path = codelldb_root .. "adapter/codelldb"
    local liblldb_path = (function()
      local candidates = {
        codelldb_root .. "lldb/lib/liblldb.dylib",
        codelldb_root .. "lldb/lib/liblldb.so",
        codelldb_root .. "lldb/bin/liblldb.dll",
      }
      for _, p in ipairs(candidates) do
        if vim.fn.filereadable(p) == 1 then
          return p
        end
      end
      return nil
    end)()

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = adapter_path,
        args = { "--liblldb", liblldb_path, "--port", "${port}" },
        detached = true,
      },
    }

    -- Launch the debug build of current package (Cargo)
    dap.configurations.rust = {
      {
        name = "Debug executable (cargo run)",
        type = "codelldb",
        request = "launch",
        program = function()
          -- build then ask for the produced binary
          vim.fn.jobstart({ "cargo", "build" }, { detach = true })
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        env = function()
          local variables = {}
          for k, v in pairs(vim.fn.environ()) do
            variables[#variables + 1] = string.format("%s=%s", k, v)
          end
          return variables
        end,
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
  end,
}

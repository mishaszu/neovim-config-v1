return {
  "mfussenegger/nvim-dap",
  ft = { "haskell" },
  config = function()
    local dap = require("dap")
    local bin = vim.fn.stdpath("data") .. "/mason/bin/haskell-debug-adapter"

    dap.adapters.haskell = { type = "executable", command = bin }
    dap.configurations.haskell = {
      {
        type = "haskell",
        request = "launch",
        name = "Debug current file",
        workspace = "${workspaceFolder}",
        startup = "${file}",
        stopOnEntry = false,
        logFile = vim.fn.stdpath("cache") .. "/haskell-dap.log",
        logLevel = "INFO",
      },
    }
  end,
}

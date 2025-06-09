return {
  "nyoom-engineering/oxocarbon.nvim",
  "junegunn/seoul256.vim",
  "brymck/nekotako",
  "pappasam/papercolor-theme-slim",
  {
    "sainnhe/everforest",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme PaperColorSlimLight]])
      -- vim.schedule(function()
      --   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e", fg = "#ffffff" })
      --   vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#5eacd3" })
      --
      --   -- LSP diagnostics in float windows
      --   vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = "#ff5f5f", bg = "#1e1e2e" })
      --   vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = "#ffaf00", bg = "#1e1e2e" })
      --   vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = "#87afff", bg = "#1e1e2e" })
      --   vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = "#5fd7af", bg = "#1e1e2e" })
      --
      --   vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#ff5f5f" })
      --   vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ffaf00" })
      --   vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#87afff" })
      --   vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#5fd7af" })
      --
      --
      --   local bg = "#4d5254"
      --   vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#1e1e2e", bg = bg })
      --   vim.api.nvim_set_hl(0, "Normal", { bg = bg })
      --   -- vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#1e1e2e", bg = "#464a4d" })
      --   -- vim.api.nvim_set_hl(0, "Normal", { bg = "#464a4d" })
      -- end)
    end,
  },
}

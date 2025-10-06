return {
  "nyoom-engineering/oxocarbon.nvim",
  "junegunn/seoul256.vim",
  "brymck/nekotako",
  "pappasam/papercolor-theme-slim",
  "EdenEast/nightfox.nvim",
  {
    "sainnhe/everforest",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins

    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme zaibatsu]])
      -- vim.cmd([[colorscheme PaperColorSlimLight]])
      vim.schedule(function()
        vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#d1dec5" })
      end)
    end,
  },
}

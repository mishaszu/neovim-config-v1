return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  {
    "arkav/lualine-lsp-progress",
    config = function()
      local lualine = require("lualine")

      lualine.setup({
        sections = {
          lualine_c = {
            "lsp_progress",
          },
        },
      })
    end,
  },
}

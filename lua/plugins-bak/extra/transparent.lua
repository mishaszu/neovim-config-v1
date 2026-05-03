return {
  {
    "xiyaowong/transparent.nvim",
    enable = false, -- plugin is useful only with image bg
    config = function()
      local config = require("transparent")

      config.setup({
        -- table: default groups
        enable = false,
        groups = {
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLine",
          "CursorLineNr",
          -- "StatusLine",
          -- "StatusLineNC",
          "EndOfBuffer",
        },
        -- table: additional groups that should be cleared
        extra_groups = {},
        -- table: groups you don't want to clear
        exclude_groups = {
          "NormalFloat",
          "FloatBorder",
          "FzfNormal",
          "FzfBorder",
          "TelescopeNormal",
          "TelescopeBorder",
        },
        -- function: code to be executed after highlight groups are cleared
        -- Also the user event "TransparentClear" will be triggered
        on_clear = function() end,
      })

      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e1e2e", fg = "#cdd6f4" })
    end,
  },
}

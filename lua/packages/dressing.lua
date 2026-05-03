require("dressing").setup({
  input = {
    border = "rounded",
    win_options = {
      winblend = 0,
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  select = {
    backend = { "telescope", "builtin" },
    builtin = {
      border = "rounded",
      win_options = {
        winblend = 0,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
})

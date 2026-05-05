if not require("config.tools").env_enabled("NVIM_ENABLE_COLOR_TOOLS", false) then
  return
end

require("color-picker").setup({})
vim.keymap.set("n", "<leader>cp", "<cmd>PickColor<CR>", { desc = "Pick color" })

require("colorizer").setup({
  user_default_options = {
    RGB = true,
    RRGGBB = true,
    names = true,
    css = true,
    tailwind = true,
    mode = "background",
  },
})

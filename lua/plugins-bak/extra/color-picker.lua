return {
  {
    "ziontee113/color-picker.nvim",
    config = function()
      require("color-picker").setup({})
      vim.keymap.set("n", "<leader>cp", "<cmd>PickColor<CR>", { desc = "Pick color" })
    end
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        RGB = true,          -- #RGB hex
        RRGGBB = true,       -- #RRGGBB hex
        names = true,        -- "blue" or "red"
        css = true,          -- Enable CSS color functions
        tailwind = true,     -- Tailwind class colors
        mode = "background", -- "foreground" | "background" | "virtualtext"
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  }
}

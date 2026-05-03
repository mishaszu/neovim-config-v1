return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local conf = require("nvim-treesitter.configs")

      conf.setup({
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        ident = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
}

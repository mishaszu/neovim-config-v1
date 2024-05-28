return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "rescript-lang/tree-sitter-rescript",
    },
    config = function()
      local conf = require("nvim-treesitter.configs")

      conf.setup({
        ensure_installed = { "lua", "rust", "toml" },
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
  opts = function(_, opts) -- this is needed so you won't override your default nvim-treesitter configuration
    vim.list_extend(opts.ensure_installed, {
      "rescript",
    })

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.rescript = {
      install_info = {
        url = "https://github.com/rescript-lang/tree-sitter-rescript",
        branch = "main",
        files = { "src/scanner.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = true,
        use_makefile = true, -- macOS specific instruction
      },
    }
  end,
  { "nvim-treesitter/nvim-treesitter-textobjects" },
}

return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- make sure ensure_installed exists
    opts.ensure_installed = opts.ensure_installed or {}

    -- add haskell parser if not already included
    if not vim.tbl_contains(opts.ensure_installed, "haskell") then
      table.insert(opts.ensure_installed, "haskell")
    end

    -- optional: disable indenting for Haskell (layout-sensitive!)
    opts.indent = opts.indent or {}
    opts.indent.disable = opts.indent.disable or {}
    if not vim.tbl_contains(opts.indent.disable, "haskell") then
      table.insert(opts.indent.disable, "haskell")
    end

    -- optional: ensure highlighting is enabled
    opts.highlight = opts.highlight or {}
    opts.highlight.enable = true
  end,
}

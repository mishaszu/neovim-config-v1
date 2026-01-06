return {
  "nvim-treesitter/nvim-treesitter",
  -- optional: keep parsers fresh on plugin update
  build = ":tsupdate",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}

    -- add rust + toml parsers if missing
    for _, lang in ipairs({ "rust", "toml" }) do
      if not vim.tbl_contains(opts.ensure_installed, lang) then
        table.insert(opts.ensure_installed, lang)
      end
    end

    -- optional: auto-install when opening a buffer of that type
    opts.auto_install = true
  end,
  -- optional: kick an update/install pass right away
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    require("nvim-treesitter.install").update({ with_sync = false })()
  end,
}

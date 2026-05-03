return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}

    for _, lang in ipairs({ "typescript", "javascript", "tsx" }) do
      if not vim.tbl_contains(opts.ensure_installed, lang) then
        table.insert(opts.ensure_installed, lang)
      end
    end

    opts.auto_install = true
  end,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    -- Kick off an install pass now so TS/TSX don’t wait for you to open a buffer
    require("nvim-treesitter.install").update({ with_sync = false })()
    -- (Alternatively) install just the ones you care about:
    -- require("nvim-treesitter.install").ensure_installed({ "typescript", "tsx", "javascript" })
  end,
}

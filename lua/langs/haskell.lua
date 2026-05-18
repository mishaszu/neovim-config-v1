vim.g.haskell_tools = {
  hls = {
    settings = {
      haskell = {
        formattingProvider = "ormolu",
      },
    },
  },
}

local opts = require("packages.conform").opts
opts.formatters_by_ft = opts.formatters_by_ft or {}
opts.formatters_by_ft.haskell = { "ormolu" }

opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
  ormolu = {
    command = "ormolu",
    args = { "--stdin-input-file", "$FILENAME" },
    stdin = true,
  },
  fourmolu = {
    command = "fourmolu",
    args = { "--stdin-input-file", "$FILENAME" },
    stdin = true,
  },
})

local lint = require("lint")
lint.linters_by_ft = lint.linters_by_ft or {}
lint.linters_by_ft.haskell = { "hlint" }

local tools = {
  cabal = "ghcup install cabal",
  ["haskell-language-server-wrapper"] = "ghcup install hls",
  ormolu = "cabal install ormolu",
  hlint = "cabal install hlint",
  hoogle = "cabal install hoogle",
  ghcid = "cabal install ghcid",
  doctest = "cabal install doctest",
}

local function setup_buffer(ev)
  require("config.symbols").setup_forall_shortcuts(ev.buf)

  local ok, ht = pcall(require, "haskell-tools")
  if not ok then
    return
  end

  local repl = require("config.repl")
  local opts = { noremap = true, silent = true, buffer = ev.buf }

  vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts)
  vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)
  vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)
  vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)
  vim.keymap.set("n", "<leader>rf", function()
    ht.repl.toggle(vim.api.nvim_buf_get_name(ev.buf))
  end, opts)
  vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)

  vim.api.nvim_buf_create_user_command(ev.buf, "HaskellTest", function()
    repl.toggle("haskell-test", { cmd = "cabal test", display_name = "cabal test" })
  end, {})

  vim.api.nvim_buf_create_user_command(ev.buf, "HaskellGhcid", function()
    repl.toggle("haskell-ghcid", { cmd = "ghcid", display_name = "ghcid" })
  end, {})

  vim.keymap.set("n", "<leader>rt", "<cmd>HaskellTest<cr>", vim.tbl_extend("force", opts, { desc = "Run cabal test" }))
  vim.keymap.set("n", "<leader>rg", "<cmd>HaskellGhcid<cr>", vim.tbl_extend("force", opts, { desc = "Run ghcid" }))
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "haskell",
  callback = setup_buffer,
})

return tools

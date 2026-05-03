local gh = function(x) return 'https://github.com/' .. x end
local gl = function(x) return 'https://gitlab.com/' .. x end

vim.pack.add({
  -- ui
  gh("nvim-tree/nvim-tree.lua"),
  gh("stevearc/dressing.nvim"),

  -- deps
  gh("nvim-tree/nvim-web-devicons"),

  -- buffer line
  gh("arkav/lualine-lsp-progress"),
  gh("nvim-lualine/lualine.nvim"),

  -- colorscheme
  gh("nyoom-engineering/oxocarbon.nvim"),
  gh("junegunn/seoul256.vim"),
  gh("brymck/nekotako"),
  gh("pappasam/papercolor-theme-slim"),
  gh("EdenEast/nightfox.nvim"),
  gh("axieax/catppuccin-nvim-v0.1"),
  gh("rebelot/kanagawa.nvim"),
  gh("sainnhe/everforest"),

  gh("kylechui/nvim-surround"),

  -- ufo for folding lines
  gh("kevinhwang91/promise-async"),
  gh("kevinhwang91/nvim-ufo"),

  -- trouble shooting with lsp
  gh("folke/trouble.nvim"),

  --  treesitter
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-treesitter/nvim-treesitter-textobjects"),

  --
  gl("HiPhish/rainbow-delimiters.nvim"),

  --
  gh("folke/todo-comments.nvim"),

  --
  gh("nvim-lua/plenary.nvim"),

  -- telescope
  -- fzf plugin requires make after downloading
  -- eg. :!cd /path/to/telescope-fzf-native.nvim && make
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("nvim-telescope/telescope-live-grep-args.nvim"),
  gh("nvim-telescope/telescope.nvim"),

  --
  gh("mfussenegger/nvim-lint"),

  -- formatting
  gh("stevearc/conform.nvim"),

  --
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-nvim-lua"),
  gh("hrsh7th/cmp-nvim-lsp-signature-help"),
  gh("hrsh7th/cmp-vsnip"),
  gh("hrsh7th/cmp-path"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/vim-vsnip"),
  gh("hrsh7th/nvim-cmp"),

  --
  gh("windwp/nvim-autopairs"),


  gh("neovim/nvim-lspconfig"),


  -- rust
  gh("saecki/crates.nvim"),

})

vim.cmd([[colorscheme seoul256]])
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1f1f1f", fg = "#d0d0d0" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1f1f1f", fg = "#87afff" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1f1f1f", fg = "#d0d0d0" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

if vim.g.neovide then
  vim.g.neovide_opacity = 0.85
  vim.g.neovide_normal_opacity = 0.85
end

require("packages.autopairs")
require("packages.cmp")
require("packages.dressing")
require("packages.lint")
require("packages.lualine")
require("packages.nvim-tree")
require("packages.telescope")
require("packages.trouble")
require("packages.ufo")
require("packages.lsp")

local opts = require("packages.conform").opts
require("conform").setup(opts)

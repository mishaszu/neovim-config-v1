require("config.opts")
require("config.keys")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.packages")

-- have to be after packages
require("config.langs")

local conform_opts = require("packages.conform").opts
require("conform").setup(conform_opts)

-- require("config.lazyconf")

-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#ff00ff", fg = "#000000" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#ff00ff", fg = "#000000" })

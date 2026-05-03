local treesitter_langs = {
  "lua",
  "rust",
  "toml",
}

local tools = {
  ["tree-sitter"] = "sudo pacman -S tree-sitter-cli",
  ["fzf"] = "sudo pacman -S fzf ripgrep fd",
}

-- import lua config
local lua_tools = require("langs.lua")
tools = vim.tbl_extend("force", tools, lua_tools)

-- rust config
local rust_tools = require("langs.rust")
tools = vim.tbl_extend("force", tools, rust_tools)

for bin, install_cmd in pairs(tools) do
  if vim.fn.executable(bin) == 0 then
    vim.notify(
      bin .. " not found. Install with: " .. install_cmd,
      vim.log.levels.WARN
    )
  end
end


-- tree sitter config
local opts = {
  ensure_installed = treesitter_langs,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = { enable = true },
}

require("nvim-treesitter").setup(opts)
pcall(function()
  require("nvim-treesitter.install").update({ with_sync = false })
end)

vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function()
    vim.cmd("TSUpdate")
  end,
})

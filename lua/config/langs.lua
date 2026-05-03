local tool_config = require("config.tools")

local treesitter_langs = {}

local tools = {
  ["tree-sitter"] = {
    install = "sudo pacman -S tree-sitter-cli",
    min_version = "0.26.1",
    version_cmd = { "tree-sitter", "--version" },
  },
  fzf = "sudo pacman -S fzf",
  rg = "sudo pacman -S ripgrep",
  fd = "sudo pacman -S fd",
  make = "sudo pacman -S make",
  gcc = "sudo pacman -S gcc",
}

if tool_config.lang_enabled("lua", true) then
  vim.list_extend(treesitter_langs, { "lua" })
  tools = tool_config.extend(tools, require("langs.lua"))
end

if tool_config.lang_enabled("rust", true) then
  vim.list_extend(treesitter_langs, { "rust", "toml" })
  tools = tool_config.extend(tools, require("langs.rust"))
end

if tool_config.lang_enabled("haskell", false) then
  vim.list_extend(treesitter_langs, { "haskell" })
  tools = tool_config.extend(tools, require("langs.haskell"))
end

if tool_config.lang_enabled("purescript", false) then
  vim.list_extend(treesitter_langs, { "purescript" })
  tools = tool_config.extend(tools, require("langs.purescript"))
end

if tool_config.lang_enabled("web", false) then
  tools.eslint_d = "npm install -g eslint_d"
end

if tool_config.lang_enabled("python", false) then
  tools.pylint = "python -m pip install pylint"
end

tool_config.warn_missing(tools)

-- tree sitter config
local opts = {
  ensure_installed = treesitter_langs,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    disable = tool_config.lang_enabled("haskell", false) and { "haskell" } or {},
  },
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

-- lsp
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

local function is_leptos_project()
  local path = vim.fn.getcwd() .. "/Cargo.toml"
  local f = io.open(path, "r")
  if not f then
    return false
  end
  for line in f:lines() do
    if line:match("%f[%w]leptos%f[%W]") then
      f:close()
      return true
    end
  end
  f:close()
  return false
end

local base_rust_settings = {
  ["rust-analyzer"] = {
    cmd = { "rust-analyzer" },
    procMacro = {
      enable = true,
      ignored = {
        leptos_macro = {
          -- optional: --
          -- "component",
          "server",
        },
      },
    },
    cargo = {
      buildScripts = {
        enable = true,
      },
      allFeatures = true,
    },
    inlayHints = {
      enable = true,
      typeHints = {
        enable = true,
      },
      parameterHints = {
        enable = true,
      },
    },
    lens = {
      enable = true,
    },
    checkOnSave = {
      enable = true,
      command = "clippy",
      extraArgs = { "--no-deps" },
      allTargets = true,
    },
  },
}

if is_leptos_project() then
  base_rust_settings = vim.tbl_deep_extend("force", base_rust_settings, {
    ["rust-analyzer"] = {
      rustfmt = {
        overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
      },
    },
  })
end

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = base_rust_settings,
})

vim.lsp.enable("rust_analyzer")


-- formatter
local opts = require("packages.conform").opts
opts.formatters_by_ft = opts.formatters_by_ft or {}

-- Prefer leptosfmt when present; otherwise rustfmt.
opts.formatters_by_ft.rust = { "leptosfmt", "rustfmt" }

opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
  rustfmt = {
    command = "rustfmt", -- from rustup
    stdin = true,
  },
  leptosfmt = {
    command = "leptosfmt",
    args = { "--stdin" },
    stdin = true,
    condition = function()
      return vim.fn.executable("leptosfmt") == 1
    end,
  },
})

local tools = {
  leptosfmt = "cargo install leptofmt",
  ["rust-analyzer"] = "rustup component add rust-analyzer",
}

return tools

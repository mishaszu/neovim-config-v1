return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local lsp = opts.mason_lspconfig
    local dap = opts.mason_dap
    local extend = vim.list_extend

    extend(lsp.ensure_installed, { "rust_analyzer" })
    extend(dap.ensure_installed, { "codelldb" })

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
          -- ignored = {
          --   leptos_macro = {
          --     -- optional: --
          --     "component",
          --     "server",
          --   },
          -- },
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

    vim.lsp.config["rust_analyzer"] = {
      capabilities = capabilities,
      settings = base_rust_settings,
    }
    vim.lsp.enable("rust_analyzer")
  end,
}

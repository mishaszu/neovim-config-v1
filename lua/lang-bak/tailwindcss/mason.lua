return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    local lsp = opts.mason_lspconfig
    local extend = vim.list_extend
    local util = require("lspconfig.util")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    extend(lsp.ensure_installed, { "tailwindcss" })

    -- TODO Need to fix the function
    local function has_leptos_dependency(fname)
      local cargo_toml = util.search_ancestors(fname, function(dir)
        local cargo_path = dir .. "/Cargo.toml"
        if util.path.is_file(cargo_path) then
          for line in io.lines(cargo_path) do
            if line:match("%f[%w]leptos%f[%W]") then
              return dir
            end
          end
        end
      end)
      return cargo_toml
    end

    vim.lsp.config["tailwindcss"] = {
      capabilities = capabilities,
      cmd = { "tailwindcss-language-server", "--stdio" },
      filetypes = { "html", "css", "scss", "svelte", "javascript", "typescript", "rust", "rescript" },
      -- root_dir = has_leptos_dependency,
      settings = {
        tailwindCSS = {
          includeLanguages = {
            rust = "html",
          },
          experimental = {
            configFile = "style/tailwind.css",
            classRegex = {
              "class=(?:tw_merge|tw_join)!\\(([\\s\\S]*)\\)",
            },
          },
        },
      },
    }

    vim.lsp.enable("tailwindcss")
  end,
}

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      local lsp = require("cmp_nvim_lsp")
      lsp.default_capabilities()
      cmp.setup({
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        },
        -- Installed sources:
        sources = {
          { name = "path" },                                       -- file paths
          { name = "nvim_lsp",               keyword_length = 1 }, -- from language server
          { name = "nvim_lsp_signature_help" },                    -- display function signatures with current parameter emphasized
          { name = "nvim_lua",               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
          { name = "buffer",                 keyword_length = 2 }, -- source current buffer
          { name = "vsnip",                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
          { name = "calc" },                                       -- source for math calculation
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          expandable_indicator = true,
          fields = { "menu", "abbr", "kind" },
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = "λ",
              vsnip = "⋗",
              buffer = "Ω",
              path = "🖫",
            }
            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
      })
    end,
  },
  {

    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
          if err ~= nil and err.code == -32802 then
            return
          end
          return default_diagnostic_handler(err, result, context, config)
        end
      end
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local keymap = vim.keymap -- for conciseness
      local util = require("lspconfig.util")

      local function has_leptos_dependency(fname)
        local cargo_toml = util.search_ancestors(fname, function(dir)
          local cargo_path = dir .. "/Cargo.toml"
          if util.path.is_file(cargo_path) then
            for line in io.lines(cargo_path) do
              if line:match('%f[%w]leptos%f[%W]') then
                return dir
              end
            end
          end
        end)
        return cargo_toml
      end

      local function is_leptos_project()
        local path = vim.fn.getcwd() .. "/Cargo.toml"
        local f = io.open(path, "r")
        if not f then return false end
        for line in f:lines() do
          if line:match('%f[%w]leptos%f[%W]') then
            f:close()
            return true
          end
        end
        f:close()
        return false
      end


      lspconfig.rescriptls.setup({
        cmd = { "rescript-language-server", "--stdio" },
        filetype = { "rescript" },
      })

      lspconfig.purescriptls.setup({
        settings = {
          purescript = {
            formatter = "purs-tidy",
            addSpagoSources = true, -- e.g. any purescript language-server config here
          },
        },
      })

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
            -- You can also set features to "all" if you need them:
            features = "all",
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

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = base_rust_settings,
      })

      vim.lsp.inlay_hint.enable(true)

      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if client.server_capabilities.inlayHintProvider then
      --       vim.lsp.inlay_hint.enable(true, args.buf)
      --     end
      --   end,
      -- })

      vim.keymap.set("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle Inlay Hints" })

      lspconfig.ts_ls.setup({
        cmd = { "typescript-language-server", "--stdio" }, -- Global binary
        filetypes = {
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "javascript",
          "javascriptreact",
          "javascript.jsx",
        },
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
        on_attach = function(client, bufnr)
          -- optional: disable formatting if using prettier or eslint
          client.server_capabilities.documentFormattingProvider = false
        end,
      })

      lspconfig.lua_ls.setup({
        cmd = { "lua-language-server" },
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT", -- Neovim uses LuaJIT
            },
            diagnostics = {
              globals = { "vim" }, -- Recognize `vim` global
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime
              checkThirdParty = false,                           -- To stop "Do you want to configure...?" popups
            },
            telemetry = {
              enable = false, -- Disable telemetry
            },
          },
        },
      })

      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "svelte", "javascript", "typescript", "rust" }, -- 👈 add rust
        root_dir = has_leptos_dependency,
        settings = {
          tailwindCSS = {
            includeLanguages = {
              rust = "html", -- ✅ the new correct way
            },
            experimental = {
              configFile = "style/tailwind.css",
              classRegex = {
                'class=(?:tw_merge|tw_join)!\\(([\\s\\S]*)\\)'
              }
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf, silent = true }

          -- set keybinds
          opts.desc = "Show LSP references"
          keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

          opts.desc = "Show LSP definitions"
          keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "<C-k>", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "<C-j>", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end,
      })

      -- used to enable autocompletion (assign to every lsp server config)

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      require('crates').setup()
    end,
  },
  {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          rust = { "leptosfmt", "rustfmt" }, -- will run in order
        },
        format_on_save = { timeout_ms = 1000, lsp_fallback = true },
        formatters = {
          leptosfmt = {
            command = "leptosfmt",
            args = { "--stdin" },
            stdin = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({
          async = true,
          lsp_fallback = true,
        })
      end, { desc = "Format file with conform.nvim" })
    end,
  }
}

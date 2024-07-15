return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    priority = 500,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local nvimtree = require("nvim-tree")
      local api = require("nvim-tree.api")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*", -- You can specify a file pattern here
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = buf, noremap = true, silent = true, nowait = true }
          end

          -- vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
          vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        end,
      })

      -- default mappings
      -- api.config.mappings.default_on_attach(bufnr)

      -- recommended settings from nvim-tree documentation
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      nvimtree.setup({
        view = {
          width = 35,
          relativenumber = false,
        },
        -- change folder arrow icons
        renderer = {
          indent_markers = {
            enable = true,
          },
          icons = {
            glyphs = {
              folder = {
                arrow_closed = "", -- arrow when folder is closed
                arrow_open = "", -- arrow when folder is open
              },
            },
          },
        },
        filters = {
          custom = { ".DS_Store", ".res.mjs" },
        },
        git = {
          ignore = false,
        },
        hijack_cursor = true,

        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },

        log = {
          enable = true,
          truncate = true,
          types = {
            diagnostics = true,
          },
        },
      })

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
      keymap.set("n", "<leader>n", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
      keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
      keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
    end,
  },
}

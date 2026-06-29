local fd = require("config.tools").executable("fd", "fdfind", "fd-find")

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "/target/",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob",
      "!**/target/**",
    },
  },
  pickers = {
    find_files = {
      find_command = fd and { fd, "--type", "file", "--strip-cwd-prefix", "--exclude", "target" }
        or { "rg", "--files", "--glob", "!**/target/**" },
    },
  },
  extensions = {
    fzf = {},
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "live_grep_args")

local builtin = require("telescope.builtin")
local tel = require("telescope")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fg", tel.extensions.live_grep_args.live_grep_args, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fs", builtin.resume, {})

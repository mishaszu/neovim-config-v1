vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- decrement
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- increment

-- window management
keymap.set("n", "<C-a>", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<C-s>", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to the next window" }) --  go to next tab
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to the pre window" }) --  go to previous tab
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to down window" }) --  go to previous tab
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to up window" }) --  go to previous tab

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<S-Tab>", "<cmd>tabp<CR>", { noremap = true })
keymap.set("n", "<Tab>", "<cmd>tabn<CR>", { noremap = true })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set("n", "<leader>j", "<C-i>", { desc = "Jump to the next cursor position" })

keymap.set({ "n", "v" }, "<C-ScrollWheelUp>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
keymap.set(
  { "n", "v" },
  "<C-ScrollWheelDown>",
  ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>"
)

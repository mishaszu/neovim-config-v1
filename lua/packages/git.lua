if require("config.tools").env_enabled("NVIM_ENABLE_GIT_TOOLS", false) then
  vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { desc = "Toggle git blame" })
end

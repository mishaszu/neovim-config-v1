-- Enable with NVIM_ENABLE_CODECOMPANION=1 (or the legacy NVIM_ENABLE_AI=1 shorthand).
local tools = require("config.tools")
if not (tools.env_enabled("NVIM_ENABLE_CODECOMPANION", false) or tools.env_enabled("NVIM_ENABLE_AI", false)) then
  return
end

-- Never enable AI tools when the working dir is $HOME, so codecompanion
-- can't take the whole home directory as context (e.g. editing ~/.zshrc).
if vim.fn.getcwd() == vim.fn.expand("~") then
  return
end

require("codecompanion").setup({
  strategies = {
    chat = { adapter = "copilot" },
    inline = { adapter = "copilot" },
    cmd = { adapter = "copilot" },
  },
  display = {
    chat = {
      window = {
        position = "right",
        width = 0.35,
      },
    },
  },
})

local keymap = vim.keymap

keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "CodeCompanion: toggle chat" })
keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion: actions" })
keymap.set("v", "<leader>ai", ":CodeCompanion<CR>", { desc = "CodeCompanion: inline assistant" })
keymap.set("v", "<leader>ad", "<cmd>CodeCompanionChat Add<CR>", { desc = "CodeCompanion: add selection to chat" })

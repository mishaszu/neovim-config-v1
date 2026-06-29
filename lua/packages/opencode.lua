-- Enable with NVIM_ENABLE_OPENCODE=1 (or the legacy NVIM_ENABLE_AI=1 shorthand).
local tools = require("config.tools")
if not (tools.env_enabled("NVIM_ENABLE_OPENCODE", false) or tools.env_enabled("NVIM_ENABLE_AI", false)) then
  return
end

-- Never enable AI tools when the working dir is $HOME, so opencode
-- can't take the whole home directory as context (e.g. editing ~/.zshrc).
if vim.fn.getcwd() == vim.fn.expand("~") then
  return
end

vim.o.autoread = true

-- Run OpenCode in a toggleable terminal so it can be opened/hidden on demand.
-- opencode.nvim auto-discovers this instance via its --port, so ask()/select()
-- and the keymaps below attach to the same session window.
local Terminal = require("toggleterm.terminal").Terminal
local opencode_term = Terminal:new({
  cmd = "opencode --port",
  direction = "vertical",
  close_on_exit = false,
  hidden = true,
  persist_size = false,
  highlights = {
    Normal = { guibg = "#1f1f1f" },
    NormalFloat = { guibg = "#1f1f1f" },
  },
  size = function()
    return math.max(80, math.floor(vim.o.columns * 0.4))
  end,
  on_open = function()
    vim.cmd("wincmd H")
    vim.cmd("vertical resize " .. math.max(80, math.floor(vim.o.columns * 0.4)))
    vim.wo.winblend = 0
  end,
})

local function toggle_opencode()
  opencode_term:toggle()
end

vim.g.opencode_opts = {
  server = {
    start = function()
      opencode_term:open()
    end,
  },
}

-- Safeguard: default to "untrusted" mode where OpenCode must prompt before any
-- file edit, shell command, or web access. Set via OPENCODE_CONFIG_CONTENT so it
-- outranks any project-level opencode.json. Opt into full autonomy explicitly.
if not require("config.tools").env_enabled("NVIM_AI_TRUST", false) then
  vim.env.OPENCODE_CONFIG_CONTENT = vim.json.encode({
    permission = {
      bash = "ask",
      edit = "ask",
      webfetch = "ask",
      external_directory = "deny",
    },
  })
end

local keymap = vim.keymap

keymap.set({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ")
end, { desc = "OpenCode: ask about this" })

keymap.set({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "OpenCode: select prompt" })

keymap.set("n", "<leader>on", function()
  require("opencode").command("session.new")
end, { desc = "OpenCode: new session" })

keymap.set("n", "<leader>ot", toggle_opencode, { desc = "OpenCode: toggle session window" })

keymap.set({ "n", "x" }, "go", function()
  return require("opencode").operator("@this ")
end, { desc = "OpenCode: append range", expr = true })

keymap.set("n", "goo", function()
  return require("opencode").operator("@this ") .. "_"
end, { desc = "OpenCode: append line", expr = true })

keymap.set("n", "<M-u>", function()
  require("opencode").command("session.half.page.up")
end, { desc = "OpenCode: scroll up" })

keymap.set("n", "<M-d>", function()
  require("opencode").command("session.half.page.down")
end, { desc = "OpenCode: scroll down" })

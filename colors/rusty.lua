-- colorscheme: zaibatsu-light
-- Location: ~/.config/nvim/colors/zaibatsu-light.lua

local set = vim.api.nvim_set_hl
local ns = 0

local c = {
  bg      = "#7197D0", -- light solarized base
  fg      = "231849",  -- soft dark gray
  red     = "#d70000",
  orange  = "#d75f00",
  yellow  = "#af8700",
  green   = "#5f8700",
  cyan    = "#0087af",
  blue    = "#005f87",
  violet  = "#5f5faf",
  magenta = "#875f87",
  gray    = "#d0d0d0",
}

-- UI
set(ns, "Normal", { bg = c.bg, fg = c.fg })
set(ns, "NormalFloat", { bg = "#f0ece2", fg = c.fg })
set(ns, "StatusLine", { bg = "#e6dfcb", fg = c.fg })
set(ns, "VertSplit", { fg = "#d6d6d6" })
set(ns, "CursorLine", { bg = "#f0f0f0" })
set(ns, "LineNr", { fg = "#bcbcbc" })
set(ns, "Visual", { bg = "#e0e0e0" })

-- Syntax (Treesitter-friendly)
set(ns, "@function", { fg = c.blue })
set(ns, "@keyword", { fg = c.violet, bold = true })
set(ns, "@type", { fg = c.green })
set(ns, "@constant", { fg = c.red })
set(ns, "@string", { fg = c.orange })
set(ns, "@variable", { fg = c.fg })
set(ns, "@field", { fg = c.cyan })
set(ns, "@macro", { fg = c.magenta })

-- Diagnostics
set(ns, "DiagnosticError", { fg = c.red })
set(ns, "DiagnosticWarn", { fg = c.yellow })
set(ns, "DiagnosticInfo", { fg = c.blue })
set(ns, "DiagnosticHint", { fg = c.cyan })

-- LSP
set(ns, "LspReferenceText", { bg = "#e8e8e8" })
set(ns, "LspReferenceRead", { bg = "#e8e8e8" })
set(ns, "LspReferenceWrite", { bg = "#f0e8e8" })

-- Completion menu
set(ns, "Pmenu", { bg = "#eeeeee", fg = c.fg })
set(ns, "PmenuSel", { bg = "#d6d6d6", fg = c.fg, bold = true })

-- Floating windows
set(ns, "FloatBorder", { fg = "#cccccc", bg = "#f8f8f8" })

-- Optional: link legacy groups to modern
vim.cmd([[
  hi! link Function @function
  hi! link Keyword @keyword
  hi! link Type @type
  hi! link Constant @constant
]])

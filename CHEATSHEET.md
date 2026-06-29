# Neovim Keybindings Cheat Sheet

> `<SPC>` = Space (leader) &nbsp;|&nbsp; `n` = Normal &nbsp;|&nbsp; `v` = Visual &nbsp;|&nbsp; `i` = Insert &nbsp;|&nbsp; `t` = Terminal
>
> **Print tip:** `pandoc CHEATSHEET.md -o cheatsheet.pdf --pdf-engine=wkhtmltopdf -V geometry:margin=1cm -V fontsize=9pt`
> or open in a browser and use **Print → Save as PDF**, set margins to Minimum, enable **Background graphics**.

---

## Navigation — Windows & Tabs

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | n | Go to left window |
| `<C-l>` | n | Go to right window |
| `<C-j>` | n | Go to down window |
| `<C-k>` | n | Go to up window |
| `<C-a>` | n | Split vertically |
| `<C-s>` | n | Split horizontally |
| `<SPC>se` | n | Equalize split sizes |
| `<SPC>sx` | n | Close current split |
| `<Tab>` | n | Next tab |
| `<S-Tab>` | n | Previous tab |
| `<SPC>to` | n | Open new tab |
| `<SPC>tx` | n | Close current tab |
| `<SPC>tf` | n | Open buffer in new tab |
| `<SPC>j` | n | Jump forward (Ctrl-I) |

---

## Editor — General

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>nh` | n | Clear search highlights |
| `<SPC>+` | n | Increment number |
| `<SPC>-` | n | Decrement number |

---

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<Esc><Esc>` | t | Exit terminal to normal mode |
| `<C-h/j/k/l>` | t | Navigate to window (exits insert) |

---

## File Explorer — nvim-tree

| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | n | Toggle file explorer |
| `<SPC>n` | n | Reveal current file in explorer |
| `<SPC>ec` | n | Collapse explorer |
| `<SPC>er` | n | Refresh explorer |
| `?` | n | Toggle help (inside tree) |

---

## Fuzzy Finder — Telescope

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>ff` | n | Find files |
| `<SPC>fg` | n | Live grep (with args) |
| `<SPC>fb` | n | List open buffers |
| `<SPC>fh` | n | Search help tags |
| `<SPC>fs` | n | Resume last picker |

---

## LSP — Language Server Protocol

> Active when a language server is attached to the buffer.
> Note: `<C-j>/<C-k>` override window navigation when LSP is active.

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition (Telescope) |
| `gD` | n | Go to declaration |
| `gr` | n | Show references (Telescope) |
| `gi` | n | Show implementations (Telescope) |
| `gt` | n | Show type definitions (Telescope) |
| `K` | n | Hover documentation |
| `<SPC>ca` | n/v | Code actions |
| `<SPC>rn` | n | Rename symbol |
| `<SPC>d` | n | Line diagnostics (float) |
| `<SPC>D` | n | Buffer diagnostics (Telescope) |
| `<C-j>` | n | Next diagnostic |
| `<C-k>` | n | Previous diagnostic |
| `<SPC>rs` | n | Restart LSP |
| `<SPC>uh` | n | Toggle inlay hints |

---

## Diagnostics — Trouble.nvim

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>xx` | n | Toggle workspace diagnostics |
| `<SPC>xX` | n | Toggle buffer diagnostics |
| `<SPC>cs` | n | Toggle symbols panel |
| `<SPC>cl` | n | Toggle LSP defs/refs panel |
| `<SPC>xL` | n | Toggle location list |
| `<SPC>xQ` | n | Toggle quickfix list |

---

## Completion — nvim-cmp

> Active inside the completion popup.

| Key | Action |
|-----|--------|
| `<C-n>` / `<Tab>` | Next item |
| `<C-p>` / `<S-Tab>` | Previous item |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Close completion |
| `<C-f>` | Scroll docs down |
| `<C-S-f>` | Scroll docs up |
| `<CR>` | Confirm selection |

---

## Formatting & Linting

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>cf` | n/v | Format code (conform, LSP fallback) |
| `<SPC>l` | n | Trigger linting manually |

---

## Folding — nvim-ufo

| Key | Mode | Action |
|-----|------|--------|
| `zR` | n | Open all folds |
| `zM` | n | Close all folds |

---

## Git

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>gb` | n | Toggle git blame |

---

## Sessions — auto-session

> Requires `NVIM_ENABLE_SESSION=1`

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>wr` | n | Restore session for cwd |
| `<SPC>ws` | n | Save session for cwd |

---

## Text Objects & Editing

### nvim-surround (default bindings)

| Key | Mode | Action |
|-----|------|--------|
| `ys{motion}{char}` | n | Add surrounding |
| `ds{char}` | n | Delete surrounding |
| `cs{old}{new}` | n | Change surrounding |
| `S{char}` | v | Surround selection |

### Comment.nvim (default bindings)

> Requires `NVIM_ENABLE_COMMENT=1`

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | n | Toggle line comment |
| `gbc` | n | Toggle block comment |
| `gc{motion}` | n | Comment with motion |
| `gb{motion}` | n | Block comment with motion |

---

## Color Tools

> Requires `NVIM_ENABLE_COLOR_TOOLS=1`

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>cp` | n | Open color picker |

---

## Debug Adapter Protocol (DAP)

> Requires `NVIM_ENABLE_DAP=1`

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>db` | n | Toggle breakpoint |
| `<SPC>dB` | n | Conditional breakpoint |
| `<SPC>dc` | n | Continue |
| `<SPC>da` | n | Run with args |
| `<SPC>dC` | n | Run to cursor |
| `<SPC>dg` | n | Go to line (no exec) |
| `<SPC>di` | n | Step into |
| `<SPC>do` | n | Step out |
| `<SPC>dO` | n | Step over |
| `<SPC>dj` | n | Frame down |
| `<SPC>dk` | n | Frame up |
| `<SPC>dl` | n | Run last |
| `<SPC>dp` | n | Pause |
| `<SPC>dr` | n | Toggle REPL |
| `<SPC>ds` | n | Session info |
| `<SPC>dt` | n | Terminate |
| `<SPC>dw` | n | Widgets hover |
| `<SPC>du` | n | Toggle DAP UI |
| `<SPC>de` | n/v | Evaluate expression |

---

## AI Tools

> `NVIM_ENABLE_OPENCODE=1` for OpenCode, `NVIM_ENABLE_CODECOMPANION=1` for CodeCompanion, or `NVIM_ENABLE_AI=1` for both. Also requires cwd ≠ `$HOME`

### OpenCode

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>oa` | n/x | Ask OpenCode about selection |
| `<SPC>os` | n/x | Select prompt |
| `<SPC>on` | n | New session |
| `<SPC>ot` | n | Toggle session window |
| `go` | n/x | Operator: append range |
| `goo` | n | Operator: append current line |
| `<M-u>` | n | Scroll session up |
| `<M-d>` | n | Scroll session down |

### CodeCompanion

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>ac` | n/v | Toggle chat |
| `<SPC>aa` | n/v | Actions menu |
| `<SPC>ai` | v | Inline assistant |
| `<SPC>ad` | v | Add selection to chat |

---

## Language-Specific — Haskell

> Buffer-local, filetype `haskell`

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>cl` | n | Run codelens |
| `<SPC>hs` | n | Hoogle signature search |
| `<SPC>ea` | n | Evaluate all |
| `<SPC>rr` | n | Toggle REPL |
| `<SPC>rf` | n | Toggle REPL (current file) |
| `<SPC>rq` | n | Quit REPL |
| `<SPC>rt` | n | Run `cabal test` |
| `<SPC>rg` | n | Run `ghcid` |

---

## Language-Specific — PureScript

> Buffer-local, filetype `purescript`

| Key | Mode | Action |
|-----|------|--------|
| `<SPC>rr` | n | Toggle spago REPL |
| `<SPC>rt` | n | Run `spago test` |
| `<SPC>rb` | n | Run PureScript build |
| `<SPC>ca` | n/v | PureScript code action |
| `<SPC>rl` | n | Send line to REPL |
| `<SPC>rs` | v | Send selection to REPL |

---

## Neovide (GUI only)

| Key | Mode | Action |
|-----|------|--------|
| `<C-ScrollWheelUp>` | n/v | Zoom in |
| `<C-ScrollWheelDown>` | n/v | Zoom out |

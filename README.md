## Required external tools

This config uses Neovim's native package manager for plugins, but language
servers, formatters, linters, and search/build binaries are still installed by
the system package manager or language toolchains.

Missing tools are reported with `vim.notify()` during startup. Language-specific
tool checks are controlled by environment variables so the same config can run
on machines that do not use every language.

### Always checked

- `tree-sitter` >= 0.26.1: `sudo pacman -S tree-sitter-cli`
- `fzf`: `sudo pacman -S fzf`
- `rg`: `sudo pacman -S ripgrep`
- `fd`: `sudo pacman -S fd`
- `make`: `sudo pacman -S make`
- `gcc`: `sudo pacman -S gcc`

### Language groups

Enabled by default:

- `NVIM_ENABLE_LUA=1`
  - `lua-language-server`: `sudo pacman -S lua-language-server`
  - `stylua`: `sudo pacman -S stylua`
- `NVIM_ENABLE_RUST=1`
  - `cargo`: `rustup toolchain install stable`
  - `rust-analyzer`: `rustup component add rust-analyzer`
  - `rustfmt`: `rustup component add rustfmt`
  - `leptosfmt`: `cargo install leptosfmt`, checked only in Leptos projects or with `NVIM_ENABLE_LEPTOS=1`

Disabled by default:

- `NVIM_ENABLE_TYPESCRIPT=1`
  - enables `ts_ls`, JS/TS/TSX treesitter parsers, and Prettier for JS/TS files
  - `typescript-language-server`: `npm install -g typescript-language-server typescript`
  - `prettier`: `npm install -g prettier`
- `NVIM_ENABLE_WEB=1`
  - enables web formatting and JS/TS/Svelte linting with `eslint_d`
  - `prettier`: `npm install -g prettier`
  - `eslint_d`: `npm install -g eslint_d`
- `NVIM_ENABLE_RESCRIPT=1`
  - enables Rescript filetype support, treesitter parser config, and LSP
  - `rescript-language-server`: `npm install -g @rescript/language-server`
- `NVIM_ENABLE_TAILWIND=1`
  - enables Tailwind CSS language server with Rust/Leptos class regex support
  - `tailwindcss-language-server`: `npm install -g @tailwindcss/language-server`
  - optional explicit config or CSS entrypoint: `NVIM_TAILWIND_CONFIG_FILE=style/tailwind.css`
- `NVIM_ENABLE_WASM=1`
  - enables WAT/WASM syntax and `wasm_language_tools`
  - `wasm-language-tools`: `cargo install wasm-language-tools`
- `NVIM_ENABLE_HASKELL=1`
  - enables Haskell tools integration, REPL helpers, formatting, linting, and test commands
  - `cabal`: `ghcup install cabal`
  - `haskell-language-server-wrapper`: `ghcup install hls`
  - `ormolu`: `cabal install ormolu`
  - `hlint`: `cabal install hlint`
  - `hoogle`: `cabal install hoogle`
  - `ghcid`: `cabal install ghcid`
  - `doctest`: `cabal install doctest`
- `NVIM_ENABLE_PURESCRIPT=1`
  - enables PureScript LSP, formatting, filetype support, REPL helpers, and test commands
  - `purescript-language-server`: `npm install -g purescript-language-server`
  - `purs`: `npm install -g purescript`
  - `spago`: `npm install -g spago@next`
  - `purs-tidy`: `npm install -g purs-tidy`
- `NVIM_ENABLE_PYTHON=1`
  - enables Python linting with `pylint`
  - install with `python -m pip install pylint`
- `NVIM_ENABLE_DAP=1`
  - enables shared nvim-dap keymaps, DAP UI, virtual text, and Rust codelldb config
  - `codelldb`: `sudo pacman -S codelldb`
- `NVIM_ENABLE_GIT_TOOLS=1`
  - enables Fugitive and a git-blame toggle keymap; git-blame virtual text starts disabled
- `NVIM_ENABLE_SESSION=1`
  - enables auto-session restore/save keymaps
- `NVIM_ENABLE_COMMENT=1`
  - enables Comment.nvim with treesitter-aware comment strings
- `NVIM_ENABLE_COLOR_TOOLS=1`
  - enables color picker and colorizer plugins
- `NVIM_ENABLE_OPENCODE=1`
  - enables OpenCode integration with keymaps
  - `opencode`: `npm install -g opencode-ai` (or see https://opencode.ai)
  - full key bindings and setup in [AI_TOOLS.md](AI_TOOLS.md)
- `NVIM_ENABLE_CODECOMPANION=1`
  - enables CodeCompanion (chat/inline/actions) with keymaps
  - uses the Copilot adapter by default (`gh auth login` / `:Copilot auth`)
  - full key bindings and setup in [AI_TOOLS.md](AI_TOOLS.md)
- `NVIM_ENABLE_AI=1`
  - shorthand that enables **both** OpenCode and CodeCompanion at once

Set any group to `0`, `false`, `no`, or `off` to disable it. Example:

```sh
NVIM_ENABLE_RUST=0 nvim
NVIM_ENABLE_HASKELL=1 NVIM_ENABLE_PURESCRIPT=1 nvim
NVIM_ENABLE_TYPESCRIPT=1 NVIM_ENABLE_WEB=1 NVIM_ENABLE_TAILWIND=1 nvim
NVIM_ENABLE_DAP=1 NVIM_ENABLE_GIT_TOOLS=1 nvim
```

For Rust Leptos projects, Tailwind support is enabled automatically when the
current Cargo workspace contains a `leptos` dependency. You can also force it
with:

```sh
NVIM_ENABLE_TAILWIND=1 nvim
```

The Tailwind language server is configured to attach to Rust files and scan
Leptos-style `class="..."`, `class:hidden=...`, `class={...}`, and
`tw_merge!`/`tw_join!` class strings. By default it lets the language server
auto-detect Tailwind v4 CSS entrypoints or v3 config files. Set
`NVIM_TAILWIND_CONFIG_FILE` only when autodetection does not find the right
stylesheet or config.

To debug Tailwind LSP attachment inside Neovim:

```vim
:TailwindDebug
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

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
- `NVIM_ENABLE_WEB=1`
  - enables JS/TS/Svelte linting with `eslint_d`
  - install with `npm install -g eslint_d`
- `NVIM_ENABLE_PYTHON=1`
  - enables Python linting with `pylint`
  - install with `python -m pip install pylint`

Set any group to `0`, `false`, `no`, or `off` to disable it. Example:

```sh
NVIM_ENABLE_RUST=0 nvim
NVIM_ENABLE_HASKELL=1 NVIM_ENABLE_PURESCRIPT=1 nvim
NVIM_ENABLE_WEB=1 NVIM_ENABLE_PYTHON=1 nvim
```

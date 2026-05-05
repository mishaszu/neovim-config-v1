# Native Package Migration

This config has been moved from `lazy.nvim` plus Mason-managed tool installers
to Neovim's native `vim.pack` package manager.

## Current Structure

- `init.lua`: startup order and global bootstrap.
- `lua/config/packages.lua`: all native package declarations and shared UI setup.
- `lua/packages/*.lua`: plugin setup modules.
- `lua/config/langs.lua`: language group orchestration, treesitter setup, and external tool warnings.
- `lua/langs/*.lua`: language-specific LSP, formatter, linter, parser, and tool declarations.
- `lua/config/tools.lua`: env flag parsing and missing-tool warnings.

## Defaults

Enabled by default:

- core tools and plugins
- Lua
- Rust

Disabled by default:

- Haskell, PureScript, TypeScript, Web, Rescript, Tailwind, Wasm
- DAP UI
- Git extras
- sessions
- comments
- color tools

Enable optional groups with environment variables such as:

```sh
NVIM_ENABLE_TYPESCRIPT=1 NVIM_ENABLE_WEB=1 nvim
NVIM_ENABLE_HASKELL=1 NVIM_ENABLE_PURESCRIPT=1 nvim
NVIM_ENABLE_DAP=1 nvim
```

Use `0`, `false`, `no`, or `off` to disable a default group.

## Mason Replacement

Mason no longer installs tools. Language servers, formatters, linters, REPLs,
and debug adapters are expected on `PATH`. Missing tools are reported through
startup warnings from `config.tools.warn_missing()`.

## Dropped Old Behavior

- `transparent.nvim` was not migrated. Float readability is handled directly
  with `NormalFloat`, `FloatBorder`, and `Pmenu` highlights.
- Old lazy/mason backup trees were removed after porting and validation.

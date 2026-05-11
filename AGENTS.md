# Lua / Neovim Agent Environment

This project can be used with the `codex-nvim-lua:latest` image built from `Dockerfile.codex-nvim-lua`.

## Available Tools

- Lua runtime and compiler: `lua`, `luac` using Lua 5.4
- Lua package tooling: `luarocks`
- Lua formatting and linting: `stylua`, `luacheck`
- Neovim: `nvim`
- Treesitter tooling: `tree-sitter`
- JavaScript runtime support for Neovim plugins and tooling: `node`, `npm`
- Fish shell tooling: `fish`, `fish_indent`
- Shell linting: `shellcheck`
- General shell and inspection tools: `bash`, `git`, `rg`, `fd`, `jq`, `less`, `file`, `strace`, `procps`, `fzf`, `entr`
- Archive and build tooling: `unzip`, `tar`, `gzip`, `xz-utils`, `build-essential`, `pkg-config`
- Python support: `python3`, `python3-pip`, `python3-venv`
- Codex CLI: `codex`

## Not Available

The image is intentionally focused on Lua and Neovim configuration or plugin validation and does not install infrastructure or container orchestration tools.

- `docker` is not available inside the image.
- `kubectl` is not available inside the image.
- `helm` is not available inside the image.

Do not assume access to a Docker daemon or Kubernetes cluster from this environment. If validation needs those tools, report that they are unavailable rather than trying to install or invoke them.

## Recommended Validation

- Run `stylua --check .` for formatting when the project uses StyLua.
- Run `luacheck .` for Lua linting when a `.luacheckrc` or compatible project layout exists.
- Run Neovim-based checks with `nvim --headless` when the project provides plugin or config tests.
- Run `fish_indent --check` for Fish scripts and `shellcheck` for POSIX shell scripts when applicable.

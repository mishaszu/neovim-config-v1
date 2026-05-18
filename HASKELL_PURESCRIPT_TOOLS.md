# Haskell and PureScript Tools

This Neovim config does not install language servers, formatters, linters,
REPLs, or test runners. Install them with your system package manager or
language toolchain, then enable the matching Neovim language group.

The Neovim integration is intentionally small:

- Haskell uses `haskell-tools.nvim` for HLS, Hoogle, and REPL integration.
- PureScript uses `purescript-language-server` plus a `spago repl` terminal.
- Long-running REPL/test processes run through `toggleterm.nvim`.
- All Haskell/PureScript keymaps are buffer-local and only exist when the
  matching filetype is open and the matching env flag is enabled.

## Symbol Shortcuts

Haskell and PureScript buffers include buffer-local insert-mode shortcuts for
common type and logic symbols. Type the shortcut while in insert mode to insert
the symbol.

| Shortcut | Symbol | Meaning |
| --- | --- | --- |
| `\fa` | `∀` | forall |
| `\forall` | `∀` | forall |
| `\ex` | `∃` | exists |
| `\lam` | `λ` | lambda |
| `\to` | `→` | right arrow |
| `\implies` | `⇒` | implies |
| `\gets` | `←` | left arrow |
| `\::` | `∷` | type annotation |
| `\.` | `∘` | composition |
| `\and` | `∧` | and |
| `\or` | `∨` | or |
| `\not` | `¬` | not |

## Enable the Config

For fish:

```fish
set -Ux NVIM_ENABLE_HASKELL 1
set -Ux NVIM_ENABLE_PURESCRIPT 1
```

For a single shell session:

```sh
NVIM_ENABLE_HASKELL=1 NVIM_ENABLE_PURESCRIPT=1 nvim
```

## Haskell

Recommended installer:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Install the required tools:

```sh
ghcup install hls
ghcup install cabal
cabal update
cabal install ormolu
cabal install hlint
cabal install hoogle
cabal install ghcid
cabal install doctest
```

Expected commands on `PATH`:

```sh
haskell-language-server-wrapper --version
cabal --version
ormolu --version
hlint --version
hoogle --version
ghcid --version
doctest --version
```

### Haskell Project Setup

Open Neovim from the project root when possible. HLS and tools generally expect
one of these project files:

- `cabal.project`
- `*.cabal`
- `stack.yaml`
- `hie.yaml`

For a simple Cabal project:

```sh
cabal init
cabal build
```

If HLS fails to find the project, add an explicit `hie.yaml` later. For ordinary
Cabal projects this is usually not necessary.

### Haskell Neovim Workflow

- `<leader>rr`: toggle Haskell REPL
- `<leader>rf`: toggle Haskell REPL loaded with the current file
- `<leader>rq`: quit Haskell REPL
- `<space>hs`: Hoogle signature search
- `<space>ea`: evaluate all HLS eval snippets in the current buffer
- `<leader>rt`: run `cabal test` in a terminal
- `<leader>rg`: run `ghcid` in a terminal

Buffer-local commands:

```vim
:HaskellTest
:HaskellGhcid
```

### Evaluating Pure Haskell Expressions

There are two useful workflows.

Use the Haskell REPL for quick one-off expressions:

1. Open a Haskell file.
2. Press `<leader>rf` to open a REPL with the current file loaded.
3. Type expressions directly in the terminal, for example:

```haskell
f 41
map (+1) [1, 2, 3]
```

Use HLS eval snippets when you want examples stored beside the code:

HLS eval snippets are useful for checking pure function output inline:

```haskell
f :: Int -> Int
f x = x + 1

-- >>> f 41
-- 42

-- >>> map (+1) [1, 2, 3]
-- [2,3,4]
```

After writing snippets like this, press `<space>ea` to evaluate them. HLS will
update the result comments.

### Haskell Tests

Use `<leader>rt` or:

```vim
:HaskellTest
```

This runs:

```sh
cabal test
```

Use `<leader>rg` or:

```vim
:HaskellGhcid
```

This runs:

```sh
ghcid
```

`ghcid` is useful while editing because it keeps rebuilding and reporting errors
as files change.

## PureScript

Install Node.js first if it is not already available. Then install the required
PureScript tools:

```sh
npm install -g purescript
npm install -g spago@next
npm install -g purescript-language-server
npm install -g purs-tidy
```

Expected commands on `PATH`:

```sh
purs --version
spago --version
purescript-language-server --version
purs-tidy --version
```

### PureScript Project Setup

Open Neovim from a Spago project root. The project should usually contain:

- `spago.yaml`
- `package.json`, if using npm scripts or local JS tooling
- source files under `src/`
- test files under `test/`

Create or initialize a project outside Neovim as needed:

```sh
spago init
spago build
```

### PureScript Neovim Workflow

- `<leader>rr`: toggle `spago repl`
- `<leader>rt`: run `spago test` in a terminal
- `<leader>rl`: send the current line to `spago repl`
- visual `<leader>rs`: send the selected text to `spago repl`

Buffer-local commands:

```vim
:PursRepl
:PursTest
:PursSendLine
:PursSendSelection
```

### Evaluating PureScript Expressions

Start the REPL:

```vim
:PursRepl
```

or press `<leader>rr`.

Then send expressions from a PureScript buffer:

```purescript
map (_ + 1) [1, 2, 3]
```

With the cursor on that line, press `<leader>rl`. For multi-line expressions,
select the lines visually and press `<leader>rs`.

The expression is sent to:

```sh
spago repl
```

This keeps evaluation scoped to the current Spago project.

### PureScript Tests

For test suites:

```sh
spago install --test-deps spec spec-node
spago test
```

Inside Neovim, use `<leader>rt` or:

```vim
:PursTest
```

This runs:

```sh
spago test
```

## Formatting and Linting

Formatting is handled by `conform.nvim`.

Haskell:

- formatter: `ormolu`
- configured filetype: `haskell`

PureScript:

- formatter: `purs-tidy`
- configured filetype: `purescript`

Linting is handled by `nvim-lint`.

Haskell:

- linter: `hlint`

PureScript:

- no separate linter is currently configured
- diagnostics come from `purescript-language-server`

Missing linters are skipped after the startup warning, so opening a file should
not fail just because a linter is absent.

## Troubleshooting

Check whether the language group is enabled:

```vim
:lua print(vim.env.NVIM_ENABLE_HASKELL)
:lua print(vim.env.NVIM_ENABLE_PURESCRIPT)
```

Check filetype:

```vim
:set filetype?
```

Expected values:

- Haskell: `haskell`
- PureScript: `purescript`

Check whether commands exist in a language buffer:

```vim
:HaskellTest
:HaskellGhcid
:PursRepl
:PursTest
```

If a command does not exist:

1. Confirm the env flag is enabled before starting Neovim.
2. Confirm the filetype is correct.
3. Restart Neovim from the project root.

Check LSP state:

```vim
:checkhealth vim.lsp
:LspInfo
```

Common missing command warnings:

- `haskell-language-server-wrapper`: install HLS with GHCup.
- `ormolu`: install with Cabal.
- `hlint`: install with Cabal.
- `hoogle`: install with Cabal.
- `ghcid`: install with Cabal.
- `purescript-language-server`: install with npm.
- `purs`: install with npm.
- `spago`: install with npm.
- `purs-tidy`: install with npm.

## Verify in Neovim

Run:

```sh
NVIM_ENABLE_HASKELL=1 NVIM_ENABLE_PURESCRIPT=1 nvim
```

If any command is missing, Neovim will show a startup warning with the install
hint used by this config.

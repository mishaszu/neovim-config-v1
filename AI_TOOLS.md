# AI Tools (CodeCompanion + OpenCode)

This config ships two complementary AI integrations that can be enabled
independently or together.

- **CodeCompanion** — in-editor chat, inline assistant, and action palette.
- **OpenCode** — pairs Neovim with the [OpenCode](https://opencode.ai) TUI/agent.

Both disabled by default. Enable them independently:

```sh
NVIM_ENABLE_OPENCODE=1 nvim          # OpenCode only
NVIM_ENABLE_CODECOMPANION=1 nvim     # CodeCompanion only
NVIM_ENABLE_AI=1 nvim                # both (legacy shorthand)
```

Set to `0`, `false`, `no`, or `off` to disable.

## Setup

### CodeCompanion

Uses the GitHub Copilot adapter for chat, inline, and cmd strategies. Authenticate
once:

- `gh auth login`, or
- `:Copilot auth` if you use the Copilot plugin.

Switch adapters by editing `lua/packages/codecompanion.lua` (e.g. `openai`,
`anthropic`) and exporting the relevant API key (`OPENAI_API_KEY`,
`ANTHROPIC_API_KEY`, ...).

### OpenCode

Install the `opencode` CLI and make sure it is on your `PATH`:

```sh
npm install -g opencode-ai
```

See https://opencode.ai for other install methods. Verify inside Neovim with
`:checkhealth opencode`. `autoread` is enabled automatically so external edits
made by OpenCode reload in your buffers.

#### Untrusted mode (default)

By default OpenCode runs in a locked-down mode: it must **ask** before editing
files, running shell commands, or fetching URLs, and it is **denied** access to
paths outside the project. This is enforced via the `OPENCODE_CONFIG_CONTENT` env
var set in `lua/packages/opencode.lua`.

It uses inline config because that tier outranks any project-level `opencode.json`
in OpenCode's precedence order, so a checked-in repo config cannot loosen the
fuse. (The only stricter tier is admin-managed config under
`/Library/Application Support/opencode/` or `/etc/opencode/`.)

To allow OpenCode to act autonomously (only in repos you fully trust), opt in:

```sh
NVIM_ENABLE_OPENCODE=1 NVIM_AI_TRUST=1 nvim
```

Tighten or relax the rules by editing the `permission` table; values are `"ask"`,
`"allow"`, or `"deny"`. See https://opencode.ai/docs/permissions.

## Key bindings

### CodeCompanion

| Mapping        | Mode | Action                          |
| -------------- | ---- | ------------------------------- |
| `<leader>ac`   | n, v | Toggle chat window              |
| `<leader>aa`   | n, v | Open actions palette            |
| `<leader>ai`   | v    | Inline assistant on selection   |
| `<leader>ad`   | v    | Add selection to the chat       |

### OpenCode

| Mapping        | Mode | Action                          |
| -------------- | ---- | ------------------------------- |
| `<leader>oa`   | n, x | Ask about cursor/selection      |
| `<leader>os`   | n, x | Select a built-in/custom prompt |
| `<leader>ot`   | n    | Toggle session window           |
| `<leader>on`   | n    | Start a new session             |
| `go`           | n, x | Append range to OpenCode        |
| `goo`          | n    | Append current line             |
| `<M-u>`        | n    | Scroll OpenCode up              |
| `<M-d>`        | n    | Scroll OpenCode down            |

Leader is `<space>`.

## Files

- `lua/packages/codecompanion.lua`
- `lua/packages/opencode.lua`

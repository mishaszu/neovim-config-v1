local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()
  return content
end

local function has_tailwind_import(path)
  local content = read_file(path)
  return content and (content:match("@import%s+['\"]tailwindcss") or content:match("@tailwind%s+utilities"))
end

local function find_tailwind_config_file()
  if vim.env.NVIM_TAILWIND_CONFIG_FILE and vim.env.NVIM_TAILWIND_CONFIG_FILE ~= "" then
    return vim.env.NVIM_TAILWIND_CONFIG_FILE
  end

  local cwd = vim.fn.getcwd()
  local candidates = {
    "style/tailwind.css",
    "styles/tailwind.css",
    "src/tailwind.css",
    "src/style.css",
    "src/styles.css",
    "input.css",
    "app.css",
  }

  for _, candidate in ipairs(candidates) do
    local path = cwd .. "/" .. candidate
    if vim.uv.fs_stat(path) and has_tailwind_import(path) then
      return path
    end
  end

  if vim.fn.executable("fd") == 1 then
    local files = vim.fn.systemlist({ "fd", "--type", "file", "--extension", "css", ".", cwd })
    if vim.v.shell_error == 0 then
      for _, path in ipairs(files) do
        if has_tailwind_import(path) then
          return path
        end
      end
    end
  end

  return nil
end

local config_file = find_tailwind_config_file()

local experimental = {
  classRegex = {
    'class\\s*=\\s*"([^"]*)"',
    'class\\s*=\\s*\\{\\s*"([^"]*)"',
    'class\\s*=\\s*move\\s*\\|\\|\\s*"([^"]*)"',
    'class\\s*=\\s*format!\\("([^"]*)"',
    "class:([A-Za-z0-9_:\\-\\[\\]\\/\\.]+)",
    "class=(?:tw_merge|tw_join)!\\(([\\s\\S]*)\\)",
    { "class=(?:tw_merge|tw_join)!\\(([\\s\\S]*)\\)", '"([^"]*)"' },
  },
}

if config_file and config_file ~= "" then
  experimental.configFile = config_file
end

vim.lsp.config("tailwindcss", {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "svelte", "javascript", "typescript", "rust", "rescript" },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "package.json",
    "Cargo.toml",
    ".git",
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        rust = "html",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "class:.*",
      },
      experimental = experimental,
    },
  },
})

vim.lsp.enable("tailwindcss")

vim.api.nvim_create_user_command("TailwindDebug", function()
  local clients = vim
    .iter(vim.lsp.get_clients({ bufnr = 0 }))
    :map(function(client)
      return client.name
    end)
    :totable()

  vim.print({
    cwd = vim.fn.getcwd(),
    filetype = vim.bo.filetype,
    executable = vim.fn.executable("tailwindcss-language-server"),
    env_enabled = vim.env.NVIM_ENABLE_TAILWIND,
    env_config_file = vim.env.NVIM_TAILWIND_CONFIG_FILE,
    resolved_config_file = config_file,
    active_clients = clients,
    config = vim.lsp.config.tailwindcss,
  })
end, {})

local tools = {
  ["tailwindcss-language-server"] = "npm install -g @tailwindcss/language-server",
}

return tools

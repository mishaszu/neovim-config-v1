local opts = require("packages.conform").opts
opts.formatters_by_ft = opts.formatters_by_ft or {}

for _, ft in ipairs({ "svelte", "css", "html", "json", "yaml", "markdown", "graphql", "liquid" }) do
  opts.formatters_by_ft[ft] = { "prettier" }
end

local tools = {
  prettier = "npm install -g prettier",
}

return tools

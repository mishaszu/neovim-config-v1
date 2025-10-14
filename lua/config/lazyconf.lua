local bootstrap = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local generate_import_specs = function()
  local specs = {}

  local function add_specs_from_dir(path)
    local uv = vim.loop
    local dir, err = uv.fs_opendir(vim.fn.stdpath("config") .. "/" .. "lua" .. "/" .. path, nil, 1000)

    if dir == nil then
      return
    end

    local stats = uv.fs_readdir(dir)
    if not stats then
      return
    end

    for _, stat in ipairs(stats) do
      -- print(stat.name)
      if stat.type == "directory" then
        local new_import_path = path .. "/" .. stat.name
        table.insert(specs, { import = new_import_path:gsub("/", ".") })
        add_specs_from_dir(new_import_path)
      elseif stat.name == "init.lua" then
        table.remove(specs) -- removes last element
      end
    end
  end

  add_specs_from_dir("plugins")
  add_specs_from_dir("lang")
  -- print(vim.inspect(specs))

  return specs
end

bootstrap()

require("lazy").setup({ spec = generate_import_specs() }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    },
  },
})

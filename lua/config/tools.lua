local M = {}

local function normalize(value)
  if value == nil then
    return nil
  end
  return tostring(value):lower()
end

function M.env_enabled(name, default)
  local value = normalize(vim.env[name])
  if value == nil or value == "" then
    return default
  end
  return not vim.tbl_contains({ "0", "false", "no", "off" }, value)
end

function M.lang_enabled(lang, default)
  return M.env_enabled("NVIM_ENABLE_" .. lang:upper(), default)
end

local function version_tuple(version)
  local major, minor, patch = version:match("(%d+)%.(%d+)%.(%d+)")
  return tonumber(major), tonumber(minor), tonumber(patch)
end

local function version_lt(actual, required)
  local actual_major, actual_minor, actual_patch = version_tuple(actual)
  local required_major, required_minor, required_patch = version_tuple(required)

  if not actual_major or not required_major then
    return false
  end

  if actual_major ~= required_major then
    return actual_major < required_major
  end
  if actual_minor ~= required_minor then
    return actual_minor < required_minor
  end
  return actual_patch < required_patch
end

function M.warn_missing(tools)
  for bin, spec in pairs(tools) do
    local install_cmd = spec.install or spec

    if vim.fn.executable(bin) == 0 then
      vim.notify(bin .. " not found. Install with: " .. install_cmd, vim.log.levels.WARN)
    elseif spec.min_version and spec.version_cmd then
      local output = vim.fn.system(spec.version_cmd)
      if vim.v.shell_error == 0 and version_lt(output, spec.min_version) then
        vim.notify(
          bin .. " is too old. Required >= " .. spec.min_version .. ". Install with: " .. install_cmd,
          vim.log.levels.WARN
        )
      end
    end
  end
end

function M.extend(target, source)
  return vim.tbl_extend("force", target, source or {})
end

return M

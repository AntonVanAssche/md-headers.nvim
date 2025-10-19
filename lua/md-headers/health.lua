local ts_config = require("nvim-treesitter.config")
local config = require("md-headers.model.config").values

local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local clean_path = function(input)
  local path = vim.fn.fnamemodify(input, ":p")
  if vim.fn.has("win32") == 1 then
    path = path:gsub("/", "\\")
  end

  return path
end

local check_ts_is_installed = function()
  return pcall(require, "nvim-treesitter")
end

local check_ts_parser_is_installed = function(lang)
  local matched_parsers = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", true) or {}
  local install_dir = ts_config.get_install_dir()
  if not install_dir then
    return false
  end

  install_dir = clean_path(install_dir)
  for _, path in ipairs(matched_parsers) do
    local abspath = clean_path(path)
    if vim.startswith(abspath, install_dir) then
      return true
    end
  end

  return false
end

local is_hex_color = function(color)
  return type(color) == "string" and color:match("^#%x%x%x%x%x%x$") ~= nil
end

local get_utf8_len = function(str)
  local _, count = string.gsub(str, "[%z\1-\127\194-\244][\128-\191]*", "")
  return count
end

local check_width = function()
  return type(config.width) == "number" and config.width > 0
end

local check_height = function()
  return type(config.height) == "number" and config.height > 0
end

local check_borderchars_len = function()
  return type(config.borderchars) == "table" and #config.borderchars == 8
end

local check_borderchars_chars = function()
  local borderchars = config.borderchars
  for _, char in ipairs(borderchars) do
    if type(char) ~= "string" or get_utf8_len(char) > 1 then
      return false
    end
  end

  return true
end

local check_headerchars_len = function()
  return type(config.headerchars) == "table" and #config.headerchars == 6
end

local check_headerchars_chars = function()
  local headerchars = config.headerchars
  for _, char in ipairs(headerchars) do
    if type(char) ~= "string" then
      return false
    end
  end

  return true
end

local check_popup_auto_close = function()
  return type(config.popup_auto_close) == "boolean"
end

local check_highlight_groups = function()
  if type(config.highlight_groups) ~= "table" then
    return false
  end

  local valid_highlight_keys = { "title", "border", "text" }
  for _, key in ipairs(valid_highlight_keys) do
    local group = config.highlight_groups[key]
    if
      group == nil
      or (group.fg ~= nil and not is_hex_color(group.fg))
      or (group.bg ~= nil and not is_hex_color(group.bg))
    then
      return false
    end
  end

  return true
end

M.check = function()
  start("Treesitter:")
  if check_ts_is_installed() then
    ok("Treesitter installed")
  else
    error("Treesitter not installed")
  end

  if check_ts_parser_is_installed("markdown") then
    ok("Markdown parser installed")
  else
    error("Markdown parser not installed")
  end

  if check_ts_parser_is_installed("html") then
    ok("HTML parser installed")
  else
    error("HTML parser not installed")
  end

  start("Config:")
  if check_width() then
    ok("Width is a positive number")
  else
    error("Width is not a positive number, got " .. vim.inspect(config.width))
  end

  if check_height() then
    ok("Height is a positive number")
  else
    error("Height is not a positive number, got " .. vim.inspect(config.height))
  end

  if check_borderchars_len() then
    ok("Borderchars is a table with 8 elements")
  else
    error("Borderchars is not a table with 8 elements, got " .. #config.borderchars)
  end

  if check_borderchars_chars() then
    ok("Borderchars elements are strings with length 0 or 1")
  else
    warn(
      "Borderchars elements are not strings with length 0 or 1, got: "
        .. vim.inspect(config.borderchars)
    )
  end

  if check_headerchars_len() then
    ok("Headerchars is a table with 6 elements")
  else
    error("Headerchars is not a table with 6 elements, got " .. #config.headerchars)
  end

  if check_headerchars_chars() then
    ok("Headerchars elements are strings")
  else
    warn("Headerchars elements are not strings, got: " .. vim.inspect(config.headerchars))
  end

  if check_popup_auto_close() then
    ok("Popup_auto_close is a boolean")
  else
    error("Popup_auto_close is not a boolean, got " .. vim.inspect(config.popup_auto_close))
  end

  if check_highlight_groups() then
    ok("Highlight groups are valid")
  else
    error("Highlight groups are not valid, got: " .. vim.inspect(config.highlight_groups))
  end
end

return M

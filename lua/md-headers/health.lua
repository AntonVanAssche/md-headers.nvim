local ts_config = require("nvim-treesitter.configs")
local config = require("md-headers.config").config

local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local error = vim.health.error or vim.health.report_error

local _clean_path = function(input)
  local path = vim.fn.fnamemodify(input, ":p")
  if vim.fn.has("win32") == 1 then
    path = path:gsub("/", "\\")
  end

  return path
end

local _ts_is_installed = function()
  local _is_installed, _ = pcall(require, "nvim-treesitter")
  return _is_installed
end

local _ts_parser_is_installed = function(lang)
  local matched_parsers = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", true) or {}
  local install_dir = ts_config.get_parser_install_dir()
  if not install_dir then
    return false
  end

  install_dir = _clean_path(install_dir)
  for _, path in ipairs(matched_parsers) do
    local abspath = _clean_path(path)
    if vim.startswith(abspath, install_dir) then
      return true
    end
  end

  return false
end

local _is_hex_color = function(color)
  return type(color) == "string" and color:match("^#%x%x%x%x%x%x$") ~= nil
end

local _get_utf8_len = function(str)
  if str == "" then
    return 0
  end

  local _, count = string.gsub(str, "[%z\1-\127\194-\244][\128-\191]*", "")
  return count
end

local _check_width = function()
  return type(config.width) == "number" and config.width > 0
end

local _check_height = function()
  return type(config.height) == "number" and config.height > 0
end

local _check_borderchars_len = function()
  return type(config.borderchars) == "table" and #config.borderchars == 8
end

local _check_borderchars_chars = function()
  local borderchars = config.borderchars
  for _, char in ipairs(borderchars) do
    if _get_utf8_len(char) ~= 1 or #char == 0 then
      return false
    end
  end

  return true
end

local _check_popup_auto_close = function()
  return type(config.popup_auto_close) == "boolean"
end

local _check_highlight_groups = function()
  if type(config.highlight_groups) ~= "table" then
    return false
  end

  local valid_highlight_keys = { "title", "border", "text" }
  for _, key in ipairs(valid_highlight_keys) do
    local group = config.highlight_groups[key]
    if
      group == nil
      or (group.fg ~= nil and not _is_hex_color(group.fg))
      or (group.bg ~= nil and not _is_hex_color(group.bg))
    then
      return false
    end
  end
  return true
end

M.check = function()
  start("Treesitter:")
  if _ts_is_installed() then
    ok("Treesitter installed")
  else
    error("Treesitter not installed")
  end

  if _ts_parser_is_installed("html") then
    ok("HTML parser installed")
  else
    error("HTML parser not installed")
  end

  if _ts_parser_is_installed("markdown") then
    ok("Markdown parser installed")
  else
    error("Markdown parser not installed")
  end

  start("Config:")

  local checks = {
    { _check_width, "Width should be a positive number, got: " .. vim.inspect(config.width) },
    { _check_height, "Height should be a positive number, got: " .. vim.inspect(config.height) },
    {
      _check_borderchars_len,
      "Borderchars should be a table with length of 8, got: " .. #config.borderchars,
    },
    {
      _check_borderchars_chars,
      "Borderchars should be a table of 8 single characters, got: "
        .. vim.inspect(config.borderchars),
    },
    {
      _check_popup_auto_close,
      "Popup auto close should be a boolean, got: " .. vim.inspect(config.popup_auto_close),
    },
    {
      _check_highlight_groups,
      "Highlight groups should be a valid table, got: " .. vim.inspect(config.highlight_groups),
    },
  }

  for _, check in ipairs(checks) do
    local validator, error_message = check[1], check[2]
    if validator() then
      ok(error_message:match("^[^,]+"))
    else
      error(error_message)
    end
  end
end

return M

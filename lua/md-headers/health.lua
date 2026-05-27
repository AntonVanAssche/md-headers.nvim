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

local check_indent = function()
  return type(config.indent) == "number" and config.indent >= 0
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

local function check_highlight_error(value)
  local success, error_message = pcall(function()
    vim.api.nvim_set_hl(0, "MarkdownHeadersHealthCheck", value)
  end)
  if success then
    return nil
  end

  local stripped_message = string.match(error_message, "health%.lua:%d+:%s*(.*)")
  return stripped_message or error_message
end

local check_highlight_groups = function()
  if type(config.highlight_groups) ~= "table" then
    error("Highlight groups are not a table, got " .. vim.inspect(config.highlight_groups))
    return
  end

  if type(config.highlight_groups.headers) ~= "table" then
    error(
      "Highlight groups - `headers` is not a table, got "
        .. vim.inspect(config.highlight_groups.headers)
    )
    return
  end

  -- { "text", config.highlight_groups.text },
  local checks = {
    { "title", config.highlight_groups.title },
    { "border", config.highlight_groups.border },
    { "text", config.highlight_groups.text },
    { "headers[1]", config.highlight_groups.headers[1] },
    { "headers[2]", config.highlight_groups.headers[2] },
    { "headers[3]", config.highlight_groups.headers[3] },
    { "headers[4]", config.highlight_groups.headers[4] },
    { "headers[5]", config.highlight_groups.headers[5] },
    { "headers[6]", config.highlight_groups.headers[6] },
  }

  for _, check in ipairs(checks) do
    local check_name = check[1]
    local check_value = check[2]
    if type(check_value) == "string" then
      ok("Highlight groups - `" .. check_name .. "` is valid")
    elseif type(check_value) == "table" then
      local error_message = check_highlight_error(check_value)
      if error_message then
        error(
          "Highlight groups - `"
            .. check_name
            .. "` is invalid ("
            .. error_message
            .. "), got "
            .. vim.inspect(check_value)
        )
      else
        ok("Highlight groups - `" .. check_name .. "` is valid")
      end
    else
      error(
        "Highlight groups - `" .. check_name .. "` is invalid, got " .. vim.inspect(check_value)
      )
    end
  end
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

  if check_indent() then
    ok("Indent is a non-negative number")
  else
    error("Indent is not a non-negative number, got " .. vim.inspect(config.height))
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

  check_highlight_groups()
end

return M

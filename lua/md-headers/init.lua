local config = require("md-headers.config")
local headings = require("md-headers.headings")
local ui = require("md-headers.ui")

local M = {}

M.markdown_headers = function(start_on_heading_above)
  if not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype) then
    vim.api.nvim_echo({ { "MDHeaders: not a supported filetype", "WarningMsg" } }, true, {})
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local _headings = headings.get_headings(bufnr)

  local heading_above = 1
  if start_on_heading_above then
    heading_above = headings.get_heading_above(_headings, current_line)
  end

  ui.open_window(_headings, heading_above)
end

M.setup = function(opts)
  config.setup(opts)
end

return M

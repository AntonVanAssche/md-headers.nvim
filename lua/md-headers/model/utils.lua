local config = require("md-headers.model.config")
local feedback = require("md-headers.ui.feedback")

local M = {}

function M.validate_headings(headings)
  if not headings or #headings == 0 then
    feedback.warn("No headings found in the document")
    return false
  end

  return true
end

function M.is_supported_filetype()
  if not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype) then
    feedback.warn("Not a supported filetype")
    return false
  end

  return true
end

return M

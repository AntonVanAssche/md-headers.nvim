local config = require("md-headers.model.config")
local feedback = require("md-headers.ui.feedback")

local M = {}

function M.is_supported_filetype()
  if not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype) then
    feedback.warn("Not a supported filetype")
    return false
  end

  return true
end

return M

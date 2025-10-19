local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  vim.api.nvim_err_writeln("MDHeaders: telescope.nvim is required to use this extension")
  return
end

local config = require("md-headers.model.config")
local feedback = require("md-headers.ui.feedback")
if not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype) then
  feedback.warn("Not a supported filetype")
  return
end

return telescope.register_extension({
  exports = {
    headings = require("telescope._extensions.md-headers.headings"),
  },
})

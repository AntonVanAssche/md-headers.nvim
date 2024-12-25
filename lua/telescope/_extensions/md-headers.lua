local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  vim.api.nvim_err_writeln("MDHeaders: telescope.nvim is required to use this extension")
  return
end

local config = require("md-headers.config")
if not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype) then
  vim.api.nvim_echo({ { "MDHeaders: not a supported filetype", "WarningMsg" } }, true, {})
  return
end

return telescope.register_extension({
  exports = {
    headings = require("telescope._extensions.md-headers.headings"),
  },
})

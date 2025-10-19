local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  vim.api.nvim_err_writeln("MDHeaders: telescope.nvim is required to use this extension")
  return
end

local utils = require("md-headers.model.utils")
if not utils.is_supported_filetype() then
  return
end

return telescope.register_extension({
  exports = {
    headings = require("telescope._extensions.md-headers.headings"),
  },
})

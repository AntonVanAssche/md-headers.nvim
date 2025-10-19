if vim.g.loaded_md_headers then
  return
end

local supported_filetypes = require("md-headers.model.config").supported_filetypes
if not vim.tbl_contains(supported_filetypes, vim.bo.filetype) then
  return
end

require("md-headers").setup()

vim.g.loaded_md_headers = true

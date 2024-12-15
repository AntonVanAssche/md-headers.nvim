if vim.g.loaded_md_headers then
  return
end

local supported_filetypes = require("md-headers.config").supported_filetypes
if not vim.tbl_contains(supported_filetypes, vim.bo.filetype) then
  return
end

require("md-headers").setup()
require("md-headers.command").setup()

vim.g.loaded_md_headers = true

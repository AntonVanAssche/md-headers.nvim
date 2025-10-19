if vim.g.loaded_md_headers then
  return
end

local utils = require("md-headers.model.utils")
if not utils.is_supported_filetype() then
  return
end

require("md-headers").setup()

vim.g.loaded_md_headers = true

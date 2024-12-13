if vim.g.loaded_md_headers then
  return
end

require("md-headers").setup()
require("md-headers.command").setup()

vim.g.loaded_md_headers = true

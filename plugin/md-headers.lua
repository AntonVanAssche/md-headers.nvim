local utils = require("md-headers.model.utils")
if not utils.is_supported_filetype() then
  return
end

require("md-headers").setup()

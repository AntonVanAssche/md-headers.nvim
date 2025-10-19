local config = require("md-headers.model.config")
local controller = require("md-headers.controller")

local M = {}

function M.setup(opts)
  config.setup(opts)
  controller.register_commands()
end

return M

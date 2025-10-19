local M = {}

local prefix = "MDHeaders: "

function M.error(msg)
  vim.api.nvim_err_writeln(prefix .. msg)
end

function M.warn(msg)
  vim.api.nvim_echo({ { prefix .. msg, "WarningMsg" } }, true, {})
end

function M.info(msg)
  vim.api.nvim_echo({ { prefix .. msg, "Normal" } }, true, {})
end

return M

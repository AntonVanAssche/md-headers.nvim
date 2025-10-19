local utils = require("md-headers.model.utils")

local M = {}

function M.open(headings)
  if not utils.validate_headings(headings) then
    return
  end

  local qf_win = vim.fn.getqflist({ winid = true }).winid
  if qf_win ~= 0 then
    vim.cmd.cclose()
    return
  end

  local qf_list = {}
  for _, heading in ipairs(headings) do
    table.insert(qf_list, {
      filename = vim.fn.expand("%"),
      lnum = heading.line + 1,
      text = heading.text,
    })
  end

  vim.fn.setqflist(qf_list)
  vim.cmd.copen()
end

return M

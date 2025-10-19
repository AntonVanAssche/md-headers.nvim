local config = require("md-headers.model.config")
local feedback = require("md-headers.ui.feedback")
local headings = require("md-headers.model.headings")
local window = require("md-headers.ui.window")
local quickfix = require("md-headers.ui.quickfix")

local M = {}

function M.popup(cursor_line)
  if
    not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype)
    and not vim.tbl_contains({ "qf", "lspinfo" }, vim.bo.filetype)
  then
    feedback.warn("Not a supported filetype")
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local _headings = headings.get_headings(bufnr)

  local start_line = 1
  if cursor_line then
    start_line = math.max(headings.get_heading_above(_headings, cursor_line), 1)
  end

  window.open(_headings, start_line)
end

function M.quickfix()
  if
    not vim.tbl_contains(config.supported_filetypes, vim.bo.filetype)
    and not vim.tbl_contains({ "qf", "lspinfo" }, vim.bo.filetype)
  then
    feedback.warn("Not a supported filetype")
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local _headings = headings.get_headings(bufnr)

  quickfix.open(_headings)
end

function M.telescope()
  vim.cmd("Telescope md-headers headings")
end

function M.register_commands()
  local cmds = {
    {
      "MDHeaders",
      function()
        M.popup()
      end,
      { desc = "Generate a table of contents for a Markdown file.", nargs = 0 },
    },
    {
      "MDHeadersCurrent",
      function()
        M.popup(vim.api.nvim_win_get_cursor(0)[1])
      end,
      {
        desc = "Generate a table of contents for a Markdown file, using the closest heading.",
        nargs = 0,
      },
    },
    {
      "MDHeadersQuickfix",
      M.quickfix,
      { desc = "Generate a quickfix list of headings for a Markdown file.", nargs = 0 },
    },
    {
      "MDHeadersTelescope",
      M.telescope,
      { desc = "Open a Telescope window with headings for a Markdown file.", nargs = 0 },
    },
  }

  for _, c in ipairs(cmds) do
    vim.api.nvim_create_user_command(c[1], function(opts)
      local ok, err = pcall(c[2], opts.fargs)
      if not ok then
        feedback.error(err)
      end
    end, c[3])
  end
end

return M

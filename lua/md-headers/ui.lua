local config = require("md-headers.config")
local popup = require("plenary.popup")

local M = {}

local _configure_win = function(bufnr)
  vim.api.nvim_win_set_option(bufnr, "number", false)
  vim.api.nvim_win_set_option(bufnr, "relativenumber", false)
  vim.api.nvim_win_set_option(bufnr, "cursorline", true) -- Enable cursorline for better visibility

  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<CR>",
    ':lua require("md-headers.ui").select_heading()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "q",
    ':lua require("md-headers.ui").close_window()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<Esc>",
    ':lua require("md-headers.ui").close_window()<CR>',
    { noremap = true, silent = true }
  )
end

local _open_window = function(headings, heading_to_start_on)
  local bufnr = vim.api.nvim_create_buf(false, true)

  local width = config.config.width
  local height = config.config.height
  local borderchars = config.config.borderchars

  local _, win = popup.create(bufnr, {
    title = "Markdown Headers",
    highlight = "MarkdownHeadersWindow",
    titlehighlight = "MarkdownHeadersTitle",
    borderhighlight = "MarkdownHeadersBorder",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
  })

  vim.api.nvim_win_set_option(win.border.win_id, "winhl", "Normal:MarkdownHeadersBorder")

  local contents = {}
  for _, heading in ipairs(headings) do
    table.insert(contents, heading.text)
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, #contents, false, contents)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(win.win_id, { heading_to_start_on, 0 })

  -- Store headings in the buffer variable for later access.
  vim.b[bufnr].headings = headings
end

local _goto_heading = function(headings, line)
  local win = vim.api.nvim_get_current_win()
  local popup_auto_close = config.config.popup_auto_close

  vim.api.nvim_win_close(win, true)
  vim.api.nvim_win_set_cursor(0, { headings[line].line + 1, 0 })

  if not popup_auto_close then
    M.open_window(headings, line)
  end
end

M.select_heading = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local headings = vim.b[bufnr].headings
  if not headings then
    vim.notify("No headings found!", vim.log.levels.ERROR)
    return
  end

  _goto_heading(headings, line)
end

M.open_window = function(headings, heading_to_start_on)
  _open_window(headings, heading_to_start_on)
  _configure_win(0)
end

M.close_window = function()
  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_close(win, true)
end

return M

local config = require("md-headers.model.config")
local feedback = require("md-headers.ui.feedback")
local utils = require("md-headers.model.utils")

local M = {}
local highlight_namespace = vim.api.nvim_create_namespace("md-headers")

local function get_indent(depth)
  return string.rep(" ", config.values.indent * (depth - 1))
end

local function get_icon(depth)
  return config.values.headerchars[depth] or ""
end

local function get_highlight(depth)
  return config.resolved_highlights.headers[depth]
end

local function set_window_options(win_id)
  local opts = config.values.win_options
  vim.api.nvim_set_option_value("number", opts.number, { win = win_id })
  vim.api.nvim_set_option_value("relativenumber", opts.relativenumber, { win = win_id })
  vim.api.nvim_set_option_value("cursorline", opts.cursorline, { win = win_id })
  vim.api.nvim_set_option_value("scrolloff", opts.scrolloff, { win = win_id })
end

local function set_buffer_keymaps(bufnr)
  local mappings = {
    ["<CR>"] = "select",
    ["q"] = "close",
    ["<Esc>"] = "close",
  }

  for key, func in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      key,
      string.format(':lua require("md-headers.ui.window").%s()<CR>', func),
      { noremap = true, silent = true }
    )
  end
end

local function create_window(bufnr, width, height, borderchars)
  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    style = "minimal",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    border = borderchars,
    title = "Markdown Headers",
    title_pos = "center",
  })

  vim.api.nvim_set_option_value(
    "winhl",
    table.concat({
      "Normal:" .. config.resolved_highlights.text,
      "FloatBorder:" .. config.resolved_highlights.border,
      "FloatTitle:" .. config.resolved_highlights.title,
    }, ","),
    { win = win }
  )

  return win
end

local function set_window_contents(bufnr, headings)
  local lines = {}
  for _, h in ipairs(headings) do
    table.insert(lines, get_indent(h.depth) .. get_icon(h.depth) .. h.text)
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

  for line, heading in ipairs(headings) do
    local highlight = get_highlight(heading.depth)
    if highlight then
      vim.api.nvim_buf_set_extmark(
        bufnr,
        highlight_namespace,
        line - 1,
        #get_indent(heading.depth),
        { end_col = #lines[line], hl_group = highlight }
      )
    end
  end
end

local function open_window(headings, start_line)
  local bufnr = vim.api.nvim_create_buf(false, true)
  local cfg = config.values
  local win = create_window(bufnr, cfg.width, cfg.height, cfg.borderchars)

  set_window_contents(bufnr, headings)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(win, { start_line, 0 })

  vim.b[bufnr].headings = headings
end

local function goto_heading(headings, index)
  local win = vim.api.nvim_get_current_win()
  local auto_close = config.values.popup_auto_close

  vim.api.nvim_win_close(win, true)
  vim.api.nvim_win_set_cursor(0, { headings[index].line + 1, 0 })

  if not auto_close then
    M.open(headings, index)
  end
end

function M.select()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local headings = vim.b[bufnr].headings

  if not headings or #headings == 0 then
    feedback.warn("Cannot open empty headings")
    return
  end

  local index = math.max(1, math.min(line, #headings))
  goto_heading(headings, index)
end

function M.open(headings, start_line)
  if not utils.validate_headings(headings) then
    return
  end

  open_window(headings, start_line)

  local win = vim.api.nvim_get_current_win()
  set_window_options(win)
  set_buffer_keymaps(vim.api.nvim_get_current_buf())
end

function M.close()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end

return M

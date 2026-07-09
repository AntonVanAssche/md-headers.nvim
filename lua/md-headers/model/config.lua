local M = {}

M.defaults = {
  width = 60,
  height = 10,
  borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  headerchars = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
  indent = 2,
  popup_auto_close = true,
  win_options = {
    number = false,
    relativenumber = true,
    cursorline = true,
    scrolloff = 0,
  },
  highlight_groups = {
    title = nil,
    border = nil,
    text = nil,
    headers = { nil, nil, nil, nil, nil, nil },
  },
}

M.supported_filetypes = {
  "markdown",
  "markdown.pandoc",
  "markdown.markdown",
  "quarto",
  "rmd",
}

M.resolved_highlights = {}

local function resolve_highlight(default_name, config_value)
  if type(config_value) == "string" then -- existing highlight group name
    return config_value
  elseif config_value == nil then -- fall back to non-existent highlight group
    return ""
  else
    pcall(function()
      vim.api.nvim_set_hl(0, default_name, config_value)
    end)
    return default_name
  end
end

function M.setup(opts)
  opts = opts or {}
  M.values = vim.tbl_deep_extend("force", M.defaults, opts)

  local hl = M.values.highlight_groups
  M.resolved_highlights = {
    title = resolve_highlight("MarkdownHeadersTitle", hl.title),
    border = resolve_highlight("MarkdownHeadersBorder", hl.border),
    text = resolve_highlight("MarkdownHeadersWindow", hl.text),
    headers = {
      resolve_highlight("MarkdownHeadersH1", hl.headers[1]),
      resolve_highlight("MarkdownHeadersH2", hl.headers[2]),
      resolve_highlight("MarkdownHeadersH3", hl.headers[3]),
      resolve_highlight("MarkdownHeadersH4", hl.headers[4]),
      resolve_highlight("MarkdownHeadersH5", hl.headers[5]),
      resolve_highlight("MarkdownHeadersH6", hl.headers[6]),
    },
  }
end

return M

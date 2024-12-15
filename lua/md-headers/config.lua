local M = {}

M.supported_filetypes = {
  "markdown",
  "markdown.pandoc",
  "markdown.markdown",
  "markdown",
  "quarto",
  "rmd",
}
M.config = {
  width = 60,
  height = 10,
  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  popup_auto_close = true,
  highlight_groups = {
    title = {
      fg = nil,
      bg = nil,
    },
    border = {
      fg = nil,
      bg = nil,
    },
    text = {
      fg = nil,
      bg = nil,
    },
  },
}

local _set_hl_colors = function()
  local highlight_groups = M.config.highlight_groups

  if highlight_groups.title.fg ~= nil or highlight_groups.title.bg ~= nil then
    vim.api.nvim_set_hl(0, "MarkdownHeadersTitle", {
      fg = highlight_groups.title.fg or "NONE",
      bg = highlight_groups.title.bg or "NONE",
    })
  end

  if highlight_groups.border.fg ~= nil or highlight_groups.border.bg ~= nil then
    vim.api.nvim_set_hl(0, "MarkdownHeadersBorder", {
      fg = highlight_groups.border.fg or "NONE",
      bg = highlight_groups.border.bg or "NONE",
    })
  end

  if highlight_groups.text.fg ~= nil or highlight_groups.text.bg ~= nil then
    vim.api.nvim_set_hl(0, "MarkdownHeadersWindow", {
      fg = highlight_groups.text.fg or "NONE",
      bg = highlight_groups.text.bg or "NONE",
    })
  end
end

M.setup = function(opts)
  opts = opts or {}

  for k, v in pairs(opts) do
    if type(v) == "table" and type(M.config[k]) == "table" then
      for sub_k, sub_v in pairs(v) do
        M.config[k][sub_k] = sub_v
      end
    else
      M.config[k] = v
    end
  end

  _set_hl_colors()
end

return M

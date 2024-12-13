local M = {}

local md_query = vim.treesitter.query.parse(
  "markdown",
  [[
(atx_heading) @md_heading
]]
)

local html_query = vim.treesitter.query.parse(
  "html",
  [[
(element
  (start_tag
    (tag_name) @html_heading (#match? @html_heading "^h[1-9]"))
  (text) @tag_text
  (end_tag
    (tag_name) @end_html_heading (#match? @end_html_heading "^h[1-9]"))
)
]]
)

local _get_root = function(bufnr, lang)
  local parser = vim.treesitter.get_parser(bufnr, lang, {})
  if parser then
    local root = parser:parse()[1]
    return root:root()
  end
end

local _query_md = function(bufnr)
  local headings = {}

  local root = _get_root(bufnr, "markdown")
  for id, node in md_query:iter_captures(root, bufnr, 0, -1) do
    local name = md_query.captures[id]

    if name == "md_heading" then
      local range = { node:range() }
      local text = vim.api.nvim_buf_get_lines(bufnr, range[1], range[3], false)[1]
      local level = 0
      level, text = text:match("^(#+) (.*)")
      level = #level

      if tonumber(level) > 0 then
        table.insert(headings, { line = range[1], text = string.rep(" ", level - 1) .. text })
      end
    end
  end

  return headings
end

local _query_html = function(bufnr)
  local headings = {}
  local root = _get_root(bufnr, "html")
  local level

  for id, node in html_query:iter_captures(root, bufnr, 0, -1) do
    local name = html_query.captures[id]

    if name == "html_heading" then
      local range = { node:range() }
      local text = vim.api.nvim_buf_get_lines(bufnr, range[1], range[3] + 1, false)[1]
      text = string.sub(text, range[2] + 1, range[4])
      level = tonumber(text:match("h([1-9])"))
    end

    if name == "tag_text" then
      local range = { node:range() }
      local text = vim.api.nvim_buf_get_lines(bufnr, range[1], range[3] + 1, false)[1]
      text = string.sub(text, range[2] + 1, range[4])

      if level > 0 then
        table.insert(headings, { line = range[1], text = string.rep(" ", level - 1) .. text })
      end
    end
  end

  return headings
end

local _sort_headings = function(headings)
  table.sort(headings, function(a, b)
    return a.line < b.line
  end)

  return headings
end

M.get_headings = function(bufnr)
  local md_headings = _query_md(bufnr) or {}
  local html_headings = _query_html(bufnr) or {}

  local headings = {}
  for _, h in ipairs(md_headings) do
    table.insert(headings, h)
  end

  for _, h in ipairs(html_headings) do
    table.insert(headings, h)
  end
  headings = _sort_headings(headings)

  return headings
end

M.get_heading_above = function(headings, current_line)
  local popup_window_line = 0

  for _, heading in ipairs(headings) do
    if heading.line < current_line then
      popup_window_line = popup_window_line + 1
    end
  end

  return popup_window_line
end

return M

local popup = require("plenary.popup")

local M = {}
local headers = {}

local md_extract_regex = "^(#+) (.*)"

-- Default options for the floating window.
local settings = {
    width = 60,
    height = 10,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    popup_auto_close = true, -- or false
}

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

local sort_by_line = function(t)
    table.sort(t, function(a, b)
        return a.line < b.line
    end)
    return t
end

local function get_root(bufnr, lang)
    local parser = vim.treesitter.get_parser(bufnr, lang, {})
    if parser then
        local root = parser:parse()[1]
        return root:root()
    end
end

-- Scan the current buffer for headers.
-- This includes Markdown and HTML headers.
-- Once a header is found, it is added to the headers table
-- and will be indented with spaces according to its level.
-- @param buffer: The buffer to scan.
local function find_headers(buffer)
    headers = {}

    local root_md = get_root(buffer, "markdown")
    local root_html = get_root(buffer, "html")

    for id, node in md_query:iter_captures(root_md, buffer, 0, -1) do
        local name = md_query.captures[id]

        if name == "md_heading" then
            local range = { node:range() }
            local text = vim.api.nvim_buf_get_lines(buffer, range[1], range[3], false)[1]
            local level = 0
            level, text = text:match(md_extract_regex)
            level = #level

            if tonumber(level) > 0 then
                table.insert(
                    headers,
                    { line = range[1], text = string.rep(" ", level - 1) .. text }
                )
            end
        end
    end

    local _level

    for id, node in html_query:iter_captures(root_html, buffer, 0, -1) do
        local name = html_query.captures[id]

        if name == "html_heading" then
            local range = { node:range() }
            local text = vim.api.nvim_buf_get_lines(buffer, range[1], range[3] + 1, false)[1]
            text = string.sub(text, range[2] + 1, range[4])
            local level = tonumber(text:match("h([1-9])"))
            _level = level
        end

        if name == "tag_text" then
            local range = { node:range() }
            local text = vim.api.nvim_buf_get_lines(buffer, range[1], range[3] + 1, false)[1]
            text = string.sub(text, range[2] + 1, range[4])

            if _level > 0 then
                table.insert(
                    headers,
                    { line = range[1], text = string.rep(" ", _level - 1) .. text }
                )
            end
        end
    end

    return sort_by_line(headers)
end

-- Gets the closest header above the current cursor position.
-- Returns the corresponding line inside the popup window.
-- @return popup_window_line: number
local function get_closest_header_above()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local popup_window_line = 0

    for _, header in ipairs(headers) do
        if header.line < line then
            popup_window_line = popup_window_line + 1
        end
    end

    return popup_window_line
end

-- Open a popup window with the headers of the current buffer.
-- The buffer itself is not modifiable.
-- @param header_to_start_on: Line number of the header to set the cursor on, inside the popup window.
local function open_header_window(header_to_start_on)
    local buffer = vim.api.nvim_create_buf(false, true)

    local width = settings.width
    local height = settings.height
    local borderchars = settings.borderchars

    -- Options for the new buffer window.
    -- The window will open in the center of the current window.
    local _, window = popup.create(buffer, {
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

    vim.api.nvim_win_set_option(window.border.win_id, "winhl", "Normal:MarkdownHeadersBorder")

    local contents = {}
    for _, header in ipairs(headers) do
        table.insert(contents, header.text)
    end

    vim.api.nvim_buf_set_lines(buffer, 0, #contents, false, contents)
    vim.api.nvim_buf_set_option(buffer, "modifiable", false)
    vim.api.nvim_set_current_buf(buffer)
    vim.api.nvim_win_set_cursor(window.win_id, { header_to_start_on, 0 })
end

-- Close the buffer with the headers and navigate to the selected header.
-- @param index: Index of the selected header inside the headers table.
local function goto_header(index)
    local win = vim.api.nvim_get_current_win()
    local popup_auto_close = settings.popup_auto_close

    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_set_cursor(0, { headers[index].line + 1, 0 })

    if not popup_auto_close then
        M.markdown_headers(true)
    end
end

-- Select a header from the header window and navigate to it.
M.select_header = function()
    local line = vim.api.nvim_win_get_cursor(0)[1]

    goto_header(line)
end

M.close_header_window = function()
    local win = vim.api.nvim_get_current_win()

    vim.api.nvim_win_close(win, true)
end

M.markdown_headers = function(start_on_closest)
    local buffer = vim.api.nvim_get_current_buf()

    find_headers(buffer)

    local header_to_start_on = nil
    if start_on_closest then
        header_to_start_on = get_closest_header_above()
    else
        header_to_start_on = 1
    end

    open_header_window(header_to_start_on)

    vim.api.nvim_win_set_option(0, "number", false)
    vim.api.nvim_win_set_option(0, "relativenumber", false)
    vim.api.nvim_win_set_option(0, "cursorline", false)

    -- Map the enter key to select the header.
    -- Map q and escape to close the window.
    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<CR>",
        ':lua require("md-headers").select_header()<CR>',
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "q",
        ':lua require("md-headers").close_header_window()<CR>',
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<Esc>",
        ':lua require("md-headers").close_header_window()<CR>',
        { noremap = true, silent = true }
    )
end

-- Set the settings, if any where passed.
-- If none are passed, the default settings will be used.
-- @param opts: Plugin settings.
M.setup = function(opts)
    if opts then
        for k, v in pairs(opts) do
            settings[k] = v
        end
    end
end

return M

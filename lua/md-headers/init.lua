local popup = require("plenary.popup")

local M = {}
local headers = {}

local md_extract_regex = '^(#+) (.*)'                      -- Extract markdown headers text and level.

-- Default options for the floating window.
local settings = {
    width = 60,
    height = 10,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'}
}

-- Tree-sitter query to find Markdown headings.
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
)
]]
)

local sort_by_line = function(t)
    table.sort(t, function(a, b) return a.line < b.line end)
    return t
end

local function get_root(bufnr)
    local parser = vim .treesitter.get_parser(bufnr, "markdown", {})
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

    local root = get_root(buffer)

    for id, node in md_query:iter_captures(root, buffer, 0, -1) do
        local name = md_query .captures[id]

        if name == "md_heading" then
            local range = { node:range() }
            local text = vim.api.nvim_buf_get_lines(buffer, range[1], range[3], false)[1]
            local level = 0
            level, text = text:match(md_extract_regex)
            level = #level

            if tonumber(level) > 0 then
                table.insert(headers, {line = range[1], text = string.rep(" ", level - 1) .. text})
            end
        end
    end

    for id, node in html_query:iter_captures(root, buffer, 0, -1) do
        local name = html_query.captures[id]
        print(name)

        if name == "html_heading" then
            local range = { node:range() }
            local text = vim.api.nvim_buf_get_lines(buffer, range[1], range[3], false)[1]
            local level = tonumber(text:match("^h([1-9])"))

            print(level)

            if level > 0 then
                table.insert(headers, {line = range[1], text = string.rep(" ", level - 1) .. text})
            end
        end
    end

    print(vim.inspect(headers))

    return sort_by_line(headers)
end

-- Gets the closest header above the current cursor position.
-- Returns the corresponding line inside the popup window.
-- @param buffer The buffer to search for headers.
-- @return popup_window_line: number
local function get_closest_header_above(buffer)
    -- Get the current line.
    local line = vim.api.nvim_win_get_cursor(0)[1]

    local popup_window_line = 0
    local root = get_root(buffer)

    for id, node in md_query:iter_captures(root, buffer, 0, -1) do
        local name = md_query.captures[id]

        if name == "md_heading" then
            -- Get distance between the current line and the header.
            local range = { node:range() }
            local distance = line - range[1]

            -- If the header is above the current line, return it.
            if distance > 0 then
                popup_window_line = popup_window_line + 1
            end
        end
    end

    return popup_window_line
end

-- Open a popup window with the headers of the current buffer.
-- The buffer itself is not modifiable.
-- @param closest_header: Line number of the closest header inside the popup window.
local function open_header_window(closest_header)
    -- Create a new buffer.
    local buffer = vim.api.nvim_create_buf(false, true)

    local width = settings.width
    local height = settings.height
    local borderchars = settings.borderchars

    -- Options for the new buffer window.
    -- The window will open in the center of the current window.
    local _, window = popup.create(buffer, {
        title = "Markdown Headers",
        highlight = "MarkdownHeadersWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    -- Set the buffer options.
    vim.api.nvim_win_set_option(
        window.border.win_id,
        "winhl",
        "Normal:MarkdownHeadersBorder"
    )

    -- Add the headers to the new buffer.
    local contents = {}
    for _, header in ipairs(headers) do
        table.insert(contents, header.text)
    end

    -- Set the contents of the new buffer.
    vim.api.nvim_buf_set_lines(buffer, 0, #contents, false, contents)

    -- Make the buffer read-only.
    vim.api.nvim_buf_set_option(buffer, "modifiable", false)

    -- Make the buffer the current buffer.
    vim.api.nvim_set_current_buf(buffer)

    -- Set the cursor to the closest header.
    vim.api.nvim_win_set_cursor(window.win_id, {closest_header, 0})
end

-- Close the buffer with the headers and navigate to the selected header.
-- @param index: Index of the selected header inside the headers table.
local function goto_header(index)
    -- Get the current window.
    local win = vim.api.nvim_get_current_win()

    -- Close the header window.
    vim.api.nvim_win_close(win, true)

    -- Go to the line of the selected header.
    vim.api.nvim_win_set_cursor(0, {headers[index].line + 1, 0})
end

-- Select a header from the header window and navigate to it.
M.select_header = function()
    -- Get the current line.
    local line = vim.api.nvim_win_get_cursor(0)[1]

    -- Go to the selected header.
    goto_header(line)
end

M.close_header_window = function()
    -- Get the current window.
    local win = vim.api.nvim_get_current_win()

    -- Close the header window.
    vim.api.nvim_win_close(win, true)
end

M.markdown_headers = function(start_on_closest)
    -- Get the current buffer.
    local buffer = vim.api.nvim_get_current_buf()

    -- Find the headers in the current buffer.
    find_headers(buffer)

    local closest_header = nil
    if start_on_closest then
        -- Get the closest header to the current cursor position.
        -- In other words, the header above the current cursor.
        closest_header = get_closest_header_above(buffer)
    else
        closest_header = 1
    end

    -- Open the header window.
    open_header_window(closest_header)

    -- Set the window settings.
    vim.api.nvim_win_set_option(0, "number", false)
    vim.api.nvim_win_set_option(0, "relativenumber", false)
    vim.api.nvim_win_set_option(0, "cursorline", false)

    -- Map the enter key to select the header.
    -- Map q and escape to close the window.
    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':lua require("md-headers").select_header()<CR>', {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':lua require("md-headers").close_header_window()<CR>', {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':lua require("md-headers").close_header_window()<CR>', {noremap = true, silent = true})
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

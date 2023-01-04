local popup = require("plenary.popup")

local M = {}
local headers = {}

local md_match_regex = '^#+ '                              -- Match markdown headers.
local md_extract_regex = '^(#+) (.*)'                      -- Extract markdown headers text and level.
local html_match_regex = '%s*<h(%d)[^>]*>(.-)</h%d>%s*$'   -- Match html headers and extract level and text.

-- Scan the current buffer for headers.
-- This includes Markdown and HTML headers.
-- Once a header is found, it is added to the headers table
-- and will be indented with spaces according to its level.
local function find_headers(buffer)
    -- Clear the headers table.
    headers = {}

    -- Get the number of lines in the buffer.
    local line_count = vim.api.nvim_buf_line_count(buffer)

    -- Iterate through the lines in the buffer.
    for i = 0, line_count - 1 do
        -- Get the current line.
        local line = vim.api.nvim_buf_get_lines(buffer, i, i+1, false)[1]

        -- Check if the line is a markdown header.
        local level = 0
        local text = ''
        if line:match(md_match_regex) then
            -- Extract the heading text and the number of # characters.
            level, text = line:match(md_extract_regex)
            level = #level
        -- Check if the line is an HTML header.
        elseif line:match(html_match_regex) then
            -- Extract the heading text and the header level.
            level, text = line:match(html_match_regex)
        end

        -- Add the header to the headers table.
        if tonumber(level) > 0 then
            table.insert(headers, {line = i, text = string.rep(" ", level - 1) .. text})
        end
    end
end

-- Gets the closest header above the current cursor position.
-- Returns the corresponding line inside the popup window.
-- @return popup_window_line: number
local function get_closest_header_above(buffer)
    -- Get the current line.
    local line = vim.api.nvim_win_get_cursor(0)[1]

    local popup_window_line = 0

    for i = 0, line do
        local current_line = vim.api.nvim_buf_get_lines(buffer, i, i+1, false)[1]

        -- If it's a Markdown header.
        if string.match(current_line, md_match_regex) or string.match(current_line, html_match_regex)then
            popup_window_line = popup_window_line + 1
        end
    end

    return popup_window_line
end

-- Open a popup window with the headers of the current buffer.
-- The buffer itself is not modifiable.
local function open_header_window(closest_header)
    -- Create a new buffer.
    local buffer = vim.api.nvim_create_buf(false, true)

    local width = 60
    local height = 10
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

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

return M

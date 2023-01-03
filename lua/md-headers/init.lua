local popup = require("plenary.popup")

local M = {}
local headers = {}

-- Scan the current buffer for headers.
-- This includes Markdown and HTML headers.
-- Once a header is found, it is added to the headers table
-- and will be indented with spaces according to its level.
local function find_headers()
    -- Clear the headers table.
    headers = {}

    -- Get the current buffer.
    local buffer = vim.api.nvim_get_current_buf()

    -- Get the number of lines in the buffer.
    local line_count = vim.api.nvim_buf_line_count(buffer)

    -- Iterate through the lines in the buffer.
    for i = 0, line_count - 1 do
        -- Get the current line.
        local line = vim.api.nvim_buf_get_lines(buffer, i, i+1, false)[1]

        -- Check if the line is a markdown header.
        local level = 0
        if line:match("^#+ ") and not line:match("^#+ %[.*%]%(#.*%)") then
            -- Extract the number of # characters.
            level = #line:match("^#+")

            -- Add the header to the headers table.
            if level > 0 then
                table.insert(headers, {line = i, text = string.rep(" ", level - 1) .. line:gsub("^#+ ", "")})
            end
        -- Check if the line is an HTML header.
        elseif line:match("^<h%d>.*</h%d>$") then
            -- Extract the number of h tags.
            level = tonumber(line:match("^<h(%d)>"))

            -- Add the header to the headers table.
            if level > 0 then
                table.insert(headers, {line = i, text = string.rep(" ", level - 1) .. line:match("^<h%d>(.*)</h%d>$")})
            end
        end
    end
end

-- Open a new buffer with the headers on the left side.
local function open_header_window()
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

M.markdown_headers = function()
    -- Find the headers in the current buffer.
    find_headers()

    -- Open the header window.
    open_header_window()

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

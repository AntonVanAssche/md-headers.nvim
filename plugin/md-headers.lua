-- Check whether the plugin is already loaded.
if _G.loaded_md_headers then
    return
end

-- Assig the MarkdownHeaders command when entering a buffer
-- containing a Markdown file.
vim .api.nvim_create_autocmd(
    'BufWinEnter', {
    pattern = {
        '*.md',
        '*.rmd'
    },
    callback = function()
        vim.api.nvim_create_user_command('MarkdownHeaders', function()
            require('md-headers').markdown_headers(false)
        end, {})
    end
})

vim .api.nvim_create_autocmd(
    'BufWinEnter', {
    pattern = {
        '*.md',
        '*.rmd'
    },
    callback = function()
        vim.api.nvim_create_user_command('MarkdownHeadersClosest', function()
            require('md-headers').markdown_headers(true)
        end, {})
    end
})

-- Set the plugin as loaded.
_G.loaded_md_headers = true

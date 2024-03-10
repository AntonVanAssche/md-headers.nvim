This page provides instructions on how to configure the Markdown Headers plugin according to your preferences. You can customize various settings to tailor the plugin to your specific needs.

# 1. Initialization in init.vim

While the examples below are in lua, you can adapt them for `.vim` files by wrapping them in a lua heredoc. However, it's not recommended due to significant slowdowns in Neovim's load time.

```vim
lua << END
    require('md-headers').setup()
END
```

# 2. Initialization in init.lua

Configure the plugin in your `init.lua` file, as demonstrated in the example below. The default configuration is shown, and you can customize it by modifying the values of different settings.

```lua
local md_headers_status_ok, md_headers = pcall(require, 'md-headers')
if not md_headers_status_ok then
    return
end

-- Default plugin settings.
md_headers.setup {
    width = 60,
    height = 10,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    popup_auto_close = true
}
-- Shorten function name.
local keymap = vim.keymap.set
-- Silent keymap option.
local opts = { silent = true }

-- Set keymap.
keymap('n', '<leader>mdh', '<cmd>MarkdownHeaders<CR>', opts)
keymap('n', '<leader>mdhc', '<cmd>MarkdownHeadersClosest<CR>', opts)
```

# 3. Customization Options

You can customize the following settings:

## 3.1 Width

You can customize the width of the Markdown Headers popup window using the `width` setting.

-   **Format:** Numeric
-   **Example:** Setting the width to '100' makes the popup window 100 columns wide.

## 3.2 Height

Adjust the height of the Markdown Headers popup window with the `height` setting.

-   **Format:** Numeric
-   **Example:** Setting the height to '30' results in a popup window that is 30 lines high.

## 3.3 Border Characters

Customize the characters used to draw the border around the popup window using the `borderchars` setting.

-   **Format:** Array of eight strings
-   **Example:** Setting borderchars to ``{ '', '', '', '', '', '', '', '' }`` results in a borderless popup window.

## 3.4 Popup Auto-Close

Specify whether the popup window should automatically close after selecting a heading using the `popup_auto_close` setting.

-   **Format:** Boolean (true or false)
-   **Example:** Setting `popup_auto_close` to false will **NOT** automatically close the popup window after selecting a heading.

# 4. Default Settings

If you don't configure Markdown Headers or leave certain settings unconfigured, the plugin will use its default settings. These settings can be found above.

# 5. Customizing Colors

The text, border, and title colors can be independently customized through highlight colors. Achieve this through either manual changes or configuration file settings.

## 5.1 Using the Configuration File

```lua
-- Change the border foreground color to '#61afef', and the background color to '#202020'.
vim.api.nvim_set_hl(0, "MarkdownHeadersBorder", { fg = "#61afef", bg = "#202020" })

-- Change the border foreground color to '#61afef'.
vim.api.nvim_set_hl(0, "MarkdownHeadersTitle", { fg = "#61afef" })
```

## 5.2 Manual Changes

-   Title: `highlight MarkdownHeadersTitle guifg=#61afef`
-   Border: `highlight MarkdownHeadersBorder guifg=#61afef`
-   Text: `highlight MarkdownHeadersWindow guifg=#61afef`

This flexibility allows users to have fine-grained control over the visual appearance of text, border, and title according to their preferences and needs.

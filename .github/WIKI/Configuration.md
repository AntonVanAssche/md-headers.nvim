This page provides instructions on how to configure the Markdown Headers plugin
according to your preferences. You can customize various settings to tailor the
plugin to your specific needs.

# 1. Initialization in init.vim

While the examples below are in lua, you can adapt them for `.vim` files by
wrapping them in a lua heredoc. However, it's not recommended due to
significant slowdowns in Neovim's load time.

```vim
lua << END
    require('md-headers').setup()
END
```

# 2. Initialization in init.lua

Configure the plugin in your `init.lua` file, as demonstrated in the example
below. The default configuration is shown, and you can customize it by
modifying the values of different settings.

```lua
local md_headers_status_ok, md_headers = pcall(require, 'md-headers')
if not md_headers_status_ok then
    return
end

-- Default plugin settings.
md_headers.setup {
  width = 60,
  height = 10,
  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  popup_auto_close = true, -- or false
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
```

# 3. Default Settings

If you don't configure Markdown Headers or leave certain settings unconfigured,
the plugin will use its default settings. These settings can be found above.

# 4. Customization Options

You can customize the following settings:

## 4.1 Width

You can customize the width of the Markdown Headers popup window using the
`width` setting.

- **Format:** Numeric
- **Example:** Setting the width to '100' makes the popup window 100 columns wide.

## 4.2 Height

Adjust the height of the Markdown Headers popup window with the `height` setting.

- **Format:** Numeric
- **Example:** Setting the height to '40' results in a popup window that is 40
  lines high.

## 4.4 Border Characters

Customize the characters used to draw the border around the popup window using
the `borderchars` setting.

- **Format:** Array of eight strings
- **Example:** Setting borderchars to ``{ '', '', '', '', '', '', '', '' }``
  results in a borderless popup window.

## 4.4 Popup Auto-Close

Specify whether the popup window should automatically close after selecting a
heading using the `popup_auto_close` setting.

- **Format:** Boolean (true or false)
- **Example:** Setting `popup_auto_close` to false will **NOT** automatically
  close the popup window after selecting a heading.

## 4.5 Highlight Groups

People with a keen eye for aesthetics can customize the colors of the popup.
Markdown Headers uses 4 highlight groups:

- `MarkdownHeadersTitle`: The title of the popup window.
- `MarkdownHeadersBorder`: The border of the popup window.
- `MarkdownHeadersWindow`: The text inside the popup window.

The following settings can be customized:

### 4.5.1 Title

- **Format:** Table with `fg` and `bg` keys
  - **fg:** Hex color code for the text color
  - **bg:** Hex color code for the background color
- **Example:** `{ fg = '#FF0000', bg = '#0000FF' }`

### 4.5.2 Border

- **Format:** Table with `fg` and `bg` keys
  - **fg:** Hex color code for the text color
  - **bg:** Hex color code for the background color
- **Example:** `{ fg = '#FF0000', bg = '#0000FF' }`

### 4.5.4 Text

- **Format:** Table with `fg` and `bg` keys
  - **fg:** Hex color code for the text color
  - **bg:** Hex color code for the background color
- **Example:** `{ fg = '#FF0000', bg = '#0000FF' }`

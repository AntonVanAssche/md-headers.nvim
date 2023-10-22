# Markdown Headers

Markdown Headers is a simple/basic Neovim plugin that allows you to easily navigate between headings in a Markdown file.

![preview](./assets/preview.gif)

## Why use Markdown Headers?

-   It saves time and effort when navigating long and complex markdown documents.
-   It works for both Markdown and HTML headings.
-   It helps you keep track of your location in the document.
-   It can improve your productivity and efficiency when writing or editing markdown documents.

There are probably plenty of other plugins that do the exact same thing and are probably nicer to look at 😅, feel free to use them.
I only created this plugin just to make navigating my college course summaries a little easier and to learn a thing or two about the Neovim API 😉.

## Limitations

Currently, the plugin is only able to recognize and extract headings that are constructed on a single line.
This is because the regular expression used to match headings only looks for the start and end tags of a heading element on the same line.

```markdown
# Heading
```

```html
<h1>Heading</h1>
```

Headings that span multiple lines, such as the one shown in the example below, will not be recognized by the plugin because the start and end tags are not on the same line.
This means that the regular expression will not match the heading, and it will not be included in the list of headings displayed in the popup window.

```html
<h1>
    Heading
</h1>
```

I understand that this limitation may be frustrating, and I apologize for the inconvenience.
Since this is a known and reported bug, please do not report it.
If reported, the issue will be closed and marked as `duplicate`.
This limitation is currently worked on, see pull request [#4](https://github.com/AntonVanAssche/md-headers.nvim/pull/4).
But I'm stuck on the implementation to detect html headings.

## Installation

### Using [Packer](https://github.com/wbthomason/packer.nvim)

1. Add this to your Neovim config:

```lua
use {
    'AntonVanAssche/md-headers.nvim',
    requires = {
        'nvim-lua/plenary.nvim'
    }
}

```

2. Run `:PackerSync` to install the plugin on your machine.

### Using [Vim-Plug](https://github.com/junegunn/vim-plug)

1. Add the following to your Neovim config:

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'AntonVanAssche/md-headers.nvim'
```

2. Run `:PlugInstall` to install the plugin on your machine.

### Manually

1. Clone this repository into your Neovim ~/.config/nvim/pack/plugins/start/directory.

## Configuration

You can configure the plugin by adding the following to your init.lua:

### Configuring Markdown Headers in init.vim

All the examples below are in lua. You can use the same examples in .vim files by wrapping them in lua heredoc like this:

```vim
lua << END
    require('md-headers').setup()
END
```

### Configuring Markdown Headers in init.lua

Here is an example of how you can configure the plugin in your init.lua file.
The example below shows the default configuration, which you can customize by modifying the values of the different settings.

```lua
local md_headers_status_ok, md_headers = pcall(require, 'md-headers')
if not md_headers_status_ok then
    return
end

-- Configure the popup window settings.
md_headers.setup {
    width = 60,
    height = 10,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'}
}

-- Shorten function name.
local keymap = vim.keymap.set
-- Silent keymap option.
local opts = { silent = true }

-- Set keymap.
keymap('n', '<leader>mdh', ':MarkdownHeaders<CR>', opts)
keymap('n', '<leader>mdhc', ':MarkdownHeadersClosest<CR>', opts)
```

You can customize the following settings:

-   `width`: The width of the Markdown Headers popup window.
    -   For example, setting the width to '100' will result in the popup window being 100 columns wide.
-   `height`: The height of the Markdown Headers popup window.
    -   For example, setting the height to '30' will result in the popup window being 30 lines high.
-   `borderchars`: The character that will be used to draw the border around the popup window.
    -   For example, setting the borderchars to '{ '', '', '', '', '', '', '', '' }' will result in the popup window being drawn without a border.

If you do not configure Markdown Headers or leave certain settings unconfigured, it will use its default settings for those settings.

The text, border, and title colors can be independently customized by adjusting their highlight colors. This can be achieved through either manual changes or configuration file settings, as demonstrated below:

1.  Using the configuration file to change the highlight colors:

```lua
-- Change the border and title highlight color to '#61afef'.
do
    vim.cmd [[
        highlight! MarkdownHeadersTitle guifg=#61afef
        highlight! MarkdownHeadersBorder guifg=#61afef
    ]]
end
```

2. Manually change the highlight colors:
    - Title: `highlight MarkdownHeadersTitle guifg=#61afef`
    - Border: `highlight MarkdownHeadersBorder guifg=#61afef`
    - Text: `highlight MarkdownHeadersWindow guifg=#61afef`

This enables users to have fine-grained control over the visual appearance of the text, border, and title according to their preferences/needs.

## Usage

To use the Markdown Headers plugin, use the `:MarkdownHeaders` command to display a list of headings in the current buffer in a floating window.
The headings will include both Markdown and HTML headings.
You can navigate to a heading by pressing Enter on it, and the cursor will move to the corresponding heading in the main window.
You can also press Escape or q to close the window.
The window will also close automatically when you've selected a heading.

To start the plugin with the cursor already positioned on the closest heading, use the `:MarkdownHeadersClosest` command instead.

Examples:

```
:MarkdownHeaders
:MarkdownHeadersClosest
```

## License

Markdown Headers is licensed under the MIT License. See the [LICENSE.md](./LICENSE.md) file for more information.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs or feature requests.

## TODO

-   [ ] Support headings that are spread across multiple lines.
    -   HTML only.
-   [ ] To be continued...

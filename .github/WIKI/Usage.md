To utilize the Markdown Headers plugin, follow these instructions for efficient
navigation within Neovim.

# 1. Commands

To utilize the Markdown Headers plugin for efficient navigation within Neovim,
follow these instructions:

## 1.1 MDHeaders

> :warning: This command was previously named `:MarkdownHeaders`, which has been
marked as deprecated, use `:MDHeaders` instead.

Opens a floating window displaying a list of headings in the current buffer,
which includes both Markdown and HTML headings. The user's cursor is placed
on the first heading in the list.

Recommended keybinding:

```lua
vim.keymap.set('n', '<leader>mh', '<cmd>MDHeaders<CR>', { silent = true })
```

## 1.2 MDHeadersCurrent

> :warning: This command was previously named `:MarkdownHeadersClosest`, which has
marked as deprecated, use `:MDHeadersCurrent` instead.

Opens a floating window that displays a list of headings from the current
buffer. This list includes both Markdown and HTML headings. The cursor is
automatically positioned on the heading corresponding to the section where the
user is currently editing.

Recommended keybinding:

```lua
vim.keymap.set('n', '<leader>mc', '<cmd>MDHeadersCurrent<CR>', { silent = true })
```

## 1.3 MDHeadersQuickfix

Opens a quickfix window displaying a list of headings in the current buffer,
including both Markdown and HTML headings. Calling this command again will
close the quickfix window. Making it act as a toggle.

Recommended keybinding:

```lua
vim.keymap.set('n', '<leader>mq', '<cmd>MDHeadersQuickfix<CR>', { silent = true })
```

## 1.4 MDHeadersTelescope

See the [Telescope Integration](#3-telescope-integration) section for more
information.

# 2. Navigation

Navigate through the headings using the following keybindings:

- Press `Enter` on a heading to move the cursor to the corresponding heading in
  the main window.
- Press `Escape` or `q` to close the floating window.

The popup window is designed to automatically close upon selecting a heading,
streamlining your workflow. However, this behavior changes when the
`popup_auto_close` option is configured as `false` in your settings file,
preventing automatic closure. Refer to the
[configuration](https://github.com/AntonVanAssche/md-headers.nvim/wiki/Configuration)
page for additional details on this setting.
to navigate and explore your Markdown or HTML document's structure.

# 3. Telescope Integration

Markdown Headers provides a Telescope extension to quickly navigate to
headings in a Markdown file. This is useful for large files where headings
act as an outline. Requires
[`telescope.nvim`](https://www.github.com/nvim-telescope/telescope.nvim)
to be installed.

As any other Telescope extension, you can call it with the following command:

```vim
:Telescope md-headers headings
```

However, the plugin provides an alias for this command:

```vim
:MDHeadersTelescope
```

Both commands will open a Telescope picker showing all headings in the current
buffer, with their depth and text. Select a heading to jump to that section.
If no headings are found, a warning message is shown.

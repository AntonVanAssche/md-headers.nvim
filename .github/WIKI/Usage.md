To utilize the Markdown Headers plugin, follow these instructions for efficient navigation within Neovim.

# 1. Commands

To utilize the Markdown Headers plugin for efficient navigation within Neovim, follow these instructions:

## 1.1 MarkdownHeaders

Execute the `:MarkdownHeaders` command to trigger a floating window displaying a list of headings in the current buffer. This list includes both Markdown and HTML headings.

## 1.2 MarkdownHeadersClosest

For enhanced and precise navigation, activate the plugin with the cursor preemptively placed at the current heading using the `:MarkdownHeadersClosest` command. This functionality facilitates focused navigation within the Markdown file, aligning the cursor with the specific heading you are actively editing.

# 2. Navigation

Navigate through the headings using the following keybindings:

-   Press `Enter` on a heading to move the cursor to the corresponding heading in the main window.
-   Press `Escape` or `q` to close the floating window.

The popup window is designed to automatically close upon selecting a heading, streamlining your workflow. However, this behavior changes when the `popup_auto_close` option is configured as `false` in your settings file, preventing automatic closure. Refer to the [configuration](https://github.com/AntonVanAssche/md-headers.nvim/wiki/Configuration) page for additional details on this setting.

# 3. Keybinding Recommendation

For a more efficient workflow, it's recommended to bind both commands to keystrokes. The example below demonstrates how to set up these keybindings in your init.lua file. You can also find this information on the [configuration](https://github.com/AntonVanAssche/md-headers.nvim/wiki/Configuration) page.

```lua
-- Shorten function name.
local keymap = vim.keymap.set
-- Silent keymap option.
local opts = { silent = true }

-- Set keymap.
keymap('n', '<leader>mdh', ':MarkdownHeaders<CR>', opts)
keymap('n', '<leader>mdhc', ':MarkdownHeadersClosest<CR>', opts)
```

# 4. Examples

Execute the following commands to interact with the plugin:

```vim
:MarkdownHeaders
:MarkdownHeadersClosest
```

These commands open the floating window, providing a quick and convenient way to navigate and explore your Markdown or HTML document's structure.

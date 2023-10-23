To utilize the Markdown Headers plugin, follow these instructions for efficient navigation within Neovim.

# 1. Displaying Headings

To use the Markdown Headers plugin, execute the `:MarkdownHeaders` command. This command triggers a floating window that displays a list of headings in the current buffer. The list includes both Markdown and HTML headings.

# 2. Navigation

Navigate through the headings using the following keybindings:

-   Press `Enter` on a heading to move the cursor to the corresponding heading in the main window.
-   Press `Escape` or `q` to close the floating window.

The window will also close automatically once you've selected a heading, optimizing your workflow.

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

# 4. Starting with the Cursor on the Closest Heading

For more targeted navigation, initiate the plugin with the cursor already positioned on the closest heading using the `:MarkdownHeadersClosest` command.

# 5. Examples

Execute the following commands to interact with the plugin:

```vim
:MarkdownHeaders
:MarkdownHeadersClosest
```

These commands open the floating window, providing a quick and convenient way to navigate and explore your Markdown or HTML document's structure.

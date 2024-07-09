This page provides instructions for installing the Markdown Headers plugin and its dependencies, ensuring you can seamlessly integrate and benefit from its features in Neovim.

# 1. Plugins

The Markdown Headers plugin relies on the following dependencies:

-   [AntonVanAssche/md-headers](https://github.com/AntonVanAssche/md-headers.nvim)
-   [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
-   [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (Optional, see [4. Markdown language parser](#4-markdown-language-parser))
# 2. Plugin Managers


Choose your preferred plugin manager below to easily install the Markdown Headers plugin:
Please add unlisted plugin managers to this page.

## 2.1 [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'AntonVanAssche/md-headers.nvim',
    requires = {
        'nvim-lua/plenary.nvim'
        -- 'nvim-treesitter/nvim-treesitter',
    }
}
```

## 2.2 [Vim-Plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'AntonVanAssche/md-headers.nvim'
```

## 2.3 [Lazy](https://github.com/folke/lazy.nvim)

Importing file below or directory it is contained on lazy setup.

```lua
return {
    'AntonVanAssche/md-headers.nvim',
    version = '*',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- 'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('md-headers').setup {}
    end,
}
```

# 3. Lazy Loading

It's not recommended to lazy load Markdown Headers. The plugin isn't resource-expensive, performing minimal validation and configuration setting. There's no performance benefit from lazy loading.

# 4. Markdown language parser

To ensure Markdown Headers function correctly, a language parser is necessary. Neovim includes the Treesitter library, which supports parsing for various programming languages. According to Neovim's documentation (See: [Treesitter](https://neovim.io/doc/user/treesitter.html#_parser-files)):

> By default, Nvim bundles parsers for C, Lua, Vimscript, Vimdoc, and Treesitter query files, but parsers can be installed via a plugin like [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) or even manually.

Since the Markdown parser is not included with Neovim, you can either download it manually or install it using the [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin, which also allows for easier management of other language parsers. If you choose to use the [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin, ensure that it is listed as a dependency for this plugin. This is crucial because Markdown Headers may not recognize the Markdown language parser if it loads after Markdown Headers due to its size.

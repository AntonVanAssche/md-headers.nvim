This page provides instructions for installing the Markdown Headers plugin and
its dependencies, ensuring you can seamlessly integrate and benefit from its
features in Neovim.

# 1. Plugins

The Markdown Headers plugin relies on the following dependencies:

- [AntonVanAssche/md-headers](https://github.com/AntonVanAssche/md-headers.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  (Optional, see [4. Markdown language parser](#4-markdown-language-parser))

# 2. Plugin Managers

Choose your preferred plugin manager below to easily install the Markdown
Headers plugin:

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
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- 'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('md-headers').setup {}
    end,
}
```

# 3. Markdown language parser

To ensure Markdown Headers functions correctly, a language parser is required.
Neovim includes the Treesitter library, which supports parsing for various
programming languages. According to Neovim's documentation (see:
[Treesitter](https://neovim.io/doc/user/treesitter.html#_parser-files)):

> By default, Nvim bundles parsers for C, Lua, Vimscript, Vimdoc, and
Treesitter query files. However, additional parsers can be installed through
plugins like [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
or manually.

Since the Markdown parser is not bundled with Neovim, you can either download
it manually or install it via the [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin,
which also simplifies managing other language parsers. If you opt to use the
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin,
make sure to list it as a dependency for Markdown Headers. This is important
because Markdown Headers might fail to recognize the Markdown parser if it is
loaded after the plugin due to its size.

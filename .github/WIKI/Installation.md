This page provides instructions for installing the Markdown Headers plugin and its dependencies, ensuring you can seamlessly integrate and benefit from its features in Neovim.

# 1. Plugins

The Markdown Headers plugin relies on the following dependencies:

-   [AntonVanAssche/md-headers](https://github.com/AntonVanAssche/md-headers.nvim)
-   [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
-   (optional if you manually install the Markdown langauge parser, otherwise required to the download Markdown language parser) [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  

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

For md-headers to work as intended, a language parser is required. Shipped with Neovim is the TreeSitter library, which facilitates the parsing of programming languages. Neovim's documentations states "By default, Nvim bundles parsers for C, Lua, Vimscript, Vimdoc and Treesitter query files, but parsers can be installed via a plugin like https://github.com/nvim-treesitter/nvim-treesitter or even manually." Because the Markdown parser is not shipped with Neovim we can either download it manually or install it and manage our other language parsers in an easier manner. If you installed the parser using the nvim-treesitter plugin, then make sure to add nvim-treesitter as a dependency for md-headers otherwise md-headers will may not recognize the  Markdown language parser due it typically loading after md-headers due to its size. 

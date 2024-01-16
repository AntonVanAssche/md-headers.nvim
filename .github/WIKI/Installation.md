This page provides instructions for installing the Markdown Headers plugin and its dependencies, ensuring you can seamlessly integrate and benefit from its features in Neovim.

# 1. Plugins

The Markdown Headers plugin relies on the following dependencies:

-   [AntonVanAssche/md-headers](https://github.com/AntonVanAssche/md-headers.nvim)
-   [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

# 2. Plugin Managers

Choose your preferred plugin manager below to easily install the Markdown Headers plugin:
Please add unlisted plugin managers to this page.

## 2.1 [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'AntonVanAssche/md-headers.nvim',
    requires = {
        'nvim-lua/plenary.nvim'
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
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('md-headers').setup {}
    end,
}
```

# 3. Lazy Loading

It's not recommended to lazy load Markdown Headers. The plugin isn't resource-expensive, performing minimal validation and configuration setting. There's no performance benefit from lazy loading.

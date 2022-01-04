<div align="center">

  <h1>refactoring.nvim</h1>
  <h5>The Refactoring library based off the Refactoring book by Martin Fowler</h5>
  <h6>'If I use an environment that has good automated refactorings, I can trust those refactorings' - Martin Fowler</h6>

  [![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
  [![Neovim Nightly](https://img.shields.io/badge/Neovim%20Nightly-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
  ![Work In Progress](https://img.shields.io/badge/Work%20In%20Progress-orange?style=for-the-badge)

</div>

## Table of Contents

- [Installation](#installation)
  - [Requirements](#requirements)
  - [Setup Using Packer](#packer)
- [Features](#features)
  - [Supported Languages](#supported-languages)
  - [Refactoring Features](#refactoring-features)
  - [Debug Features](#debug-features)
- [Configuration](#configuration)
  - [Configuration for Refactoring Operations](#config-refactoring)
    - [Using Direct Remaps](#config-refactoring-direct)
    - [Using Telescope](#config-refactoring-telescope)
  - [Configuration for Debug Operations](#config-debug)
  - [Configuration for Prompt Type Operations](#config-prompt)

## Installation<a name="installation"></a>

### Requirements<a name="requirements"></a>

- **Neovim Nightly**
- Treesitter
- Plenary

### Setup Using Packer<a name="packer"></a>

```lua
use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
    }
}
```

## Features<a name="features"></a>

### Supported Languages<a name="supported-languages"></a>

Given that this is a work in progress, the languages supported for the
operations listed below is **constantly changing**. As of now, these languages are
supported (with individual support for each function varying):

- TypeScript
- JavaScript
- Lua
- C/C++
- Golang
- Python

### Refactoring Features<a name="refactoring-features"></a>

- Support for various common refactoring operations
  - **106: Extract Function**
    - Also possible to extract to file
  - **119: Extract Variable**
  - **123: Inline Variable**

### Debug Features<a name="debug-features"></a>

- Also comes with various useful features for debugging
  - **Printf:** Automated insertion of print statement to mark the calling of a function
  - **Print var:** Automated insertion of print statement to print a variable at a given point in the code
  - **Cleanup:** Automated cleanup of all print statements generated by the plugin

## Configuration<a name="configuration"></a>

There are many ways to configure this plugin. Below are some example configurations.

**Setup Function**

No matter which configuration option you use, you must first call the
setup function.

```lua
require('refactoring').setup({})
```

### Configuration for Refactoring Operations<a name="config-refactoring"></a>

#### Using Direct Remaps<a name="config-refactoring-direct"></a>

If you want to make remaps for a specific refactoring operation, you can do so
by configuring the plugin like this:

```lua
-- Remaps for each of the four debug operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<Leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<Leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})
```

Notice that these maps are **visual mode** remaps, and that ESC is pressed before executing
the command. As of now, these are both necessary for the plugin to work.

#### Using Telescope<a name="config-refactoring-telescope"></a>

If you would prefer to use Telescope to choose a refactor when you're in visual mode,
you can do so use using the **Telescope extension.** Here is an example config
for this setup:

```lua
-- Remap to open the Telescope refactoring menu in visual mode
require("telescope").load_extension("refactoring")

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
	"v",
	"<leader>rr",
	"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	{ noremap = true }
)
```

### Configuration for Debug Operations<a name="config-debug"></a>

Finally, you can configure remaps for the debug operations of this plugin like this:

```lua
-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.api.nvim_set_keymap(
	"n",
	"<leader>rp",
	":lua require('refactoring').debug.printf({below = false})<CR>",
	{ noremap = true }
)

-- Print var: this remap should be made in visual mode
vim.api.nvim_set_keymap("v", "<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })

-- Cleanup function: this remap should be made in normal mode
vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })
```

### Configuration for Prompt Type Operations<a name="config-prompt"></a>

For certain languages like Golang, types are required for functions that return
an object(s) and parameters of functions. Unfortunately, for some parameters
and functions there is no way to automatically find their type. In those
instances, we want to provide a way to input a type instead of inserting a
placeholder value.

By default all prompts are turned off. The configuration below shows how to
enable prompts for all the languages currently supported.

```lua
require('refactoring').setup({
    -- prompt for return type
    prompt_func_return_type = {
        go = true,
    },
    -- prompt for function parameters
    prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
    },
})
```

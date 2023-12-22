# cmp-vimtex

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source providing bespoke support for [Vimtex](https://github.com/lervag/vimtex)'s omnifunc.

Check out the [tutorial](https://github.com/micangl/cmp-vimtex/tree/master/doc/TUTORIAL.md) for an in-depth explanation of the plugin's functionality.

## Table of contents
- [Features](#features)
- [Installation](#installation)
- [Setup](#setup)
- [Advanced setup](#advanced-setup)
- [Acknowledgments](#acknowledgments)

## Features

Provides support for:
- Fuzzy matching against all info provided by Vimtex (including bibliographic details, useful for citations):
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/4887b19b-d08d-44e3-9b29-22e91a3a1728)
- Perform websearches of bibliographic completion items on research databases and search engines (check out the [tutorial](https://github.com/micangl/cmp-vimtex/tree/master/doc/TUTORIAL.md));
- Parse and display all details contained in bibtex files:
  ![](https://github-production-user-asset-6210df.s3.amazonaws.com/142919381/274990752-d9cba239-aa54-4398-a17f-02f6eec1d628.png)
- Trimming long strings in the completion menu (adds space for the documenation window):
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/bed1ab56-09cf-486c-baa9-be4198e52ce0)
- Trigger the completion menu automatically after typing `\cite{` (normally, it has to be done manually).
- Conveniently toggling symbols and additional information shown in the completion menu:
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/fc167389-134d-4a7c-b083-2c9eafe98891)
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/daa3c5b3-b3a7-46d4-a3e6-427b9d4371de)
- Granuarly configuring the menus, and more (check out the [tutorial](https://github.com/micangl/cmp-vimtex/tree/master/doc/TUTORIAL.md)).

## Installation

Install the plugin through your plugin manager:

[lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
require("lazy").setup({
  "micangl/cmp-vimtex",
})
```

## Setup

Add cmp-vimtex as a completion source:

```lua
require('cmp').setup({
  sources = {
    { name = 'vimtex', },
  },
})
```

If you're manually specifying a custom `format` function (this doesn't apply to [lspkind.nvim](https://github.com/onsails/lspkind.nvim)), make sure not to overwrite `cmp-vimtex`'s additional information:

```lua
format = function(entry, vim_item)
  vim_item.menu = ({
    -- Use this line if you wish to add a specific kind for cmp-vimtex:
    --vimtex = "[Vimtex]" .. (vim_item.menu ~= nil and vim_item.menu or ""),
    vimtex = vim_item.menu,
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
  })[entry.source.name]

  return vim_item
end
```

Eventually, apply your configuration (**note**:this is not necessary unless you want to apply a custom configuration):

```lua
require('cmp_vimtex').setup({
    -- Eventual options can be specified here.
    -- Check out the tutorial for further details.
})
```

## Advanced setup

This is covered in the [tutorial](https://github.com/micangl/cmp-vimtex/tree/master/doc/TUTORIAL.md).

## Acknowledgments

This plugin is based on [@hrsh7th](https://github.com/hrsh7th)'s [cmp-omni](https://github.com/hrsh7th/cmp-omni).
The [timer implementation](https://github.com/micangl/cmp-vimtex/blob/master/lua/cmp_vimtex/timer.lua) has been taken from [cmp-buffer](https://github.com/hrsh7th/cmp-buffer).
The bibtex parser is a lua rewrite of [Vimtex](https://github.com/lervag/vimtex)'s integrated parser, which has also been adapted for asynchronous execution.

I'd like to thank [@lervag](https://github.com/lervag) for all the help provided when developing this plugin.

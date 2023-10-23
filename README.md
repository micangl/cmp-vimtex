# cmp-vimtex

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source providing bespoke support for [Vimtex](https://github.com/lervag/vimtex)'s omnifunc.

Provides support for:
- Fuzzy matching against all info provided by Vimtex (including bibliographic details, useful for citations):
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/4887b19b-d08d-44e3-9b29-22e91a3a1728)
- Parse and display all details contained in bibtex files:
  ![](https://github-production-user-asset-6210df.s3.amazonaws.com/142919381/274990752-d9cba239-aa54-4398-a17f-02f6eec1d628.png)
- Trimming long strings in the completion menu (adds space for the documenation window):
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/bed1ab56-09cf-486c-baa9-be4198e52ce0)
- Conveniently toggling symbols and additional information shown in the completion menu:
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/fc167389-134d-4a7c-b083-2c9eafe98891)
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/daa3c5b3-b3a7-46d4-a3e6-427b9d4371de)
- Granuarly configuring the menus, and more (check out the sections below).

# Installation

Install the plugin through your plugin manager:

[vim-plug](https://github.com/junegunn/vim-plug):
```lua
Plug 'micangl/cmp-vimtex'
```

[packer.nvim](https://github.com/wbthomason/packer.nvim) or [pckr.nvim](https://github.com/lewis6991/pckr.nvim):
```lua
use 'micangl/cmp-vimtex'
```

[pckr.nvim](https://github.com/lewis6991/pckr.nvim):
```lua
require('pckr').add{
  'micangl/cmp-vimtex';
}
```

[lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
require("lazy").setup({
  "micangl/cmp-vimtex",
})
```

# Setup

Add cmp-vimtex as a completion source:

```lua
require('cmp').setup({
  sources = {
    { name = 'vimtex', },
  },
})
```
Eventually, apply your configuration (**note**:this is not necessary unless you want to apply a custom configuration):

```lua
require('cmp_vimtex').setup({
    -- Eventual options can be specified here.
    -- See below for further details.
})
```

# Options

These are the default values of the configuration options:

```lua
require('cmp_vimtex').setup({
    additional_information = {
        info_in_menu = 1,
        info_in_window = 1,
        info_max_length = 60,
        match_against_info = 1,
        symbols_in_menu = 1,
    },
    bibtex_parser = {
        enabled = 1,
    },
})
```

### additional_information.info_in_menu: integer
default: 1

Show detailed information (such as citations details) in the completion menu.

### additional_information.info_in_window: integer
default: 1

Show detailed information (such as citations details) in the documentation window.

### additional_information.info_max_length: integer
default: 60

Limit length (width) of additional info shown in the completion menu to the specified number of characters.
To turn off this feature, set the option to a negative value.

### additional_information.match_against_info: integer
default: 1

Fuzzy match against both keyword and description.
Particularly useful when completing citations, since the user can simply type the author/title/publication date.

### additional_information.symbols_in_menu: integer
default: 1

Show sybmols associated with Latex keywords inside completion menu.

### bibtex_parser.enabled: integer
default: 1

The source comes with a bibtex parser (a lua port of Vimtex's own), used to display, inside the documentation window, all of the bibliographic informations contained in the files.

If the parser is disabled, the plugin will only show author/title/publication date (provided directly by Vimtex's omnifunc).

# Acknowledgments

This plugin is based on [@hrsh7th](https://github.com/hrsh7th)'s [cmp-omni](https://github.com/hrsh7th/cmp-omni).
The [timer implementation](https://github.com/micangl/cmp-vimtex/blob/master/lua/cmp_vimtex/timer.lua) has been taken from [cmp-buffer](https://github.com/hrsh7th/cmp-buffer).
The bibtex parser is a lua rewrite of [Vimtex](https://github.com/lervag/vimtex)'s integrated parser, which has also been adapted for asynchronous execution.

I'd like to thank [@lervag](https://github.com/lervag) for all the help provided when developing this plugin.

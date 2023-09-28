# cmp-vimtex

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source for [Vimtex](https://github.com/lervag/vimtex)'s omnifunc.
Based on [@hrsh7th](https://github.com/hrsh7th)'s [cmp-omni](https://github.com/hrsh7th/cmp-omni), with help from [@lervag](https://github.com/lervag).

Provides support for:
- Fuzzy matching against all info provided by Vimtex (including bibliographic details, useful for citations):
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/4887b19b-d08d-44e3-9b29-22e91a3a1728)
- Conveniently toggling symbols and additional information shown in the completion menu:
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/fc167389-134d-4a7c-b083-2c9eafe98891)
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/d2291237-81ba-408d-8860-a05487fed0fa)
- Displaying additional information provided by Vimtex in a separate documentation window:
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/eb3d8605-037c-4d0e-bd59-6144d428db1b)

# Installation

Install the plugin through your plugin manager:

[vim-plug](https://github.com/junegunn/vim-plug):
```
Plug 'micangl/cmp-vimtex'
```

[packer.nvim](https://github.com/wbthomason/packer.nvim) or [pckr.nvim](https://github.com/lewis6991/pckr.nvim):
```
use 'micangl/cmp-vimtex'
```

[pckr.nvim](https://github.com/lewis6991/pckr.nvim):
```
require('pckr').add{
  'micangl/cmp-vimtex';
}
```

[lazy.nvim](https://github.com/folke/lazy.nvim):
```
require("lazy").setup({
  "micangl/cmp-vimtex",
})
```

# Setup

```lua
require'cmp'.setup {
  sources = {
    {
      name = 'vimtex',
      option = {
        info_in_menu = 1,
        info_in_window = 1,
        match_against_description = 1,
        symbols_in_menu = 1,
      },
    },
  },
}
```

# Options

### info_in_menu: integer
default: 1

Show detailed information (such as citations details) in the completion menu.

### info_in_window: integer
default: 1

Show detailed information (such as citations details) in the documentation window.

### match_against_info: integer
default: 1

Fuzzy match against both keyword and description.
Particularly useful when completing citations, since the user can simply type the author/title/publication date.

### symbols_in_menu: integer
default: 1

Show sybmols associated with Latex keywords inside completion menu.

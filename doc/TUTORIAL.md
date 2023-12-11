# Tutorial


**NOTE**: this should be considered a **reference** tutorial, which means that most of
this information will result superflous to many users.

## Table of contents
- [Installation](#installation)
- [Features](#features)
  - [Basic enhancements](#basic-enhancements)
  - [Additional enhancements](#additional-enhancements)
- [Configuration](#configuration)
- [Options](#options)

## Installation

Install the plugin through your plugin manager, and add it as a completion source. For example:

[vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'micangl/cmp-vimtex'
```

[packer.nvim](https://github.com/wbthomason/packer.nvim):
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

Add it to the list of sources.
```lua
require('cmp').setup({
  sources = {
    { name = 'vimtex', },
  },
})
```

## Features

This plugin provides a variety of features, mostly related to bibliographic citations.
As a result, `cmp-vimtex` will be particularly beneficial to academics and, in general,
people who find themselves working a lot with citations.

### Basic enhancements

- Fuzzy matching against all the bibliographic information provided by Vimtex. This is especially useful when dealing
  with a consistent amount of literature, and remembering the exact Bibtex key of a specific paper may be difficult.
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/4887b19b-d08d-44e3-9b29-22e91a3a1728)
  Toggle with [match_against_info](#additional_informationmatch_against_info-boolean).
- Triggering the completion menu automatically after typing a `\cite{` statement (normally, it has to be done manually).
- Trimming long strings in the completion menu. Since the titles of various works can be quite long, the menu would
  become too big; preventing this leaves space for the documentation window, too.
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/bed1ab56-09cf-486c-baa9-be4198e52ce0)
  The maximum number of characters is determined by [info_max_length](#additional_informationinfo_max_length-integer).
- Toggling symbols and additional information shown in the completion menu:
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/fc167389-134d-4a7c-b083-2c9eafe98891)
  <img src="https://github.com/micangl/cmp-vimtex/assets/142919381/daa3c5b3-b3a7-46d4-a3e6-427b9d4371de" alt="drawing" width="500"/>
  
  These can be toggled, respectively, by [symbols_in_menu](additional_informationsymbols_in_menu-boolean) and [info_in_menu](additional_informationinfo_in_menu-boolean).

### Additional enhancements

- Parsing all the information contained in bibtex files, and displaying it in the documentation window.
  ![](https://github-production-user-asset-6210df.s3.amazonaws.com/142919381/274990752-d9cba239-aa54-4398-a17f-02f6eec1d628.png)
  Toggle with [enabled](bibtex_parserenabled-boolean). If the parser is disabled, the information shown in the documentation
  window will be that provided by Vimtex itself (author, title, publication date).

  If the display of information is, in both cases, undesired, setting the option [info_in_window](#additional_informationinfo_in_window-boolean) to `false` will prevent it.
- Searching in bibliographic databases and through search engines.
  
  When a specific entry is selected, calling the `search_menu` function will open a menu, thus allowing the user to select
  a bibliographic database, or search engine, of his choice. It is advised to map said function; as an example:
  ```lua
  vim.keymap.set("i", "<C-s>", function() require('cmp_vimtex.search').search_menu() end)
  ```

  Alternatively, the `perform_search` can be used to immediately perform a websearch with a specific engine.
  It can, optionally, receive as argument a table with the engine key, which unusprisingly specifies which engine to use.
  If none is provided, the default is used; this can be specified with the [default](#searchdefault-string) field. As an example:
  ```lua
  vim.keymap.set("i", "<C-s>", function() require('cmp_vimtex.search').perform_search({ engine = "arxiv", }) end)
  ```

  Notice how `perform_search` is wrapped in an anonymous function.

  The browser employed to perform the websearch is determined by the [browser](#searchbrowser-string) option.

  The engines shipped with the plugin are:

  | Bibliographic databases | Key | Search engines | Key |
  | ----------- | ----------- | ----------- | ----------- |
  | [Google Scholar](https://scholar.google.com/) | `google_scholar` | [DuckDuckGo](https://duckduckgo.com/) | `duckduckgo` |
  | [IEEE Xplore](https://ieeexplore.ieee.org/Xplore/home.jsp) | `ieee_xplore` | [Brave Search](https://search.brave.com/) | `brave_search` |
  | [arXiv](https://arxiv.org/) | `arxiv` | [Google](https://www.google.com/) | `google` |
  | [ResearchGate](https://www.researchgate.net/) | `researchgate` | | |
  | [JSTOR](https://www.jstor.org/) | `jstor` | | |
  | [Sematic Scholar](https://www.semanticscholar.org/) | `semantic_scholar` | | |

  Others can be specified by providing a url for the new search engine (`%s` is the placeholder for the search string), to be passed as argument to the
  `url_default_format` function. For example:
  ```lua
  require('cmp_vimtex').setup({
    search = {
      search_engine = {
        google_scholar = {
          name = "Google Scholar",
          get_url = require('cmp_vimtex').url_default_format("https://scholar.google.com/scholar?hl=en&q=%s"),
        },
      },
    },
  })
  ```

  For more advanced uses, users can define their own `get_url` function. Since this is outside the scope of this tutorial, interested users
  can refere to the implementation of the `url_default_format` function in the [init.lua](https://github.com/micangl/cmp-vimtex/blob/tutorial/lua/cmp_vimtex/init.lua) file.

## Options

These are the default values of the configuration options:

```lua
require('cmp_vimtex').setup({
  additional_information = {
    info_in_menu = true,
    info_in_window = true,
    info_max_length = 60,
    match_against_info = true,
    symbols_in_menu = true,
  },
  bibtex_parser = {
    enabled = true,
  },
  search = {
    browser = "xdg-open",
    default = "google_scholar",
    search_engines = {
      google_scholar = {
        name = "Google Scholar",
        get_url = require('cmp_vimtex').url_default_format("https://scholar.google.com/scholar?hl=en&q=%s"),
      },
      -- Other search engines.
    },
  },
})
```

### additional_information.info_in_menu: boolean
default: true

Show detailed information (such as citations details) in the completion menu.

### additional_information.info_in_window: boolean
default: true

Show detailed information (such as citations details) in the documentation window.

### additional_information.info_max_length: integer
default: 60

Limit length (width) of additional info shown in the completion menu to the specified number of characters.
To turn off this feature, set the option to a negative value.

### additional_information.match_against_info: boolean
default: true

Fuzzy match against both keyword and description.
Particularly useful when completing citations, since the user can simply type the author/title/publication date.

### additional_information.symbols_in_menu: boolean
default: true

Show sybmols associated with Latex keywords inside completion menu.

### bibtex_parser.enabled: boolean
default: true

The source comes with a bibtex parser (a lua port of Vimtex's own), used to display, inside the documentation window, all of the bibliographic informations contained in the files.

If the parser is disabled, the plugin will only show author/title/publication date (provided directly by Vimtex's omnifunc).

### search.browser: string
default: "xdg-open"

Specifies the browser employed to perform websearches.

### search.default: string
default: "google_scholar"

Indicates the default search engine.

### search.search_engines: table
default: refer to [source.lua](https://github.com/micangl/cmp-vimtex/blob/tutorial/lua/cmp_vimtex/source.lua).

Table which specifies the search engines.

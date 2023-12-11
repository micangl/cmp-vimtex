# Tutorial


**NOTE**: this should be considered a **reference** tutorial, which means that most of
this information will result superflous to many users.

## Table of contents
- [Installation](#installation)
- [Features](#features)
  - [Basic enhancements](#basic-enhancements)
  - [Additional enhancements](#additional-enhacements)
- [Configuration](#configuration)

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
  with a consistent amount of literature, and remembering the exact Bibtex key of a specific paper may be hard.
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/4887b19b-d08d-44e3-9b29-22e91a3a1728)
- Triggering the completion menu automatically after typing a `\cite{` statement (normally, it has to be done manually).
- Trimming long strings in the completion menu. Since the titles of various works can be quite long, the menu would
  become too big; preventing this leaves space for the documentation window, too.
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/bed1ab56-09cf-486c-baa9-be4198e52ce0)
- Toggling symbols and additional information shown in the completion menu:
  ![](https://github.com/micangl/cmp-vimtex/assets/142919381/fc167389-134d-4a7c-b083-2c9eafe98891)
  <img src="https://github.com/micangl/cmp-vimtex/assets/142919381/daa3c5b3-b3a7-46d4-a3e6-427b9d4371de" alt="drawing" width="500"/>

### Additional enhancements

- Parsing all the information contained in bibtex files, and displaying it in the documentation window.
  ![](https://github-production-user-asset-6210df.s3.amazonaws.com/142919381/274990752-d9cba239-aa54-4398-a17f-02f6eec1d628.png)
- Searching in bibliographic databases and search engines.

  | Bibliographic databases | Search engines |
  | ----------- | ----------- |
  | [Google Scholar](https://scholar.google.com/) | [DuckDuckGo](https://duckduckgo.com/) |
  | [IEEE Xplore](https://ieeexplore.ieee.org/Xplore/home.jsp) | [Brave Search](https://search.brave.com/) |
  | [arXiv](https://arxiv.org/) | [Google](https://www.google.com/) |
  | [ResearchGate](https://www.researchgate.net/) | |
  | [JSTOR](https://www.jstor.org/) | |
  | [Sematic Scholar](https://www.semanticscholar.org/) | |

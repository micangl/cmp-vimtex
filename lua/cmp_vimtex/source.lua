local source = {}

local defaults = {
  additional_information = {
    info_in_menu = true,
    info_in_window = true,
    info_max_length = 60,
    match_against_info = true,
    symbols_in_menu = true,
    bib_highlighting = true,
    highlight_colors = {
      default_group = "Normal",
      important_group = "IncSearch",
      default = {
        fg = "",
        bg = "",
      },
      important = {
        fg = "",
        bg = "",
      },
    },
    highlight_links = {
      -- Bibtex
      Address = "Default",
      Annote = "Default",
      Author = "Important",
      Booktitle = "Default",
      Email = "Default",
      Chapter = "Default",
      Crossref = "Default",
      Doi = "Default",
      Edition = "Default",
      Editor = "Default",
      Howpublished = "Default",
      Institution = "Default",
      Journal = "Default",
      Key = "Default",
      Month = "Default",
      Note = "Default",
      Number = "Default",
      Organization = "Default",
      Pages = "Default",
      Publisher = "Default",
      School = "Default",
      Series = "Default",
      Title = "Important",
      Type = "Default",
      Volume = "Default",
      Year = "Default",
      -- Biblatex
      Isbn = "Default",
      -- cmp-vimtex-specific keys
      File = "Default",
      Lnum = "Default",
      Cite = "Default",
    },
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
        get_url = require("cmp_vimtex").url_default_format "https://scholar.google.com/scholar?hl=en&q=%s",
      },
      arxiv = {
        name = "arXiv",
        get_url = require("cmp_vimtex").url_default_format "https://arxiv.org/search/?query=%s&searchtype=all",
        --get_url = function(data)
        --  local search_url = nil
        --  if type(data) == "table" and data.eprinttype == "arxiv" and data.eprint ~= nil then
        --    search_url = string.format("https://arxiv.org/search/?query=%s&searchtype=all", data.eprint)
        --  else
        --    local fn = require('cmp_vimtex').url_default_format("https://arxiv.org/search/?query=%s&searchtype=all")
        --    search_url = fn(data)
        --  end
        --  return search_url
        --end,
      },
      ieee_xplore = {
        name = "IEEE Xplore",
        get_url = require("cmp_vimtex").url_default_format "https://ieeexplore.ieee.org/search/searchresult.jsp?queryText=%s",
      },
      researchgate = {
        name = "ResearchGate",
        get_url = require("cmp_vimtex").url_default_format "https://www.researchgate.net/search/publication?q=%s",
      },
      jstor = {
        name = "JSTOR",
        get_url = require("cmp_vimtex").url_default_format "https://www.jstor.org/action/doBasicSearch?Query=%s",
      },
      semantic_scholar = {
        name = "Semantic Scholar",
        get_url = require("cmp_vimtex").url_default_format "https://www.semanticscholar.org/search?q=%s",
      },
      google = {
        name = "Google",
        get_url = require("cmp_vimtex").url_default_format "https://www.google.com/search?q=%s",
      },
      brave_search = {
        name = "Brave Search",
        get_url = require("cmp_vimtex").url_default_format "https://search.brave.com/search?q=%s",
      },
      duckduckgo = {
        name = "DuckDuckGo",
        get_url = require("cmp_vimtex").url_default_format "https://duckduckgo.com/?q=%s",
      },
    },
  },
}

source.start_parser = function(self)
  if not vim.b.vimtex or not vim.loop.fs_stat(vim.b.vimtex.root) then
    return
  end

  local parser = require "cmp_vimtex.parser"

  vim.fn["vimtex#paths#pushd"](vim.b.vimtex.root)
  local files = vim.fn["vimtex#bib#files"]()
  for _, file in pairs(files) do
    if self.bib_files[file] == nil then
      local new_parser = parser.new(file)
      new_parser:start_parsing()
      self.bib_files[file] = new_parser
    end
  end
  vim.fn["vimtex#paths#popd"]()
end

local apply_config = function(user_config)
  return vim.tbl_deep_extend("keep", user_config or {}, defaults)
end

local apply_syntax = function(config)
  if config.additional_information.bib_highlighting then
    local colors = config.additional_information.highlight_colors

    local default_link = true
    local default_style = ""
    local default_group = ""
    if colors.default.fg ~= "" and colors.default.bg ~= "" then
      default_link = false
      default_style = string.format("gui=bold guifg=%s guibg=%s", colors.default.fg, colors.default.bg)
    elseif colors.default_group ~= "" then
      default_group = colors.default_group
    end

    local important_link = true
    local important_style = ""
    local important_group = ""
    if colors.important.fg ~= "" and colors.important.bg ~= "" then
      important_link = false
      important_style = string.format("gui=bold guifg=%s guibg=%s", colors.important.fg, colors.important.bg)
    elseif colors.important_group ~= "" then
      important_group = colors.important_group
    end

    for key, el in pairs(config.additional_information.highlight_links) do
      -- If the default options are used
      if el == "Default" then
        if default_link then -- Just link the group
          vim.api.nvim_command(string.format("hi def link CmpVimtex%s %s", key, default_group))
        elseif default_style ~= "" then -- Use the fg bg codes.
          vim.api.nvim_command(string.format("hi def CmpVimtex%s ", key) .. default_style)
        end
      elseif el == "Important" then
        if important_link then -- Just link the group
          vim.api.nvim_command(string.format("hi def link CmpVimtex%s %s", key, important_group))
        elseif important_style ~= "" then -- Use the fg bg codes.
          vim.api.nvim_command(string.format("hi def CmpVimtex%s ", key) .. important_style)
        end
      else
        -- If a non-default highlight group is provided.
        vim.api.nvim_command(string.format("hi def link CmpVimtex%s %s", key, el))
      end
    end
  end
end




source.new = function(options)
  local self = setmetatable({}, { __index = source })
  self.bib_files = {}
  self.config = apply_config(options)
  self.config_loaded = true

  apply_syntax(self.config)

  return self
end

source.is_available = function()
  return vim.bo.omnifunc == "vimtex#complete#omnifunc"
end

source.get_position_encoding_kind = function()
  return "utf-8"
end

source.get_keyword_pattern = function()
  return [[\k\+]]
end

source.get_trigger_characters = function()
  return { "{" }
end

source.complete = function(self, params, callback)
  local config = self.config

  local offset_0 = self:_invoke(vim.bo.omnifunc, { 1, "" })
  if type(offset_0) ~= "number" then
    return callback()
  end
  local result = self:_invoke(vim.bo.omnifunc, { 0, string.sub(params.context.cursor_before_line, offset_0 + 1) })
  if type(result) ~= "table" then
    return callback()
  end

  local text_edit_range = {
    start = {
      line = params.context.cursor.line,
      character = offset_0,
    },
    ["end"] = {
      line = params.context.cursor.line,
      character = params.context.cursor.character,
    },
  }

  local items = {}
  for _, v in ipairs(result) do
    local menuLength = (v.menu ~= nil and string.len(v.menu) or 3)

    if type(v) == "string" then
      table.insert(items, {
        label = v,
        textEdit = {
          range = text_edit_range,
          newText = v,
        },
      })
    elseif type(v) == "table" then
      local _item = {
        label = v.abbr or v.word,
        textEdit = {
          range = text_edit_range,
          newText = v.word,
        },
        labelDetails = {
          detail = v.kind,
        },
      }

      if config.additional_information.info_in_menu and menuLength > 3 then
        _item.labelDetails.description = v.menu

        -- Inspired by https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-1844480
        if
          config.additional_information.info_max_length >= 0
          and v.menu:len() > config.additional_information.info_max_length
        then
          _item.labelDetails.description = vim.fn.strcharpart(
            _item.labelDetails.description,
            0,
            config.additional_information.info_max_length
          ) .. "…"
        end
      end

      if config.additional_information.info_in_window and v.info ~= nil then
        if config.bibtex_parser.enabled then
          for _, data in pairs(self.bib_files) do
            if data.indexed == 1 and data.result[_item.label] ~= nil then
              _item.documentation = {
                kind = "markdown",
                value = data.result[_item.label].info,
              }
            end
          end
        else
          _item.documentation = {
            kind = "markdown",
            -- "%u%u+" specifies at least two consecutive uppercase letters.
            value = string.gsub(v.info, "%u%u+", function(s)
              return "**" .. s .. "**"
            end),
          }
        end
      end

      if config.additional_information.match_against_info then
        _item.filterText = (v.abbr or v.word) .. (v.menu ~= nil and (" " .. v.menu) or "")
      end

      -- Symbols should have a length of 1 but, since most of them are Unicode
      -- characters, are more than 1 byte long (up to 3). Unfortunately, Lua
      -- counts using the number of bytes, since it doesn't support Unicode.
      if config.additional_information.symbols_in_menu and menuLength <= 3 then
        _item.labelDetails.description = v.menu
      end

      table.insert(items, _item)
    end
  end
  callback { items = items }
end

source._invoke = function(_, func, args)
  local prev_pos = vim.api.nvim_win_get_cursor(0)
  local _, result = pcall(function()
    return vim.fn["cmp_vimtex#invoke"](func, args)
  end)
  local next_pos = vim.api.nvim_win_get_cursor(0)
  if prev_pos[1] ~= next_pos[1] or prev_pos[2] ~= next_pos[2] then
    vim.api.nvim_win_set_cursor(0, prev_pos)
  end
  return result
end

return source

local source = {}
local uv = vim.loop.version()

local defaults = {
    info_in_menu = 1,
    info_in_window = 1,
    match_against_description = 1,
    parse_bibtex = 1,
    symbols_in_menu = 1,
}

source.newbib_r = function(self)
    local parser = require('cmp_vimtex.parser')

    vim.cmd([[call vimtex#paths#pushd(b:vimtex.root)]])
    local files = vim.fn['vimtex#bib#files']()
    for _, file in pairs(files) do
        if self.bib_files[file] == nil then
            local new_parser = parser.new(file)
            new_parser:start_parsing()
            self.bib_files[file] = new_parser
        end
    end
end

local apply_config = function(user_config)
    return vim.tbl_deep_extend("keep", user_config or {}, defaults)
end

source.new = function(options)
  local self = setmetatable({}, { __index = source })
  self.bib_files = {}
  self.config = apply_config(options)
  cmp_vimtex_global = self

  return self
end

source.is_available = function()
  return vim.bo.omnifunc ~= '' and vim.api.nvim_get_mode().mode == 'i'
end

source.get_position_encoding_kind = function()
  return 'utf-8'
end

source.get_keyword_pattern = function()
  return [[\k\+]]
end

source.get_trigger_characters = function()
    return { '{' }
end

source.complete = function(self, params, callback)
  local config = self.config

  local offset_0 = self:_invoke(vim.bo.omnifunc, { 1, '' })
  if type(offset_0) ~= 'number' then
    return callback()
  end
  local result = self:_invoke(vim.bo.omnifunc, { 0, string.sub(params.context.cursor_before_line, offset_0 + 1) })
  if type(result) ~= 'table' then
    return callback()
  end

  local text_edit_range = {
    start = {
      line = params.context.cursor.line,
      character = offset_0,
    },
    ['end'] = {
      line = params.context.cursor.line,
      character = params.context.cursor.character,
    },
  }

  local items = {}
  for _, v in ipairs(result) do
    local menuLength = (v.menu ~= nil and string.len(v.menu) or 3)

    if type(v) == 'string' then
      table.insert(items, {
        label = v,
        textEdit = {
          range = text_edit_range,
          newText = v,
        },
      })
    elseif type(v) == 'table' then

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

      --if config.info_in_menu == 1 and menuLength > 3 then
      --  _item.labelDetails.description = v.menu
      --end

      if config.info_in_window == 1 then
        if config.parse_bibtex == 1 then
          for _, data in pairs(self.bib_files) do
            if data.indexed == 1  and data.result[_item.label] ~= nil then
              _item.documentation = {
                kind = 'markdown',
                value = data.result[_item.label].info,
              }
            end
          end
        else
          _item.documentation = {
            kind = 'plaintext',
            value = v.info,
          }
        end
      end

      if config.match_against_info == 1 then
        _item.filterText = (v.abbr or v.word) .. (v.menu ~= nil and (" " .. v.menu) or "")
      end

      -- Symbols should have a length of 1 but, since most of them are Unicode
      -- characters, are more than 1 byte long (up to 3). Unfortunately, Lua
      -- counts using the number of bytes, since it doesn't support Unicode.
      if config.symbols_in_menu == 1 and menuLength <= 3 then
        _item.labelDetails.description = v.menu
      end

      table.insert(items, _item)

    end
  end
  callback({ items = items })
end

source._invoke = function(_, func, args)
  local prev_pos = vim.api.nvim_win_get_cursor(0)
  local _, result = pcall(function()
    return vim.fn['cmp_vimtex#invoke'](func, args)
  end)
  local next_pos = vim.api.nvim_win_get_cursor(0)
  if prev_pos[1] ~= next_pos[1] or prev_pos[2] ~= next_pos[2] then
    vim.api.nvim_win_set_cursor(0, prev_pos)
  end
  return result
end

return source
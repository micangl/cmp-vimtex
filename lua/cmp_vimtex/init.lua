local source = {}
local uv = vim.loop.version()
local parser = require('cmp_vimtex.parser')

local defaults = {
    info_in_menu = 1,
    info_in_window = 1,
    match_against_description = 1,
    symbols_in_menu = 1,
}

--local group = vim.api.nvim_create_augroup('cmp_vimtex', {clear = true})
--vim.api.nvim_create_autocmd({"BufWinEnter",}, {
--  pattern = '*.tex',
--  group = group,
--  --callback = function() newbib() end,
--  --callback = function() aucmd_function() end,
--  --command = "echo 'Autocommand working.'",
--  --callback = function()
--  --    vim.schedule(function() newbib_r() end)
--  --end,
--  command = "lua newbib_r()",
--
--})

newbib_r = function()
    local parser = require('cmp_vimtex.parser')

    vim.cmd([[call vimtex#paths#pushd(b:vimtex.root)]])
    local files = vim.fn['vimtex#bib#files']()
    for _, value in pairs(files) do
        parser.parse_with_vim(parser, value)
    end

    vim.cmd([[call vimtex#paths#popd()]])
end

--newbib_r = function()
--    vim.cmd([[call vimtex#paths#pushd(b:vimtex.root)]])
--    local tmp = vim.fn['vimtex#bib#files']()
--    logger(vim.g.cmp_vimtex_parsing)
--    for _, value in pairs(tmp) do
--        --For some reason this is not being assigned to vim.g.cmp_vimt...
--        vim.g.cmp_vimtex_parsing.to_be_parsed[value] =  value
--        logger(vim.g.cmp_vimtex_parsing)
--    end
--    --logger(vim.g.cmp_vimtex_parsing.to_be_parsed)
--    --vim.g.cmp_vimtex_parsing.to_be_parsed = vim.fn['vimtex#bib#files']()
--    -- For some reason the preceding assignment fails.
--    --vim.cmd([[echom tostring(g:cmp_vimtex_parsing[to_be_parsed])]])
--    --logger(vim.g.cmp_vimtex_parsing.to_be_parsed)
--
--    if vim.g.cmp_vimtex_parsing.to_be_parsed ~= nil then
--        vim.schedule(function() vim.fn['cmp_vimtex#parse_with_vim_r']() end)
--    end
--end

--newbib = function()
--    logger(os.date("Beginning: %X"))
--    beg_time = os.clock()
--    vim.cmd([[call vimtex#paths#pushd(b:vimtex.root)]])
--    local files = vim.fn['vimtex#bib#files']()
--    
--    local parsed_data = {}
--
--    for _, file in pairs(files) do
--      -- Provisory variable
--      local was_modified = 1
--      if bib_files[file] == nil or was_modified then
--        -- result is probably useless (as in not needed)
--        logger(os.date("About to parse file: %X"))
--        beg_parse_time_1 = os.clock()
--        --local result = vim.fn['cmp_vimtex#parse_bibtex'](file)
--        local result = vim.fn['cmp_vimtex#parse_with_vim'](file)
--        --local result = parser(file)
--        end_parse_time_1 = os.clock()
--        logger("beg_parse_time: " .. beg_parse_time_1 - beg_time .. "\n")
--        logger(os.date("Parsed file: %X"))
--        logger("end_parse_time: " .. end_parse_time_1 - beg_parse_time_1 .. "\n")
--        for key, value in pairs(result) do
--            parsed_data[value.key] = value
--        end
--        logger(os.date("Formatted file: %X"))
--        formatted_time = os.clock()
--        logger("formatted_time: " .. formatted_time - end_parse_time_1 .. "\n")
--        result = nil
--        bib_files[file] = {
--            required_by = {},
--            added = {},
--            data = parsed_data,
--        }
--        parsed_data = {}
--        logger(os.date("Assigned table: %X"))
--        assigned_time = os.clock()
--        logger("formatted_time: " .. assigned_time - formatted_time .. "\n")
--      end
--    end
--    end_time = os.clock()
--    logger("End_time: " .. end_time - beg_time .. "\n")
--    logger(os.date("Ending: %X"))
--    logger(bib_files)
--    logger("Log_time: " .. os.clock() - end_time .. "\n")
--    logger(os.date("Logging: %X"))
--    vim.cmd([[call vimtex#paths#popd()]])
--    --res = vim.fn['cmp_vimtex#parse_bibtex']()
--    --for ind, el in ipairs(res) do
--    --  res[el.key] = el
--    --  res[ind] = nil
--    --end
--end
--
--parse_response = function()
--    -- Correctly formats the data.
--    -- For each file.
--    for key, _ in pairs(vim.g.cmp_vimtex_bib_files) do
--        -- For each entry of the current file.
--        for _key, _value in pairs(vim.g.cmp_vimtex_bib_files[key].data) do
--            vim.g.cmp_vimtex_bib_files.data[_value._key] = _value
--            vim.g.cmp_vimtex_bib_files.data[_key] = nil
--        end
--    end
--
--    vim.cmd([[call vimtex#paths#popd()]])
--end

local apply_config = function(user_config)
    return vim.tbl_deep_extend("keep", user_config, defaults)
end

source.new = function()
  -- All the bibtex files which have been parsed.
  bib_files = {}
  vim.g.cmp_vimtex_parsing = {
  to_be_parsed = {},
  }
  return setmetatable({}, { __index = source })
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
  --local fn = vim.schedule_wrap(newbib_r)
  --fn()
  local config = apply_config(params.option)

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

      if config.info_in_menu == 1 and menuLength > 3 then
        _item.labelDetails.description = v.menu
      end
      
      if config.info_in_window == 1 then
        _item.documentation = {
          kind = 'plaintext',
          value = v.info,
        }
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

parser = function(file)

    if not vim.fn.filereadable(file) then
        return {}
    end

    local current = {}
    local strings = {}
    local entries = {}
    local lnum = 0
    for _, line in pairs(vim.fn.readfile(file)) do
        lnum = lnum + 1

        if vim.fn.empty(current) then
            if vim.fn['cmp_vimtex#parse_type'](file, lnum, line, current, strings, entries) then
                current = {}
            end
            goto continue
        end

        if current.type == 'string' then
            if vim.fn['cmp_vimtex#parse_string'](line, current, strings) then
                current = {}
            end
        else
            if vim.fn['cmp_vimtex#parse_entry'](line, current, string) then
                current = {}
            end
        end
        ::continue::
    end
    
    return vim.fn.map(entries, 's:parse_entry_body(v:val, l:strings)')
end

return source

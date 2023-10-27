-- Copyright (c) 2021 Karl Yngve Lervåg
-- Copyright (c) 2023 micangl
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
local parser = {}
local timer = require('cmp_vimtex.timer')

parser.new = function(file)
  local self = setmetatable({}, { __index = parser })

  self.file = file
  self.timer = timer.new()

  self.result = {}
  self.indexed = 0

  self.data = {}
  self.size = 0

  self.current = {}
  self.strings = {}
  self.entries = {}
  self.lnum = 0

  return self
end

parser.format_entry = function(entry)
  local info = ""
  local _entry = {}

  local _format = function(title, object)
    return "**" .. string.upper(title) .. "**" .. ": " .. object .. "\n"
  end

  local has_priority = function(key, list)
    for _, b in pairs(list) do
      if b == key then
        return true
      end
    end

    return false
  end

  local prioritized_keys = { 'title', 'author' }
  for _, key in pairs(prioritized_keys) do
    if entry[key] ~= nil then
      info = info .. _format(key, entry[key])
    end
  end

  local i = 1
  for k, v in pairs(entry) do
    if has_priority(k, prioritized_keys) then
      goto continue
    end

    _entry[i] = _format(k, v)
    i = i + 1
    ::continue::
  end
  table.sort(_entry)

  for _, a in ipairs(_entry) do
    info = info .. a
  end

  return info
end

parser.start_parsing = function(self)
  if self.file == nil then
    return
  end

  if not vim.fn['filereadable'](self.file) then
    return
  end

  self.data = vim.fn['readfile'](self.file)
  self.size = #self.data

  self.timer:start(0, 50, function()
    local current_lines = 0
    local _beg = self.lnum + 1
    local _end = _beg + 199

    for i = _beg, _end do
      if i > self.size then
        break
      end
      local line = self.data[i]
      self.lnum = self.lnum + 1
      current_lines = current_lines + 1

      if self.empty(self.current) then
        if self.parse_type(self, line) then
          self.current = {}
        end
        -- Lua doesn't provide a continue statement.
        goto continue
      end

      if self.current.type == 'string' then
        if self.parse_string(self, line) then
          self.current = {}
        end
      else
        if self.parse_entry(self, line) then
          self.current = {}
        end
      end
      ::continue::

      if current_lines >= 200 then
        goto finish
      end
    end

    self.data = nil
    self.current = nil
    self.lnum = nil

    for _, v in pairs(self.entries) do
      self.result[v.key] = self.parse_entry_body(self, v)
      self.result[v.key].info = self.format_entry(self.result[v.key])
    end

    self.strings = nil
    self.entries = nil

    self.indexed = 1

    self.timer:stop()

    ::finish::
  end)
end

parser.parse_type = function(self, line)
  local matches = vim.fn['matchlist'](line, [[\v^\@(\w+)\s*\{\s*(.*)]])
  if self.empty(matches) then
    return false
  end

  -- First match. 2 is used because Lua in 1-indexed
  local type = string.lower(matches[2])
  local types = { preamble = 1, comment = 1 }
  if types[type] ~= nil then
    return false
  end
  types = nil

  self.current.level = 1
  self.current.body = ''
  self.current.vimtex_file = self.file
  self.current.vimtex_lnum = self.lnum

  if type == 'string' then
    return self.parse_string(self, matches[3])
  else
    matches = vim.fn['matchlist'](matches[3], [[\v^([^, ]*)\s*,\s*(.*)]])
    self.current.type = type
    self.current.key = matches[2]

    if self.empty(matches[3]) then
      return false
    else
      self.parse_entry(self, matches[3])
    end
  end
end

parser.parse_string = function(self, line)
  self.current.level = self.current.level + vim.fn['cmp_vimtex#count'](line, '{') - vim.fn['cmp_vimtex#count'](line, '}')
  if self.current.level > 0 then
    self.current.body = self.current.body .. line
    return false
  end

  self.current.body = self.current.body .. vim.fn['matchstr'](line, [[.*\ze}]])

  local matches = vim.fn['matchlist'](self.current.body, [[\v^\s*(\w+)\s*\=\s*"(.*)"\s*$]])
  if not self.empty(matches) and not self.empty(matches[2]) then
    self.strings[matches[2]] = matches[3]
  end

  return true
end

parser.parse_entry = function(self, line)
  self.current.level = self.current.level + vim.fn['cmp_vimtex#count'](line, '{') - vim.fn['cmp_vimtex#count'](line, '}')
  if self.current.level > 0 then
    self.current.body = self.current.body .. line
    return false
  end

  self.current.body = self.current.body .. vim.fn['matchstr'](line, [[.*\ze}]])

  table.insert(self.entries, self.current)
  return true
end

parser.parse_entry_body = function(self, entry)
  entry.level = nil

  local key = ''
  -- Pos is 0-indexed
  local pos = vim.fn['matchend'](entry.body, [[^\s*]])
  while pos >= 0 do
    if self.empty(key) then
      key, pos = self.get_key(self, entry.body, pos)
    else
      local value
      value, pos = self.get_value(self, entry.body, pos)
      entry[key] = value
      key = ''
    end
  end

  entry.body = nil
  return entry
end

---@param head 0-index
parser.get_key = function(self, body, head)
  local matches = vim.fn['matchlist'](body, [[^\v([-_:0-9a-zA-Z]+)\s*\=\s*]], head)
  if self.empty(matches) then
    return '', -1
  else
    -- The first match is the second element. The first is the original string.
    return string.lower(matches[2]), head + vim.fn['strlen'](matches[1])
  end
end

parser.get_value = function(self, body, head)
  --Note the +1, since the substring is extracted by lua.
  if vim.regex([[\d]]):match_str(body:sub(head + 1, head + 1)) then
    local value = vim.fn['matchstr'](body, [[^\d\+]], head)
    local head_1 = vim.fn['matchend'](body, [[^\s*,\s*]], head + vim.fn['len'](value))
    return value, head_1
  else
    return self.get_value_string(self, body, head)
  end
end

---@param head 0-index
parser.get_value_string = function(self, body, head)
  local value
  local head_1
  if body:sub(head + 1, head + 1) == '{' then
    local sum = 1
    local i1 = head + 1
    local i0 = i1

    while sum > 0 do
      local match
      local res = vim.fn['matchstrpos'](body, [=[[{}]]=], i1)
      match, _, i1 = res[1], res[2], res[3]
      res = nil

      if i1 < 0 then
        break
      end

      i0 = i1
      sum = sum + (match == '{' and 1 or -1)
    end

    value = body:sub(head + 1 + 1, i0 - 2 + 1)
    head_1 = vim.fn['matchend'](body, [[^\s*]], i0)
  elseif body:sub(head + 1, head + 1) == [["]] then
    local index = vim.fn['match'](body, [[\\\@<!"]], head + 1)
    if index < 0 then
      return 'cmp_vimtex: get_value_string failed', ''
    end

    value = body:sub(head + 1 + 1, index - 1 + 1)
    head_1 = vim.fn['matchend'](body, [[^\s*]], index + 1)
    return value, head_1
  elseif vim.regex([[^\w]]):match_str(body:sub(head + 1)) then
    value = vim.fn['matchstr'](body, [[^\x\+]], head)
    head_1 = vim.fn['matchend'](body, [[^\s*]], head + vim.fn['strlen'](value))
    value = vim.fn['get'](self.strings, value, [[@(]] .. value .. [[)]])
  else
    head_1 = head
  end

  if body:sub(head + 1, head + 1) == '#' then
    head_1 = vim.fn['matchend'](body, [[^\s*]], head_1 + 1)
    local vadd
    vadd, head_1 = self.get_value_string(self, body, head_1)
    value = value .. vadd
  end

  return value, vim.fn['matchend'](body, [[^,\s*]], head_1)
end

parser.empty = function(list)
  if type(list) == "table" then
    if next(list) == nil then
      return true
    else
      return false
    end
  elseif type(list) == "string" then
    if list == "" then
      return true
    else
      return false
    end
  end
end

return parser

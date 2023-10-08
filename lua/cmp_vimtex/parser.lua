local parser = {}

parser.parse_with_vim = function(self, file)
    if not vim.fn['filereadable'](file) then
        return
    end

    local current = {}
    local strings = {}
    local entries = {}
    local lnum = 0
    for _, line in pairs(vim.fn['readfile'](file)) do
        lnum = lnum + 1

        if empty(current) then
            if self.parse_type(self, file, lnum, line, current, strings, entries) then
                current = {}
            end
            -- Lua doesn't provide a continue statement.
            goto continue
        end

        if current.type == 'string' then
            if self.parse_string(self, line, current, strings) then
                current = {}
            end
        else
            if self.parse_entry(self, line, current, entries) then
                current = {}
            end
        end
        ::continue::
    end

    for i, v in pairs(entries) do
        entries[i] = self.parse_entry_body(self, v, strings)
    end
    return entries
end

parser.parse_type = function(self, file, lnum, line, current, strings, entries)
    local matches = vim.fn['matchlist'](line, [[\v^\@(\w+)\s*\{\s*(.*)]])
    if empty(matches) then
        return false
    end

    -- First match. 2 is used because Lua in 1-indexed
    local type = string.lower(matches[2])
    -- Check if type is one of the two in the table. Could be more efficiently, maybe.
    local types = {preamble = 1, comment = 1}
    if types[type] ~= nil then
        return false
    end
    types = nil

    current.level = 1
    current.body = ''
    current.vimtex_file = file
    current.vimtex_lnum = lnum

    if type == 'string' then
        return self.parse_string(matches[3], current, strings)
    else
        matches = vim.fn['matchlist'](matches[3], [[\v^([^, ]*)\s*,\s*(.*)]])
        current.type = type
        current.key = matches[2]

        -- Using empty like this may be problematic. I think that mathces[3] is maybe a string.
        if empty(matches[3]) then
            return false
        else
            self.parse_entry(matches[3], current, entries)
        end
    end
end

parser.parse_string = function(self, line, string, strings)
    string.level = string.level + vim.fn['cmp_vimtex#count'](line, '{') - vim.fn['cmp_vimtex#count'](line, '}')
    if string.level > 0 then
        string.body = string.body .. line
        return false
    end
    
    string.body = string.body .. vim.fn['matchstr'](line, [[.*\ze}]])

    local matches = vim.fn['matchlist'](string.body, [[\v^\s*(\w+)\s*\=\s*"(.*)"\s*$]])
    --Again, empty(...) is possibly used on a string. Problematic?
    if not empty(matches) and not empty(matches[2]) then
        strings[matches[2]] = matches[3]
    end

    return true
end

parser.parse_entry = function(self, line, entry, entries)
    entry.level = entry.level + vim.fn['cmp_vimtex#count'](line, '{') - vim.fn['cmp_vimtex#count'](line, '}')
    if entry.level > 0 then
        entry.body = entry.body .. line
        return false
    end

    entry.body = entry.body .. vim.fn['matchstr'](line, [[.*\ze}]])

    --call add(...)
    table.insert(entries, entry)
    return true
end

parser.parse_entry_body = function(self, entry, strings)
    entry.level = nil

    local key = ''
    -- Pos is 0-indexed
    local pos = vim.fn['matchend'](entry.body, [[^\s*]])
    while pos >= 0 do
        if empty(key) then
            key, pos = self.get_key(self, entry.body, pos)
        else
            local value
            value, pos = self.get_value(self, entry.body, pos, strings)
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
    if empty(matches) then
        return '', -1
    else
        -- The first match is the second element. The first is the original string.
        return string.lower(matches[2]), head + vim.fn['strlen'](matches[1])
    end
end

parser.get_value = function(self, body, head, strings)
    --Note the +1, since the substring is extracted by lua.
    if vim.regex([[\d]]):match_str(body:sub(head+1, head+1)) then
        local value = vim.fn['matchstr'](body, [[^\d\+]], head)
        local head = vim.fn['matchend'](body, [[^\s*,\s*]], head + vim.fn['len'](value))
        return value, head
    else
        return self.get_value_string(self, body, head, strings)
    end

    return 'cmp_vimtex#get_value failed', -1
end

---@param head 0-index
parser.get_value_string = function(self, body, head, strings)
    local value
    local head_1
    if body:sub(head+1, head+1) == '{' then
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

        value = body:sub(head+1+1, i0-2+1)
        head_1 = vim.fn['matchend'](body, [[^\s*]], i0)
    elseif body:sub(head+1, head+1) == [["]] then
        local index = vim.fn['match'](body, [[\\\@<!"]], head+ 1)
        if index < 0 then
            return 'cmp_vimtex: get_value_string failed', ''
        end

        value = body:sub(head+1+1, index-1+1)
        head_1 = vim.fn['matchend'](body, [[^\s*]], index+1)
        return value, head_1
    elseif vim.regex([[^\w]]):match_str(body:sub(head+1)) then
        value = vim.fn['matchstr'](body, [[^\x\+]], head)
        head_1 = vim.fn['matchend'](body, [[^\s*]], head + vim.fn['strlen'](value))
        value = vim.fn['get'](strings, value, [[@(]] .. value .. [[)]])
    else
        head_1 = head
    end

    if body:sub(head+1, head+1) == '#' then
        head_1 = vim.fn['matchend'](body, [[^\s*]], head_1 + 1)
        local vadd
        vadd, head_1 = self.get_value_string(body, head_1, strings)
        value = value .. vadd
    end

    return value, vim.fn['matchend'](body, [[^,\s*]], head_1)
end

empty = function(list)
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

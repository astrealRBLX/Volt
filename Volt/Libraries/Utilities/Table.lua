--[[

    Libraries/Utilities/Table

    @description Library providing more features for table manipulation
    @author AstrealDev

]]

local Table = { Name = 'Table' }

local READONLY_METATABLE = {
    __index = function(t, k, v)
        return t._raw[k]
    end,
    __newindex = function()
        error('Attempt to set a value on a read-only table.')
    end
}

--[[
    Create a new table starting and ending at the provided indices
]]
function Table.Select(tbl, startIndex, endIndex)
    endIndex = endIndex or table.getn(tbl)
    local empty = {}
    local selecting = false
    for key, value in pairs(tbl) do
        if (key >= startIndex and key <= endIndex) then
            selecting = true
        else
            selecting = false
        end
        if (selecting) then
            table.insert(empty, value)
        end
    end
    return empty
end

--[[
    Split a table at a certain index
    Value at index provided will be kept in the first returned table
]]
function Table.Split(tbl, index)
    local tbl1 = Table.Copy(tbl)
    local tbl2 = Table.Copy(tbl1)
    for i = index + 1, table.getn(tbl1), 1 do
        tbl1[i] = nil
    end
    for i = (index), 1, -1 do
        tbl2[i] = nil
    end
    tbl2 = Table.Shift(tbl2, -index)
    return tbl1, tbl2
end

--[[
    Shift a table and wrap the values around
]]
function Table.Wrap(tbl, shift)
    local copy = Table.Copy(tbl)
    for i = 1, shift do
        table.insert(copy, 1, copy[#copy])
        table.remove(copy, #copy)
    end
    return copy
end

--[[
    Shift a table's values
]]
function Table.Shift(tbl, shift)
    local copy = Table.Copy(tbl)
    for i = shift > 0 and #tbl or 1, shift < 0 and #tbl or 1, shift > 0 and -1 or 1 do
        copy[i + shift] = tbl[i]
        copy[i] = nil
    end
    return copy
end

--[[
    Extend a table by copying values from another table
]]
function Table.Extend(tbl, tbl2)
    local copy = Table.Copy(tbl)
    for key, value in pairs(tbl2) do
        print(key, value)
        if (typeof(key) == 'number') then
            if (table.find(copy, value) == nil) then
                table.insert(copy, value)
            end
            continue
        end
        print(key)
        if (copy[key] == nil) then
            copy[key] = value
        end
    end
    return copy
end

--[[
    Remove all instances of x from a table
]]
function Table.Clean(tbl, value)
    local copy = Table.Copy(tbl)
    copy = Table.Filter(copy, function(v)
        if (v == value) then
            return false
        end
        return true
    end)
    return copy
end

--[[
    Copy a table
]]
function Table.Copy(tbl)
    local copy = {}
    for key, value in pairs(tbl) do
        if (typeof(value) == 'table') then
            copy[key] = Table.Copy(value)
            continue
        end
        copy[key] = value
    end
    return copy
end

--[[
    Lua equivalent to JavaScript's fill()
]]
function Table.Fill(tbl, value, startIndex, endIndex)
    startIndex = startIndex or 1
    endIndex = endIndex or table.getn(tbl)
    local copy = Table.Copy(tbl)
    for i = startIndex, endIndex, 1 do
        copy[i] = value
    end
    return copy
end

--[[
    Lua equivalent to JavaScript's copyWithin()
]]
function Table.CopyWithin(tbl, target, startIndex, endIndex)
    endIndex = endIndex or table.getn(tbl)
    local copy = Table.Copy(tbl)
    local intIndex = 0
    for i = startIndex, endIndex, 1 do
        copy[target + intIndex] = tbl[i]
        intIndex += 1
    end
    return copy
end

--[[
    Lua equivalent to JavaScript's filter()
]]
function Table.Filter(tbl, callback)
    local final = {}
    for key, value in pairs(tbl) do
        local result = callback(value)
        if (result) then
            final[key] = value
        end
    end
    return final
end

--[[
    Flatten a table down to the first level
]]
function Table.Flatten(tbl)
    local final = {}
    for key, value in pairs(tbl) do
        if (typeof(value) ~= 'table') then
            table.insert(final, value)
            continue
        end
        if (typeof(key) ~= 'number') then continue end
        for key2, value2 in pairs(value) do
            if (typeof(value2) == 'table') then
                local flat = Table.Flatten(value2)
                for key3, value3 in pairs(flat) do
                    table.insert(final, value3)
                end
                continue
            end
            table.insert(final, value2)
        end
    end
    tbl = final
    return final
end

--[[
    Create a read-only table
]]
function Table.ReadOnly(tbl, deep)
    local self = setmetatable({}, READONLY_METATABLE)
    rawset(self, '_raw', tbl)
    if (deep) then
        for key, value in pairs(tbl) do
            if (typeof(value) ~= 'table') then continue end
            rawset(self._raw, key, Table.ReadOnly(value, true))
        end
    end
    return self
end


return Table
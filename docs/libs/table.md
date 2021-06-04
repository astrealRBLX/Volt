# Table
Table is a useful Lua table manipulation library.

## Examples
```lua
local Volt = require(game.ReplicatedStorage.Volt)
local Table = Volt.import('Libraries/Utilities/Table')

local myTable = {'a', 'b', 'c', 'd', 'e', 'f'}
print(Table.Select(myTable, 2, 5)) --> Outputs: {'b', 'c', 'd', 'e'}
print(Table.Split(myTable, 3)) --> Outputs: {'a', 'b', 'c'}, {'d', 'e', 'f'}
print(Table.Wrap(myTable, 2)) --> Outputs: {'e', 'f', 'a', 'b', 'c', 'd'}
print(Table.Shift(myTable, -5)) --> Outputs: {[-4] = 'a', [-3] = 'b', [-2] = 'c', [-1] = 'd', [0] = 'e', [1] = 'f'}
print(Table.Extend(myTable, {'g', 'h', 'i'})) --> Outputs: {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'}
print(Table.Clean(myTable, 'a')) --> Outputs: {'b', 'c', 'd', 'e', 'f'}
print(Table.Copy(myTable)) --> Outputs: {'a', 'b', 'c', 'd', 'e', 'f'}
print(Table.Fill(myTable, 'filler', 2, 5)) --> Outputs: {'a', 'filler', 'filler', 'filler', 'filler', 'f'}
print(Table.CopyWithin(myTable, 1, 3, 5)) --> Outputs: {'c', 'd', 'e', 'd', 'e', 'f'}
print(Table.Filter(myTable, function(v) return v == 'c' or v == 'f' end)) --> Outputs: {'c', 'f'}
print(Table.Flatten(myTable, {1, 2, 3, {4, 5, 6, {7, 8, {9, 10}}}})) --> Outputs: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local readOnly = Table.ReadOnly(myTable)
readOnly.abc = 'Hello world!' --> Errors: Attempt to set a value on a read-only table.
```
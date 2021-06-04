# InstanceBuilder
InstanceBuilder is a library created specifically for Volt. It allows you to use method chaining to quickly create instances.

## Settings
* enabled - Is InstanceBuilder enabled?

## Example
```lua
local Volt = require(game.ReplicatedStorage.Volt)
Volt.import('Libraries/Instances/InstanceBuilder')

local myPart = Instance.new('Part')
    .Name('My Part!')
    .Color(Color3.fromRGB(255, 0, 0))
    .Parent(workspace)
    .Build() -- .Build() returns the Roblox instance itself

Instance.new('Part')
    .Name('Anonymous Part!')
    .Parent(workspace)
```

!!! tip
    There is no need to set imported InstanceBuilder to a variable. It will override your script environment's default Instance class.
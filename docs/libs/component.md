# Component
Component is a library made specifically for Volt. You can use Component to create `components` which are essentially just containers of instances. These instances can have events binded to them in bulk.

## Examples
```lua
local Volt = require(game.ReplicatedStorage.Volt)
local Component = Volt.import('Libraries/Instances/Component')

local myComponent = Component.new('KillParts')
myComponent:Assign({ workspace.KillPart1, workspace.KillPart2 }):Connect('Touched', function(self, hit)
    -- self is the instance the event was fired on
    print(self.Name, 'was touched by', hit.Name)
end)
```

## API
> #### `Component Component.new(string name)`
> Create a new component

> #### `Component Component.Get(string name)`
> Get an existing component by name

> #### `Component Component:Assign({Instance} instances)`
> Assign instances to a component

> #### `Component Component:Connect(string event, function callback)`
> Bulk connect an event & callback to a component's instances

> #### `Component Component:Clean()`
> Clean up a component's connections

> #### `void Component:Destroy()`
> Fully destroy & clean a component
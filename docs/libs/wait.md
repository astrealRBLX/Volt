# Wait
Wait is a library originally created by CloneTrooper1019 that was ported over to Volt. It is a more optimized version of the global Roblox wait() function.

## Settings
* enabled - Is Wait enabled?
* warnings - Should Wait warn you about the dangers of wait()?

## Example
```lua
local Volt = require(game.ReplicatedStorage.Volt)
Volt.import('Libraries/Utilities/Wait')

wait() --> Outputs a warning since warnings are enabled by default
```

!!! tip
    There is no need to set imported Wait to a variable. It will override your script environment's default wait() function.
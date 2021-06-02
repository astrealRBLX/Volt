# BetterWait
BetterWait is library originally created by CloneTrooper1019 that was ported over to Volt. It is a more optimized version of the global Roblox wait() function.

## Settings
* enabled - Is BetterWait enabled?
* warnings - Should BetterWait warn you about the dangers of wait()?

## Example
```lua
local Volt = require(game.ReplicatedStorage.Volt)
Volt.import('Libraries/BetterWait')

wait() --> Outputs a warning since warnings are enabled by default
```

!!! tip
    There is no need to set imported BetterWait to a variable. It will override your script environment's default wait() function.
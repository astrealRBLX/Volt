# Tween
Tween is a great library as an alternative to Roblox's TweenService.

## Examples
This example will tween a number from 1 to 1000 over 5 seconds using the Quad EasingStyle and Out EasingDirection, round it down, then set a TextLabel's text to the number.
```lua
local Volt = require(game.ReplicatedStorage.Volt)
local Tween = Volt.import('Libraries/Utilities/Tween')

local player = game.Players.LocalPlayer

local screenGUI = script.Parent
local label = screenGUI.TextLabel

local tween = Tween.new(1, 1000, 5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
tween:OnStep(function(value)
    label.Text = tostring(math.floor(value))
end)
tween:Start()
```

## API
> #### `Tween Tween.new(any initialValue, any goal, number time, EasingStyle style, EasingDirection direction)`
> Create a new tween object.

> #### `any Tween.Lerp(any a, any b, number alpha)`
> Tween a value by providing an alpha. Special Roblox types are supported such as Vector3 and UDim2. Alpha should be between 0 and 1.

> #### `void Tween:Start()`
> Begin a tween.

> #### `void Tween:OnStep(function callback)`
> Connect a callback function called every time a tween steps.

> #### `void Tween:OnComplete(function callback)`
> Connect a callback function called when a tween completes.

> #### `void Tween:Wait()`
> Yield until a tween completes.

> #### `void Tween:Pause()`
> Pause a currently running tween.

> #### `void Tween:Resume()`
> Resume a currently running tween.

> #### `void Tween:Finish()`
> Force a tween to skip to its goal.
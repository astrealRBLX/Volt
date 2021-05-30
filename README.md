# <img src="https://user-images.githubusercontent.com/80359818/120092800-e199e300-c0e3-11eb-9e70-bb087f297184.png" width="42" align="left"> Volt

### What is Volt?
An intuitive and feature-packed Roblox game framework.


### Why Volt?
While other game frameworks exist (most notably AGF & Knit), Volt provides a different feature set as well as a different focus. Volt was created around the idea that organization comes before everything else. Many games tend to quickly become disorganized as they get populated with more and more scripts. Volt solves this problem through 'executables', module scripts Volt can read and assign to the server and client for simple communication between them. Volt also makes giving users the ability to manipulate the control flow of their scripts a priority including in an asynchronous manner.

### Example
```lua
-- Main.lua (Server Script)
local Volt = require(game.ReplicatedStorage.Volt)
local PlayerMoney = Volt.import('Money/PlayerMoney.Server')

-- Control flow of the server
Volt.Server.Execute({
  PlayerMoney
})
```
```lua
-- Main.lua (Local Script)
local Volt = require(game.ReplicatedStorage.Volt)
local PlayerMoney = Volt.import('Money/PlayerMoney.Client')

-- Control flow of the client
Volt.Client.Execute({
  PlayerMoney
})
```
```lua
-- PlayerMoney.Server.lua (Module Script)
local PlayerMoney = { Name = 'PlayerMoney', Async = false }

PlayerMoney.Players = {}

function PlayerMoney.OnExecute()
  -- Register bridge for getting money from the client
  -- Client -> Server
  PlayerMoney.Volt.RegisterBridge('PlayerMoney/GetMoney', function(player)
    return PlayerMoney.Players[player]
  end)

  -- Set default player money upon join
  game:GetService('Players').PlayerAdded:Connect(function(player)
    PlayerMoney.SetMoney(player, 15)
  end)
end

function PlayerMoney.SetMoney(player, amount)
  PlayerMoney.Players[player] = amount
end

return PlayerMoney
```
```lua
-- PlayerMoney.Client.lua (Module Script)
local PlayerMoney = { Name = 'PlayerMoney', Async = false }

function PlayerMoney.OnExecute()
  print(PlayerMoney.Volt.GetBridge('PlayerMoney/GetMoney'):Fire()) --> Prints 15
end

return PlayerMoney
```

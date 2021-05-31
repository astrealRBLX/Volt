--[[

	Volt // Game Framework
	Created by AstrealDev
	
	Version 1.0.0

]]

local Volt = { Core = {}, Config = require(script.Config), Root = script }

local core = script.Core
local lib = script.Libraries

local isClient = game.Players.LocalPlayer and true or false

for _, m in pairs(core:GetChildren()) do
	local src = require(m)
	src.constructor(Volt.Config.Core[src.name])
	src.constructor = nil
	Volt.Core[src.name] = src
end

for _, m in pairs(lib:GetChildren()) do
	local src = require(m)
	if (src.constructor) then
		src.constructor()
		src.constructor = nil
	end
end

if (not isClient) then
	Volt.Server = require(script.Server)(Volt)
	Volt.Bridges = Instance.new('Folder', Volt.Root)
	Volt.Bridges.Name = 'Bridges'
else
	Volt.Client = require(script.Client)(Volt)
	Volt.Bridges = script:FindFirstChild('Bridges')
end

Volt.import = Volt.Core.Import.new

return Volt

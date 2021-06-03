--[[

	Volt // Game Framework
	Created by AstrealDev
	
	Version 1.0.2

]]

local initialTime = tick()

local Volt = { Core = {}, Libraries = {}, Config = require(script.Config), Root = script }

local core = script.Core
local lib = script.Libraries

local isClient = game:GetService('RunService'):IsClient()

for _, m in pairs(core:GetChildren()) do
	local src = require(m)
	src.constructor(Volt.Config.Core[src.name])
	src.constructor = nil
	Volt.Core[src.name] = src
end

for _, m in pairs(lib:GetDescendants()) do
	if (not m:IsA('ModuleScript')) then continue end
	local src = require(m)
	if (src.name == nil) then
		error('All libraries must contain a name property')
	end
	Volt.Libraries[src.name] = src
end

for _, src in pairs(Volt.Libraries) do
	src.Volt = {
		Libraries = Volt.Libraries
	}
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

if (Volt.Config.Debug == true) then
	print(string.format('%s LOADED (%fs)', isClient and 'CLIENT' or 'SERVER', tick() - initialTime))
else
	initialTime = nil
end

return Volt
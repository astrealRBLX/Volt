--[[

	Volt // Game Framework
	Created by AstrealDev
	
	Version 1.1.0

]]

local initialTime = tick()

local Volt = { Core = {}, Libraries = {}, Config = require(script.Config), Root = script }

local core = script.Core
local lib = script.Libraries

local isClient = game:GetService('RunService'):IsClient()

-- Load core modules
for _, m in pairs(core:GetChildren()) do
	local src = require(m)
	if (src.constructor) then
		src.constructor(Volt.Config.Core[src.Name] or {})
	end
	src.constructor = nil
	src.Volt = Volt
	Volt.Core[src.Name] = src
end

-- Load library modules
for _, m in pairs(lib:GetDescendants()) do
	if (not m:IsA('ModuleScript')) then continue end
	local src = require(m)
	if (src.Name == nil) then
		error('All libraries must contain a Name property')
	end
	Volt.Libraries[src.Name] = src
end

-- Inject other libraries & call library constructors
for _, src in pairs(Volt.Libraries) do
	src.Volt = {
		Libraries = Volt.Libraries
	}
	if (src.constructor) then
		src.constructor()
		src.constructor = nil
	end
end

-- Define global Volt variables
Volt.import = Volt.Core.Import.new
Volt.BulkImport = Volt.Core.Import.bulk
Volt.Bridge = Volt.Core.Bridge

-- Provide respective side of Volt
if (not isClient) then
	Volt.Server = require(script.Server)(Volt)
	Volt.Bridges = Instance.new('Folder', Volt.Root)
	Volt.Bridges.Name = 'Bridges'
else
	Volt.Client = require(script.Client)(Volt)
	Volt.Bridges = script:FindFirstChild('Bridges')
end

-- Provide some debug information
if (Volt.Config.Debug == true) then
	print(string.format('%s LOADED (%fs)', isClient and 'CLIENT' or 'SERVER', tick() - initialTime))
else
	initialTime = nil
end

return Volt
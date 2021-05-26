--[[

	Volt // By AstrealDev
	Current Version: 1.0.0
	
]]

local initialTime = tick()

local Volt = {
	libraries = {},
	isClient = game.Players.LocalPlayer and true or false,
	Settings = require(script.Settings),
	debugMsg = function(msg, t)
		t = t or 1
		if (t == 0) then
			return '✗ Volt - ' .. msg
		elseif (t == 1) then
			return '✓ Volt - ' .. msg
		end
	end,
}

--[[
	Volt console messages
]]
local function err(str)
	return '✗ Volt - ' .. str
end
local function suc(str)
	return '✓ Volt - ' .. str
end

--[[
	Get a server instance of Volt
]]
function Volt.Server()
	assert(not Volt.isClient, err('Server cannot be used within client.'))
	
	local server = {
		import = Volt.import,
	}
	
	return server
end

--[[
	Get a client instance of Volt
]]
function Volt.Client()
	assert(Volt.isClient, err('Client cannot be used within server.'))
	
	return Volt
end

--[[
	Function for importing libraries
]]
function Volt.import(s)
	assert(Volt.libraries[s], err('Library "' .. s .. '" does not exist.'))
	if (Volt.libraries[s].serverSideOnly) then
		assert(not Volt.isClient, err('Attempted to import "' .. s .. '" from the client.'))
	end
	if (Volt.libraries[s].dependencies and (not Volt.libraries[s].hasLoaded)) then
		local loadedDependencies = 0
		for _, dep in pairs(Volt.libraries[s].dependencies) do
			for l, lib in pairs(Volt.libraries) do
				if (lib.id == dep) then
					Volt.libraries[s][l] = Volt.libraries[l]
					loadedDependencies += 1
				end
			end
		end
		assert(loadedDependencies == #Volt.libraries[s].dependencies, err(string.format('Missing %s dependencies for "' .. s .. '"!', tostring(#Volt.libraries[s].dependencies - loadedDependencies)))) 
		Volt.libraries[s].hasLoaded = true
	end
	if (Volt.libraries[s].OnImport) then
		Volt.libraries[s].OnImport()
	end
	return Volt.libraries[s]
end

--[[
	Require libraries
]]
for _, lib in pairs(Volt.Settings.LibrariesFolder:GetChildren()) do
	if (lib:IsA('ModuleScript')) then
		local source = require(lib)
		if (source.id == nil) then
			warn(err('Failed to load "' .. (source.name or lib.Name) .. '". Missing id field.'))
			continue
		end
		source.Volt = {
			import = Volt.import,
			isClient = Volt.isClient,
			Settings = Volt.Settings,
			debugMsg = Volt.debugMsg
		}
		Volt.libraries[source.name or lib.Name] = source
		if (source.OnLoaded) then
			source.OnLoaded()
		end
	end
end

if (Volt.Settings.Debug) then
	print(suc(string.format('%s loaded in ' .. tick() - initialTime .. ' seconds!', Volt.isClient and ('Client (' .. game.Players.LocalPlayer.Name .. ')') or 'Server')))
else
	initialTime = nil	
end

return Volt

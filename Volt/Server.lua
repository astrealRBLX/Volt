--[[
	Server
	
	Provided to all server scripts
	and server-side executables
]]

local Server = {}
local Volt, Promise

--[[
	Execute an executable
	@private
]]
local function execute(f)
	local initialTime = Volt.Config.Debug and tick() or nil
	local success, err = pcall(function()
		f.OnExecute()
	end)
	if ((not success) and err) then
		if (initialTime) then
			print(string.format('\t\t• %s\n\t\t\tERROR: %s', f.Name, err))
		else
			print(string.format('Error occurred while executing "%s"', f.Name))
			error(err)
		end
			
	elseif (initialTime) then
		print(string.format('\t\t• %s (%fs)', f.Name, tick() - initialTime))
	end
end

--[[
	Asynchronously execute an executable
	@private
]]
local function asyncExe(f)
	coroutine.wrap(function()
		execute(f)
	end)()
end

--[[
	Execute an executable and provide
	whether it should be ran asynchronously or not
	@public
]]
function Server.Execute(execs, async)
	local startTime = Volt.Config.Debug and tick() or nil
	if (startTime) then
		print('BEGIN EXECUTE')
	end
	for _, exe in pairs(execs) do
		exe.Bridges = setmetatable({}, {
			__newindex = Volt.Core.Bridge.__newindex
		})
		exe.Volt = {
			Server = Volt.Server,
			import = Volt.import,
			Bridge = Volt.Bridge 
		}
		if (exe.OnExecute) then
			if (exe.Async == true) then
				asyncExe(exe)
			else
				if (async == true) then
					asyncExe(exe)
				else
					execute(exe)
				end
			end
		end
		Volt.Server[exe.Name or error('Attempted to execute a module without a provided name field')] = exe
	end
	if (startTime) then
		print(string.format('END EXECUTE (%fs)', tick() - startTime))
	end
end

--[[
	Bulk import executables and return them
	in a nicely formatted way. Example of
	a return:
	local Executables = {
		PlayerData = ...,
	}

	You can then use the returned executables
	in Server.Execute:
	Volt.Server.Execute {
		Executables.PlayerData,
	}
	@public
]]
function Server.LoadExecutables(loc, deep)
	return Volt.BulkImport(loc,
		deep,
		function(child)
			if (string.match(child.Name, '.Server') == '.Server') then
				return true
			end
			return false
		end,
		function(child)
			return string.gsub(child.Name, '.Server', '')
		end)
end

--[[
	Await for an executable to execute. This
	is useful for cross communication between
	normal scripts and executables. Returns
	a Promise.
	@public	
]]
function Server.Await(n, t)
	local promise = Promise.new(function(resolve, reject)
		coroutine.wrap(function()
			local initialTime = tick()
			repeat
				game:GetService('RunService').Stepped:Wait()
				local passedTime = tick() - initialTime
				if (passedTime >= (t or 10)) then
					reject()
					error(string.format('Server.Await() has timed out (%fs)', passedTime))
				end
			until (Volt.Server[n] ~= nil)
			resolve()
		end)()
	end)
	return promise
end

return setmetatable({}, {
	__call = function(t, v, ...)
		Volt = v
		Promise = Volt.import('Libraries/Utilities/Promise')
		return Server
	end,
})
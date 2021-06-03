local Server = {}
local Volt

local function getFromPath(o, s)
	for i, v in pairs(string.split(s, '/')) do
		if (i == #(string.split(s, '/'))) then
			continue
		end
		local success = pcall(function()
			o = o[v]
		end)
		if (not success) then
			local x = Instance.new('Folder', o)
			x.Name = v
			o = x
		end
	end
	return o
end

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

local function asyncExe(f)
	coroutine.wrap(function()
		execute(f)
	end)()
end

local function constructBridge(r)
	local self = setmetatable({}, {})

	self._remote = r

	function self:Fire(c, ...)
		return self._remote:InvokeClient(c, ...)
	end
	
	function self:Hook(func)
		self._remote.OnServerInvoke = function(...)
			return func(...)
		end
	end

	return self
end

function Server.Execute(execs, async)
	local startTime = Volt.Config.Debug and tick() or nil
	if (startTime) then
		print('BEGIN EXECUTE')
	end
	for index, exe in pairs(execs) do
		exe.Volt = {
			RegisterBridge = function(path, func)
				local iPath = getFromPath(Volt.Bridges, path or error('A path must be provided to register a new bridge'))
				local remote = Instance.new('RemoteFunction', iPath)
				remote.Name = string.split(path, '/')[#(string.split(path, '/'))]
				
				remote.OnServerInvoke = function(...)
					return func(...)
				end
				
				return constructBridge(remote)
			end,
			Server = Volt.Server,
			import = Volt.import
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

function Server.Await(n, t, f)
	coroutine.wrap(function()
		local initialTime = tick()
		repeat
			game:GetService('RunService').Stepped:Wait()
			local passedTime = tick() - initialTime
			if (passedTime >= (t or 10)) then
				error(string.format('Server.Await() has timed out (%s seconds passed)', passedTime))
			end
		until (Volt.Server[n] ~= nil)
		if (f) then
			f()
		end
	end)()
end

return setmetatable({}, {
	__call = function(t, v, ...)
		Volt = v
		return Server
	end,
})
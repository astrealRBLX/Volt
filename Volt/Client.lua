local Client = {}
local Volt

local function getFromPath(o, s)
	for i, v in pairs(string.split(s, '/')) do
		local success = pcall(function()
			o = o[v]
		end)
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

	function self:Fire(...)
		return self._remote:InvokeServer(...)
	end
	
	function self:Hook(func)
		self._remote.OnClientInvoke = function(...)
			return func(...)
		end
	end

	return self
end

function Client.Execute(execs, async)
	local startTime = Volt.Config.Debug and tick() or nil
	if (startTime) then
		print('BEGIN EXECUTE')
	end
	for index, exe in pairs(execs) do
		exe.Volt = {
			GetBridge = function(path)
				return constructBridge(getFromPath(Volt.Bridges, path or error('A path must be provided to get a bridge')))
			end,
			Client = Volt.Client,
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
		Volt.Client[exe.Name or error('Attempted to execute a module without a provided name field')] = exe
	end
	if (startTime) then
		print(string.format('END EXECUTE (%fs)', tick() - startTime))
	end
end

return setmetatable({}, {
	__call = function(t, v, ...)
		Volt = v
		return Client
	end,
})
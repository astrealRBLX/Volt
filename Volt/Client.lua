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
	for index, exe in pairs(execs) do
		exe.Volt = {
			GetBridge = function(path)
				return constructBridge(getFromPath(Volt.Bridges, path or error('A path must be provided to get a bridge')))
			end,
			Client = Volt.Client
		}
		Volt.Client[exe.Name or error('Attempted to execute a module without a provided name field')] = exe
		if (exe.OnExecute) then
			if (exe.Async == true) then
				coroutine.wrap(function()
					exe.OnExecute()
				end)()
			else
				if (async == true) then
					coroutine.wrap(function()
						exe.OnExecute()
					end)()
				else
					exe.OnExecute()
				end
			end
		end
	end
end

return setmetatable({}, {
	__call = function(t, v, ...)
		Volt = v
		return Client
	end,
})

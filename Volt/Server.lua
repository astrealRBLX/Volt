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
			Server = Volt.Server
		}
		Volt.Server[exe.Name or error('Attempted to execute a module without a provided name field')] = exe
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
		return Server
	end,
})

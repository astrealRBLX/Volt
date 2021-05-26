--[[
	
	Service // Provided by Volt
	Created by AstrealDev
	
	Allows for the creation of Volt services,
	tables of information that securely
	replicate from server to client
	
]]

local Service = { id = 'service', dependencies = {} }
local ServiceClass = {}
local services = {}
local remoteFolder

--[[
	Locate a service from its name
]]
local function locateService(s)
	for _, v in pairs(Service.Volt.Settings.ServicesFolder:GetDescendants()) do
		if (v:IsA('ModuleScript')) then
			local src = require(v)
			if (src.name and src.public) then
				return src
			end
		end
	end
end

--[[
	Construct a client-side service
]]
local function constructService(s)
	local rawSrc = locateService(s)
	
	if (remoteFolder == nil) then
		remoteFolder = script:FindFirstChild('RF')
	end
	
	for k, prop in pairs(rawSrc.public.client) do
		local remote = remoteFolder:FindFirstChild(rawSrc.name):FindFirstChild(k)
		if (remote) then
			local this = setmetatable({}, {
				__call = function(t, ...)
					return remote:InvokeServer(...)
				end,
			})
			rawSrc.public.client[k] = this
		end
	end
	
	local self = setmetatable({}, {__index = ServiceClass})
	self._raw = rawSrc
	
	services[rawSrc.name] = self
end

--[[
	Load a service from a modulescript
	Server-side only
]]
function Service.Load(mod)
	assert(not Service.Volt.isClient, 'Load() can only be called from the server.')
	
	local service = require(mod)
	
	assert(mod.Parent == Service.Volt.Settings.ServicesFolder, 'Service must be a child of the set services folder.')
	assert(service.name, 'Failed to load service. Missing name field.')
	assert(service.public, 'Failed to load service. Missing public field.')
	assert(service.public.client, 'Failed to load service. Missing client field.')
	
	local serviceFolder = Instance.new('Folder', remoteFolder)
	serviceFolder.Name = service.name
	
	local remotes = {}
	
	-- Generate client remotes
	for k, prop in pairs(service.public.client) do
		if (typeof(prop) == 'function') then
			local func = Instance.new('RemoteFunction', serviceFolder)
			func.Name = k
			func.OnServerInvoke = function(...)
				return prop(service.public, ...)
			end
		end
	end
	
	local self = setmetatable({}, {__index = ServiceClass})
	self._raw = service
	self._rf = {}
	self._remotes = serviceFolder
	
	
	
	services[service.name] = self
	
	return Service.Get(service.name)
end

--[[
	Bulk load services through the provided parent folder
	Server-side only
]]
function Service.BulkLoad()
	assert(not Service.Volt.isClient, 'BulkLoad() can only be called from the server.')
	
	for _, child in pairs(Service.Volt.Settings.ServicesFolder:GetDescendants()) do
		if (not child:IsA('ModuleScript')) then continue end
		Service.Load(child)
	end
end

--[[
	Retrieve a service
]]
function Service.Get(s)
	if (Service.Volt.isClient) then
		if (services[s] == nil) then
			constructService(s)
		end
		return services[s]._raw.public.client
	else
		return services[s]._raw.public
	end
end

--[[
	Awake & start all services
	Server-side only
]]
function Service.Begin()
	assert(not Service.Volt.isClient, 'Begin() can only be called from the server.')
	
	for _, service in pairs(services) do
		if (service._raw.OnAwake) then
			coroutine.wrap(function()
				service._raw:OnAwake()
			end)()
		end
	end
	for _, service in pairs(services) do
		if (service._raw.OnStart) then
			coroutine.wrap(function()
				service._raw:OnStart()
			end)()
		end
	end
end

--[[
	Internal Volt method called upon loading
	Generate remote folders
]]
function Service.OnLoaded()
	if (not Service.Volt.isClient) then
		remoteFolder = Instance.new('Folder', script)
		remoteFolder.Name = 'RF'
	end
end

return Service

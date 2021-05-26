--[[
	
	Bridge // Provided by Volt
	Created by AstrealDev
	
	Bridge the gap between client & server

]]

local Bridge = { id = 'bridge' }
local BridgeClass = {}

Bridge.Types = {
	OPPOSITE = {
		Object = 'RemoteFunction'
	},
	SAME = {
		Object = 'BindableFunction'
	}
}

local isClient = game.Players.LocalPlayer and true or false
local bridges = {
	RF = {},
	BF = {}
}
local bridgesFolder = script:FindFirstChild('Bridges')

function Bridge.new(name, bType, override)
	assert((not isClient) or override, 'Cannot create a Bridge on the client.')
	
	local obj = Instance.new(bType.Object)
	obj.Name = name
	
	local self = setmetatable({}, { __index = BridgeClass })

	self._name = name
	self._instance = obj
	self._type = bType

	self._instance.Parent = bridgesFolder
	if (self._type.Object == 'RemoteFunction') then
		bridges.RF[self._name] = self
	elseif (self._type.Object == 'BindableFunction') then
		bridges.BF[self._name] = self
	end

	return self
end

function BridgeClass:Connect(func)
	if (self._instance:IsA('RemoteFunction')) then
		if (isClient) then
			self._instance.OnClientInvoke = function(...)
				return func(...)
			end
		else
			self._instance.OnServerInvoke = function(...)
				return func(...)
			end
		end
	elseif (self._instance:IsA('BindableFunction')) then
		self._instance.OnInvoke = function(...)
			return func(...)
		end
	end
end

function BridgeClass:Trigger(...)
	if (self._instance:IsA('RemoteFunction')) then
		if (isClient) then
			return self._instance:InvokeServer(...)
		else
			local args = {...}
			local player = args[1]
			table.remove(args, 1)
			return self._instance:InvokeClient(player, unpack(args))
		end
	elseif (self._instance:IsA('BindableFunction')) then
		return self._instance:Invoke(...)
	end
end

local function determineType(inst)
	if (inst:IsA('RemoteFunction')) then
		return Bridge.Types.OPPOSITE
	elseif (inst:IsA('BindableFunction')) then
		return Bridge.Types.SAME
	end
end

local function constructBridge(inst)
	local _new = Bridge.new(inst.Name, determineType(inst), true)
	_new._name = inst.Name
	_new._instance = inst
	return _new
end

function Bridge.GetBridge(name)
	for _, v in pairs(bridges) do
		for _, v2 in pairs(v) do
			if (v2._name == name) then
				return v2
			end
		end
	end
end

function Bridge.Get(name)
	return Bridge.GetBridge(name)
end

if (not isClient) then
	bridgesFolder = Instance.new('Folder', script)
	bridgesFolder.Name = 'Bridges'
else
	for _, child in pairs(bridgesFolder:GetChildren()) do
		if (child:IsA('RemoteFunction')) then
			bridges.RF[child.Name] = constructBridge(child)
		else
			bridges.BF[child.Name] = constructBridge(child)
		end
	end
end

return Bridge

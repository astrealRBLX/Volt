--[[
    Core/Bridge

    Bridges are objects that simplify passing
    the client-server boundary
]]
local Bridge = { Name = 'Bridge' }
local BridgeClass = {}
local BridgeSymbol = newproxy()

local isClient = game:GetService('RunService'):IsClient()

local INVALID_BRIDGE_MESSAGE = '%s is not a valid bridge object. Create one using Bridge.new()'
local MISSING_REMOTE_MESSAGE = 'Cannot :Connect() Bridge as it has not been properly constructed'
local CLIENT_BRIDGE_MESSAGE = 'Bridge.new() must first be called on the server to create a Bridge before fetching it on the client.'
local FAILED_NAME_MESSAGE = 'An internal error occurred when attempting to fetch the executable name.'
local PLAYER_REQUIRED_MESSAGE = 'Calling :Fire() on a Bridge from Server -> Client requires the first parameter to be a player.'

--[[
    Internally used when getting Bridges
    on the client
]]
function Bridge.__index(bridges, bridgeName)
    local bridge = rawget(bridges, bridgeName)
    if (bridge ~= nil) then
        if (bridge._class ~= nil) then
            if (bridge._class == BridgeSymbol) then
                return bridge
            end
        end
    end

    bridge = Bridge.new()

    local executableName = string.gsub(getfenv(2).script.Name, '.Client', '')
    assert(executableName ~= nil, FAILED_NAME_MESSAGE)

    local executablePath = Bridge.Volt.Bridges:FindFirstChild(executableName)
    assert(executablePath ~= nil, CLIENT_BRIDGE_MESSAGE)

    bridge._parent = executablePath
    
    local remote = executablePath:FindFirstChild(bridgeName)
    assert(remote ~= nil, CLIENT_BRIDGE_MESSAGE)

    bridge._remote = remote

    return bridge
end

--[[
    Internally used when creating Bridges
    on the server
]]
function Bridge.__newindex(bridges, bridgeName, bridge)
    assert(bridge._class ~= nil, string.format(INVALID_BRIDGE_MESSAGE, bridgeName))
    assert(bridge._class == BridgeSymbol, string.format(INVALID_BRIDGE_MESSAGE, bridgeName))

    local remote = Instance.new('RemoteFunction', bridge._parent)
    remote.Name = bridgeName
    bridge._remote = remote

    rawset(bridges, bridgeName, bridge)
end

--[[
    Create a new Bridge object
]]
function Bridge.new()
    --[[
        TODO: Unfortunately getfenv() disables Luau optimizations
        it would be nice to find a user-friendly work around
        for getting the executable in the future.
    ]]
    local executableName = string.gsub(getfenv(2).script.Name, '.Server', '')
    assert(executableName ~= nil, FAILED_NAME_MESSAGE)

    local executablePath
    if (executableName ~= nil and executableName ~= script.Name) then
        executablePath = Bridge.Volt.Bridges:FindFirstChild(executableName)

        if (executablePath == nil) then
            executablePath = Instance.new('Folder', Bridge.Volt.Bridges)
            executablePath.Name = executableName
        end
    end

    local self = setmetatable({}, {__index = BridgeClass})
    
    self._class = BridgeSymbol
    self._parent = executablePath or nil

    return self
end

--[[
    Connect to a Bridge object
]]
function BridgeClass:Connect(callback)
    assert(self._remote ~= nil, MISSING_REMOTE_MESSAGE)

    if (isClient) then
        self._remote.OnClientInvoke = function(...)
            return callback(...)
        end
    else
        self._remote.OnServerInvoke = function(...)
            return callback(...)
        end
    end
end

--[[
    Fire a Bridge object
]]
function BridgeClass:Fire(...)
    assert(self._remote ~= nil, MISSING_REMOTE_MESSAGE)

    if (isClient) then
        return self._remote:InvokeServer(...)
    else
        local params = {...}
        local player = params[1]

        assert(player ~= nil, PLAYER_REQUIRED_MESSAGE)

        table.remove(params, 1)

        return self._remote:InvokeClient(player, unpack(params))
    end
end

--[[
    Fire a Bridge object on all clients
]]
function BridgeClass:FireAll(...)
    assert(self._remote ~= nil, MISSING_REMOTE_MESSAGE)

    if (not isClient) then
        for _, player in pairs(game:GetService('Players'):GetPlayers()) do
            self._remote:InvokeClient(player, ...)
        end
    end
end

return Bridge
--[[

    Libraries/Instances/Component

    @description Library for creating components, containers of instances
    that can have events binded to them in bulk
    @author AstrealDev

]]

local Component = { Name = 'Component' }
local ComponentClass = {}

local components = {}

--[[
    Create a new component
]]
function Component.new(name)
    local self = setmetatable({}, {__index=ComponentClass})

    self.Name = name
    self._instances = {}
    self._connections = {}

    components[name] = self

    return self
end

--[[
    Get an existing component
]]
function Component.Get(name)
    for _, comp in pairs(components) do
        if (comp.Name == name) then
            return comp
        end
    end
end


--[[
    Assign instances to a component
]]
function ComponentClass:Assign(instances)
    self:Clean()

    self._instances = instances

    for _, instance in pairs(instances) do
        self._connections[instance] = {}
    end

    return self
end

--[[
    Connect a callback to a component
]]
function ComponentClass:Connect(event, callback)
    self:Clean()

    for _, instance in pairs(self._instances) do
        self._connections[instance][event] = instance[event]:Connect(function(...)
            callback(instance, ...)
        end)
    end

    return self
end

--[[
    Clean up a component
]]
function ComponentClass:Clean()
    for instance, connections in pairs(self._connections) do
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
        self._connections[instance] = {}
    end
    return self
end

function ComponentClass:Destroy()
    self:Clean()
    components[self.Name] = nil
    self = nil
end

return Component
local InstanceBuilder = { name = 'InstanceBuilder' }
local InstanceClass = {}
local enabled = true

--[[

	InstanceBuilder // Provided by Volt
	Created by AstrealDev

]]

function InstanceBuilder.OnImport()
	if (not enabled) then return end
	
	getfenv(3).Instance = {
		new = InstanceBuilder.new
	}
end

function InstanceBuilder.new(s)
	local inst = Instance.new(s)
	
	local self
	
	self = setmetatable({}, {
		__index = function(t, k)
			return function(v)
				local success = pcall(function()
					_ = inst[k]
				end)
				if (success) then
					inst[k] = v
				end
				return self
			end
		end,
	})
	
	function self.Build()
		return inst
	end
	
	return self
end

return InstanceBuilder

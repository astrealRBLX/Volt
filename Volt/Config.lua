--[[
	Config

	This is the Volt config. Core modules use
	this config for various purposes.
]]
return {
	-- Should debugging be enabled? Debugging provides additional information as well as supresses executable errors
	Debug = true,
	Core = {
		-- Config settings for the Import module
		Import = {
			-- The directory where Volt is located
			VoltPath = game:GetService('ReplicatedStorage').Shared.Volt,
			ImportPathDefinitions = {
				-- The root directory to start imports with no additional from parameter
				root = game:GetService('ReplicatedStorage'),
			}
		}
	}
}
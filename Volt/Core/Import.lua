--[[
	Core/Import

	Utility module for requiring()
	module scripts with additional
	functionality. Used internally
	by Volt.
]]

local Import = { Name = 'Import', importable = false }
local root, volt

--[[
	Break apart an import path and find the target
	@private	
]]
local function generatePath(o, s, x)
	for _, v in pairs(string.split(s, '/')) do
		local success = pcall(function()
			o = o[v]
		end)
		if (not success and not x) then
			return generatePath(volt, s, true)
		elseif (not success and x) then
			return nil
		end
	end
	return o
end

--[[
	Internal Volt constructor for getting a root & volt instance
	This function will garbage collect after being called once
	@public
]]
function Import.constructor(c)
	root = c.ImportPathDefinitions.root or game:GetService('ReplicatedStorage')
	volt = c.VoltPath
end

--[[
	Create a new import providing an import
	path formatted such as (Some/Folders/Then/A/Script)
	with an optional argument for a starting directory
	@public
]]
function Import.new(p, from)
	local path = generatePath(from or root, p)
	
	if (path) then
		local src = require(path)
		
		if (typeof(src) == 'table') then
			if (src.importable ~= nil) then
				if (src.importable == false) then
					error(string.format('%s cannot be imported as it is not importable', p))
				end
			end
			
			if (src.OnImport) then
				src.OnImport()
			end
		end
		
		return src
	end
	
	error(string.format('Failed to import %s from %s', p, root.Name or from.Name))
end

--[[
	Bulk import by providing an optional directory,
	whether to look deep for modules, an optional filter
	function, and an optional formatting function.
	@public
]]
function Import.bulk(loc, deep, filter, formatting)
	loc = loc or root
	
	deep = deep or false
	filter = filter or function() return true end
	formatting = formatting or function(c) return c.Name end
	
	local finalized = {}
	for _, child in pairs(deep and loc:GetDescendants() or loc:GetChildren()) do
		if (not child:IsA('ModuleScript')) then continue end
		
		if (filter(child)) then
			local imp = Import.new(child.Name, child.Parent)
			finalized[formatting(child)] = imp
		end
	end
	
	return finalized
end

return Import

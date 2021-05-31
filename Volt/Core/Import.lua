local Import = { name = 'Import', importable = false }
local ImportClass = {}
local root, volt

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

function Import.constructor(c)
	root = c.ImportPathDefinitions.root or game:GetService('ReplicatedStorage')
	volt = c.VoltPath
end

function Import.new(p, from)
	local self = setmetatable({}, { __index = ImportClass })
	
	self._rawPath = p
	self._path = generatePath(from or root, p)
	
	if (self._path) then
		local src = require(self._path)
		
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

return Import

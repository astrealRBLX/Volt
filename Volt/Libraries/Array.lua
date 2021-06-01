--[[

	Array // Provided by Volt
	Ported from RoStrap
	Originally by Validark
	
]]

local type = type
local insert = table.insert
local remove = table.remove

local Array = { name = 'Array' }

function Array.Flatten(a1)
	-- Takes in an array, which may have arrays inside of it
	-- Unpacks all arrays in their proper place into a1
	-- e.g. a1 = {{1, 2}, 3, 4, {5, {6, {{7, 8}, 9}, 10}, 11}, 12}
	-- becomes: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}

	local i = 1
	local numt = #a1

	while i <= numt do
		if type(a1[i]) == "table" then
			local a2 = remove(a1, i)
			local numv = #a2

			for j = 1, numv do
				insert(a1, i + j - 1, a2[j])
			end

			numt = numt + numv - 1
		else
			i = i + 1
		end
	end

	return a1
end

function Array.Contains(a1, v)
	-- Returns the index at which v exists within array a1 if applicable

	for i = 1, #a1 do
		if a1[i] == v then
			return i
		end
	end
end

return Array

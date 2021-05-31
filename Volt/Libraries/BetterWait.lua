local BetterWait = { name = 'BetterWait' }
local enabled = true
local warnings = true
local threads = {}

--[[

	BetterWait // Provided by Volt
	Original module by CloneTrooper1019
	Ported to Volt by AstrealDev

]]

function BetterWait.OnImport()
	if (not enabled) then return end
	
	getfenv(3).wait = function(t)
		if (t == nil) then
			warn('Using wait() is not recommended, prefer RunService.Heartbeat:Wait()')
		end
		
		local t = tonumber(t) or 1 / 30
		local initialTime = tick()
		
		local thread = coroutine.running()
		threads[thread] = initialTime + t
		
		coroutine.yield()
	end
	
	game:GetService('RunService').Stepped:Connect(function()
		local now = tick()
		local resumePool

		for thread, resumeTime in pairs(threads) do
			local diff = resumeTime - now

			if (diff < 0.005) then
				if (not resumePool) then
					resumePool = {}
				end
				table.insert(resumePool, thread)
			end
		end

		if (resumePool) then
			for _, thread in pairs(resumePool) do
				threads[thread] = nil
				coroutine.resume(thread, now)
			end
		end
	end)
end

return BetterWait

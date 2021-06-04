--[[

    Libraries/Utilities/Tween

    @description Library for creating tweens with more functionality
    than the existing Roblox tween service
    @author AstrealDev

]]

local Tween = { Name = 'Tween' }
local TweenClass = {}
local TweenService = game:GetService('TweenService')

--[[
    Create a new Tween object
]]
function Tween.new(startValue, goal, time, style, dir)
    if (typeof(startValue) == 'string') then
        error('Attempt to tween a string.')
    end
    if (typeof(startValue) ~= typeof(goal)) then
        error('Initial value and goal value must be of same type.')
    end

    style = style or Enum.EasingStyle.Linear
    dir = dir or Enum.EasingDirection.InOut

    local self = setmetatable({}, {__index = TweenClass})

    self._startValue = startValue
    self._value = startValue
    self._goal = goal
    self._time = time
    self._style = style
    self._direction = dir
    self._finished = false
    self._running = false

    return self
end

--[[
    Useful lerp function that can lerp multiple types
]]
function Tween.Lerp(a, b, alpha)
    if (typeof(a) ~= 'number') then
        local r
        local success = pcall(function()
            r = a:Lerp(b, alpha)
        end)
        if (success) then
            return r
        else
            error('Cannot tween value of type ' .. typeof(a))
        end
    end
    return a + (b - a) * alpha 
end

--[[
    Begin a tween
]]
function TweenClass:Start()
    if (self._running) then return end
    self._running = true
    self._start = tick()
    local conn
    conn = game:GetService('RunService').Stepped:Connect(function()
        if (not self._running) then return end
        if (self._alpha == 1) then
            self._value = self._goal
            if (self._stepped) then
                self._stepped(self._value)
            end
            if (self._completed) then
                self._completed()
            end
            self._finished = true
            self._running = false
            conn:Disconnect()
        else
            local x = (tick() - self._start) / self._time
            self._alpha = TweenService:GetValue(x, self._style, self._direction)
            self._value = Tween.Lerp(self._startValue, self._goal, self._alpha)
            if (self._stepped) then
                self._stepped(self._value)
            end
        end
    end)
end

--[[
    Assign a function to be called upon a tween stepping
]]
function TweenClass:OnStep(callback)
    self._stepped = callback
end

--[[
    Assign a function to be called upon a tween completing
]]
function TweenClass:OnComplete(callback)
    self._completed = callback
end

--[[
    Yield until a tween completes
]]
function TweenClass:Wait()
    repeat
        game:GetService('RunService').Stepped:Wait()
    until (self._finished)
end

--[[
    Pause a tween
]]
function TweenClass:Pause()
    if (not self._running) then return end
    self._running = false
    self._passedTime = tick() - self._start
end

--[[
    Resume a tween
]]
function TweenClass:Resume()
    if (self._running) then return end
    self._start = tick() - self._passedTime
    self._running = true
end

--[[
    Force a tween to skip to its goal
]]
function TweenClass:Finish()
    self._start = tick() - self._time
end

return Tween
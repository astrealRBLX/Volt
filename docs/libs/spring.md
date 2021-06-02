# Spring
Spring is a library by fractality included in RoStrap that was ported over to Volt. It can be used to create critically damped springs.

## API
> #### `Spring Spring.new(double damp, double freq, vector pos)`
> Create a new spring.

> #### `void Spring:SetGoal(vector goal)`
> Set a spring's goal.

> #### `void Spring:SetFrequency(double freq)`
> Set a spring's frequency.

> #### `void Spring:SetDampingRatio(double damp)`
> Set a spring's damping ratio.

> #### `vector Spring:GetPosition()`
> Get a spring's position.

> #### `vector Spring:GetVelocity()`
> Get a spring's velocity.

> #### `vector Spring:Update(double dt)`
> Call the spring to update by passing in delta time. Recommended use in a Roblox provided loop such as `RenderStepped`.

> #### `void Spring:Reset(vector state)`
> Reset a spring to a provided state.
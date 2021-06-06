# Promise
Promise was created by evaera and used by Volt. The GitHub for it can be found [here](https://github.com/evaera/roblox-lua-promise).

## Examples
```lua
local Volt = require(game.ReplicatedStorage.Volt)
local Promise = Volt.import('Libraries/Utilities/Promise')

local myPromise = Promise.new(function(resolve, reject)
    coroutine.wrap(function()
        ...
        resolve('Some code ran successfully!')
    end)()
end)

myPromise:andThen(function(text)
    print(text) --> Outputs: Some code ran successfully!
end):catch(function(textError)
    error('Promise failed to run due to: ' .. textError)
end)
```

## [Documentation](https://eryn.io/roblox-lua-promise/lib/)
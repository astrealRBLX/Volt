# Getting Started
Starting with Volt is straightforward, easy, and user-friendly.

## Installation
=== "Roblox Model"

    1. Get the Roblox Volt model [here](https://www.roblox.com/library/6892133318/).
    2. Use the Toolbox to place it under ReplicatedStorage.
    3. That's it!

=== "With Rojo"

    1. Download the ZIP from the latest release [here](https://github.com/astrealRBLX/volt/releases).
    2. Unzip it and drag Volt into your Rojo project's `src` directory.
    3. Make sure to add Volt's `$path` under `ReplicatedStorage` in your `default.project.json`

## Configuration
Volt's config is compact and doesn't have anything that needs touching. Insure that VoltPath is set to the path of your Volt module. You can mess with the root key if you would like your imports to begin somewhere else. For example, you may have a folder within ReplicatedStorage called Modules. If you wanted your import strings to start from within there you would set root to `#!lua game:GetService('ReplicatedStorage').Modules`.

!!! note
    Assume the root path remains unchanged from its default ReplicatedStorage value in the rest of the documentation examples.

## Imports
Volt provides users a useful import function. There's no longer a need to use Roblox's global require() function. Import is specifically tailored to meet the needs of Volt and you should prefer it whenever possible (which is almost always).

### Basic Importing
```lua
local Volt = require(game.ReplicatedStorage.Volt)
local SomeModule = Volt.import('MyModule')
```
You can also provide a directory to start you import in rather than Volt using the root directory.
```lua
local SomeModule = Volt.import('MyModule', script.Parent.Parent)
```

### Volt Directory System
Volt uses a powerful and intuitive directory system. This system strays away from Roblox's dot notation and chained `:FindFirstChild()` methods which can be repetitive, tedious to type, and very very long. Rather, Volt uses a directory system similar to your computer's file system.

Have a module deep within your root path and need to import it? Let's compare using Volt versus using the raw Roblox API.
=== "Volt"

    ```lua
    Volt.import('Some/Directory/MyModule')
    ```

=== "Roblox"

    ```lua
    require(game:GetService('ReplicatedStorage'):FindFirstChild('Some'):FindFirstChild('Directory'):FindFirstChild('MyModule'))
    ```

There's a pretty major difference here in terms of length and readability. On top of this imports have a priority system.

### Priority Order
When importing something Volt prioritizes files in certain directories first.

1. Import's optional 2nd argument
2. Root directory
3. Volt

### Special Import Properties
When Volt attempts to import a module it checks for a few things. First it will determine if the module is returning a table. If all the module returns is a value or a function or something that isn't a table then Volt will directly return that. Otherwise if the module is a table then Volt will check for an `importable` key in the returned table. If this is set to false Volt will spit out an error stating that the module is not importable. This is primarily used internally. Finally, Volt will check for an `OnImport` function in the returned table. If one exists it will call the function. This is useful if you want your modules to have some special behavior when imported. Here's an example of a module using these special properties.
```lua
local MyModule = { importable = true }

function MyModule.OnImport()
    print('Imported!')
end

return MyModule
```
!!! note
    These special properties are all entirely optional and are simply meant to add an extra layer of functionality to modules.


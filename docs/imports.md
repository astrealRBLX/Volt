# Imports

Importing is one of the strongest features of Volt and is what helped the project gain traction. The import system has been entirely redesigned as of v2.0.0 and is superior to its predecessor. Let's learn why you should be using Volt's import system rather than the standard `require()` global.

## Importing Modules

Assume you have a ModuleScript in ReplicatedStorage under a folder by the name of `MyFolder`. Normally, you access and `require()` this module like so.

```lua
local MyModule = require(game:GetService('ReplicatedStorage').MyFolder.MyModule)
```

This code is long and tedious to write out. Not only that but you didn't even use `:FindFirstChild()`, Roblox's safer method of accessing children instances. If you have more modules to `require()` you end up wasting lots of time just writing these lines out. This is where imports come in. Using imports you can import modules with [instance paths](paths.md). Moreover, imports provide additional functionality to modules that allow them to directly communicate with Volt. Let's rewrite the above example using Volt's import system.

```lua
local MyModule = Volt:Import('ReplicatedStorage/MyFolder/MyModule')
```

This is much cleaner and faster to write and internally `:FindFirstChild()` is used!
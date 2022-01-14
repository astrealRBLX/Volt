# Paths

Paths, or instance paths, are a feature of Volt that you'll find throughout the API. All they really are is a string with a delimeter of `/`. These paths are incredibly flexible and allow you to focus on code rather than spending time writing out long `:FindFirstChild()` chains or trying to get a reference to a instance in the data model.

## Writing Paths

First and foremost you need to understand the different types of paths. Both relative and absolute paths exist. You can think of this like your own computer's directory paths.

### Absolute Paths

Let's write an absolute path to the default Roblox baseplate. This would look like `Workspace/Baseplate`. Whenever you're writing an absolute path you start with the name of the service you're trying to enter. Volt knows to use `:GetService()` for this specific task. You then separate children by a `/`. In this example Volt sees the `/` and knows that `Baseplate` should be a child of `Workspace`.

Other absolute path examples:
- `ReplicatedStorage/MyFolder/SomeInstance`
- `Workspace/MyModel/MyPart`

### Relative Paths

Now let's write a relative path. Assume we're currently a script in a folder called `MyFolder` with a sibling that is a part named `MyPart`. We want to access that part but writing an absolute path could prove troublesome and tedious. To solve this Volt supports relative paths. The path used as a solution to this task is `./MyPart`. The single `.` means to look in the same directory as the script. What if we wanted to go out of the current parent? This is easily solved via the `..` operator. For example, `../MyFolder` is a path back to the original folder.

Other relative path examples:
- `../../MyFolder/MyModel`
- `./MyPart/MyTexture`
- `.` *Equivalent to `script.Parent`*
- `..` *Equivalent to `script.Parent.Parent`*

## Special Paths

Volt uses paths pretty frequently and normal path syntax as demonstrated above is fully supported, however, certain functions will alter the paths you pass in. For example, [:Import()](../api/Volt#Import) will prepend `ReplicatedStorage` to your path if it isn't relative or the beginning isn't a valid Roblox service. The API documentation for these methods explains how they alter paths in depth.
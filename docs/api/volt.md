# Volt API

> #### `Module|Executable|Library Volt.import(Path importPath [, Instance startDirectory])`
> For more information view [Imports](../../start/#imports)

## Server
> #### `void Server.Execute(table executables [, bool isAsync])`
> Execute a table of executables and determine whether to execute them each in a separate thread or not. The `isAsync` argument overrides the `Async` property of executables if `isAsync` is set to true.

> #### `void Await(string executableName [, number timeout] [, function callback])`
> Execute a function callback after an executable has completed execution. Keep in mind if the executable you await is running on a separate thread there will be nothing to await. When this function is called it will be executed in a separate thread and will *not* yield the current thread.

> #### `Executable Server.ExecutableName`
> You can reference an executable via dot notation. Keep in mind the executable will inject itself only after it has completed execution.

## Client
> #### `void Client.Execute(table executables, [, bool isAsync])`
> [Reference](#void-serverexecutetable-executables-bool-isasync)

> #### `void Await(string executableName [, number timeout] [, function callback])`
> [Reference](#void-awaitstring-executablename-number-timeout-function-callback)

> #### `Executable Client.ExecutableName`
> [Reference](#executable-serverexecutablename)

## Libraries
> #### `Library Libraries.LibraryName`
> You can directly reference a library through `Volt.Libraries`. Please be aware this has the potential to cause unexpected functionality, prefer `Volt.import('Libraries/...')`.

## Config
> Contains the returned table from `Volt.Config`.
# Executable API

## Volt
Volt injects directly into an executable directly before execution under `MyExecutableTable.Volt`.
> #### `Module|Executable|Library Volt.import(Path importPath [, Instance startDirectory])`
> For more information view [Imports](../../start/#imports)

## Server
Executables have access to the same functions as [Volt's Server](../volt/#server). The Server injects into an executable directly before execution under `MyExecutableTable.Volt.Server`.

> #### `Bridge Server.RegisterBridge(Path bridgePath [, function callback])`
> Register a new bridge to go client to server or server to client. View the [Bridge API](../bridges) to learn more.

## Client
Executables have access to the same functions as [Volt's Client](../volt/#client). The Client injects into an executable directly before execution under `MyExecutableTable.Volt.Client`.

> #### `Bridge Client.GetBridge(Path bridgePath)`
> Get an existing bridge. View the [Bridge API](../bridges) to learn more.
# Bridge API
!!! danger
    This page contains API documentation for a legacy feature available from v1.0.0 to v1.0.3. If you are new to Volt it is recommended you use the [more recent and maintained version of Bridges](/bridges). API documentation is [also available](../bridges) for the most recent version.
## Server
> #### `any Bridge:Fire(Player client [, ...])`
> Fire a bridge on a client. Server -> Client

> #### `void Bridge:Hook(function callback)`
> Hook a bridge to a callback. Client -> Server

## Client
> #### `any Bridge:Fire([...])`
> Fire a bridge on the server. Client -> Server

> #### `void Bridge:Hook(function callback)`
> Hook a bridge to a callback. Server -> Client
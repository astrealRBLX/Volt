# Bridge API

## Server
> #### `Bridge Bridge.new()`
> Create a new bridge.

> #### `any Bridge:Fire(Player client [, ...])`
> Fire a bridge on a client. Server -> Client

> #### `void Bridge:Connect(function callback)`
> Hook a bridge to a callback. Client -> Server

## Client
> #### `any Bridge:Fire([...])`
> Fire a bridge on the server. Client -> Server

> #### `void Bridge:Connect(function callback)`
> Hook a bridge to a callback. Server -> Client
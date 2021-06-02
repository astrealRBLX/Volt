# Bridge API

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
# Bridges
Volt attempts to reduce the frustrations concerning client & server communication. The primary method of communication across the client-server boundary is RemoteEvents & RemoteFunctions that Roblox provides. These can be a hassle to set up and maintain so Volt does the heavy lifting for you and provides a wrapper in the form of Bridges.

## Creating a Bridge
Bridges are created within executables inside their `OnExecute()` method.
=== "Client To Server"

    !!! example "PlayerData.Server"
        ```lua
        local PlayerData = {
            Name = 'PlayerData',
            Async = false,
            Bridges = {}
        }

        function PlayerData.OnExecute()
            -- Register a bridge called MyBridge
            PlayerData.Bridges.MyBridge = PlayerData.Volt.Bridge.new()

            -- Connect to the bridge and provide it a callback
            PlayerData.Bridges.MyBridge:Connect(function(player)
                print(player.Name)
            end)
        end

        return PlayerData
        ```

    !!! example "PlayerData.Client"
        ```lua
        local PlayerData = {
            Name = 'PlayerData',
            Async = false,
            Bridges = {}
        }

        function PlayerData.OnExecute()
            -- Fire the bridge going client -> server
            PlayerData.Bridges.MyBridge:Fire()
        end

        return PlayerData
        ```

=== "Server To Client"

    !!! example "PlayerData.Server"
        ```lua
        local PlayerData = {
            Name = 'PlayerData',
            Async = false,
            Bridges = {}
        }

        function PlayerData.OnExecute()
            -- Register a bridge called MyBridge
            PlayerData.Bridges.MyBridge = PlayerData.Volt.Bridge.new()

            -- Wait for the player to be added so the client executable has a chance
            -- to connect to the bridge
            game:GetService('Players').PlayerAdded:Connect(function(player)
                -- Fire the bridge on the provided player going server -> client
                PlayerData.Bridges.MyBridge:Fire(player)
            end)
        end

        return PlayerData
        ```

    !!! example "PlayerData.Client"
        ```lua
        local PlayerData = {
            Name = 'PlayerData',
            Async = false,
            Bridges = {}
        }

        function PlayerData.OnExecute()
            PlayerData.Bridges.MyBridge:Connect(function()
                print('Server -> Client!')
            end)
        end

        return PlayerData
        ```

!!! warning
    Bridges cannot be registered on the client and their creation is expected on the server. The only exception to this rule is interal use.

!!! info
    Bridges *are* bound to their executables. You cannot get and fire a bridge from another executable. A work around to this problem is to create a public method in the second executable that can be accessed from the first.
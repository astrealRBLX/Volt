# Executables
Executables are the most vital part of Volt. They are used to manipulate control flow in an easy and user-friendly manner.

They are essentially just module scripts. That's it. The only difference from a normal module script is that Volt knows how to read these module scripts and execute their code in a way that makes your development workflow significantly smoother.

## Executable Creation
You can store your executables anywhere. It's recommended you create an individual folder to group your executables. Let's say you are creating a `Money` executable to handle player money. First you would create a folder called `Money` then within that folder create two module scripts. One for the server and one for the client. To help distinguish them within the explorer you should append `.Server` or `.Client` to their names. However, Volt doesn't read your executable names and this is entirely personal preference.

!!! tip
    Stay organized! Prefer creating a folder within ReplicatedStorage called `Exe` or `Executables` to store your executables and prevent clutter.

## Executable Tables
Now that you have your client and server executables you can start writing code. There is absolutely nothing that distinguishes the executables except for the fact that one will be ran on the server and the other will be ran on the client.

!!! example "Server Example"
    ```lua
    local Money = { Name = 'Money', Async = false }

    function Money.OnExecute()
        print('Server!')
    end

    return Money
    ```

!!! example "Client Example"
    ```lua
    local Money = { Name = 'Money', Async = false }

    function Money.OnExecute()
        print('Client!')
    end

    return Money
    ```

These examples are actually identical and run on their respective sides. You may have noticed the `Name` and `Async` properties as well as the `OnExecute` function of the executable table. These are special properties.

## Special Executable Properties

| Properties  | Type      | Description |
| ----------- | --------- | ----------- |
| `Name`      | string    | Defines the executable name. This is used so executables can communicate with each other. |
| `Async`     | boolean   | Defines whether an executable should be ran on a separate thread when executed. |
| `OnExecute` | function  | Called when the executable is executed from its respective server or client. |

## Communicating Across Executables
In this example assume we have a `Money` and `Role` executable. The `Money` executable will handle our game's in-game money system for each player. The `Role` executable will handle our game's in-game role system. Each player will get assigned a role (Civilian, Criminal, or Cop) upon joining. Their money will then be decided based on their role.

!!! example "Role.Server"
    ```lua
    local Role = { Name = 'Role', Async = false }

    -- This table is within the Role table so it is public and can be accessed by other executables
    Role.ValidRoles = {
        'Civilian',
        'Criminal',
        'Cop'
    }

    -- By not including our players table in the returned Role table we've made it private
    local players = {}

    function Role.OnExecute()
        game:GetService('Players').PlayerAdded:Connect(function(player)
            math.randomseed(tick())
            local roleChosen = Role.ValidRoles[math.random(1, #Role.ValidRoles)]
            players[player] = roleChosen

            -- Await will wait x amount of time (5s in this example) for another executable to execute and then call a function
            Role.Volt.Server.Await('Money', 5, function()
                -- We know Money has executed so we have access to the AssignMoney function
                Role.Volt.Server.Money.AssignMoney(player, roleChosen)
            end)
        end)
    end

    --[[
        Function for getting the role of a player
        Can be called from other executables!
    ]]
    function Role.GetRole(player)
        return players[player]
    end

    return Role
    ```

!!! example "Money.Server"
    ```lua
    local Money = { Name = 'Money', Async = false }

    local players = {}

    function Money.OnExecute()
        
    end

    function Money.AssignMoney(player, roleChosen)
        local Role = Money.Volt.Server.Role
	
        if (roleChosen == Role.ValidRoles[1]) then  -- Civilian
            players[player] = 30
        elseif (roleChosen == Role.ValidRoles[2]) then -- Criminal
            players[player] = 20
        elseif (roleChosen == Role.ValidRoles[3]) then -- Cop
            players[player] = 50
        end
    end

    return Money
    ```

!!! example "Main Server Script"
    ```lua
    local Volt = require(game.ReplicatedStorage.Volt)
    local Role = Volt.import('Role.Server')
    local Money = Volt.import('Money.Server')

    Volt.Server.Execute({
        Role,
        Money
    }, true) -- Second argument will override the async property of executables
    ```

So this is a pretty extensive example. It showcases that `Volt` injects itself into executables under their return tables. So you can access others by doing:
=== "Server"

    ```lua
    MyExecutableTable.Volt.Server.SomeOtherExecutable
    ```

=== "Client"

    ```lua
    MyExecutableTable.Volt.Client.SomeOtherExecutable
    ```

## Running Executables
Executables should be ran from a server or local script. Smaller games might only have one server script and one local script for each side to handle all their executables. Larger games might need more.

!!! example "Server Script"
    ```lua
    local Volt = require(game.ReplicatedStorage.Volt)
    local SomeExecutable = Volt.import('Executables/SomeExecutable.Server')

    Volt.Server.Execute({
        SomeExecutable
    })
    ```

!!! example "Local Script"
    ```lua
    local Volt = require(game.ReplicatedStorage.Volt)
    local SomeExecutable = Volt.import('Executables/SomeExecutable.Client')

    Volt.Client.Execute({
        SomeExecutable
    })
    ```
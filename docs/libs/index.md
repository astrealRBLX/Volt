# Libraries
Volt comes packaged with a few libraries that are popular and you may find useful. You can also create your own libraries.

## Libraries vs Modules
Think of libraries as modules with a bit more functionality. They support the same [special properties](../start/#special-import-properties) normal modules do when imported but have even more power. Libraries should go within the Libraries folder of Volt. All modules within this folder are deep loaded using `#!lua :GetDescendants()`.

Libraries also have access to each other. Let's say I have a library that uses the Volt's provided Array library. Volt will inject itself into the return table.
```lua
local MyLibrary = {}
local Array -- Initially undefined

function MyLibrary.constructor()
    Array = MyLibrary.Volt.Libraries.Array -- Access injected library
end

return MyLibrary
```

!!! info
    Libraries are required() at server start unlike other modules which are required() when they are imported.

## Constructors
Libraries have optional constructors. The way you add a constructor to a library is by simply adding a function called `constructor` to the return table.
```lua
local MyLibrary = {}

function MyLibrary.constructor()
    print('Constructed!')
end

return MyLibrary
```

## Importing Libraries
```lua
local SomeLibrary = Volt.import('Libraries/SomeLibrary')
```
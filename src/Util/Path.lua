--[=[
  @class Path
  @private

  The internal path utility class. When using Volt you should never
  have to touch this class, however, its API is documented.
]=]
local Path = {}
local PathClass = {}

local Package = script.Parent.Parent
local Util = Package.Util

local Logger = require(Util.Logger)

type InstancePath = {
  position: number,
  pathString: string,
  splitPath: { string },
  
  caller: LuaSourceContainer?,
  instance: Instance?,
  
  Step: (self: InstancePath) -> (),
}

--[[
  Validates a small segment of a path.
]]
local function validatePathSegment(str: string)
  if str ~= '..' and str ~= '.' then
    local success = pcall(function()
      return game:GetService(str)
    end)

    if not success then
      return false
    end
  end

  return true
end

--[[
  Validates a path string.
]]
local function validatePath(str: string)
  -- Validate path type
  if typeof(str) ~= 'string' then
    return false, 'Expected path to be of type string, received "%s"', typeof(str)
  end

  
  -- Validate split path length
  local split = string.split(str, '/')
  if #split == 0 then
    return false, 'Expected path to be greater than length 0'
  end

  
  -- Validate root of the path
  local validRoot = validatePathSegment(split[1])
  if not validRoot then
    return false, 'Expected path root to be "..", ".", or a service, received "%s"', split[1]
  end

  return true, split
end

--[=[
  @within Path
  @private

  Constructs a new path from a path string. The caller argument is
  only necessary if a path is relative and uses relative commands
  such as `..` or `.`
]=]
function Path.new(path: string, caller: LuaSourceContainer?): InstancePath
  -- Validate the path
  local isValid, result, errArg = validatePath(path)

  if not isValid then
    Logger:Log(Logger.Identity.Error, 'Invalid path "%s" provided. %s', path, string.format(result, errArg))
  end

  return setmetatable({
    position = 1,
    pathString = path,
    splitPath = result,
    caller = caller,
  }, {
    __index = PathClass,
  })
end

--[=[
  @within Path
  @private

  Steps through a path.
]=]
function PathClass:Step()
  self = self :: InstancePath

  -- Prevent overstepping
  if self.position > #self.splitPath then
    return
  end

  local segment = self.splitPath[self.position]

  -- Determine if the current segment is valid
  if self.position ~= 1 then
    local isValidSegment = validatePathSegment(segment)
    if not isValidSegment then
      Logger:Log(Logger.Identity.Error, 'Invalid path segment "%s" in path "%s".', segment, self.pathString)
    end
  end
  
  local currentInstance = if self.position == 1 then self.caller else self.instance

  -- Handle stepping into the path
  if segment == '..' then
    local success, inst = pcall(function()
      return currentInstance.Parent.Parent
    end)
    
    if not success then
      Logger:Log(Logger.Identity.Error, 'Unable to access parent of "%s" in path "%s". Perhaps the parent is nil or outside the game\'s DataModel?', currentInstance.Name, self.pathString)
    end

    self.instance = inst
  elseif segment == '.' then
    local success, inst = pcall(function()
      return currentInstance.Parent
    end)

    if not success then
      Logger:Log(Logger.Identity.Error, 'Unable to access parent of "%s" in path "%s". Perhaps the parent is nil or outside the game\'s DataModel?', currentInstance.Name, self.pathString)
    end

    self.instance = inst
  else
    if self.position == 1 then
      self.instance = game:GetService(segment)
    else
      local child = self.instance:FindFirstChild(segment)
      if child then
        self.instance = child
      else
        Logger:Log(Logger.Identity.Error, 'Invalid path "%s". "%s" does not have a child named "%s".', self.pathString, self.instance.Name, segment)
      end
    end
  end

  self.position += 1
end

return Path

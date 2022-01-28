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

local Prefix = {
  None = 'None',
  W = 'W',
}

type InstancePath = {
  position: number,
  pathString: string,
  splitPath: { string },
  isRelative: boolean,
  prefix: string,
  
  caller: LuaSourceContainer?,
  instance: Instance?,

  Step: (self: InstancePath) -> (),
}

--[[
  Validates the root segment of an absolute path.
]]
local function validateAbsolutePathRoot(str: string)
  local success, serv = pcall(function()
    return game:GetService(str)
  end)

  if not success or not serv then
    return false
  end

  return true
end

--[[
  Validates the root segment of a relative path.
]]
local function validateRelativePathRoot(str: string, caller: LuaSourceContainer?)
  if caller == nil then
    Logger:Log(Logger.Identity.Error, 'Path "%s" is relative yet no caller was specified. The caller argument should be `script`.')
  end

  if str == '..' or str == '.' or caller:FindFirstChild(str) then
    return true
  end

  return false
end

--[[
  Validates a path string.
]]
local function validatePath(str: string, caller: LuaSourceContainer?)
  -- Validate path type
  if typeof(str) ~= 'string' then
    return false, 'Expected path to be of type string, received "%s"', typeof(str)
  end
  
  -- Validate split path length
  local split = string.split(str, '/')
  if #split == 0 then
    return false, 'Expected path to be greater than length 0'
  end

  local isRelative = Path:IsRelative({
    splitPath = split
  }, caller)

  -- Validate root of the path
  if isRelative then
    local validRoot = validateRelativePathRoot(split[1], caller)

    if not validRoot then
      return false, 'Expected relative path root to be "..", ".", a service, or a child, received "%s"', split[1]
    end
  else
    local validRoot = validateAbsolutePathRoot(split[1])

    if not validRoot then
      return false, 'Expected absolute path root to be a service, received "%s"', split[1]
    end
  end

  return true, split
end

--[[
  Extracts and validates the prefix from the start of a path.
]]
local function extractPrefix(path: string)
  if string.sub(path, 2, 2) == '$' then
    local prefix = string.sub(path, 1, 1)

    if prefix and Prefix[prefix] then
      return true, prefix
    else
      return false, string.format('Prefix "%s" in path "%s" is not a valid prefix', prefix, path)
    end
  else
    return true, Prefix.None
  end
end

--[=[
  @within Path
  @private

  Constructs a new path from a path string. The caller argument is
  only necessary if a path is relative and uses relative commands
  such as `..` or `.`
]=]
function Path.new(path: string, caller: LuaSourceContainer?): InstancePath
  -- Validate the prefix
  local isValidPrefix, prefixResult = extractPrefix(path)

  if not isValidPrefix then
    Logger:Log(Logger.Identity.Error, prefixResult)
  elseif not isValidPrefix and prefixResult ~= Prefix.None then
    path = string.sub(path, 3)
  end

  -- Validate the path
  local isValid, result, errArg = validatePath(path, caller)

  if not isValid then
    Logger:Log(Logger.Identity.Error, 'Invalid path "%s" provided. %s', path, string.format(result, errArg))
  end

  return setmetatable({
    position = 1,
    pathString = path,
    splitPath = result,
    caller = caller,
    prefix = prefixResult,
    isRelative = Path:IsRelative({
      splitPath = result
    }, caller),
  }, {
    __index = PathClass,
  })
end

--[=[
  @within Path
  @private

  Determines if a path is relative or absolute.
]=]
function Path:IsRelative(path: InstancePath | { splitPath: { string } }, caller: LuaSourceContainer?)
  for _, segment in pairs(path.splitPath) do
		if segment == '.' or segment == '..' then
			return true
		end
	end

  -- Check if the root is a child
  if caller and caller:FindFirstChild(path.splitPath[1]) then
    return true
  end

  return false
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
      if self.isRelative then
        self.instance = if self.prefix == Prefix.W then currentInstance:WaitForChild(segment) else currentInstance:FindFirstChild(segment)
      else
        self.instance = game:GetService(segment)
      end
    else
      local child = if self.prefix == Prefix.W then currentInstance:WaitForChild(segment) else self.instance:FindFirstChild(segment)
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

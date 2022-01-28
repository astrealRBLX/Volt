--[=[
  @class Instances

  The instances utility class is used to
  interact with Roblox instances using
  instance paths.
]=]
local Instances = {}

local Types = require(script.Parent.Parent.Types)
local Path = require(script.Parent.Path)
local Logger = require(script.Parent.Logger)
local Cache = require(script.Parent.Cache)

local pathCache: typeof(Cache.new())

--[=[
	@within Instances
	@param path InstancePath

	This function will locate an instance similar to Roblox's
	`:FindFirstChild()`. See the [instance path](../docs/paths)
	documentation for more information.
]=]
function Instances:FindInstance(path: string, caller: LuaSourceContainer?)
  local cachedResult = pathCache:Lookup(path)
  
  if cachedResult then
    return cachedResult
  end
  
	local instancePath = Path.new(path, caller)
	
	if Path:IsRelative(instancePath, caller) and caller == nil then
		Logger:Log(Logger.Identity.Error, ':FindInstance() was provided a relative path but no caller. To provide the caller pass in `script` as the second argument.')
	end
  
	-- Step through the path
	while instancePath.position <= #instancePath.splitPath do
		instancePath:Step()
	end
  
  -- Cache the path for future look ups
  pathCache:Cache(path, instancePath.instance)

	return instancePath.instance
end

--[=[
	@within Instances
	@param path InstancePath

	This function will import a module script similar to Roblox and Lua's
	`require()` but with additional functionality. See the
	[instance path](../docs/paths) and [imports](../docs/imports)
	documentation for more information.
]=]
function Instances:Import(path: string, caller: LuaSourceContainer?)
	local instance = self:FindInstance(path, caller)
	
	if not instance:IsA('ModuleScript') then
		Logger:Log(Logger.Identity.Error, 'Cannot import instance of class "%s", expected a ModuleScript', instance.ClassName)
	end

	local module = require(instance) :: Types.Importable

	if module.Importable == false then
		Logger:Log(Logger.Identity.Warning, 'Cannot import module "%s" as its `Importable` attribute is set to false', instance.Name)
		return
	end

	local importReturn
	if module.OnImport then
		importReturn = module:OnImport()
	end

	return if importReturn then importReturn else module
end


return function(pathCacheSize: number?)
  pathCache = Cache.new(pathCacheSize or 25)

  return Instances
end
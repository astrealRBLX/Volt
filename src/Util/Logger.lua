--[=[
  @class Logger
  @private

  The logger class is used internally
  to log messages to the console.
]=]
local Logger = {
  Identity = {
    Info = 0,
    Warning = 1,
    Error = 2,
  }
}

--[=[
  @within Logger
  @private
  
  Logs a message to the console when provided
  a certain identity.
]=]
function Logger:Log(identity: number, message: string, ...: string)
  local constructedString = string.format('[Volt] %s', string.format(message, ...))

  if identity == self.Identity.Info then
    print(constructedString)
  elseif identity == self.Identity.Warning then
    warn(constructedString)
  elseif identity == self.Identity.Error then
    error(constructedString)
  end
end

return Logger

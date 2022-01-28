--[=[
  @class Cache
  @private

  The internal cache utility class. When using Volt you should never
  have touch this class, however, its API is documented. This class
  is used to cache data that can be quickly looked up in the future.
]=]
local Cache = {}
local CacheClass = {}

--[=[
  @within Cache
  @private

  Creates a new cache.
]=]
function Cache.new<K, V>(size: number?)
  local cache: {{ K | V }} = {}

  return setmetatable({
    _cache = cache,
    _size = size or -1,
  }, {
    __index = CacheClass
  })
end

--[=[
  @within Cache
  @private

  Caches an entry and its corresponding data.
]=]
function CacheClass:Cache(entry: any, data: any)
  if self:Lookup(entry) == nil then
    if self._size ~= -1 and #self._cache >= self._size then
      table.remove(self._cache, 1)
    end

    table.insert(self._cache, {
      entry,
      data
    })
  end
end

--[=[
  @within Cache
  @private

  Looks up an entry and returns its corresponding data.
]=]
function CacheClass:Lookup(entry: any)
  for _, result: { any } in ipairs(self._cache) do
    if result[1] == entry then
      return result[2]
    end
  end
end

--[=[
  @within Cache
  @private

  Returns the cache's full data table.
]=]
function CacheClass:Get()
  return self._cache
end

--[=[
  @within Cache
  @private

  Deletes an entry from the cache.
]=]
function CacheClass:Delete(entry: any)
  for index, result: { any } in ipairs(self._cache) do
    if result[1] == entry then
      table.remove(self._cache, index)
      break
    end
  end
end

return Cache
local loaded = {}
local callbacks = {}

local function getModtime(path)
	return love.filesystem.getInfo(path).modtime
end

local function getModulePath(module)
	return "lua/" .. module:gsub("%.", "/") .. ".lua"
end

local rerequire = {
	require = require,
	__call = function(self, module)
		package.loaded[module] = nil
		local modtime = getModtime(getModulePath(module))
		loaded[module] = modtime
		return self.require(module)
	end,
	setCallback = function(module, callback)
		callbacks[module] = callback
	end,
	reload = function(self, modules)
		modules = modules or loaded
		for module, modtime in pairs(loaded) do
			if modtime < getModtime(getModulePath(module)) then
				_G[module] = self(module)
				if callbacks[module] then
					callbacks[module]()
				end
				print("Hot-reloaded:" .. module)
			end
		end
	end,
}
setmetatable(rerequire, rerequire)

return rerequire

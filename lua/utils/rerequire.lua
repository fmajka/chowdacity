local loaded = {}
local callbacks = {}

local function getModtime(path)
	return love.filesystem.getInfo(path).modtime
end

local function getModulePath(module)
	return "lua/" .. module:gsub("%.", "/") .. ".lua"
end

local function getModuleName(module)
	local pos = module:find("%.[^%.]*$")
	return pos and module:sub(pos + 1) or module
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
				local name = getModuleName(module)
				_G[name] = self(module)
				if callbacks[name] then
					callbacks[name]()
				end
				print("Hot-reloaded:" .. name)
			end
		end
	end,
}
setmetatable(rerequire, rerequire)

return rerequire

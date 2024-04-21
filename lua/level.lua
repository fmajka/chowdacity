local Tile = require("enums.Tile")

local Level = {}
setmetatable(Level, Level)
Level.__index = Level
Level.__call = function(_, o)
	o = o or {}
	o.size = o.size or 8
	setmetatable(o, Level)
	-- Init level with random tiles
	for i = 1, o.size * o.size do
		if math.random(1, 3) == 1 then
			o[i] = Tile(Tile.GRASS)
		else
			o[i] = Tile(Tile.WATER)
		end
	end
	return o
end

function Level:getTile(x, y)
	if x < 0 or y < 0 or x >= self.size or y >= self.size then
		return nil
	end
	return self[1 + x + y * self.size]
end

return Level

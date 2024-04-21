local Tile = require("tile")

local Level = {}
Level.__index = Level
	
function Level.new(o)
	o = o or {}
	o.size = o.size or 8
	setmetatable(o, Level)
	for i=1, o.size*o.size do
		if math.random(1, 3) == 1 then
			o[i] = Tile.Grass:new()
		else
			o[i] = Tile.Water:new()
		end
	end
	return o
end

function Level:getTile(x, y)
	if x < 0 or y < 0 or x >= self.size or y >= self.size then
		return nil
	end
	return self[1+x+y*self.size]
end

function Level:draw()
	local size = self.size
	for i = 1, #self do
		local x, y = (i-1)%size, math.floor((i-1)/size)
		local tile = self[i]
		tile:draw(self, x, y)
	end
end

return Level

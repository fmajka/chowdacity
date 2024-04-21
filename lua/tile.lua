local Sprite = require("utils.sprite")
local bit = require("bit")

local Tile = {
	SIZE = 16,
	GRASS = 1,
	WATER = 2,
}

function Tile:new(id)
	local o = { id = id }
	self.__index = self
	setmetatable(o, self)
	return o
end

function Tile:draw(level, x, y)
	local ts = 8
	love.graphics.rectangle("fill", x, y, ts, ts)
end

Tile.Grass = Tile:new(Tile.GRASS)

function Tile.Grass:new()
	local o = Tile:new(self.id)
	self.__index = self
	setmetatable(o, self)

	o.data = math.random(0, 255)
	return o
end

function Tile.Grass:draw(level, x, y)
	local ts, hs = Tile.SIZE, Tile.SIZE / 2
	local colors = Colors.Grass
	local data = self.data
	for i = 0, 3 do
		local var = bit.band(data, 3)
		local varx, vary = var % 2, math.floor(var / 2)
		local sprite = Sprite.get(varx + 1, vary + 4, colors)
		love.graphics.draw(sprite, x * ts + (i % 2) * hs, y * ts + math.floor(i / 2) * hs)
		data = bit.rshift(data, 2)
	end
end

Tile.Water = Tile:new(Tile.WATER)

function Tile.Water:new()
	local o = Tile:new(self.id)
	self.__index = self
	setmetatable(o, self)

	return o
end

function Tile.Water:draw(level, x, y)
	local ts, hs = 16, 8
	local colors = Colors.Water

	local rt = { 0, 1, 3, 2 }
	for i = 0, 3 do
		local xo, yo = (i % 2 == 0) and -1 or 1, math.floor(i / 2) == 0 and -1 or 1
		local tx, ty = level:getTile(x + xo, y) or Tile, level:getTile(x, y + yo) or Tile
		local sprite = Sprite.get(3, 4, colors)
		local sum, r = 0, rt[i + 1]
		if tx.id == self.id then
			sum = sum + 1
		end
		if ty.id == self.id then
			sum = sum + 2
		end
		if sum == 3 then
			sprite = Sprite.get(4, 5, colors)
		elseif sum == 1 or sum == 2 then
			sprite = Sprite.get(4, 4, colors)
			if sum == 1 then
				r = yo + 1
			end
			if sum == 2 then
				r = xo
			end
		end
		Sprite.draw(sprite, x * ts + (i % 2) * hs, y * ts + math.floor(i / 2) * hs, r)
	end
end

return Tile

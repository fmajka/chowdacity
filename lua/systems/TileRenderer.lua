local Sprite = require("utils.sprite")
local bit = require("bit")

local ts, hs = 16, 8
local rt = { 0, 1, 3, 2 }
local Tile = {
	GRASS = 1,
	WATER = 2,
}

local function draw(level, tile, x, y)
	local id = tile.id
	local data = tile.data
	local drawX = x * ts - Game.camera.pos.x
	local drawY = y * ts - Game.camera.pos.y

	if id == Tile.GRASS then
		local colors = Colors.Grass
		for i = 0, 3 do
			local var = bit.band(data, 3)
			local varx, vary = var % 2, math.floor(var / 2)
			local sprite = Sprite.get(varx + 1, vary + 4, colors)
			love.graphics.draw(sprite, drawX + (i % 2) * hs, drawY + math.floor(i / 2) * hs)
			data = bit.rshift(data, 2)
		end
	--
	elseif id == Tile.WATER then
		local colors = Colors.Water
		for i = 0, 3 do
			local xo, yo = (i % 2 == 0) and -1 or 1, math.floor(i / 2) == 0 and -1 or 1
			local tx, ty = level:getTile(x + xo, y) or Tile, level:getTile(x, y + yo) or Tile
			local sprite = Sprite.get(3, 4, colors)
			local sum, r = 0, rt[i + 1]
			if tx.id == id then
				sum = sum + 1
			end
			if ty.id == id then
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
			Sprite.draw(sprite, drawX + (i % 2) * hs, drawY + math.floor(i / 2) * hs, r)
		end
	end
	--
end

return function(level)
	local size = level.size
	for i = 1, #level do
		local x, y = (i - 1) % size, math.floor((i - 1) / size)
		local tile = level[i]
		draw(level, tile, x, y)
	end
end

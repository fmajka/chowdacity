
level = {
	width = 16,
	height = 16,
	tiles = {}
}

Tile = {}
function Tile:create(tileType, var)
	var = var or math.random(1, #tileType)
	return { tileType = tileType, var = var }
end

TileType = {}
function TileType:create(id, varCount)
	-- TODO: game constant
	local ts = 8
	local tileType = { id = id }

	-- Append tile variants
	local x = (id-1)*ts
	for var = 1, varCount do
		local y = (var-1)*ts
		tileType[var] = love.graphics.newQuad(x, y, ts, ts, Assets.Tiles)
	end

	self[id] = tileType
	return tileType
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Assets = {
		Tiles =	love.graphics.newImage("/assets/tiles.png")
	}
	TileType:create(1, 6) -- Grass
	TileType:create(2, 4) -- Rocks
	TileType:create(3, 3) -- Flower

	-- Init tilemap
	for i = 1, level.width * level.height do
		local tileId = math.random(1, 3)
		local tileType = TileType[tileId]
		if math.random(1, 10) == 1 then
			level.tiles[i] = Tile:create(tileType)
		else
			level.tiles[i] = Tile:create(TileType[1], 6)
		end
	end
end

function love.keypressed(k)
   if k == 'escape' then
      love.event.quit()
   end
end

function love.update()

end

function drawTiles(level)
	local tiles = level.tiles
	local ts = 8
	for i = 1, #tiles do
		local x, y = (i-1)%level.width, math.floor((i-1)/level.width)
		local tile = tiles[i]
		local tileType = tile.tileType
		love.graphics.draw(Assets.Tiles, tileType[tile.var], x*ts, y*ts)
	end
end

function love.draw()
	love.graphics.scale(4, 4)
	love.graphics.setColor(1, 1, 1)
	drawTiles(level)
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle("fill", 20, 20, 40, 40)
end


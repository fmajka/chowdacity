local Tile = {
	__call = function(self, id)
		local tile = { id = id }
		if id == self.GRASS then
			tile.data = math.random(0, 255)
		end
		return tile
	end,
	-- TileId enum
	GRASS = 1,
	WATER = 2,
}
setmetatable(Tile, Tile)

return Tile

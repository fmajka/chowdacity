local bit = require("bit")
local Tint = require("tint")

local Sprite = {
	FLIP_X = 1,
	FLIP_Y = 2,
	FLIP_XY = 3,
}
-- TODO: move to some...
local tileSize = 8
local tiles = love.image.newImageData("assets/tiles-grey.png")
local tilesX = math.floor(tiles:getWidth() / tileSize)

local function getLocation(x, y, colors)
	-- TODO: tiles.width
	local index = x + y * 16
	local key = tostring(colors[1]) .. tostring(colors[2]) .. tostring(colors[3]) .. tostring(colors[4])
	return index, key
end

local function store(x, y, colors, sprite)
	local index, key = getLocation(x, y, colors)
	if not Sprite[index] then
		Sprite[index] = {}
	end
	Sprite[index][key] = sprite
end

function Sprite.get(x, y, colors)
	local index, key = getLocation(x, y, colors)
	local sprite = Sprite[index]
	return sprite and sprite[key] or nil
end

local function loadSprite(x, y, colors, size)
	local spriteData = love.image.newImageData(size, size)
	spriteData:paste(tiles, 0, 0, (x - 1) * size, (y - 1) * size, size, size)
	Tint.prepare(unpack(colors))
	Tint.apply(spriteData)
	return love.graphics.newImage(spriteData)
end

function Sprite.loadSprite8(x, y, colors)
	local sprite = loadSprite(x, y, colors, 8)
	store(x, y, colors, sprite)
	return sprite
end

function Sprite.loadSprite16(x, y, colors)
	return loadSprite(x, y, colors, 16)
end

-- r    = range[0;3]
-- flip = range[0;3]
function Sprite.draw(image, x, y, r, flip)
	r = r or 0
	flip = flip or 0
	local flipX, flipY = bit.band(flip, Sprite.FLIP_X), bit.band(flip, Sprite.FLIP_Y)
	local sx, sy = flipX == 0 and 1 or -1, flipY == 0 and 1 or -1
	if flipX ~= 0 then
		x = x + image:getWidth()
	end
	if flipY ~= 0 then
		y = y + image:getHeight()
	end
	love.graphics.draw(image, x + 4, y + 4, r * math.pi / 2, sx, sy, 4, 4)
end

return Sprite

package.path = package.path .. ";.\\lua\\?.lua;.\\lua\\utils\\?.lua"
local require = require("utils.rerequire")
local Sprite = require("utils.sprite")
-- NOTE: locals aren't hot-reloadable
Colors = require("Colors")
Level = require("Level")

local function loadAssets()
	-- 20.04: Entity sprites
	spriteCat = Sprite.loadSprite16(1, 1, { 111, 222, 422, 530 })
	spriteMan = Sprite.loadSprite16(2, 1, { 111, 222, 333, 543 })
	-- New epicness
	Sprite.loadSprite8(1, 4, Colors.Grass)
	Sprite.loadSprite8(2, 4, Colors.Grass)
	Sprite.loadSprite8(1, 5, Colors.Grass)
	Sprite.loadSprite8(2, 5, Colors.Grass)
	Sprite.loadSprite8(3, 4, Colors.Water)
	Sprite.loadSprite8(4, 4, Colors.Water)
	Sprite.loadSprite8(4, 5, Colors.Water)
end

function love.load()
	love.graphics.setFont(love.graphics.newFont(24))
	love.graphics.setDefaultFilter("nearest", "nearest")
	pcall(require.setCallback, "Colors", loadAssets)
	loadAssets()
	level = Level.new()
end

local reload_time = 0
function love.update(dt)
	reload_time = reload_time + dt
	if reload_time > 0.2 then
		reload_time = 0
		pcall(require.reload, require)
	end
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(6, 6)
	level:draw()
	love.graphics.draw(spriteCat, 32, 0)
	love.graphics.draw(spriteMan, 48, 0)
	love.graphics.pop()

	love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.keypressed(key, scancode, isrepeat)
	if scancode == "escape" then
		love.event.quit()
	end
end

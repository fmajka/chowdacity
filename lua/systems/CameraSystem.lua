local lk = love.keyboard
local SQRT2DIV2 = math.sqrt(2) / 2

return function(dt)
	local cam = Game.camera
	local x, y = 0, 0

	if lk.isDown("a") and not lk.isDown("d") then
		x = -1
	elseif lk.isDown("d") and not lk.isDown("a") then
		x = 1
	end

	if lk.isDown("w") and not lk.isDown("s") then
		y = -1
	elseif lk.isDown("s") and not lk.isDown("w") then
		y = 1
	end

	if x ~= 0 and y ~= 0 then
		x = x * SQRT2DIV2
		y = y * SQRT2DIV2
	end

	cam.pos.x = cam.pos.x + cam.vel.x * x * dt
	cam.pos.y = cam.pos.y + cam.vel.y * y * dt
end

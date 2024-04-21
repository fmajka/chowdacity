local Tint = {
	{0,0,0},
	{0,0,0},
	{0,0,0},
	{0,0,0},
}

local function map(r, g, b)
	return r / 6, g / 6, b / 6
end

local function getRGB(clr)
	local b = clr % 10
	clr = math.floor(clr / 10)
	local g = clr % 10
	clr = math.floor(clr / 10)
	return map(clr, g, b) --> clr == r
end

local function applyfun(x, y, r, g, b, a)
	local i = math.floor(r*3) + 1
	Tint[i][4] = a
	return unpack(Tint[i])
end

-- TODO: does it work / is it useful?
function Tint.getValue(clr)
	local val, mul = 0, 1
	while clr > 0 do
		val = val + mul*(clr % 10)
		clr = math.floor(clr / 10)
		mul = mul * 10
	end
	return val
end

function Tint.prepare(...)
	local arg = {...}
	for i, clr in ipairs(arg) do
		local r, g, b = getRGB(clr)
		Tint[i][1] = r; Tint[i][2] = g; Tint[i][3] = b
	end
end

function Tint.apply(imageData)
	imageData:mapPixel(applyfun)
end

return Tint

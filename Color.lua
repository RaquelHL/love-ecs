Color = {}
Color.__index = Color


local function new(r, g, b, a)
	local c = {}
	setmetatable(c, Color)

	c.r = r or 0
	c.g = g or c.r
	c.b = b or c.r
	c.a = a or 255

	return c
end

function Color:value()
	return self.r, self.g, self.b, self.a
end

setmetatable(Color, {__call = function(_, ...) return new(...) end})

--Constantes
Color.white = Color(255)
Color.black = Color(0)
Color.grey = Color(127)
Color.red = Color(200,50,50)
Color.green = Color(50,200,50)
Color.blue = Color(50,50,200)
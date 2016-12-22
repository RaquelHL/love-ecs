local imagewidth = 384
local imageheight = 1600
local texture = love.graphics.newImage("textures/pixelChar.png")
return {
	{
		name = "idle",
		texture = texture,
		size = 4,
		timestep = 0.3,
		loop = true,
		tilewidht = 64,
		tileheight = 64,
		offset = vector(-32, -41),
		colBox = {
			w = 20,
			h = 46
		},
		frames = {
			{quad = love.graphics.newQuad(0, 0, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(64, 0, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(128, 0, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(192, 0, 64, 64, imagewidth, imageheight)}
		}
	},
	{
		name = "jump",
		texture = texture,
		size = 6,
		timestep = 0.2,
		loop = false,
		tilewidht = 64,
		tileheight = 64,
		offset = vector(-32, -40),
		colBox = {
			w = 20,
			h = 46
		},
		frames = {
			{quad = love.graphics.newQuad(0, 64, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(64, 64, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(128, 64, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(192, 64, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(256, 64, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(320, 64, 64, 64, imagewidth, imageheight)}
		}
	},
	{
		name = "walk",
		texture = texture,
		size = 6,
		timestep = 0.1,
		loop = true,
		tilewidht = 64,
		tileheight = 64,
		offset = vector(-32, -40),
		colBox = {
			w = 20,
			h = 46
		},
		frames = {
			{quad = love.graphics.newQuad(0, 128, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(64, 128, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(128, 128, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(192, 128, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(256, 128, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(320, 128, 64, 64, imagewidth, imageheight)}
		}
	},
	{
		name = "die",
		texture = texture,
		size = 6,
		timestep = 0.2,
		loop = false,
		tilewidht = 64,
		tileheight = 64,
		offset = vector(-32, -40),
		colBox = {
			w = 20,
			h = 46
		},
		frames = {
			{quad = love.graphics.newQuad(0, 448, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(64, 448, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(128, 448, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(192, 448, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(256, 448, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(320, 448, 64, 64, imagewidth, imageheight)}
		}
	}

}
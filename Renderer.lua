--[[
	Componente Renderer
	->  Desenha a textura na posição do objeto
]]

Renderer = {}
Renderer.__index = Renderer

local function new(texture, color)
	local r = {}
	setmetatable(r, Renderer)

	r.isComponent = true
	r.name = "renderer"
	r.texture = texture
	r.color = color or Color(255)

	return r
end

function Renderer:init()
	assert(self.go, self.name.." component has no GameObject")
end

function Renderer:draw()
	love.graphics.setColor(self.color:value())
	love.graphics.draw(self.texture, self.go.transform.x, self.go.transform.y, self.go.transform.o, self.go.transform.sx, self.go.transform.sy)

end

function Renderer:clone()
	return new(self.texture, self.color)
end


setmetatable(Renderer, {__call = function(_, ...) return new(...) end})
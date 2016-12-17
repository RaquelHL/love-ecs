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
	if (type(texture)== "userdata") then
 		r.texture = texture
 	else
 		if (type(texture) == "string") then
 			r.texture = ResourceMgr.get("texture", texture)
 		end
 	end

	r.offsetX = 0
	r.offsetY = 0
	r.mirror = false

	r.color = color or Color(255)

	return r
end

function Renderer:init()
	assert(self.go, self.name.." component has no GameObject")
end

function Renderer:draw()
	love.graphics.setColor(self.color:value())
	local posX = self.go.transform.x + self.offsetX
	local scaleX = self.go.transform.sx
	if self.mirror then
		scaleX = scaleX * -1
		if (self.quad) then
			local a, b, quadW = self.quad:getViewport()
			posX = self.go.transform.x + quadW + self.offsetX
		else
			posX = self.go.transform.x + self.texture:getWidth() + self.offsetX			
		end
	end
	if(self.quad) then
		love.graphics.draw(self.texture, self.quad, math.floor(posX), math.floor(self.go.transform.y + self.offsetY), self.go.transform.o, scaleX, self.go.transform.sy)
	else
		love.graphics.draw(self.texture, posX, self.go.transform.y, self.go.transform.o, scaleX, self.go.transform.sy)
	end
end

function Renderer:clone()
	return new(self.texture, self.color)
end


setmetatable(Renderer, {__call = function(_, ...) return new(...) end})
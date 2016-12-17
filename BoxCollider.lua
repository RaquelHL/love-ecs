--[[
	BoxCollider
	-> Faz um retângulo para ser usado nas detecções de colisão
	-> bump.lua só cuida de colisões com retangulos, sem rotação
]]
BoxCollider = Component("collider")


function BoxCollider:new(w, h, offsetX, offsetY)
	
	self.w = w or 1
	self.h = h or 1
	self.offsetX = offsetX or 0
	self.offsetY = offsetY or 0

	return self
end

function BoxCollider:init()
	assert(self.go, self.name.." component has no GameObject")
	
	if (self.go.renderer) then 		--Se não tiver largura e altura, pega essas informações da textura do renderer
		if (self.go.renderer.texture) then
			if (self.go.renderer.quad) then
				local x, y, w, h = self.go.renderer.quad:getViewport( )
				if (self.w == -1) then
					self.w = w * self.go.transform.sx
				end
				if (self.h == -1) then
					self.h = h * self.go.transform.sy
				end
			else
				if (self.w == -1) then
					self.w = self.go.renderer.texture:getWidth() * self.go.transform.sx
				end
				if (self.h == -1) then
					self.h = self.go.renderer.texture:getHeight() * self.go.transform.sy
				end
			end
		end
	end
	
	physics:add(self.go, self.go.transform.x + self.offsetX, self.go.transform.y + self.offsetY, self.w, self.h)
end

function BoxCollider:draw()
	if self.go.debugCollider then
		love.graphics.setColor(220, 50, 220)
		love.graphics.rectangle("line", self.go.transform.x + self.offsetX, self.go.transform.y + self.offsetY, self.w, self.h)
	end
end

function BoxCollider:updateRect(x, y, w, h)
	self.offsetX = x or self.offsetX
	self.offsetY = y or self.offsetY
	self.w = w or self.w
	self.h = h or self.h
	physics:update(self.go, self.go.transform.x + self.offsetX, self.go.transform.y + self.offsetY, self.w, self.h)
end

function BoxCollider:destroy()
	physics:remove(self.go)
end

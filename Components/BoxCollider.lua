--[[
	BoxCollider
	-> Faz um retângulo para ser usado nas detecções de colisão
	-> bump.lua só cuida de colisões com retangulos, sem rotação
]]
BoxCollider = Component("collider")


function BoxCollider:new(w, h, offset)
	
	self.w = w or 1
	self.h = h or 1
	self.offset = offset or vector(0,0)

	self.autoScale = true
	if w or h then
		self.autoScale = false
	end

	return self
end

function BoxCollider:init()
	assert(self.go, self.name.." component has no GameObject")

	physics:add(self.go, self.go.transform.pos.x, self.go.transform.pos.y, self.w, self.h)

	if self.autoScale then
		self:autoUpdate()
	end
end

function BoxCollider:autoUpdate()
	if (self.go.renderer) then 		--Se não tiver largura e altura, pega essas informações da textura do renderer
		if (self.go.renderer.texture) then
			if (self.go.renderer.quad) then
				local x, y, w, h = self.go.renderer.quad:getViewport( )
				if (self.w == -1) then
					self.w = w * self.go.transform.scale.x
				end
				if (self.h == -1) then
					self.h = h * self.go.transform.scale.y
				end
			else
				self.w = self.go.renderer.texture:getWidth() * self.go.transform.scale.x
				self.h = self.go.renderer.texture:getHeight() * self.go.transform.scale.y

				self.offset = -self.go.renderer.offset
			end
		end
	end

	self:updateRect(nil,nil,nil,nil,true)
end

function BoxCollider:updateRect(x, y, w, h, a)
	self.offset.x = x or self.offset.x
	self.offset.y = y or self.offset.y
	self.w = w or self.w
	self.h = h or self.h
	physics:update(self.go, self.go.transform.pos.x, self.go.transform.pos.y, self.w, self.h)
	
	if not a then
		self.autoScale = false
	end
end

function BoxCollider:destroy()
	physics:remove(self.go)
end

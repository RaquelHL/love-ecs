--[[
	Componente Renderer
	->  Desenha a textura na posição do objeto
]]

Renderer = Component("renderer")

Renderer.pivot = {
	top_left = function(w, h)
		return vector(0, 0)
	end,
	top = function(w, h)
		return vector(w/2, 0)
	end,
	top_right = function(w, h)
		return vector(w, 0)
	end,
	left = function(w, h)
		return vector(0, h/2)
	end,
	center = function(w, h)
		return vector(w/2, h/2)
	end,
	right = function(w, h)
		return vector(w, h/2)
	end,
	bottom_left = function(w, h)
		return vector(0, h)
	end,
	bottom = function(w, h)
		return vector(w/2, h)
	end,
	bottom_right = function(w, h)
		return vector(w,h)
	end
}

function Renderer:new(texture, args)
	args = args or {}
	
	self.pivot = args.pivot or "center"
	self.mirror = args.mirror or false
	self.color = args.color or Color(255)
	
	
	self:setTexture(texture)

	return self
end

function Renderer:draw()
	if not self.texture then
		return
	end
	love.graphics.setColor(self.color:value())
	local posX = self.go.transform.pos.x
	local posY = self.go.transform.pos.y
	local scaleX = self.go.transform.scale.x
	local scaleY = self.go.transform.scale.y
	if self.mirror then
		scaleX = scaleX * -1
		if (self.quad) then
			local a, b, quadW = self.quad:getViewport()
			posX = self.go.transform.pos.x --+ quadW + self.offset.x*2
		else
			posX = self.go.transform.pos.x --+ self.texture:getWidth() + self.offset.x*2
		end
	end

	if (self.go.collider) then
		posX = posX + self.go.collider.offset.x
		posY = posY + self.go.collider.offset.y
	end

	if(self.quad) then
		love.graphics.draw(self.texture, self.quad, math.floor(posX), math.floor(posY), self.go.transform.o, scaleX, scaleY, -self.offset.x, -self.offset.y)
	else
		love.graphics.draw(self.texture, math.floor(posX), math.floor(posY), self.go.transform.o, scaleX, scaleY, -self.offset.x, -self.offset.y)
	end

end

function Renderer:setTexture(texture, quad)
	if not texture then
		return
	end

	if (type(texture)== "userdata") then
 		self.texture = texture
 	else
 		if (type(texture) == "string") then
 			self.texture = ResourceMgr.get("texture", texture)
 		end
 	end
 	self.offset = vector(0,0)
	if self.texture and self.texture:type() == "Image" then
		if quad then
			self.quad = quad
			local qX, qY, qW, qH = self.quad:getViewport()
			self.offset = Renderer.pivot[self.pivot](-qW,-qH)
		else
			self.offset = Renderer.pivot[self.pivot](-self.texture:getWidth(), -self.texture:getHeight())
		end
	end

end

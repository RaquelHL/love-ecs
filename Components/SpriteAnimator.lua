--[[
	SpriteAnimator
]]
SpriteAnimator = Component("animator")
SpriteAnimator:require("renderer")

function SpriteAnimator:new(anim)
	
	self.lastUpdate = love.timer.getTime()
	self.curFrame = 1

	if anim then
		self:setAnim(anim)
	end
	return self
end

function SpriteAnimator:init()	
	if (self.anim) then
		self:setAnim(self.anim.name)
	end
end

function SpriteAnimator:update(dt)
	if (self.anim) then
		if (love.timer.getTime() - self.lastUpdate > self.anim.timestep) then
			self.curFrame = self.curFrame + 1
			if (self.curFrame > self.anim.size) then
				if (self.anim.loop) then
					self.curFrame = 1
				else
					self.curFrame = self.anim.size
				end
			end
			self.go.renderer.quad = self.anim.frames[self.curFrame].quad

			self.lastUpdate  = love.timer.getTime()
		end
	end
end

function SpriteAnimator:setAnim(name)
	self.anim = ResourceMgr.get("anim", name)
	if (self.go) then
		self.go.renderer:setTexture(self.anim.texture, self.anim.frames[1].quad)
		if (self.go.collider) then
			self.go.collider:updateRect(self.anim.colBox.w/2,self.anim.colBox.h/2,self.anim.colBox.w, self.anim.colBox.h)
		end
		if (self.anim.offset) then
			self.go.renderer.offset = self.anim.offset
		end
	end
end

function SpriteAnimator:nextFrame()
	if (self.curFrame + 1 > self.anim.size) then
		if (self.anim.loop) then
			return 1
		else
			return self.anim.size
		end
	end
	return self.curFrame + 1
end

function SpriteAnimator:gotoFrame(f)
	if(f <= self.anim.size) then
		self.curFrame = f
		self.go.renderer.quad = self.anim.frames[self.curFrame].quad
	end
end
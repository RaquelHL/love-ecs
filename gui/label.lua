local gui = nil

local function newDefaultLabel()
	return {
		text = "Label",
		x = 0,
		y = 0,
		h = 0,
		w = 0,
		maxW = 0,
		color = Color(255,255,255,255),
		textAlign = "center",
		font = font,
		halign = "parent",
		valign = "parent",
		weight = 1,
		wType = widgetType.label,
		setText = function(self, text)
			self.text = text
			self:refresh()
		end,
		drawSelf = function(self)
			love.graphics.setColor(self.color:value())
			love.graphics.setFont(self.font)
			love.graphics.printf(self.text, self.realX, self.realY + self.fontY, self.realW, self.textAlign)

			love.graphics.setColor(255, 0, 0)
			--love.graphics.rectangle("fill", self.realX, self.realY, self.realW, self.realH)
		end,
		refresh = function(self)
			if self.maxW ~= 0 then
				self.realW = math.min(self.maxW, self.font:getWidth(self.text))
			else
				if (type(self.w) ~= "string") then
					self.realW = self.font:getWidth(self.text)
				end
			end
			--self.realW = self.w
			self.realH = math.max(self.font:getHeight(), self.h or 0)
			self.fontY = (self.realH - self.font:getHeight()) / 2
			
		end,
		active = true
	}
end


return function(self, args)
	assert(self.isGUI, "Use a colon to call this function")
	gui = self
	args = args or {}
	defaultLabel = newDefaultLabel()
	local lb = {}

	for k,v in pairs(defaultLabel) do
		lb[k] = args[k] or v
	end

	fr.realX = fr.x
	fr.realY = fr.y
	fr.realW = fr.w
	fr.realH = fr.h

	lb:refresh()	
	
	return lb
end
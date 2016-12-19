local gui = nil

local function newDefaultLabel()
	return {
		text = "Label",
		x = 0,
		y = 0,
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
			love.graphics.printf(self.text, self.x, self.y, self.w, self.textAlign)
		end,
		refresh = function(self)
			if self.maxW ~= 0 then
				self.w = math.min(self.maxW, self.font:getWidth(self.text))
			else
				self.w = self.font:getWidth(self.text)
			end
			self.h = self.font:getHeight()
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

	lb:refresh()	
	
	return lb
end
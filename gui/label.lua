local function newDefaultLabel()
	return {
		text = "Label",
		maxW = 0,
		color = Color(255,255,255,255),
		textAlign = "center",
		font = font,
		h = font:getHeight(),
		w = "parent",
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
		end
	}
end

return Widget(newDefaultLabel)
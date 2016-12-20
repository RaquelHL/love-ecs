local function newDefaultFrame()
	return {
		panelType = "none",
		w = "parent",
		h = "parent",

		color = Color(255),
		layout = "absolute",

		halign = "parent",
		valign = "parent",
		weight = 1,

		childHalign = "center",
		childValign = "center",
		padding = 10,

		text = "",

		children = {},
		wType = widgetType.frame,

		drawSelf = function(self)
			if (self.panelType ~= "none") then
					love.graphics.setColor(self.color:value())
				if (self.panelType == "box") then
					love.graphics.rectangle("fill", self.realX, self.realY, self.realW, self.realH)
				else
					love.graphics.draw(self.batch, self.realX, self.realY, 0, 1, 1)
				end
			end
			
			for i,child in ipairs(self.children) do
				self.gui:draw(child)
			end
		end,

		addChild = function(self, wd)
			wd.parent = self
			self.children[#self.children+1] = wd
			self:refresh()
		end,

		refresh = function(self)
			if (self.h == "parent") then
				if (self.parent) then
					self.realH = self.parent.realH
				else
					self.realH = love.graphics.getHeight()
				end
			end
			if (self.w == "parent") then
				if (self.parent) then
					self.realW = self.parent.realW
				else
					self.realW = love.graphics.getWidth()
				end
			end
			self.batch = self.gui:newPanel(self.panelType, self.realW, self.realH)
			if (self.layout ~= "absolute") then
				layoutFunctions[self.layout](self)
			end
		end
	}
end

return Widget(newDefaultFrame)
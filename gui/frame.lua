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
			
			for i,chID in ipairs(self.children) do
				self.gui:draw(Widget.get(chID))
			end
		end,

		addChild = function(self, wd)
			wd.parent = self.id
			self.children[#self.children+1] = wd.id
			self:refresh()
		end,

		refresh = function(self)
			if (self.parent) then
				local parent = Widget.get(self.parent)
				if (parent.layout == "absolute") then
					if (self.h == "parent") then
						self.realH = parent.realH
					end
					if (self.w == "parent") then
						self.realW = parent.realW
					end
				end
			else
				if (self.w == "parent") then
					self.realW = love.graphics.getWidth()
				end
				if (self.h == "parent") then
					self.realH = love.graphics.getHeight()
				end
			end				
				
			self.batch = self.gui:newPanel(self.panelType, self.realW, self.realH)
			if (self.layout ~= "absolute") then
				layoutFunctions[self.layout](self)
			end
		end,

		update = function(self, dt)
			for k,chID in pairs(self.children) do
				local child = Widget.get(chID)
				if (child.update) then
					child:update(dt)
				end
			end
		end
	}
end

return Widget(newDefaultFrame)
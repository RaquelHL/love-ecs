gui = nil

local function newDefaultFrame()
	return {
		panelType = "none",
		x = 0,
		y = 0,
		w = love.graphics.getWidth(),
		h = love.graphics.getHeight(),
		realX = 0,
		realY = 0,
		realW = love.graphics.getWidth(),
		realH = love.graphics.getHeight(),

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
				gui:draw(child)
			end
		end,

		addChild = function(self, wd)
			self.children[#self.children+1] = wd
			self:refresh()
		end,

		refresh = function(self)
			self.batch = gui:newPanel(self.panelType, self.realW, self.realH)
			if (self.layout ~= "absolute") then
				layoutFunctions[self.layout](self)
			end
		end,

		active = true
	}
end

return function(self, args)
	assert(self.isGUI, "Use a colon to call this function")
	gui = self
	args = args or {}
	defaultFrame = newDefaultFrame()

	local fr = {}

	for k,v in pairs(defaultFrame) do
		fr[k] = args[k] or v
	end

	fr.realX = fr.x
	fr.realY = fr.y
	fr.realW = fr.w
	fr.realH = fr.h

	fr:refresh()

	return fr
end
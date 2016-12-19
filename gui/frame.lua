gui = nil

local function newDefaultFrame()
	return {
		panelType = "none",
		x = 0,
		y = 0,
		w = love.graphics.getWidth(),
		h = love.graphics.getHeight(),

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
				love.graphics.draw(self.batch, self.x, self.y, 0, 1, 1)
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
			self.batch = gui:newPanel(self.panelType, self.w, self.h)
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

	fr:refresh()

	return fr
end
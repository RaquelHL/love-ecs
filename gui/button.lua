local gui = nil

local function newDefaultButton()
	return {
		text = "Button",
		panelType = "button",
		x = 0,
		y = 0,
		w = 200,
		h = 60,
		callback = function() end,
		color = Color(255),
		hoverColor = Color(200),
		textColor = Color(0),
		font = font,
		textAlign = "center",

		halign = "parent",
		valign = "parent",
		weight = 1,
		wType = widgetType.button,

		drawSelf = function(self)
			if ((mx > self.x) and (mx < self.x + self.w) and (my > self.y) and (my < self.y + self.h)) then 	--Se o mouse estiver em cima do botao
				love.graphics.setColor(self.hoverColor:value())
			else
				love.graphics.setColor(self.color:value())
			end
			love.graphics.draw(self.batch, self.x, self.y, 0, 1, 1)
			love.graphics.setColor(self.textColor:value())
			love.graphics.setFont(self.font)
			love.graphics.printf(self.text, self.x+panelTypes[self.panelType].borderSize, self.y + self.fontY + panelTypes[self.panelType].borderSize, self.w-panelTypes[self.panelType].borderSize*2, self.textAlign)
		end,

		refresh = function(self)
			self.batch = gui:newPanel(self.panelType, self.w, self.h)
			self.fontY = (self.h - panelTypes[self.panelType].borderSize*2 - self.font:getHeight()) / 2
		end,

		active = true
	}
end

return function(self, args)
	assert(self.isGUI, "Use a colon to call this function")
	gui = self
	args = args or {}
	defaultButton = newDefaultButton()
	local bt = {}

	for k,v in pairs(defaultButton) do
		bt[k] = args[k] or v
	end

	bt:refresh()

	return bt
end
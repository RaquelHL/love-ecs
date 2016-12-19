local gui = nil

local function newDefaultTextBox()
	return {
		--Basico
		text = "",
		panelType = "textBox",
		x = 0,
		y = 0,
		w = 200,
		h = 60,
		callback = function() end,
		hasFocus = false,

		--Cores
		color = Color(220),
		focusColor = Color(220),
		textColor = Color(0),
		
		--Texto
		font = font,
		textAlign = "left",

		--Caret
		caret = false,
		caretTimer = love.timer.getTime(),
		caretPos = 0,

		--Layout 
		halign = "parent",
		valign = "parent",
		weight = 1,

		wType = widgetType.textBox,

		drawSelf = function(self)
			if (self.hasFocus) then
				love.graphics.setColor(self.focusColor:value())
				if (love.timer.getTime() - self.caretTimer > 0.5) then
					self.caretTimer = love.timer.getTime()
					self.caret = not self.caret
				end
				
			else
				love.graphics.setColor(self.color:value())
			end
			love.graphics.draw(self.batch, self.x, self.y, 0, 1, 1)
			love.graphics.setColor(self.textColor:value())
			love.graphics.setFont(self.font)
			if (self.caret) then
				love.graphics.printf("|", self.x+self.fontX+panelTypes[self.panelType].borderSize + self.font:getWidth(string.sub(self.text, 1, self.caretPos)) - self.font:getWidth("|")/2, self.y + self.fontY + panelTypes[self.panelType].borderSize, self.w-panelTypes[self.panelType].borderSize*2, self.textAlign)
			end

			love.graphics.printf(self.text, self.x+self.fontX+panelTypes[self.panelType].borderSize, self.y + self.fontY + panelTypes[self.panelType].borderSize, self.w-panelTypes[self.panelType].borderSize*2, self.textAlign)
		end,

		refresh = function(self)
			self.batch = gui:newPanel(self.panelType, self.w, self.h)
			self.fontY = (self.h - panelTypes[self.panelType].borderSize*2-self.font:getHeight()) / 2
			self.fontX = 5
		end,

		active = true
	}
end

return function(self, args)
	assert(self.isGUI, "Use a colon to call this function")
	gui = self
	args = args or {}
	defaultTextBox = newDefaultTextBox()
	local tb = {}
	
	for k,v in pairs(defaultTextBox) do
		tb[k] = args[k] or v
	end

	tb:refresh()

	return tb

end
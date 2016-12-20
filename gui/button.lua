local function newDefaultButton()
	local bt = {
		text = "Button",
		panelType = "button",
		w = 150,
		h = 30,
		callback = function() end,
		color = Color(255),
		hoverColor = Color(200),
		textColor = Color(0),
		font = font,
		textAlign = "center",

		halign = "parent",
		valign = "parent",
		weight = 1,
		wType = widgetType.button
	}

	function bt:drawSelf()
		if ((mx > self.realX) and (mx < self.realX + self.realW) and (my > self.realY) and (my < self.realY + self.realH)) then 	--Se o mouse estiver em cima do botao
			love.graphics.setColor(self.hoverColor:value())
		else
			love.graphics.setColor(self.color:value())
		end
		if (not panelTypes[self.panelType]) then
			love.graphics.rectangle("fill", self.realX, self.realY, self.realW, self.realH, 12, 8)
		else
			love.graphics.draw(self.batch, self.realX, self.realY, 0, 1, 1)
		end
		love.graphics.setColor(self.textColor:value())
		love.graphics.setFont(self.font)
		local border = 5
		if (panelTypes[self.panelType]) then
			border = panelTypes[self.panelType].borderSize
		end
		love.graphics.printf(self.text, self.realX+border, self.realY + self.fontY + border, self.realW-border*2, self.textAlign)
	end

	function bt:refresh()
		if (panelTypes[self.panelType]) then
			self.batch = self.gui:newPanel(self.panelType, self.realW, self.realH)
		end
		local border = 5
		if (panelTypes[self.panelType]) then
			border = panelTypes[self.panelType].borderSize
		end
		self.fontY = (self.realH - border*2 - self.font:getHeight()) / 2
	end

	function bt:mousepressed(e)
		if (self.callback) then
			self:callback(e)
		end
	end
	
	return bt
end

return Widget(newDefaultButton)
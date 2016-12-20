local function newDefaultLabel()
	local lb = {
		text = "Label",
		maxW = 0,
		color = Color(255,255,255,255),
		bgColor = Color(0,0,0,0),
		textAlign = "center",
		font = font,
		h = font:getHeight(),
		halign = "parent",
		valign = "parent",
		weight = 1,
		wType = widgetType.label
	}

	--Funções de renderização
	function lb:drawSelf()
		love.graphics.setColor(self.bgColor:value())
		love.graphics.rectangle("fill", self.realX, self.realY, self.realW, self.realH)

		love.graphics.setColor(self.color:value())
		love.graphics.setFont(self.font)
		love.graphics.printf(self.text, self.realX, self.realY + self.fontY, self.realW, self.textAlign)

	end

	function lb:refresh()
		if (self.w == 0) then
			self.w = self.font:getWidth(self.text)	--Isso seria melhor em uma função de inicialização
		end
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

	--Funções de lógica
	function lb:setText(text)
		self.text = text
		self:refresh()
	end
	
	return lb
end

return Widget(newDefaultLabel)
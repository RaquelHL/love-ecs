local function newDefaultFrame()
	local fr = {
		panelType = "none",
		w = "parent",
		h = "parent",
		maxW = "parent",
		maxH = "parent",

		color = Color(255),
		layout = "absolute",

		halign = "parent",
		valign = "parent",
		weight = 1,

		childHalign = "center",
		childValign = "center",
		padding = 10,

		allowScrolling = false,
		scrollOffset = 0,
		autoScroll = false,

		children = {},
		wType = widgetType.frame
	}

	--Funções de renderização
	function fr:drawSelf()

	  	love.graphics.stencil(function()
	  		love.graphics.rectangle("fill", self.realX, self.realY, self.realW, self.realH)
	  	end, "replace", 1)
    	love.graphics.setStencilTest("greater", 0)
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
		love.graphics.setStencilTest()

	end

	function fr:refresh()
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
			if (self.w == 9999) then
				self.realW = love.graphics.getWidth()
			end
			if (self.h == 9999) then
				self.realH = love.graphics.getHeight()
			end
		end		

		self.batch = self.gui:newPanel(self.panelType, self.realW, self.realH)
		if (self.layout ~= "absolute") then
			layoutFunctions[self.layout](self)
		end
	end

	--Funções de lógica	
	function fr:addChild(wd)
		wd.parent = self.id
		self.children[#self.children+1] = wd.id
		self:refresh()
	end

	function fr:update(dt)	--Melhor não usar
		for k,chID in pairs(self.children) do
			local child = Widget.get(chID)
			if (child.update) then
				child:update(dt)
			end
		end
	end

	function fr:mousepressed(e)
		for k,chID in pairs(self.children) do
			local child = Widget.get(chID)
			if isInRect(e.x, e.y, child.realX, child.realY, child.realW, child.realH) and child.mousepressed then
				if(child:mousepressed(e)) then
					return true
				end
			end
		end
		if (self.allowScrolling) then
			self.gui:requestFocus(self.id,e)
			return true
		end
		return false
	end

	function fr:keypressed(k)
		local change = 0
		if (self.allowScrolling) then
			if (k == "up") then
				change = -10
			end
			if (k == "down") then
				change = 10
			end
		end

		if change ~= 0 then
			self.scrollOffset = math.min(self.contentHeight - self.realH, math.max(0, self.scrollOffset + change)) 
			self:refresh()
		end
	end

	function fr:wheelmoved(x, y)
		if (self.allowScrolling and self.gui:isMouseHovering(self)) then
			self.scrollOffset = math.min(self.contentHeight - self.realH, math.max(0, self.scrollOffset - y*5)) 
			self:refresh()
		end
	end

	return fr
end

return Widget(newDefaultFrame)
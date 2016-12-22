local BASE = (...):match('(.-)[^%.]+$')	--Aparentemente pega o caminho até o diretorio do arquivo atual. Não sei como.

local gui = {}   
--gui.__index = gui


gui.debugLines = false

widgetType = {
	frame = 1,
	button = 2,
	label = 3,
	textBox = 4
}

panelTypes = {}

gui.focus = -1

local lastClick = love.timer.getTime()
local clickCooldown = 0.1

layoutFunctions = {
	gridH = function(wd)
		local totalWeight = 0
		for i,chID in ipairs(wd.children) do
			local child = Widget.get(chID)
			if child.active then
				totalWeight = totalWeight + child.weight
			end
		end
		local baseWidth = wd.realW / totalWeight
		local lastWidth = 0
		local maxHeight = 0
		for i,chID in ipairs(wd.children) do
			local child = Widget.get(chID)
			if child.active == true then
				local boxWidth = baseWidth * child.weight
				local halign = ""
				local valign = ""

				if (child.halign == "parent") then
					halign = wd.childHalign
				else
					halign = child.halign
				end
				if (child.valign == "parent") then
					valign = wd.childValign
				else
					valign = child.valign
				end
				
				child.realW = math.min(child.w, boxWidth-wd.padding*2)
				
				maxHeight = math.max(maxHeight, child.realH)

				if(child.redraw)then
					child.redraw()
				end

				if (halign == "left") then
					child.realX = lastWidth + wd.padding
				elseif (halign == "center") then
					child.realX = lastWidth + boxWidth/2 - child.realW/2
				elseif (halign == "right") then
					child.realX = lastWidth + boxWidth - wd.padding - child.realW
				end

				if (valign == "top") then
					child.realY = wd.padding
				elseif (valign == "center") then
					child.realY = wd.realH/2 - child.realH/2
				elseif (valign == "bottom") then
					child.realY = wd.realH - wd.padding - child.realH
				end
				
				child.realX = math.floor(child.realX + wd.realX)
				child.realY = math.floor(child.realY + wd.realY)

				if (child.layout) then
					if (child.layout ~= "absolute") then
						layoutFunctions[child.layout](child)
					end
				end

				lastWidth = lastWidth + boxWidth
			end
			child:refresh()
		end
		
		wd.realH = math.min(wd.h, maxHeight)

		wd.drawLines = function()
			love.graphics.setColor(255, 0, 255)
			love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
			love.graphics.setColor(0,255,0)
			local totalWeight = 0
			for i,chID in ipairs(wd.children) do
				local child = Widget.get(chID)
				totalWeight = totalWeight + child.weight
			end
			local baseWidth = wd.realW / totalWeight
			local lastWidth = 0
			for i,chID in ipairs(wd.children) do
				local child = Widget.get(chID)
				local boxWidth = baseWidth * child.weight
				love.graphics.rectangle("line", wd.realX+wd.padding+lastWidth, wd.realY+wd.padding, boxWidth - wd.padding*2, wd.realH - wd.padding*2)
				lastWidth = lastWidth + boxWidth
			end
		end
	end,
	gridV = function(wd)
		local totalWeight = 0
		for i,chID in ipairs(wd.children) do
			local child = Widget.get(chID)
			if child.active then
				totalWeight = totalWeight + child.weight
			end
		end
		local baseHeight = wd.realH / totalWeight
		local lastHeight = 0
		for i,chID in ipairs(wd.children) do
			local child = Widget.get(chID)
			if child.active == true then
				local boxHeight = baseHeight * child.weight
				local halign = ""
				local valign = ""

				if (child.halign == "parent") then
					halign = wd.childHalign
				else
					halign = child.halign
				end
				if (child.valign == "parent") then
					valign = wd.childValign
				else
					valign = child.valign
				end
				
				child.realH = math.min(child.h, boxHeight-wd.padding*2)
				child.realW = math.min(child.w, wd.realW-wd.padding*2)
				if(child.redraw)then
					child.redraw()
				end

				if (halign == "left") then
					child.realX = wd.padding
				elseif (halign == "center") then
					child.realX = wd.realW/2 - child.realW/2
				elseif (halign == "right") then
					child.realX = wd.realW - wd.padding - child.realW
				end

				if (valign == "top") then
					child.realY = lastHeight + wd.padding
				elseif (valign == "center") then
					child.realY = lastHeight + boxHeight/2 - child.realH/2
				elseif (valign == "bottom") then
					child.realY = lastHeight + boxHeight - wd.padding - child.realH
				end
				
				child.realX = math.floor(child.realX + wd.realX)
				child.realY = math.floor(child.realY + wd.realY)

				if (child.layout) then
					if (child.layout ~= "absolute") then
						layoutFunctions[child.layout](child)
					end
				end

				lastHeight = lastHeight + boxHeight
			end
			child:refresh()
		end

		wd.drawLines = function()
			love.graphics.setColor(255, 0, 255)
			love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
			love.graphics.setColor(0,255,0)
			local totalWeight = 0
			for i,chID in ipairs(wd.children) do
				local child = Widget.get(chID)
				totalWeight = totalWeight + child.weight
			end
			local baseHeight = wd.realH / totalWeight
			local lastHeight = 0
			for i,chID in ipairs(wd.children) do
				local child = Widget.get(chID)
				local boxHeight = baseHeight * child.weight
				love.graphics.rectangle("line", wd.realX+wd.padding, wd.realY+wd.padding+lastHeight, wd.realW - wd.padding*2, boxHeight - wd.padding*2)
				lastHeight = lastHeight + boxHeight
			end
		end
	end,
	boxH = function(wd)
		local lastWidth = 0
		local tallestChild = 0
		for i,chID in ipairs(wd.children) do
			local child = Widget.get(chID)
			if child.active == true then
				local valign = ""

				if (child.valign == "parent") then
					valign = wd.childValign
				else
					valign = child.valign
				end

				if (valign == "top") then
					child.realY = wd.padding
				elseif (valign == "center") then
					child.realY = wd.realH/2 - child.realH/2
				elseif (valign == "bottom") then
					child.realY = wd.realH - wd.padding - child.realH
				end

				child.realH = math.min(child.h, wd.realH-wd.padding*2)			
				child.realW = child.w
				tallestChild = math.max(tallestChild, child.realH)

				if(child.redraw)then
					child.redraw()
				end

				child.realX = lastWidth + wd.padding
				
				child.realX = math.floor(child.realX + wd.realX)
				child.realY = math.floor(child.realY + wd.realY)

				if (child.layout) then
					if (child.layout ~= "absolute") then
						layoutFunctions[child.layout](child)
					end
				end

				lastWidth = lastWidth + child.realW + wd.padding
			end
			child:refresh()
		end
		local maxW = wd.w
		if(wd.parent) then
			local parent = Widget.get(wd.parent)
			maxW = math.min(maxW, parent.realW)
		else
			maxW = math.min(maxW, love.graphics.getWidth())
		end
		
		wd.realW = math.max(lastWidth + wd.padding, maxW)
		wd.realH = math.max(wd.h, tallestChild)

		wd.drawLines = function()
			love.graphics.setColor(255, 0, 255)
			love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
			love.graphics.setColor(0,255,0)
			local lastWidth = 0
			for i,chID in ipairs(wd.children) do
				local child = Widget.get(chID)
				love.graphics.rectangle("line", wd.realX+wd.padding+lastWidth, wd.realY+wd.padding, child.realW, child.realH - wd.padding*2)
				lastWidth = lastWidth + child.realW + wd.padding
			end
		end
	end,
	boxV = function(wd)
		local lastHeight = -wd.scrollOffset
		for i,chID in ipairs(wd.children) do
			local child = Widget.get(chID)
			if child.active == true then
				local halign = ""

				if (child.halign == "parent") then
					halign = wd.childHalign
				else
					halign = child.halign
				end

				if (halign == "left") then
					child.realX = wd.padding
				elseif (halign == "center") then
					child.realX = wd.realW/2 - child.realW/2
				elseif (halign == "right") then
					child.realX = wd.realW - wd.padding - child.realW
				end

				child.realW = math.min(child.w, wd.realW-wd.padding*2)			
				child.realH = child.h--math.min(child.h, wd.realH-wd.padding*2)
				
				if(child.redraw)then
					child.redraw()
				end

				child.realY = lastHeight + wd.padding
				
				child.realX = math.floor(child.realX + wd.realX)
				child.realY = math.floor(child.realY + wd.realY)

				if (child.layout) then
					if (child.layout ~= "absolute") then
						layoutFunctions[child.layout](child)
					end
				end

				lastHeight = lastHeight + child.realH + wd.padding
			end
			child:refresh()
		end

		wd.contentHeight = lastHeight + wd.scrollOffset

		local maxH = wd.h
		if(wd.parent) then
			local parent = Widget.get(wd.parent)
			maxH = math.min(maxH, parent.realH)
		else
			maxH = math.min(maxH, love.graphics.getHeight())
		end

		maxH = math.max(lastHeight + wd.padding, maxH)

		if (wd.maxH < maxH) then
			if (wd.autoScroll) then
				wd.scrollOffset = maxH - wd.maxH + wd.scrollOffset
				--wd:refresh()
			end
			maxH = wd.maxH
		end
		wd.realH = math.min(maxH)


		wd.drawLines = function()
			love.graphics.setColor(255, 0, 255)
			love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
			love.graphics.setColor(0,255,0)
			local lastHeight = -wd.scrollOffset
			for i,chID in ipairs(wd.children) do
				local child = Widget.get(chID)
				love.graphics.rectangle("line", wd.realX+wd.padding, wd.realY+wd.padding+lastHeight, wd.realW - wd.padding*2, child.realH)
				lastHeight = lastHeight + child.realH + wd.padding
			end
		end
	end
}


local function init()

	require(BASE.."widget")

	gui.Frame = require(BASE.."frame")
	gui.Label = require(BASE.."label")
	gui.Button = require(BASE.."button")
	gui.TextBox = require(BASE.."textBox")

	gui.isGUI = true

	font = font or love.graphics.getFont()
	fontt = font or love.graphics.getFont()
    local texDefaultPanel = love.graphics.newImage(BASE.."/defaultPanel.png")
    texDefaultPanel:setFilter("nearest","nearest")
    gui:newPanelType("textBox", texDefaultPanel, 1, 1)
	love.keyboard.setKeyRepeat(true)
	return gui
end

function gui:newPanelType(name, tex, borderS, centerS)
	panelTypes[name] = {}
	panelTypes[name].texture = tex
	panelTypes[name].borderSize = borderS
	panelTypes[name].centerSize = centerS
	panelTypes[name].quads = {}
	panelTypes[name].quads[0] = love.graphics.newQuad(0, 0, panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[1] = love.graphics.newQuad(panelTypes[name].borderSize, 0, panelTypes[name].centerSize, panelTypes[name].borderSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[2] = love.graphics.newQuad(panelTypes[name].borderSize+panelTypes[name].centerSize, 0, panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[3] = love.graphics.newQuad(0, panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].centerSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[4] = love.graphics.newQuad(panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].centerSize, panelTypes[name].centerSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[5] = love.graphics.newQuad(panelTypes[name].borderSize+panelTypes[name].centerSize, panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].centerSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[6] = love.graphics.newQuad(0, panelTypes[name].borderSize+panelTypes[name].centerSize, panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[7] = love.graphics.newQuad(panelTypes[name].borderSize, panelTypes[name].borderSize+panelTypes[name].centerSize, panelTypes[name].centerSize, panelTypes[name].borderSize, panelTypes[name].texture:getDimensions())
	panelTypes[name].quads[8] = love.graphics.newQuad(panelTypes[name].borderSize+panelTypes[name].centerSize, panelTypes[name].borderSize+panelTypes[name].centerSize, panelTypes[name].borderSize, panelTypes[name].borderSize, panelTypes[name].texture:getDimensions())
end

function gui:newPanel(pType, w, h)
	if (pType == "none" or pType == "box") then
		return nil
	end
	
	scaleX = (w - panelTypes[pType].borderSize - panelTypes[pType].borderSize) / (panelTypes[pType].texture:getWidth() - panelTypes[pType].borderSize - panelTypes[pType].borderSize)
	scaleY = (h - panelTypes[pType].borderSize - panelTypes[pType].borderSize) / (panelTypes[pType].texture:getHeight() - panelTypes[pType].borderSize - panelTypes[pType].borderSize)
	
	panelBatch = love.graphics.newSpriteBatch(panelTypes[pType].texture, 9, "static")
	panelBatch:add(panelTypes[pType].quads[0], 0, 0, 0, 1, 1)
	panelBatch:add(panelTypes[pType].quads[1], panelTypes[pType].borderSize, 0, 0, scaleX, 1)
	panelBatch:add(panelTypes[pType].quads[2], panelTypes[pType].borderSize + panelTypes[pType].centerSize * scaleX, 0, 0, 1, 1)
	
	panelBatch:add(panelTypes[pType].quads[3], 0, panelTypes[pType].borderSize, 0, 1, scaleY)
	panelBatch:add(panelTypes[pType].quads[4], panelTypes[pType].borderSize, panelTypes[pType].borderSize, 0, scaleX, scaleY)
	panelBatch:add(panelTypes[pType].quads[5], panelTypes[pType].borderSize + panelTypes[pType].centerSize * scaleX, panelTypes[pType].borderSize, 0, 1, scaleY)

	panelBatch:add(panelTypes[pType].quads[6], 0, panelTypes[pType].borderSize + panelTypes[pType].centerSize * scaleY, 0, 1, 1)
	panelBatch:add(panelTypes[pType].quads[7], panelTypes[pType].borderSize, panelTypes[pType].borderSize + panelTypes[pType].centerSize * scaleY, 0, scaleX, 1)
	panelBatch:add(panelTypes[pType].quads[8], panelTypes[pType].borderSize + panelTypes[pType].centerSize * scaleX, panelTypes[pType].borderSize + panelTypes[pType].centerSize * scaleY, 0, 1, 1)
	
	return panelBatch
end

function gui:draw(wd)
	if not wd then
		return
	end
	if not wd.active then
		return
	end	

	--Atualiza posição do mouse
	local mX, mY = love.mouse.getPosition()
	self.mouse = {x = mX, y = mY}

	--Desenha widget
	wd:drawSelf()

	if gui.debugLines and wd.drawLines then
		wd.drawLines()
	end	
end

function gui:requestFocus(wdID, e)
	if (self.focus ~= -1) then
		local lastFocus = Widget.get(self.focus)
		lastFocus.hasFocus = false
		if (lastFocus.onFocusLost) then
			lastFocus:onFocusLost(e)
		end
	end
	self.focus = wdID
	if wdID ~= -1 then
		local wd = Widget.get(wdID)
		wd.hasFocus = true
		if (wd.onFocusEnter) then
			wd:onFocusEnter(e)
		end
	end
end

function gui:mousepressed(wd, x, y, b)	
	if (not wd.active) then
		return
	end
	local event = {time = love.timer.getTime(), x = x, y = y, b = b}
	if (event.time-lastClick > clickCooldown) then
		lastClick = love.timer.getTime()
	else
		--return
	end
	self:requestFocus(-1)
	if (isInRect(event.x, event.y, wd.realX, wd.realY, wd.realW, wd.realH)) then
		if (wd.mousepressed) then
			wd:mousepressed(event)
		end
	end
	
end

function gui:textinput(t)
	if (self.focus ~= -1) then
		local focusWD = Widget.get(self.focus)
		if (focusWD.textinput) then
			focusWD:textinput(t)
		end
	end
end

function gui:keypressed(k)
	if (self.focus ~= -1) then
		local focusWD = Widget.get(self.focus)
		if (focusWD.keypressed) then
			focusWD:keypressed(k)
		end
	end
end

function gui:wheelmoved(x, y)
	if (self.focus ~= -1) then
		local focusWD = Widget.get(self.focus)
		if (focusWD.wheelmoved) then
			focusWD:wheelmoved(x, y)
		end
	end
end

function gui:isMouseHovering(wd)
	return isInRect(self.mouse.x, self.mouse.y, wd.realX, wd.realY, wd.realW, wd.realH)
end

--Funcao extra
function isInRect(x1,y1,x,y,w,h)
	return (x1>x and x1<x+w and y1>y and y1<y+h)
end

return init()
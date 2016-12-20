local BASE = (...):match('(.-)[^%.]+$')	--Aparentemente pega o caminho até o diretorio do arquivo atual. Não sei como.


local gui = {}   
gui.__index = gui



debugLines = true

widgetType = {
	frame = 1,
	button = 2,
	label = 3,
	textBox = 4
}

panelTypes = {}

textBoxFocus = nil

lastClick = love.timer.getTime()
clickCooldown = 0.1

layoutFunctions = {
	gridH = function(wd)
		local totalWeight = 0
		for i,child in ipairs(wd.children) do
			if child.active then
				totalWeight = totalWeight + child.weight
			end
		end
		local baseWidth = wd.realW / totalWeight
		local lastWidth = 0
		for i,child in ipairs(wd.children) do
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
				
				if (type(child.h) == "number") then
					child.realH = math.min(child.h, wd.realH-wd.padding*2)
				else
					child.realH = wd.realH-wd.padding*2
				end
				if(type(child.w) == "number") then
					child.realW = math.min(child.w, boxWidth-wd.padding*2)
				else
					child.realW = boxWidth - wd.padding*2
				end
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

		if debugLines then
			wd.drawLines = function()
				love.graphics.setColor(255, 0, 255)
				love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
				love.graphics.setColor(0,255,0)
				local totalWeight = 0
				for i,child in ipairs(wd.children) do
					totalWeight = totalWeight + child.weight
				end
				local baseWidth = wd.realW / totalWeight
				local lastWidth = 0
				for i,child in ipairs(wd.children) do
					local boxWidth = baseWidth * child.weight
					love.graphics.rectangle("line", wd.realX+wd.padding+lastWidth, wd.realY+wd.padding, boxWidth - wd.padding*2, wd.realH - wd.padding*2)
					lastWidth = lastWidth + boxWidth
				end
			end
		end
	end,
	gridV = function(wd)
		local totalWeight = 0
		for i,child in ipairs(wd.children) do
			if child.active then
				totalWeight = totalWeight + child.weight
			end
		end
		local baseHeight = wd.realH / totalWeight
		local lastHeight = 0
		for i,child in ipairs(wd.children) do
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

		if debugLines then
			wd.drawLines = function()
				love.graphics.setColor(255, 0, 255)
				love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
				love.graphics.setColor(0,255,0)
				local totalWeight = 0
				for i,child in ipairs(wd.children) do
					totalWeight = totalWeight + child.weight
				end
				local baseHeight = wd.realH / totalWeight
				local lastHeight = 0
				for i,child in ipairs(wd.children) do
					local boxHeight = baseHeight * child.weight
					love.graphics.rectangle("line", wd.realX+wd.padding, wd.realY+wd.padding+lastHeight, wd.realW - wd.padding*2, boxHeight - wd.padding*2)
					lastHeight = lastHeight + boxHeight
				end
			end
		end
	end,
	boxH = function(wd)
		local lastWidth = 0
		for i,child in ipairs(wd.children) do
			if child.active == true then
				local valign = ""

				if (child.valign == "parent") then
					valign = wd.childValign
				else
					valign = child.valign
				end
				
				wd.realW = wd.w

				child.realH = math.min(child.h, wd.realH-wd.padding*2)
				child.realW = math.min(child.w, wd.realW-wd.padding*2)
				if(child.redraw)then
					child.redraw()
				end				

				child.realX = lastWidth + wd.padding

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

				lastWidth = lastWidth + child.realW + wd.padding
			end
			child:refresh()
		end

		if debugLines then
			wd.drawLines = function()
				love.graphics.setColor(255, 0, 255)
				love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
				love.graphics.setColor(0,255,0)
				local lastWidth = 0
				for i,child in ipairs(wd.children) do
					love.graphics.rectangle("line", wd.realX+wd.padding+lastWidth, wd.realY+wd.padding, child.realW, wd.realH - wd.padding*2)
					lastWidth = lastWidth + child.realW + wd.padding
				end
			end
		end
	end,
	boxV = function(wd)
		local lastHeight = 0
		for i,child in ipairs(wd.children) do
			if child.active == true then
				local halign = ""

				if (child.halign == "parent") then
					halign = wd.childHalign
				else
					halign = child.halign
				end

				if (child.w == "parent") then
					child.realW = wd.realW - wd.padding*2
				else
					child.realW = math.min(child.w, wd.realW-wd.padding*2)
				end
				if (child.h == "parent") then
					child.realH = wd.h - wd.padding*2
				else
					child.realH = math.min(child.h, wd.realH-wd.padding*2)
				end

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

		if debugLines then
			wd.drawLines = function()
				love.graphics.setColor(255, 0, 255)
				love.graphics.rectangle("line", wd.realX, wd.realY, wd.realW, wd.realH)
				love.graphics.setColor(0,255,0)
				local lastHeight = 0
				for i,child in ipairs(wd.children) do
					love.graphics.rectangle("line", wd.realX+wd.padding, wd.realY+wd.padding+lastHeight, wd.realW - wd.padding*2, child.realH)
					lastHeight = lastHeight + child.realH + wd.padding
				end
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
    --gui:newPanelType("button", texDefaultPanel, 1, 1)
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
	if not wd.active then
		return
	end
	--Atualiza posição do mouse
	mx, my = love.mouse.getPosition()
		
	--Desenha widget
	wd:drawSelf()

	if wd.drawLines then
		wd.drawLines()
	end
	
end

function gui:mousepressed(wd, x, y, b)	--Reescrever
	if (not wd.active) then
		return
	end
	if wd.realX and wd.realY and wd.realW and wd.realH then 	--Basicamente, se é um widget clicavel(label nao é)
		if ((x > wd.realX) and (x < wd.realX + wd.realW) and (y > wd.realY) and (y < wd.realY + wd.realH)) then 	--Verifica se clicou dentro do widget
			if (wd.wType == widgetType.button) then 	--Chama o callback se for botao
				if(love.timer.getTime()-lastClick>clickCooldown)then
					wd.callback(b)
					lastClick = love.timer.getTime()
				end
				
			elseif (wd.wType == widgetType.textBox) then 	--Transfere o foco se for textBoxFocus 
				if textBoxFocus then
					textBoxFocus.caret = false
					textBoxFocus.hasFocus = false
				end
				textBoxFocus = wd
				textBoxFocus.hasFocus = true
			end
			if (wd.children) then 
				for i,child in ipairs(wd.children) do
					self:mousepressed(child, x, y, b)
				end
			end
		elseif (wd == textBoxFocus) then 	--Se wd é o textBox com foco e ele nao foi clicado, tira o foco dele
			wd.hasFocus = false
			textBoxFocus = nil
		end

	end
end

function gui:textinput(t)
	if textBoxFocus then
		textBoxFocus.text = string.sub(textBoxFocus.text, 1, textBoxFocus.caretPos)..t..string.sub(textBoxFocus.text, textBoxFocus.caretPos+1)
		textBoxFocus.caretPos = textBoxFocus.caretPos + 1
	end
end

function gui:keypressed(k)
	if textBoxFocus then
		if (k == "backspace" and textBoxFocus.caretPos > 0) then
	        textBoxFocus.text = string.sub(textBoxFocus.text, 1, textBoxFocus.caretPos-1)..string.sub(textBoxFocus.text, textBoxFocus.caretPos+1)
	        textBoxFocus.caretPos = textBoxFocus.caretPos - 1
		end
		if (k == "delete") then
	        textBoxFocus.text = string.sub(textBoxFocus.text, 1, textBoxFocus.caretPos)..string.sub(textBoxFocus.text, textBoxFocus.caretPos+2)
		end
		
		if (k == "right" and textBoxFocus.caretPos<string.len(textBoxFocus.text)) then
			textBoxFocus.caretPos = textBoxFocus.caretPos + 1
		end
		if (k == "left" and textBoxFocus.caretPos>0) then
			textBoxFocus.caretPos = textBoxFocus.caretPos - 1
		end

		if (k == "return") then
			if (textBoxFocus.callback) then
				textBoxFocus.callback()
			end
		end
	end
end

return init()
--[[return setmetatable({new = init},
	{__call = function(_, ...) return init(...) end})]]

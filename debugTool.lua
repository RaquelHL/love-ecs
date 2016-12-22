
debugTool = {}

local enabled = false

local pprintList = {}


local function init()
	initConsole()
end

function debugTool.toggle()
	enabled = not enabled
end

function initConsole()
	frConsole = GUI:Frame({color = Color(80,80,80,150), layout = "gridV", padding = 1, x = 250, y = -200, h = 200, w = -250, maxH = 200,
		panelType = "textBox", y = -200})

	frLog = GUI:Frame({color = Color(80,80,80,150), layout = "boxV", padding = 1, childHalign = "left", allowScrolling = true, maxH = 160})
	txtCommand = GUI:TextBox({weight = 0.2, w = "parent", callback = function(self)
		
		local f, err = loadstring(self.text)
		if f then
			print(self.text)
			f()
		else
			print(err)
		end
		self.text = ""
		self.gui:requestFocus(self.id)
	end})
	frConsole:addChild(frLog)
	frConsole:addChild(txtCommand)
end

function debugTool.initInspector(go)
	fieldList = {}
	fr = GUI:Frame({color = Color(80,80,80,150), layout = "boxV", w = 250, h="parent", panelType = "box", padding = 3, maxH = 600, allowScrolling = true})
	
	fr:addChild(GUI:Label({text = go.name, h = 30}))

	for k,v in pairs(go.components) do
		local compBox = componentBox(v)
		fr:addChild(compBox)
	end
	
	if frConsole then
		frConsole:refresh()
	end
end

local fieldList = {}

function componentBox(comp)
	local frComp = GUI:Frame({color = Color(180,180,180,150), layout = "boxV", w = "parent", h = "content", panelType = "box", padding = 2})
	
	frComp:addChild(GUI:Label({text = comp.name, h = 20, w = "parent", textAlign = "left"}))
	
	for k,v in pairs(comp) do
		local f = fieldBox(k,v,comp)
		if f then
			frComp:addChild(f)
		end
	end
	return frComp
end

function fieldBox(k, f,comp)
	local frField = GUI:Frame({color = Color(180,180,180,150), layout = "gridH", w = "parent", h = 300, panelType = "box", padding = 0})
	
	if k ~= "name" and (type(f) == "number" or type(f) == "string") then
		local frLabel = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.5, childHalign = "center", padding = 0})
		local frText = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", childHalign = "left", padding = 0})
		local field = {}
		field.textBox = GUI:TextBox({text = f, h = 20, callback = function(self) comp[k] = self.text end})
		field.component = comp
		field.key = k
		frLabel:addChild(GUI:Label({text = k, h = 20, w = "parent", textAlign = "left"}))
		frText:addChild(field.textBox)

		fieldList[#fieldList+1] = field
		frField:addChild(frLabel)
		frField:addChild(frText)
		return frField
	end
	if type(f) == "table" then
		if f.isVector then
			local frLabel = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.5, childHalign = "center", padding = 0})
			local frLabelX = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.2, childHalign = "center", padding = 0})
			local frTextX = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.3, childHalign = "left", padding = 0})
			local frLabelY = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.2, childHalign = "center", padding = 0})
			local frTextY = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.3, childHalign = "left", padding = 0})
	
			frLabel:addChild(GUI:Label({text = k, h = 20, w = "parent", textAlign = "left"}))

			local fieldX = {}
			fieldX.textBox = GUI:TextBox({text = f.x, h = 20, callback = function(self) f.x = tonumber(self.text) end})
			fieldX.component = f
			fieldX.key = "x"
			frLabelX:addChild(GUI:Label({text = "x", h = 20, w = "parent", textAlign = "left"}))
			frTextX:addChild(fieldX.textBox)
	
			local fieldY = {}
			fieldY.textBox = GUI:TextBox({text = f.y, h = 20, callback = function(self) f.y = tonumber(self.text) end})
			fieldY.component = f
			fieldY.key = "y"
			frLabelY:addChild(GUI:Label({text = "y", h = 20, w = "parent", textAlign = "left"}))
			frTextY:addChild(fieldY.textBox)

			fieldList[#fieldList+1] = fieldX
			fieldList[#fieldList+1] = fieldY

			frField:addChild(frLabel)
			frField:addChild(frLabelX)
			frField:addChild(frTextX)
			frField:addChild(frLabelY)
			frField:addChild(frTextY)
			return frField
		end
	end
	return nil
end

--Print para depurar valores contínuos
function pprint(text, name)
	if name then
		pprintList[name] = text
	else
		pprintList[#pprintList+1] = text
	end
end

_print = print
function print(...)
	_print(...)
	if frLog then
		local args = {...}
		frLog:addChild(GUI:Label({text = tostring(args[1]), w = "parent", textAlign = "left"}))
		frLog.scrollOffset = frLog.contentHeight - frLog.realH
		frLog:refresh()
	end
end

local _update = love.update
function love.update(dt)
	if _update then
		_update(dt)
	end
	if enabled then
		for k,field in pairs(fieldList) do
			if(not field.textBox.hasFocus) then
				field.textBox.text = field.component[field.key]
			end
			
			field.textBox:refresh()
		end
	end

end

local _draw = love.draw --Dá override no love.draw, mas guarda a funcao anterior para poder chamar ela
function love.draw()
	_draw()
	love.graphics.setColor(0, 0, 0)
	local j = 0
	for i,v in ipairs(pprintList) do
		love.graphics.print(v, 10, j*10)
		pprintList[i] = nil
		j = j + 1
	end
	for k,v in pairs(pprintList) do
		love.graphics.print(v, 10, j*10)
		j = j + 1
	end
	if(enabled)then
		if(fr)then
			GUI:draw(fr)
		end
		GUI:draw(frConsole)
	end
end

local _mousepressed = love.mousepressed
function love.mousepressed(x,y,b)
	if _mousepressed then
		_mousepressed(x,y,b)
	end
	if enabled then
	    if fr then
		    GUI:mousepressed(fr, x, y, b)
		end
	    if frConsole then
	    	GUI:mousepressed(frConsole, x, y, b)
	    end
	end
end

local _wheelmoved = love.wheelmoved
function love.wheelmoved(x, y)
	if _wheelmoved then
		_wheelmoved(x, y)
	end
	if enabled then
		GUI:wheelmoved(x, y)
	end
end

local _textinput = love.textinput
function love.textinput(t)
	if enabled then
    	GUI:textinput(t)
    end
    if _textinput then
		_textinput(t)
	end
end

local _keypressed = love.keypressed
function love.keypressed(k)
	if (k=="f2") then
		debugTool.toggle()
		return
	end

	if enabled then
		GUI:keypressed(k)
	end
	if _keypressed then
		if GUI.focus ~= -1 then
    		return
    	end
    	_keypressed(k)
		
	end


	
end

return init()
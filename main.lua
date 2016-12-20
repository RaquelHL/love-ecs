require("Color")
GUI = require("gui.core")

function love.load()

	local go = {}
	go.name = "Player"
	a = 0

	local tr = {}
	tr.name = "Transform"
	tr.x = 10
	tr.y = 20
	tr.o = 1.2

	ren = {}
	ren.name = "Renderer"
	ren.texture = "abc.png"

	go.components = {}
	go.components[1] = tr
	go.components[2] = ren

	love.window.setMode(800, 700, {vsync = false})


	frConsole = GUI:Frame({color = Color(200,200,200,150), layout = "boxV", padding = 1, h = 200, w = "parent", panelType = "textBox", y = -200, childHalign = "left"})

	initInspector(go)

end

_print = print
function print(...)
	_print(...)

	local args = {...}
	frConsole:addChild(GUI:Label({text = args[1], w = "parent", textAlign = "left", h = 10}))
end

function initInspector(go)
	fr = GUI:Frame({x = 2, y = 2, color = Color(150,150,150,150), layout = "boxV", w = 250, h="content", panelType = "box", padding = 5})
	
	fr:addChild(GUI:Label({text = go.name, h = 30}))

	for k,v in pairs(go.components) do
		local compBox = componentBox(v)
		fr:addChild(compBox)
	end
	fr:addChild(GUI:Button({text = "teste", callback = function(e) print("Clicou!") end}))
end

function componentBox(comp)
	frComp = GUI:Frame({color = Color(180,180,180,150), layout = "gridH", w = "parent", h = 300, panelType = "box", padding = 0})
	frLabel = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", weight = 0.5, childHalign = "center", padding = 5})
	frText = GUI:Frame({color = Color(50,50,50), h = "content", layout = "boxV", childHalign = "left", padding = 5})
	
	frLabel:addChild(GUI:Label({text = comp.name, h = 20, w = "parent", textAlign = "left"}))
	frText:addChild(GUI:Label({text = "", h = 20, w = "parent", textAlign = "left"}))

	for k,v in pairs(comp) do
		if k ~= "name" then
			frLabel:addChild(GUI:Label({text = k, h = 20, w = "parent", textAlign = "left"}))
			frText:addChild(GUI:TextBox({text = v, h = 20}))
		end
	end
	frComp:addChild(frLabel)
	frComp:addChild(frText)
	return frComp
end

function love.draw()
	GUI:draw(fr)
	GUI:draw(frConsole)
end

function love.update(dt)
	GUI:update(fr)
end

function love.mousepressed(x,y,b)
    GUI:mousepressed(fr, x, y, b)
end

function love.textinput(t)
    GUI:textinput(t)
end

function love.keypressed(k)
	GUI:keypressed(k)
end


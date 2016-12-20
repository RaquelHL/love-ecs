require("Color")
GUI = require("gui.core")

function love.load()
	--[[fr = GUI:Frame({color = Color(50,50,50), layout = "boxV", childHalign = "left", padding = 5})
	
	fr1 = GUI:Frame({color = Color(50), w = 300, layout = "boxV", panelType = "textBox"})
	fr2 = GUI:Frame({color = Color(50), w = 300, layout = "boxV", panelType = "textBox"})
	txt1 = GUI:TextBox()
	txt2 = GUI:TextBox()
	txt3 = GUI:TextBox()
	txt4 = GUI:TextBox()
	
	fr:addChild(txt1)
	fr:addChild(txt2)
	fr:addChild(txt3)
	fr:addChild(txt4)]]
	--fr:addChild(fr1)
	--fr:addChild(fr2)


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

	frConsole = GUI:Frame({color = Color(200,200,200,150), layout = "boxV", padding = 1, h = 200, panelType = "textBox", y = 400})

	initInspector(go)

	love.window.setMode(800, 600, {vsync = false})
end

_print = print
function print(...)
	_print(...)

	local args = {...}
	frConsole:addChild(GUI:Label({text = args[1], w = "parent", textAlign = "left", h = 10}))
end

function initInspector(go)
	fr = GUI:Frame({color = Color(150,150,150,150), layout = "boxV", w = 250, h=400, panelType = "textBox", padding = 0})
	
	fr:addChild(GUI:Label({text = go.name, h = 30}))

	for k,v in pairs(go.components) do
		fr:addChild(componentBox(v))
	end
end

function componentBox(comp)
	frComp = GUI:Frame({color = Color(180,180,180,150), layout = "gridH", w = "parent", h=200, panelType = "textBox", padding = 0})
	frLabel = GUI:Frame({color = Color(50,50,50), layout = "boxV", weight = 0.5, childHalign = "center", padding = 5})
	frText = GUI:Frame({color = Color(50,50,50), layout = "boxV", childHalign = "left", padding = 5})
	
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
	print(ren.texture)
end

function love.mousepressed(x,y,b)
    GUI:mousepressed(fr, x, y, b)
end

function love.textinput(t)
    GUI:textinput(t)
end

function love.keypressed(k)
	GUI:keypressed(k)
    if(k=="return") then
        --Gamestate.switch(game)
	end
end

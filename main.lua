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
	local tab = {}
	tab.Name = "Player"
	tab.posX = 4
	tab.posY = 10
	initInspector(tab)
end

function initInspector(tab)
	fr = GUI:Frame({color = Color(50,50,50), layout = "gridH", w = 250, h=200, panelType = "textBox", padding = 0})
	frLabel = GUI:Frame({color = Color(50,50,50), layout = "boxV", weight = 0.5, childHalign = "right", padding = 5})
	frText = GUI:Frame({color = Color(50,50,50), layout = "boxV", childHalign = "left", padding = 5})
	
	for k,v in pairs(tab) do
		frLabel:addChild(GUI:Label({text = k, h = 30, w = "parent", textAlign = "right"}))
		frText:addChild(GUI:TextBox({text = v}))
	end
	fr:addChild(frLabel)
	fr:addChild(frText)
end

function love.draw()
	GUI:draw(fr)
end

function love.update(dt)
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

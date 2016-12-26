GUI = require("gui.guiCore")

ECS = require("ecsCore")

require("scripts.PlayerInput")
require("scripts.CharacterMotor")

function love.load()

	ResourceMgr.add("animsheet", "PixelChar")

	scene = ResourceMgr.get("scene", "sceneTeste")	

	ECS:loadScene(scene)

	debugTool.initInspector(player)
end

function love.update(dt)
	ECS:update(dt)
end

function love.draw()
	ECS:draw()
end

function love.mousepressed(x, y, b)
    ECS:mousepressed(x,y,b)
end

function love.keypressed(k)
    ECS:keypressed(k)
end

function love.textinput(t)
    ECS:textinput(t)
end

require("debugTool")	--Aperta F2 pra abrir
--debugTool.enable()

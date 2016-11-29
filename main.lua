--Principais
require("GameObject")
require("Scene")

--Componentes
require("Transform")
require("Renderer")
require("PlayerInput")

--Outros
require("Color")

function love.load()
	boxTex = love.graphics.newImage("textures/tile.png")
	smallBoxTex = love.graphics.newImage("textures/tile8.png")

	boxGO = GameObject("box", {Renderer(boxTex)})
	smallBoxGO = GameObject("smallBox", {Renderer(smallBoxTex, Color.green), PlayerInput()}):newInstance({x = 100})

	scene = Scene()
	scene:addGO(boxGO:newInstance({name = "box1", x = 50, y = 50}))
	scene:addGO(boxGO:newInstance({name = "box2", x = 300, y = 150}))
	scene:addGO(smallBoxGO)

end

function love.update(dt)
	scene:update(dt)
end

function love:draw()
	scene:draw()
end